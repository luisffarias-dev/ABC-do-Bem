import { 
  Injectable, 
  NotFoundException, 
  UnauthorizedException, 
  ConflictException 
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';
import { ApplicationStatus } from '@prisma/client';

interface RecommendationResult {
  opportunityId: string;
  score: number;
}

@Injectable()
export class OpportunitiesService {
  constructor(private prisma: PrismaService) {}

  // 1. CRIAR
  async create(ongId: string, dto: CreateOpportunityDto, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem criar vagas.');
    }
    return this.prisma.opportunity.create({
      data: {
        ...dto,
        eventDate: new Date(dto.eventDate),
        ongId,
      },
    });
  }

  // 2. LISTAR TODAS COM INDICADOR DE CANDIDATURA
  async findAll(cidade?: string, categoria?: string, userId?: string) {
    const opportunities = await this.prisma.opportunity.findMany({
      where: {
        ...(cidade && { cidade: { contains: cidade, mode: 'insensitive' } }),
        ...(categoria && { categories: { has: categoria } }),
        eventDate: { gte: new Date() },
      },
      include: {
        ong: { select: { name: true, avatar: true } },
        _count: { select: { applications: { where: { status: 'CONFIRMED' } } } },
      },
      orderBy: { eventDate: 'asc' },
    });

    if (!userId) {
      return opportunities.map(opp => ({
        ...opp,
        isApplied: false,
        applicationStatus: null,
      }));
    }

    const oppIds = opportunities.map(o => o.id);
    const userApplications = await this.prisma.application.findMany({
      where: {
        userId: userId,
        opportunityId: { in: oppIds },
      },
      select: { opportunityId: true, status: true },
    });

    const applicationMap = new Map(
      userApplications.map(app => [app.opportunityId, app.status])
    );

    return opportunities.map(opp => {
      const status = applicationMap.get(opp.id);
      return {
        ...opp,
        isApplied: !!status, 
        applicationStatus: status || null, 
      };
    });
  }

  // 3. BUSCAR AS MAIS PRÓXIMAS (Haversine)
  async findNearby(lat: number, lng: number, maxDistanceKm: number = 20) {
    const opportunities = await this.prisma.$queryRawUnsafe(`
      SELECT o.*, u.name as "ongName", u.avatar as "ongAvatar",
      (
        6371 * acos(
          cos(radians(${lat})) * cos(radians(o.latitude)) *
          cos(radians(o.longitude) - radians(${lng})) +
          sin(radians(${lat})) * sin(radians(o.latitude))
        )
      ) AS "distance_km"
      FROM "Opportunity" o
      JOIN "User" u ON o."ongId" = u.id
      WHERE o.latitude IS NOT NULL AND o.longitude IS NOT NULL
      AND o."eventDate" >= NOW()
      HAVING (
        6371 * acos(
          cos(radians(${lat})) * cos(radians(o.latitude)) *
          cos(radians(o.longitude) - radians(${lng})) +
          sin(radians(${lat})) * sin(radians(o.latitude))
        )
      ) <= ${maxDistanceKm}
      ORDER BY "distance_km" ASC
      LIMIT 15;
    `);
    
    return opportunities;
  }

  // 4. LISTAR VAGAS DE UMA ONG ESPECÍFICA
  async findByOng(ongId: string) {
    return this.prisma.opportunity.findMany({
      where: { ongId },
      include: {
        _count: { select: { applications: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // 5. DETALHES DE UMA VAGA
  async findOne(id: string) {
    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id },
      include: {
        ong: { select: { name: true, descricao: true, avatar: true, telefoneFixo: true, whatsapp: true } },
      },
    });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    return opportunity;
  }

  // 6. ATUALIZAR
  async update(id: string, ongId: string, dto: UpdateOpportunityDto, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem editar vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) throw new UnauthorizedException('Você só pode editar suas próprias vagas');

    return this.prisma.opportunity.update({
      where: { id },
      data: {
        ...dto,
        ...(dto.eventDate && { eventDate: new Date(dto.eventDate) }),
      },
    });
  }

  // 7. EXCLUIR
  async remove(id: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem excluir vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) throw new UnauthorizedException('Você só pode deletar suas próprias vagas');

    return this.prisma.opportunity.delete({ where: { id } });
  }

  // 8. CANDIDATAR-SE A UMA VAGA
  async applyToOpportunity(opportunityId: string, userId: string, userRole: string) {
    if (userRole !== 'USER') {
      throw new UnauthorizedException('Acesso negado. Apenas voluntários podem se candidatar a vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id: opportunityId },
      include: { ong: true },
    });

    if (!opportunity) {
      throw new NotFoundException('Vaga não encontrada');
    }

    try {
      // 1. Cria a candidatura
      const application = await this.prisma.application.create({
        data: {
          userId: userId,
          opportunityId: opportunityId,
        },
        include: { user: true },
      });

      // 2. Cria notificação para o Voluntário
      await this.prisma.notification.create({
        data: {
          userId: userId,
          title: 'Candidatura Realizada!',
          message: `Sua candidatura para "${opportunity.title}" foi enviada com sucesso e aguarda aprovação da ONG.`,
          type: 'APPLICATION_PENDING',
          linkId: opportunityId,
        },
      });

      // 3. Cria notificação para a ONG dona da vaga
      await this.prisma.notification.create({
        data: {
          userId: opportunity.ongId,
          title: 'Novo Voluntário Inscrito!',
          message: `${application.user.name} candidatou-se à vaga "${opportunity.title}".`,
          type: 'NEW_CANDIDATE',
          linkId: opportunityId,
        },
      });

      return { 
        message: 'Candidatura realizada com sucesso!', 
        application 
      };
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Você já se candidatou a esta vaga.');
      }
      throw error;
    }
  }

  // 9. LISTAR CANDIDATOS DE UMA VAGA
  async getApplications(opportunityId: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem ver os inscritos.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({ where: { id: opportunityId } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você só pode ver os candidatos das suas próprias vagas.');
    }

    return this.prisma.application.findMany({
      where: { opportunityId },
      include: {
        user: {
          select: { 
            id: true, name: true, avatar: true, email: true, telefone: true, habilidades: true 
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  // 10. MUDAR O STATUS DA INSCRIÇÃO
  async updateApplicationStatus(applicationId: string, ongId: string, userRole: string, status: ApplicationStatus) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs gerenciam inscrições.');
    }

    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: { opportunity: true }
    });

    if (!application) throw new NotFoundException('Inscrição não encontrada.');
    
    if (application.opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você não tem permissão para gerenciar esta inscrição.');
    }

    return this.prisma.application.update({
      where: { id: applicationId },
      data: { status }
    });
  }

  async validatePresence(applicationId: string, ongId: string, status: ApplicationStatus, horasValidadas: number = 0) {
    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: { opportunity: true },
    });

    if (!application) {
      throw new NotFoundException('Inscrição não encontrada.');
    }

    if (application.opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Apenas a ONG organizadora deste evento pode validar a presença.');
    }

    return this.prisma.application.update({
      where: { id: applicationId },
      data: {
        status: status, 
        horasValidadas: status === 'PRESENT' ? horasValidadas : 0,
      },
    });
  }

  async getRecommendedOpportunities(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        habilidades: true,
        cidade: true,
        estado: true,
      },
    });

    if (!user) throw new NotFoundException('Usuário não encontrado');

    // 2. Busca apenas vagas futuras e não inscritas ainda (Ponto 3 da documentação)
    const existingApplications = await this.prisma.application.findMany({
      where: { userId },
      select: { opportunityId: true },
    });
    const appliedOppIds = existingApplications.map(app => app.opportunityId);

    const opportunities = await this.prisma.opportunity.findMany({
      where: {
        id: { notIn: appliedOppIds }, 
        eventDate: { gte: new Date() }, 
      },
      select: {
        id: true, title: true, description: true, categories: true,
        cidade: true, estado: true, latitude: true, longitude: true,
      },
    });

    if (opportunities.length === 0) return [];

    try {
      const flaskUrl = process.env.FLASK_ML_URL || 'http://localhost:5000/recommend';
      
      const flaskResponse = await fetch(flaskUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          user: {
            habilidades: user.habilidades,
            cidade: user.cidade,
            estado: user.estado,
          },
          opportunities: opportunities,
        }),
      });

      const recommendations = (await flaskResponse.json()) as RecommendationResult[];

      const scoreMap = new Map<string, number>(
        recommendations.map((r) => [r.opportunityId, r.score])
      );

      const result = opportunities
        .filter((opp) => scoreMap.has(opp.id))
        .map((opp) => {
          const score = scoreMap.get(opp.id) ?? 0;
          return {
            ...opp,
            matchScore: Math.round(score * 100), 
          };
        })
        .sort((a, b) => b.matchScore - a.matchScore);

      return result;
    } catch (error) {
      console.error('Erro na integração com o Flask ML (usando fallback):', error);
      return opportunities.map((opp) => ({
        ...opp,
        matchScore: 0,
      }));
    }
  }
}