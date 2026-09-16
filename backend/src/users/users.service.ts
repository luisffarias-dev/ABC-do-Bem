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

  // 2. DASHBOARD DO VOLUNTÁRIO (Estatísticas e Próximo Evento)
  async getDashboardData(userId: string) {
    const completedApps = await this.prisma.application.findMany({
      where: { userId, status: 'COMPLETED' },
      include: { opportunity: true },
    });

    const horasDoadas = completedApps.reduce((acc, curr) => acc + curr.opportunity.durationHours, 0);
    const ongsAjudadas = new Set(completedApps.map(app => app.opportunity.ongId)).size;
    const cidadesAtendidas = new Set(completedApps.map(app => app.opportunity.cidade)).size;

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

    return {
      estatisticas: { cidades: cidadesAtendidas, ongsAjudadas, horasDoadas, ranking: 4.8 },
      proximoEvento: proximoEvento ? proximoEvento.opportunity : null
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
}