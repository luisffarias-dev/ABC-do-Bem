import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';
import { ApplyOpportunityDto } from './dto/apply-opportunity.dto';
import { ValidatePresenceDto } from './dto/validate-presence.dto';
import { ApplicationStatus } from '@prisma/client';
import { PDFDocument, rgb, StandardFonts } from 'pdf-lib';
import { randomBytes } from 'crypto';

interface RecommendationResult {
  opportunityId: string;
  score: number;
}

@Injectable()
export class OpportunitiesService {
  constructor(private prisma: PrismaService) {}

  // ==========================================
  // 1. CRIAR VAGA
  // ==========================================
  async create(ongId: string, dto: CreateOpportunityDto, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem criar vagas.');
    }
    return this.prisma.opportunity.create({
      data: {
        ...dto,
        eventDate: new Date(dto.eventDate),
        endDate: dto.endDate ? new Date(dto.endDate) : null,
        ongId,
      },
    });
  }

  // ==========================================
  // 2. LISTAR TODAS COM INDICADOR DE CANDIDATURA E LOTAÇÃO
  // ==========================================
  async findAll(cidade?: string, categoria?: string, userId?: string) {
    const opportunities = await this.prisma.opportunity.findMany({
      where: {
        ...(cidade && { cidade: { contains: cidade, mode: 'insensitive' } }),
        ...(categoria && { categories: { has: categoria } }),
        eventDate: { gte: new Date() },
        status: 'ATIVA', // Só retorna vagas ativas no feed geral
      },
      include: {
        ong: { select: { name: true, avatar: true } },
        _count: { select: { applications: { where: { status: 'ACCEPTED' } } } },
      },
      orderBy: { eventDate: 'asc' },
    });

    if (!userId) {
      return opportunities.map((opp) => ({
        ...opp,
        isApplied: false,
        applicationStatus: null,
      }));
    }

    const oppIds = opportunities.map((o) => o.id);
    const userApplications = await this.prisma.application.findMany({
      where: {
        userId: userId,
        opportunityId: { in: oppIds },
      },
      select: { opportunityId: true, status: true },
    });

    const applicationMap = new Map(
      userApplications.map((app) => [app.opportunityId, app.status]),
    );

    return opportunities.map((opp) => {
      const status = applicationMap.get(opp.id);
      return {
        ...opp,
        isApplied: !!status,
        applicationStatus: status || null,
      };
    });
  }

  // ==========================================
  // 3. BUSCAR AS MAIS PRÓXIMAS (Haversine)
  // ==========================================
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
      AND o.status = 'ATIVA'
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

  // ==========================================
  // 4. LISTAR VAGAS DE UMA ONG ESPECÍFICA (PAINEL)
  // ==========================================
  async findByOng(ongId: string) {
    // Encerra automaticamente vagas ativas ou lotadas cuja data já passou
    await this.prisma.opportunity.updateMany({
      where: {
        ongId,
        status: { in: ['ATIVA', 'LOTADA'] },
        eventDate: { lt: new Date() },
      },
      data: { status: 'CONCLUIDA' },
    });

    return this.prisma.opportunity.findMany({
      where: { ongId },
      include: {
        _count: {
          select: {
            applications: { where: { status: { in: ['PENDING', 'ACCEPTED'] } } },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ==========================================
  // 5. DETALHES DE UMA VAGA
  // ==========================================
  async findOne(id: string) {
    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id },
      include: {
        ong: {
          select: {
            name: true,
            descricao: true,
            avatar: true,
            telefoneFixo: true,
            whatsapp: true,
          },
        },
      },
    });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    return opportunity;
  }

  // ==========================================
  // 6. ATUALIZAR
  // ==========================================
  async update(id: string, ongId: string, dto: UpdateOpportunityDto, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem editar vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você só pode editar suas próprias vagas');
    }

    return this.prisma.opportunity.update({
      where: { id },
      data: {
        ...dto,
        ...(dto.eventDate && { eventDate: new Date(dto.eventDate) }),
        ...(dto.endDate && { endDate: new Date(dto.endDate) }),
      },
    });
  }

  // ==========================================
  // 7. EXCLUIR
  // ==========================================
  async remove(id: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem excluir vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você só pode deletar suas próprias vagas');
    }

    return this.prisma.opportunity.delete({ where: { id } });
  }

  // ==========================================
  // 8. CANDIDATAR-SE (Com Carona e Validação de Lotação)
  // ==========================================
  async applyToOpportunity(
    opportunityId: string,
    userId: string,
    userRole: string,
    dto: ApplyOpportunityDto,
  ) {
    if (userRole !== 'USER') {
      throw new UnauthorizedException('Acesso negado. Apenas voluntários podem se candidatar a vagas.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id: opportunityId },
      include: {
        ong: true,
        _count: { select: { applications: { where: { status: 'ACCEPTED' } } } },
      },
    });

    if (!opportunity) throw new NotFoundException('Vaga não encontrada');

    // Regra de Negócio: Lotação ou Evento Encerrado
    if (
      opportunity.status !== 'ATIVA' ||
      opportunity._count.applications >= opportunity.totalVacancies
    ) {
      throw new ConflictException('Infelizmente, esta vaga já está lotada ou encerrada.');
    }

    try {
      const application = await this.prisma.application.create({
        data: {
          userId: userId,
          opportunityId: opportunityId,
          tipoCarona: dto.tipoCarona || 'NENHUMA',
          detalhesCarona: dto.detalhesCarona || null,
        },
        include: { user: true },
      });

      await this.prisma.notification.create({
        data: {
          userId: userId,
          title: 'Candidatura Realizada!',
          message: `Sua candidatura para "${opportunity.title}" foi enviada com sucesso e aguarda aprovação da ONG.`,
          type: 'APPLICATION_PENDING',
          linkId: opportunityId,
        },
      });

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
        application,
      };
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Você já se candidatou a esta vaga.');
      }
      throw error;
    }
  }

  // ==========================================
  // 9. LISTAR CANDIDATOS DE UMA VAGA
  // ==========================================
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
        opportunity: { select: { id: true, title: true, eventDate: true, durationHours: true } },
        user: {
          select: {
            id: true,
            name: true,
            avatar: true,
            email: true,
            telefone: true,
            habilidades: true,
            cidade: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ==========================================
  // 10. MUDAR O STATUS DA INSCRIÇÃO (APROVAR/RECUSAR + AUTO-LOTAÇÃO)
  // ==========================================
  async updateApplicationStatus(
    applicationId: string,
    ongId: string,
    userRole: string,
    status: ApplicationStatus,
  ) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs gerenciam inscrições.');
    }

    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: { opportunity: true, user: true },
    });

    if (!application) throw new NotFoundException('Inscrição não encontrada.');
    if (application.opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você não tem permissão para gerenciar esta inscrição.');
    }

    const updated = await this.prisma.application.update({
      where: { id: applicationId },
      data: { status },
    });

    // Sincroniza automaticamente o status da vaga (ATIVA <-> LOTADA)
    await this.syncOpportunityVacancyStatus(
      application.opportunityId,
      application.opportunity.totalVacancies,
      application.opportunity.status,
    );

    // Notificar voluntário sobre o resultado da análise
    const statusMsg = status === 'ACCEPTED' ? 'foi APROVADA' : 'foi RECUSADA';
    await this.prisma.notification.create({
      data: {
        userId: application.userId,
        title: `Atualização na sua Inscrição`,
        message: `Sua candidatura para a vaga "${application.opportunity.title}" ${statusMsg} pela ONG.`,
        type: status === 'ACCEPTED' ? 'APPLICATION_ACCEPTED' : 'APPLICATION_REJECTED',
        linkId: application.opportunityId,
      },
    });

    return updated;
  }

  // ==========================================
  // 11. VALIDAR PRESENÇA E FEEDBACK NO EVENTO
  // ==========================================
  async validatePresence(applicationId: string, ongId: string, dto: ValidatePresenceDto) {
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
        status: dto.attended ? 'PRESENT' : 'ABSENT',
        attended: dto.attended,
        horasValidadas: dto.attended ? application.opportunity.durationHours : 0,
        ...(dto.feedbackOng !== undefined && { feedbackOng: dto.feedbackOng }),
      },
    });
  }

  // ==========================================
  // 12. FLASK ML (MOTOR DE RECOMENDAÇÃO)
  // ==========================================
  async getRecommendedOpportunities(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        habilidades: true,
        bio: true,
        nascimento: true,
        cidade: true,
        estado: true,
      },
    });

    if (!user) throw new NotFoundException('Usuário não encontrado');

    const existingApplications = await this.prisma.application.findMany({
      where: { userId },
      select: { opportunityId: true },
    });
    const appliedOppIds = existingApplications.map((app) => app.opportunityId);

    const opportunities = await this.prisma.opportunity.findMany({
      where: {
        id: { notIn: appliedOppIds },
        eventDate: { gte: new Date() },
        status: 'ATIVA',
      },
      select: {
        id: true,
        title: true,
        description: true,
        categories: true,
        requiredSkills: true,
        modality: true,
        minAge: true,
        status: true,
        eventDate: true,
        cidade: true,
        estado: true,
        latitude: true,
        longitude: true,
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
            bio: user.bio,
            nascimento: user.nascimento,
            cidade: user.cidade,
            estado: user.estado,
          },
          opportunities: opportunities,
        }),
      });

      const recommendations = (await flaskResponse.json()) as RecommendationResult[];

      const scoreMap = new Map<string, number>(
        recommendations.map((r) => [r.opportunityId, r.score]),
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
      console.error('Erro na integração com o Flask ML:', error);
      return opportunities.map((opp) => ({ ...opp, matchScore: 0 }));
    }
  }

  // ==========================================
  // 13. CANCELAR CANDIDATURA (Ação do Voluntário)
  // ==========================================
  async cancelApplication(opportunityId: string, userId: string, userRole: string) {
    if (userRole !== 'USER') {
      throw new UnauthorizedException('Apenas voluntários podem cancelar candidaturas.');
    }

    const application = await this.prisma.application.findUnique({
      where: { userId_opportunityId: { userId, opportunityId } },
      include: { opportunity: true },
    });

    if (!application) {
      throw new NotFoundException('Candidatura não encontrada.');
    }

    await this.prisma.application.delete({
      where: { id: application.id },
    });

    await this.syncOpportunityVacancyStatus(
      opportunityId,
      application.opportunity.totalVacancies,
      application.opportunity.status,
    );

    return { message: 'Candidatura cancelada com sucesso.' };
  }

  // ==========================================
  // 14. REMOVER INSCRIÇÃO (Ação da ONG)
  // ==========================================
  async removeApplication(applicationId: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') throw new UnauthorizedException('Apenas ONGs podem remover inscrições.');

    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: { opportunity: true },
    });

    if (!application) throw new NotFoundException('Inscrição não encontrada.');
    if (application.opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Permissão negada.');
    }

    const deleted = await this.prisma.application.delete({ where: { id: applicationId } });

    await this.syncOpportunityVacancyStatus(
      application.opportunityId,
      application.opportunity.totalVacancies,
      application.opportunity.status,
    );

    return deleted;
  }

  // ==========================================
  // AUXILIAR: SINCRONIZA LOTAÇÃO (ATIVA <-> LOTADA)
  // ==========================================
  private async syncOpportunityVacancyStatus(
    opportunityId: string,
    totalVacancies: number,
    currentStatus: string,
  ) {
    const acceptedCount = await this.prisma.application.count({
      where: { opportunityId, status: 'ACCEPTED' },
    });

    if (acceptedCount >= totalVacancies && currentStatus === 'ATIVA') {
      await this.prisma.opportunity.update({
        where: { id: opportunityId },
        data: { status: 'LOTADA' },
      });
    } else if (acceptedCount < totalVacancies && currentStatus === 'LOTADA') {
      await this.prisma.opportunity.update({
        where: { id: opportunityId },
        data: { status: 'ATIVA' },
      });
    }
  }

  // ==========================================
  // 15. LISTAR VAGAS DO VOLUNTÁRIO ("MINHAS VAGAS")
  // ==========================================
  async getMyApplications(userId: string, userRole: string) {
    if (userRole !== 'USER') {
      throw new UnauthorizedException('Acesso negado. Apenas voluntários possuem candidaturas.');
    }

    const applications = await this.prisma.application.findMany({
      where: { userId },
      include: {
        opportunity: {
          include: {
            ong: {
              select: {
                id: true,
                name: true,
                avatar: true,
                telefoneFixo: true,
                whatsapp: true,
              },
            },
          },
        },
      },
      orderBy: {
        opportunity: { eventDate: 'asc' },
      },
    });

    return applications.map((app) => ({
      applicationId: app.id,
      applicationStatus: app.status,
      attended: app.attended,
      horasValidadas: app.horasValidadas,
      feedbackOng: app.feedbackOng,
      certificateIssued: app.certificateIssued,
      certificateCode: app.certificateCode,
      tipoCarona: app.tipoCarona,
      detalhesCarona: app.detalhesCarona,
      appliedAt: app.createdAt,
      opportunity: app.opportunity,
    }));
  }

  // ==========================================
  // 16. FINALIZAR EVENTO E EMITIR CERTIFICADOS EM LOTE (Ação da ONG)
  // ==========================================
  async finalizeAndIssueCertificates(opportunityId: string, ongId: string, userRole: string) {
    if (userRole !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem finalizar eventos e emitir certificados.');
    }

    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id: opportunityId },
      include: {
        ong: { select: { name: true } },
        applications: {
          where: {
            OR: [{ status: 'PRESENT' }, { attended: true }],
          },
          include: {
            user: { select: { id: true, name: true } },
          },
        },
      },
    });

    if (!opportunity) throw new NotFoundException('Vaga não encontrada.');
    if (opportunity.ongId !== ongId) {
      throw new UnauthorizedException('Você só pode finalizar os seus próprios eventos.');
    }

    // 1. Encerra definitivamente o evento
    await this.prisma.opportunity.update({
      where: { id: opportunityId },
      data: { status: 'CONCLUIDA' },
    });

    if (opportunity.applications.length === 0) {
      return {
        message: 'Evento finalizado com sucesso, mas nenhum voluntário teve presença confirmada para emissão de certificado.',
        issuedCount: 0,
      };
    }

    const now = new Date();
    const year = now.getFullYear();
    let issuedCount = 0;

    // 2. Gera código único e notifica cada participante presente
    for (const app of opportunity.applications) {
      const code =
        app.certificateCode ||
        `ABC-${year}-${randomBytes(3).toString('hex').toUpperCase()}`;

      await this.prisma.application.update({
        where: { id: app.id },
        data: {
          certificateCode: code,
          certificateIssued: true,
          certificateDate: app.certificateDate || now,
          horasValidadas: app.horasValidadas || opportunity.durationHours,
        },
      });

      // Evita duplicar notificação se a ONG clicar duas vezes no botão
      if (!app.certificateIssued) {
        await this.prisma.notification.create({
          data: {
            userId: app.userId,
            title: '🎓 Certificado Disponível!',
            message: `Parabéns! Seu certificado de ${opportunity.durationHours}h pela participação em "${opportunity.title}" (${opportunity.ong.name}) já está disponível para download.`,
            type: 'CERTIFICATE_READY',
            linkId: app.id, // ID da application para baixar direto o PDF
          },
        });
        issuedCount++;
      }
    }

    return {
      message: `Evento finalizado e ${issuedCount} certificado(s) emitido(s) com sucesso!`,
      totalPresent: opportunity.applications.length,
      newlyIssued: issuedCount,
    };
  }

  // ==========================================
  // 17. BAIXAR CERTIFICADO EM PDF (Voluntário ou ONG)
  // ==========================================
  async generateCertificatePdf(applicationId: string, requesterId: string): Promise<{ buffer: Buffer; filename: string }> {
    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: {
        user: { select: { id: true, name: true, cpf: true } },
        opportunity: {
          include: {
            ong: { select: { id: true, name: true, razaoSocial: true, cnpj: true } },
          },
        },
      },
    });

    if (!application) throw new NotFoundException('Inscrição não encontrada.');

    // Garante que apenas o próprio voluntário ou a ONG organizadora baixe o PDF
    const isOwnerVolunteer = application.userId === requesterId;
    const isOwnerOng = application.opportunity.ongId === requesterId;
    if (!isOwnerVolunteer && !isOwnerOng) {
      throw new UnauthorizedException('Você não tem permissão para acessar este certificado.');
    }

    if (!application.certificateIssued || !application.certificateCode) {
      throw new ConflictException('O certificado ainda não foi emitido pela ONG para esta participação.');
    }

    // Cria PDF em formato A4 Paisagem (Landscape)
    const pdfDoc = await PDFDocument.create();
    const page = pdfDoc.addPage([841.89, 595.28]);
    const { width, height } = page.getSize();

    const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
    const fontRegular = await pdfDoc.embedFont(StandardFonts.Helvetica);

    // Moldura externa azul/verde institucional
    page.drawRectangle({
      x: 28,
      y: 28,
      width: width - 56,
      height: height - 56,
      borderColor: rgb(0.11, 0.45, 0.36),
      borderWidth: 3,
    });

    page.drawRectangle({
      x: 38,
      y: 38,
      width: width - 76,
      height: height - 76,
      borderColor: rgb(0.75, 0.85, 0.82),
      borderWidth: 1,
    });

    // Cabeçalho
    page.drawText('ABC DO BEM - PLATAFORMA DE VOLUNTARIADO', {
      x: 70,
      y: height - 95,
      size: 12,
      font: fontBold,
      color: rgb(0.11, 0.45, 0.36),
    });

    page.drawText('CERTIFICADO DE PARTICIPAÇÃO VOLUNTÁRIA', {
      x: 70,
      y: height - 140,
      size: 24,
      font: fontBold,
      color: rgb(0.12, 0.16, 0.22),
    });

    // Corpo do texto
    const horas = application.horasValidadas || application.opportunity.durationHours;
    const eventDateFormatted = new Date(application.opportunity.eventDate).toLocaleDateString('pt-BR');
    const cidade = application.opportunity.cidade || 'Grande ABC';
    const ongNome = application.opportunity.ong.razaoSocial || application.opportunity.ong.name;

    page.drawText('Certificamos que', {
      x: 70,
      y: height - 205,
      size: 14,
      font: fontRegular,
      color: rgb(0.3, 0.35, 0.4),
    });

    page.drawText(application.user.name.toUpperCase(), {
      x: 70,
      y: height - 240,
      size: 22,
      font: fontBold,
      color: rgb(0.11, 0.45, 0.36),
    });

    const linhas = [
      `participou como voluntário(a) da ação "${application.opportunity.title}",`,
      `promovida por ${ongNome} (CNPJ: ${application.opportunity.ong.cnpj || 'Não informado'}),`,
      `realizada em ${eventDateFormatted} na cidade de ${cidade} - SP,`,
      `totalizando carga horária de ${horas} hora(s) de atividades comunitárias.`,
    ];

    linhas.forEach((linha, index) => {
      page.drawText(linha, {
        x: 70,
        y: height - 290 - index * 26,
        size: 13,
        font: fontRegular,
        color: rgb(0.2, 0.24, 0.3),
      });
    });

    // Feedback da ONG (se houver)
    if (application.feedbackOng) {
      page.drawText(`Reconhecimento da ONG: "${application.feedbackOng.slice(0, 95)}"`, {
        x: 70,
        y: height - 415,
        size: 11,
        font: fontRegular,
        color: rgb(0.35, 0.4, 0.45),
      });
    }

    // Rodapé com código de autenticidade
    const issuedDateFormatted = new Date(application.certificateDate || new Date()).toLocaleDateString('pt-BR');
    page.drawText(`Emitido em ${issuedDateFormatted} | Código de Autenticidade: ${application.certificateCode}`, {
      x: 70,
      y: 70,
      size: 10,
      font: fontBold,
      color: rgb(0.35, 0.4, 0.45),
    });

    const pdfBytes = await pdfDoc.save();
    return {
      buffer: Buffer.from(pdfBytes),
      filename: `certificado-${application.certificateCode}.pdf`,
    };
  }
}