import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGoalDto, UpdateGoalDto } from './dto/goal.dto';
import {
  CreateSupplyDto,
  UpdateSupplyDto,
  CreatePledgeDto,
  UpdatePledgeStatusDto,
} from './dto/supply.dto';

@Injectable()
export class OngsService {
  constructor(private prisma: PrismaService) {}

  private ensureOng(role: string) {
    if (role !== 'ONG') {
      throw new UnauthorizedException('Acesso negado. Apenas ONGs podem acessar este recurso.');
    }
  }

  // ==========================================
  // 1. MÓDULO DE METAS DA INSTITUIÇÃO (Card 4)
  // ==========================================

  async getMyGoals(ongId: string, role: string) {
    this.ensureOng(role);

    const goals = await this.prisma.ongGoal.findMany({
      where: { ongId },
      orderBy: [{ status: 'asc' }, { createdAt: 'desc' }],
    });

    return goals.map((g) => ({
      ...g,
      percentualConcluido: Math.min(100, Math.round((g.valorAtual / g.valorMeta) * 100)),
    }));
  }

  async createGoal(ongId: string, role: string, dto: CreateGoalDto) {
    this.ensureOng(role);

    const valorAtual = dto.valorAtual ?? 0;
    const status = valorAtual >= dto.valorMeta ? 'CONCLUIDA' : 'EM_ANDAMENTO';

    const goal = await this.prisma.ongGoal.create({
      data: {
        ongId,
        titulo: dto.titulo,
        descricao: dto.descricao,
        valorAtual,
        valorMeta: dto.valorMeta,
        unidade: dto.unidade,
        prazoLimite: dto.prazoLimite ? new Date(dto.prazoLimite) : null,
        status,
      },
    });

    return {
      ...goal,
      percentualConcluido: Math.min(100, Math.round((goal.valorAtual / goal.valorMeta) * 100)),
    };
  }

  async updateGoal(goalId: string, ongId: string, role: string, dto: UpdateGoalDto) {
    this.ensureOng(role);

    const existing = await this.prisma.ongGoal.findUnique({ where: { id: goalId } });
    if (!existing) throw new NotFoundException('Meta não encontrada.');
    if (existing.ongId !== ongId) throw new UnauthorizedException('Permissão negada.');

    const novoValorAtual = dto.valorAtual ?? existing.valorAtual;
    const novaMeta = dto.valorMeta ?? existing.valorMeta;

    let novoStatus = dto.status ?? existing.status;
    if (novoValorAtual >= novaMeta && !dto.status) {
      novoStatus = 'CONCLUIDA';
    } else if (novoValorAtual < novaMeta && existing.status === 'CONCLUIDA' && !dto.status) {
      novoStatus = 'EM_ANDAMENTO';
    }

    const updated = await this.prisma.ongGoal.update({
      where: { id: goalId },
      data: {
        ...(dto.titulo !== undefined && { titulo: dto.titulo }),
        ...(dto.descricao !== undefined && { descricao: dto.descricao }),
        ...(dto.valorAtual !== undefined && { valorAtual: dto.valorAtual }),
        ...(dto.valorMeta !== undefined && { valorMeta: dto.valorMeta }),
        ...(dto.unidade !== undefined && { unidade: dto.unidade }),
        ...(dto.prazoLimite !== undefined && {
          prazoLimite: dto.prazoLimite ? new Date(dto.prazoLimite) : null,
        }),
        status: novoStatus,
      },
    });

    return {
      ...updated,
      percentualConcluido: Math.min(100, Math.round((updated.valorAtual / updated.valorMeta) * 100)),
    };
  }

  async deleteGoal(goalId: string, ongId: string, role: string) {
    this.ensureOng(role);

    const existing = await this.prisma.ongGoal.findUnique({ where: { id: goalId } });
    if (!existing) throw new NotFoundException('Meta não encontrada.');
    if (existing.ongId !== ongId) throw new UnauthorizedException('Permissão negada.');

    await this.prisma.ongGoal.delete({ where: { id: goalId } });
    return { message: 'Meta excluída com sucesso.' };
  }

  // ==========================================
  // 2. MINI-ERP DE SUPRIMENTOS E DOAÇÕES (Card 5)
  // ==========================================

  private enrichSupply(supply: any) {
    const saldoFaltante = Math.max(0, supply.quantidadeMeta - supply.quantidadeRecebida);
    const saldoSemPromessas = Math.max(
      0,
      supply.quantidadeMeta - (supply.quantidadeRecebida + supply.quantidadePrometida),
    );
    const percentualRecebido = Math.min(
      100,
      Math.round((supply.quantidadeRecebida / supply.quantidadeMeta) * 100),
    );

    return {
      ...supply,
      saldoFaltante,
      saldoSemPromessas,
      percentualRecebido,
    };
  }

  private async syncProfileNecessidades(ongId: string) {
    const openSupplies = await this.prisma.ongSupply.findMany({
      where: {
        ongId,
        sincronizarPerfil: true,
        status: { in: ['ABERTO', 'PARCIAL'] },
      },
      orderBy: [{ prioridade: 'desc' }, { createdAt: 'asc' }],
    });

    const formattedList = openSupplies
      .map((item) => {
        const faltante = Math.max(0, item.quantidadeMeta - item.quantidadeRecebida);
        return faltante > 0 ? `${item.nome} (Faltam ${faltante} ${item.unidade})` : null;
      })
      .filter((entry): entry is string => entry !== null);

    await this.prisma.user.update({
      where: { id: ongId },
      data: { necessidadesAtuais: formattedList },
    });
  }

  async getMySupplies(ongId: string, role: string) {
    this.ensureOng(role);

    const supplies = await this.prisma.ongSupply.findMany({
      where: { ongId },
      include: {
        pledges: {
          include: {
            volunteer: { select: { id: true, name: true, avatar: true, telefone: true } },
          },
          orderBy: { createdAt: 'desc' },
        },
      },
      orderBy: [{ status: 'asc' }, { createdAt: 'desc' }],
    });

    return supplies.map((s) => this.enrichSupply(s));
  }

  async getPublicOngSupplies(ongId: string) {
    const supplies = await this.prisma.ongSupply.findMany({
      where: {
        ongId,
        status: { in: ['ABERTO', 'PARCIAL'] },
      },
      orderBy: [{ prioridade: 'desc' }, { createdAt: 'desc' }],
    });

    return supplies.map((s) => this.enrichSupply(s));
  }

  async createSupply(ongId: string, role: string, dto: CreateSupplyDto) {
    this.ensureOng(role);

    const qtdRecebida = dto.quantidadeRecebida ?? 0;
    const status =
      qtdRecebida >= dto.quantidadeMeta
        ? 'ATENDIDO'
        : qtdRecebida > 0
          ? 'PARCIAL'
          : 'ABERTO';

    const supply = await this.prisma.ongSupply.create({
      data: {
        ongId,
        nome: dto.nome,
        unidade: dto.unidade,
        quantidadeMeta: dto.quantidadeMeta,
        quantidadeRecebida: qtdRecebida,
        prazoLimite: dto.prazoLimite ? new Date(dto.prazoLimite) : null,
        prioridade: dto.prioridade ?? 'MEDIA',
        status,
        sincronizarPerfil: dto.sincronizarPerfil ?? true,
      },
    });

    await this.syncProfileNecessidades(ongId);

    const ong = await this.prisma.user.findUnique({
      where: { id: ongId },
      select: { name: true, cidade: true, causaPrincipal: true },
    });

    // Notifica seguidores + voluntários da mesma cidade/causa (sem poluir o feed)
    if (dto.notificarVoluntarios !== false && status !== 'ATENDIDO') {
      const followers = await this.prisma.ongFollower.findMany({
        where: { ongId },
        select: { volunteerId: true },
      });

      const compatibleVolunteers = await this.prisma.user.findMany({
        where: {
          role: 'USER',
          OR: [
            ...(ong?.cidade ? [{ cidade: { contains: ong.cidade, mode: 'insensitive' as const } }] : []),
            ...(ong?.causaPrincipal ? [{ habilidades: { has: ong.causaPrincipal } }] : []),
          ],
        },
        select: { id: true },
        take: 100,
      });

      const targetIds = new Set<string>([
        ...followers.map((f) => f.volunteerId),
        ...compatibleVolunteers.map((v) => v.id),
      ]);

      if (targetIds.size > 0) {
        const faltante = Math.max(0, supply.quantidadeMeta - supply.quantidadeRecebida);
        const prazoTxt = supply.prazoLimite
          ? ` até ${new Date(supply.prazoLimite).toLocaleDateString('pt-BR')}`
          : '';

        await this.prisma.notification.createMany({
          data: Array.from(targetIds).map((userId) => ({
            userId,
            title: `📦 Nova necessidade: ${ong?.name || 'ONG parceira'}`,
            message: `Precisamos de ${faltante} ${supply.unidade} de ${supply.nome}${prazoTxt}. Toque para responder com "Posso ajudar".`,
            type: 'SUPPLY_NEEDED',
            linkId: supply.id,
          })),
        });
      }
    }

    // Criação de postagem no mural APENAS se explicitamente marcada via publicarNoFeed
    if (dto.publicarNoFeed === true) {
      const faltante = Math.max(0, supply.quantidadeMeta - supply.quantidadeRecebida);
      await this.prisma.ongPost.create({
        data: {
          ongId,
          title: `Campanha de Arrecadação: ${supply.nome}`,
          text: `Estamos arrecadando ${faltante} ${supply.unidade} de ${supply.nome}. Sua doação faz toda a diferença!`,
        },
      });
    }

    return this.enrichSupply(supply);
  }

  async updateSupply(supplyId: string, ongId: string, role: string, dto: UpdateSupplyDto) {
    this.ensureOng(role);

    const existing = await this.prisma.ongSupply.findUnique({ where: { id: supplyId } });
    if (!existing) throw new NotFoundException('Suprimento não encontrado.');
    if (existing.ongId !== ongId) throw new UnauthorizedException('Permissão negada.');

    const novaMeta = dto.quantidadeMeta ?? existing.quantidadeMeta;
    const novaRecebida = dto.quantidadeRecebida ?? existing.quantidadeRecebida;

    let novoStatus = dto.status ?? existing.status;
    if (!dto.status) {
      if (novaRecebida >= novaMeta) novoStatus = 'ATENDIDO';
      else if (novaRecebida > 0 || existing.quantidadePrometida > 0) novoStatus = 'PARCIAL';
      else novoStatus = 'ABERTO';
    }

    const updated = await this.prisma.ongSupply.update({
      where: { id: supplyId },
      data: {
        ...(dto.nome !== undefined && { nome: dto.nome }),
        ...(dto.unidade !== undefined && { unidade: dto.unidade }),
        ...(dto.quantidadeMeta !== undefined && { quantidadeMeta: dto.quantidadeMeta }),
        ...(dto.quantidadeRecebida !== undefined && { quantidadeRecebida: dto.quantidadeRecebida }),
        ...(dto.prazoLimite !== undefined && {
          prazoLimite: dto.prazoLimite ? new Date(dto.prazoLimite) : null,
        }),
        ...(dto.prioridade !== undefined && { prioridade: dto.prioridade }),
        ...(dto.sincronizarPerfil !== undefined && { sincronizarPerfil: dto.sincronizarPerfil }),
        status: novoStatus,
      },
    });

    await this.syncProfileNecessidades(ongId);
    return this.enrichSupply(updated);
  }

  async deleteSupply(supplyId: string, ongId: string, role: string) {
    this.ensureOng(role);

    const existing = await this.prisma.ongSupply.findUnique({ where: { id: supplyId } });
    if (!existing) throw new NotFoundException('Suprimento não encontrado.');
    if (existing.ongId !== ongId) throw new UnauthorizedException('Permissão negada.');

    await this.prisma.ongSupply.delete({ where: { id: supplyId } });
    await this.syncProfileNecessidades(ongId);

    return { message: 'Item de suprimento removido com sucesso.' };
  }

  // ==========================================
  // 3. COMPROMISSOS / PROMESSAS DE DOAÇÃO (Pledges)
  // ==========================================

  async createPledge(supplyId: string, user: { userId: string; role: string }, dto: CreatePledgeDto) {
    const supply = await this.prisma.ongSupply.findUnique({
      where: { id: supplyId },
      include: { ong: { select: { id: true, name: true } } },
    });

    if (!supply) throw new NotFoundException('Item de suprimento não encontrado.');
    if (supply.status === 'ATENDIDO' || supply.status === 'CANCELADO') {
      throw new BadRequestException('Este item já teve a meta atendida ou foi encerrado.');
    }

    const actor = await this.prisma.user.findUnique({
      where: { id: user.userId },
      select: { id: true, name: true, telefone: true, role: true },
    });

    const isVolunteer = actor?.role === 'USER';
    const doadorNome = dto.doadorNome?.trim() || actor?.name || 'Doador Solidário';
    const doadorContato = dto.doadorContato?.trim() || actor?.telefone || null;

    const pledge = await this.prisma.$transaction(async (tx) => {
      const created = await tx.supplyPledge.create({
        data: {
          supplyId,
          volunteerId: isVolunteer ? actor.id : null,
          doadorNome,
          doadorContato,
          quantidade: dto.quantidade,
          dataLimiteEntrega: dto.dataLimiteEntrega ? new Date(dto.dataLimiteEntrega) : null,
          status: 'PROMETIDO',
          observacoes: dto.observacoes,
        },
      });

      const novaPrometida = supply.quantidadePrometida + dto.quantidade;
      const novoStatus =
        supply.quantidadeRecebida >= supply.quantidadeMeta
          ? 'ATENDIDO'
          : supply.quantidadeRecebida > 0 || novaPrometida > 0
            ? 'PARCIAL'
            : 'ABERTO';

      await tx.ongSupply.update({
        where: { id: supplyId },
        data: {
          quantidadePrometida: novaPrometida,
          status: novoStatus,
        },
      });

      return created;
    });

    // Notifica a ONG de volta informando quem vai ajudar, quantidade e prazo
    const prazoTxt = pledge.dataLimiteEntrega
      ? ` até ${new Date(pledge.dataLimiteEntrega).toLocaleDateString('pt-BR')}`
      : '';

    await this.prisma.notification.create({
      data: {
        userId: supply.ongId,
        title: '🤝 Novo Compromisso de Doação!',
        message: `${doadorNome} se comprometeu a doar ${dto.quantidade} ${supply.unidade} de ${supply.nome}${prazoTxt}.`,
        type: 'NEW_PLEDGE',
        linkId: supply.id,
      },
    });

    return {
      message: 'Compromisso de doação registrado com sucesso!',
      pledge,
    };
  }

  async updatePledgeStatus(
    pledgeId: string,
    ongId: string,
    role: string,
    dto: UpdatePledgeStatusDto,
  ) {
    this.ensureOng(role);

    const pledge = await this.prisma.supplyPledge.findUnique({
      where: { id: pledgeId },
      include: {
        supply: {
          include: { ong: { select: { name: true } } },
        },
      },
    });

    if (!pledge) throw new NotFoundException('Compromisso de doação não encontrado.');
    if (pledge.supply.ongId !== ongId) {
      throw new UnauthorizedException('Apenas a ONG responsável pode gerenciar esta doação.');
    }

    if (pledge.status === dto.status) {
      return { message: 'Status já está atualizado.', pledge };
    }

    const updatedPledge = await this.prisma.$transaction(async (tx) => {
      const updated = await tx.supplyPledge.update({
        where: { id: pledgeId },
        data: {
          status: dto.status,
          ...(dto.observacoes !== undefined && { observacoes: dto.observacoes }),
        },
      });

      let novaRecebida = pledge.supply.quantidadeRecebida;
      let novaPrometida = pledge.supply.quantidadePrometida;

      // Transição de PROMETIDO/ATRASADO -> ENTREGUE
      if (dto.status === 'ENTREGUE' && pledge.status !== 'ENTREGUE') {
        novaRecebida += pledge.quantidade;
        if (pledge.status === 'PROMETIDO' || pledge.status === 'ATRASADO') {
          novaPrometida = Math.max(0, novaPrometida - pledge.quantidade);
        }
      }

      // Transição de PROMETIDO/ATRASADO -> CANCELADO
      if (
        dto.status === 'CANCELADO' &&
        (pledge.status === 'PROMETIDO' || pledge.status === 'ATRASADO')
      ) {
        novaPrometida = Math.max(0, novaPrometida - pledge.quantidade);
      }

      const novoStatusSupply =
        novaRecebida >= pledge.supply.quantidadeMeta
          ? 'ATENDIDO'
          : novaRecebida > 0 || novaPrometida > 0
            ? 'PARCIAL'
            : 'ABERTO';

      await tx.ongSupply.update({
        where: { id: pledge.supplyId },
        data: {
          quantidadeRecebida: novaRecebida,
          quantidadePrometida: novaPrometida,
          status: novoStatusSupply,
        },
      });

      return updated;
    });

    // Sincroniza necessidadesAtuais do perfil da ONG (remove se atingiu a meta)
    await this.syncProfileNecessidades(ongId);

    // Dispara notificação de agradecimento ao voluntário quando ENTREGUE
    if (dto.status === 'ENTREGUE' && pledge.volunteerId) {
      await this.prisma.notification.create({
        data: {
          userId: pledge.volunteerId,
          title: '💚 Doação Recebida! Obrigado!',
          message: `A ONG ${pledge.supply.ong.name} confirmou o recebimento de ${pledge.quantidade} ${pledge.supply.unidade} de ${pledge.supply.nome}. Muito obrigado pela sua solidariedade!`,
          type: 'PLEDGE_DELIVERED',
          linkId: pledge.supplyId,
        },
      });
    }

    return {
      message: `Status da doação atualizado para ${dto.status}.`,
      pledge: updatedPledge,
    };
  }
}