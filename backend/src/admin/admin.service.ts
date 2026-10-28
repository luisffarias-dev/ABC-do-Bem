import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service'; // Ajuste o caminho conforme o seu projeto
import { Role } from '@prisma/client';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  // ==========================================
  // 1. MÉTRICAS E DASHBOARD ADMIN
  // ==========================================
  async getDashboardStats() {
    const [totalVoluntarios, totalOngs, totalVagas, totalInscricoes, horasValidadas] = await Promise.all([
      this.prisma.user.count({ where: { role: Role.USER } }),
      this.prisma.user.count({ where: { role: Role.ONG } }),
      this.prisma.opportunity.count(),
      this.prisma.application.count(),
      this.prisma.application.aggregate({
        _sum: { horasValidadas: true },
      }),
    ]);

    return {
      totalVoluntarios,
      totalOngs,
      totalVagas,
      totalInscricoes,
      totalHorasDoadas: horasValidadas._sum.horasValidadas || 0,
    };
  }

  // ==========================================
  // 2. MODERAÇÃO DE VAGAS / OPORTUNIDADES
  // ==========================================
  async deleteOpportunity(id: string) {
    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) {
      throw new NotFoundException('Vaga não encontrada.');
    }

    await this.prisma.opportunity.delete({ where: { id } });
    return { message: 'Vaga/Evento removido com sucesso pela moderação.' };
  }

  // ==========================================
  // 3. MODERAÇÃO DE USUÁRIOS E ONGS
  // ==========================================
  async listAllUsers(role?: Role) {
    return this.prisma.user.findMany({
      where: role ? { role } : undefined,
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
        cidade: true,
        estado: true,
        createdAt: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateUserRole(userId: string, newRole: Role) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('Usuário não encontrado.');
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: { role: newRole },
      select: { id: true, name: true, email: true, role: true },
    });
  }

  async deleteUser(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('Usuário não encontrado.');
    }

    await this.prisma.user.delete({ where: { id: userId } });
    return { message: 'Usuário/ONG banido e removido do sistema.' };
  }

  // ==========================================
  // 4. MODERAÇÃO DO FEED SOCIAL
  // ==========================================
  async deleteOngPost(postId: string) {
    const post = await this.prisma.ongPost.findUnique({ where: { id: postId } });
    if (!post) throw new NotFoundException('Postagem não encontrada.');

    await this.prisma.ongPost.delete({ where: { id: postId } });
    return { message: 'Postagem removida do feed social.' };
  }

  async deleteVolunteerExperience(expId: string) {
    const exp = await this.prisma.volunteerExperience.findUnique({ where: { id: expId } });
    if (!exp) throw new NotFoundException('Relato não encontrado.');

    await this.prisma.volunteerExperience.delete({ where: { id: expId } });
    return { message: 'Relato de experiência removido.' };
  }
}