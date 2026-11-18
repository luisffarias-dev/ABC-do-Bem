import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateOngDto } from './dto/update-ong.dto';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  // ==========================================
  // 1. LISTA ONGS (Para a aba de Busca)
  // ==========================================
  async findAllOngs(cidade?: string, causa?: string) {
    return this.prisma.user.findMany({
      where: {
        role: 'ONG',
        ...(cidade && { cidade: { contains: cidade, mode: 'insensitive' } }),
        ...(causa && { causaPrincipal: { contains: causa, mode: 'insensitive' } }),
      },
      select: {
        id: true,
        name: true,
        avatar: true,
        cidade: true,
        estado: true,
        causaPrincipal: true,
        descricao: true,
        _count: { select: { opportunities: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ==========================================
  // 2. DASHBOARD DO VOLUNTÁRIO (Estatísticas, Próximo Evento e Histórico)
  // ==========================================
  async getDashboardData(userId: string) {
    // 1. Busca todas as participações presenciais/concluídas para as estatísticas
    const completedApps = await this.prisma.application.findMany({
      where: {
        userId,
        OR: [
          { attended: true },
          { status: { in: ['PRESENT', 'COMPLETED'] } },
        ],
      },
      include: { opportunity: true },
    });

    const horasDoadas = completedApps.reduce(
      (acc, curr) => acc + (curr.horasValidadas || curr.opportunity.durationHours),
      0,
    );
    const ongsAjudadas = new Set(completedApps.map((app) => app.opportunity.ongId)).size;
    const cidadesAtendidas = new Set(
      completedApps.map((app) => app.opportunity.cidade).filter(Boolean),
    ).size;

    // 2. Busca o próximo evento aprovado/confirmado
    const proximoEvento = await this.prisma.application.findFirst({
      where: {
        userId,
        status: { in: ['ACCEPTED', 'CONFIRMED'] },
        opportunity: {
          eventDate: { gte: new Date() },
          status: { in: ['ATIVA', 'LOTADA'] },
        },
      },
      include: {
        opportunity: { include: { ong: { select: { name: true, avatar: true } } } },
      },
      orderBy: { opportunity: { eventDate: 'asc' } },
    });

    // 3. Busca o histórico de TODAS as candidaturas do utilizador com feedback e certificado
    const allApplications = await this.prisma.application.findMany({
      where: { userId },
      include: {
        opportunity: {
          include: {
            ong: { select: { id: true, name: true, avatar: true } },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return {
      estatisticas: { cidades: cidadesAtendidas, ongsAjudadas, horasDoadas, ranking: 4.8 },
      proximoEvento: proximoEvento ? proximoEvento.opportunity : null,
      applications: allApplications,
    };
  }

  // ==========================================
  // 3. BUSCA UM PERFIL ESPECÍFICO (Com feedbacks das ONGs, certificados e horas)
  // ==========================================
  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        applications: {
          where: {
            OR: [
              { attended: true },
              { status: { in: ['PRESENT', 'COMPLETED'] } },
            ],
          },
          select: {
            id: true,
            status: true,
            attended: true,
            horasValidadas: true,
            feedbackOng: true,
            certificateIssued: true,
            certificateCode: true,
            certificateDate: true,
            updatedAt: true,
            opportunity: {
              select: {
                id: true,
                title: true,
                eventDate: true,
                categories: true,
                cidade: true,
                ong: {
                  select: {
                    id: true,
                    name: true,
                    avatar: true,
                  },
                },
              },
            },
          },
          orderBy: { updatedAt: 'desc' },
        },
      },
    });

    if (!user) throw new NotFoundException('Usuário não encontrado');

    const totalHorasVoluntariado = user.applications.reduce(
      (acc, app) => acc + (app.horasValidadas || 0),
      0,
    );

    const { password, ...result } = user;

    return {
      ...result,
      totalHorasVoluntariado,
      eventosConcluidosCount: user.applications.length,
    };
  }

  // ==========================================
  // 4. ATUALIZA O PERFIL DO VOLUNTÁRIO
  // ==========================================
  async update(id: string, dto: UpdateUserDto) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new NotFoundException('Usuário não encontrado');

    const { email, ...updateData } = dto;
    const dataToUpdate: any = { ...updateData };

    if (email && email !== user.email) {
      const token = Math.floor(100000 + Math.random() * 900000).toString();
      dataToUpdate.pendingEmail = email;
      dataToUpdate.emailConfirmationToken = token;
      console.log(`[SIMULAÇÃO] Enviar código ${token} para confirmar o novo e-mail ${email}`);
    }

    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: dataToUpdate,
    });

    const { password, ...result } = updatedUser;

    if (dataToUpdate.pendingEmail) {
      return {
        ...result,
        message: 'Perfil atualizado parcialmente. Verifique a sua caixa de entrada para confirmar o novo e-mail antes de ele ficar ativo.',
      };
    }

    return result;
  }

  // ==========================================
  // 5. LISTAR VOLUNTÁRIOS (Busca / Filtros)
  // ==========================================
  async getVoluntarios(busca?: string, cidade?: string, habilidade?: string) {
    const where: any = {
      role: 'USER',
    };

    if (cidade) {
      where.cidade = { contains: cidade, mode: 'insensitive' };
    }

    if (habilidade) {
      where.habilidades = { has: habilidade };
    }

    if (busca) {
      where.OR = [
        { name: { contains: busca, mode: 'insensitive' } },
        { bio: { contains: busca, mode: 'insensitive' } },
      ];
    }

    return this.prisma.user.findMany({
      where,
      select: {
        id: true,
        name: true,
        email: true,
        avatar: true,
        bio: true,
        cidade: true,
        estado: true,
        habilidades: true,
        disponibilidade: true,
        telefone: true,
        createdAt: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ==========================================
  // 6. ATUALIZAR PERFIL DA ONG
  // ==========================================
  async updateOng(id: string, dto: UpdateOngDto) {
    const user = await this.prisma.user.findUnique({ where: { id, role: 'ONG' } });
    if (!user) throw new NotFoundException('ONG não encontrada');

    const { email, ...updateData } = dto;
    const dataToUpdate: any = { ...updateData };

    if (email && email !== user.email) {
      const token = Math.floor(100000 + Math.random() * 900000).toString();
      dataToUpdate.pendingEmail = email;
      dataToUpdate.emailConfirmationToken = token;
      console.log(`[SIMULAÇÃO] Enviar código ${token} para confirmar o novo e-mail da ONG ${email}`);
    }

    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: dataToUpdate,
    });

    const { password, ...result } = updatedUser;

    if (dataToUpdate.pendingEmail) {
      return {
        ...result,
        message: 'Perfil atualizado parcialmente. Verifique a sua caixa de entrada para confirmar o novo e-mail antes de ele ficar ativo.',
      };
    }

    return result;
  }

  // ==========================================
  // 7. DASHBOARD DA ONG
  // ==========================================
  async getOngDashboard(ongId: string) {
    // 1. Total de voluntários engajados (Candidaturas ACEITES)
    const totalVoluntariosEngajados = await this.prisma.application.count({
      where: {
        opportunity: { ongId },
        status: 'ACCEPTED',
      },
    });

    // 2. Vagas abertas (Soma das vagas disponíveis em eventos ATIVOS)
    const eventosAtivos = await this.prisma.opportunity.findMany({
      where: { ongId, status: 'ATIVA' },
      select: {
        totalVacancies: true,
        _count: { select: { applications: { where: { status: 'ACCEPTED' } } } },
      },
    });

    let vagasAbertas = 0;
    eventosAtivos.forEach((evento: any) => {
      const vagasRestantes = evento.totalVacancies - evento._count.applications;
      vagasAbertas += vagasRestantes > 0 ? vagasRestantes : 0;
    });

    // 3. Horas Geradas (Soma das horas de eventos CONCLUÍDOS pela ONG)
    const eventosConcluidos = await this.prisma.opportunity.findMany({
      where: { ongId, status: 'CONCLUIDA' },
      select: { durationHours: true },
    });
    const horasGeradas = eventosConcluidos.reduce((acc, evento) => acc + evento.durationHours, 0);

    // 4. Candidaturas Pendentes (Aguardando análise da ONG)
    const candidaturasPendentesCount = await this.prisma.application.count({
      where: {
        opportunity: { ongId },
        status: 'PENDING',
      },
    });

    return {
      totalVoluntariosEngajados,
      vagasAbertas,
      horasGeradas,
      candidaturasPendentesCount,
    };
  }
}