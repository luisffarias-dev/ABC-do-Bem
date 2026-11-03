import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  // 1. LISTA ONGS (Para a aba de Busca)
  async findAllOngs(cidade?: string, causa?: string) {
    return this.prisma.user.findMany({
      where: {
        role: 'ONG',
        ...(cidade && { cidade: { contains: cidade, mode: 'insensitive' } }),
        ...(causa && { causaPrincipal: { contains: causa, mode: 'insensitive' } }),
      },
      select: {
        id: true, name: true, avatar: true, cidade: true, estado: true,
        causaPrincipal: true, descricao: true,
        _count: { select: { opportunities: true } } 
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // 2. DASHBOARD DO VOLUNTÁRIO (Estatísticas, Próximo Evento e Histórico de Candidaturas)
  async getDashboardData(userId: string) {
    // 1. Busca todas as candidaturas concluídas para as estatísticas
    const completedApps = await this.prisma.application.findMany({
      where: { userId, status: 'COMPLETED' },
      include: { opportunity: true },
    });

    const horasDoadas = completedApps.reduce((acc, curr) => acc + curr.opportunity.durationHours, 0);
    const ongsAjudadas = new Set(completedApps.map(app => app.opportunity.ongId)).size;
    const cidadesAtendidas = new Set(completedApps.map(app => app.opportunity.cidade)).size;

    // 2. Busca o próximo evento confirmado
    const proximoEvento = await this.prisma.application.findFirst({
      where: { 
        userId, 
        status: 'CONFIRMED',
        opportunity: { eventDate: { gte: new Date() } }
      },
      include: {
        opportunity: { include: { ong: { select: { name: true, avatar: true } } } }
      },
      orderBy: { opportunity: { eventDate: 'asc' } }
    });

    // 3. Busca o histórico de TODAS as candidaturas do utilizador com os dados da Vaga e ONG
    const allApplications = await this.prisma.application.findMany({
      where: { userId: userId },
      include: {
        opportunity: {
          include: {
            ong: { select: { id: true, name: true, avatar: true } }
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    // Retorna as estatísticas, próximo evento e o array completo de candidaturas
    return {
      estatisticas: { cidades: cidadesAtendidas, ongsAjudadas, horasDoadas, ranking: 4.8 },
      proximoEvento: proximoEvento ? proximoEvento.opportunity : null,
      applications: allApplications // CAMPO ESSENCIAL ADICIONADO PARA O HISTÓRICO
    };
  }

  // 3. BUSCA UM PERFIL ESPECÍFICO
  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new NotFoundException('Usuário não encontrado');
    const { password, ...result } = user;
    return result;
  }

  // 4. ATUALIZA O PERFIL
  async update(id: string, dto: UpdateUserDto) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) throw new NotFoundException('Usuário não encontrado');
    
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: dto,
    });
    
    const { password, ...result } = updatedUser;
    return result;
  }

  async getVoluntarios(busca?: string, cidade?: string, habilidade?: string) {
  // Monta o filtro dinâmico
  const where: any = {
    role: 'USER', // Garante que traz apenas VOLUNTÁRIOS
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

  // Busca no banco excluindo a senha
  const voluntarios = await this.prisma.user.findMany({
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

  return voluntarios;
}

}