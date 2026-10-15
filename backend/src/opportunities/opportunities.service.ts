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

@Injectable()
export class OpportunitiesService {
  constructor(private prisma: PrismaService) {}

  // 1. CRIAR
  async create(ongId: string, dto: CreateOpportunityDto, userRole: string) {
    // Validação imediata usando a role do JWT (sem precisar consultar o Banco de Dados!)
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

  // 2. LISTAR TODAS
  async findAll(cidade?: string, categoria?: string) {
    return this.prisma.opportunity.findMany({
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

  // 8. CANDIDATAR-SE A UMA VAGA (Ação do Voluntário)
  async applyToOpportunity(opportunityId: string, userId: string, userRole: string) {
    // Garante que uma ONG não se candidate à vaga de outra ONG por engano
    if (userRole !== 'USER') {
      throw new UnauthorizedException('Acesso negado. Apenas voluntários podem se candidatar a vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id: opportunityId },
    });

    if (!opportunity) {
      throw new NotFoundException('Vaga não encontrada');
    }

    try {
      const application = await this.prisma.application.create({
        data: {
          userId: userId,
          opportunityId: opportunityId,
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


// 9. LISTAR CANDIDATOS DE UMA VAGA (Apenas para a ONG dona da vaga)
  async getApplications(opportunityId: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem ver os inscritos.');
    }

    // Verifica se a vaga pertence mesmo a esta ONG
    const opportunity = await this.prisma.opportunity.findUnique({ where: { id: opportunityId } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você só pode ver os candidatos das suas próprias vagas.');
    }

    // Retorna as inscrições junto com os dados úteis do voluntário
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

  // 10. MUDAR O STATUS DA INSCRIÇÃO (Aceitar ou Recusar)
  async updateApplicationStatus(applicationId: string, ongId: string, userRole: string, status: ApplicationStatus) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs gerenciam inscrições.');
    }

    // Busca a inscrição e a vaga vinculada a ela
    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: { opportunity: true }
    });

    if (!application) throw new NotFoundException('Inscrição não encontrada.');
    
    // Garante que a ONG não está tentando aceitar um candidato da vaga de outra ONG
    if (application.opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você não tem permissão para gerenciar esta inscrição.');
    }

    return this.prisma.application.update({
      where: { id: applicationId },
      data: { status }
    });
  }
}