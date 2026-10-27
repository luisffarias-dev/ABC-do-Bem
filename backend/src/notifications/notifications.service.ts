import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service'; // Ajuste o caminho se o seu PrismaService estiver noutro lugar

@Injectable()
export class NotificationsService {
  constructor(private prisma: PrismaService) {}

  // Lista o histórico de notificações do utilizador (ordenado da mais recente para a mais antiga)
  async getUserNotifications(userId: string) {
    return this.prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Conta quantas notificações não lidas o utilizador tem (para o badge vermelho)
  async countUnread(userId: string) {
    const count = await this.prisma.notification.count({
      where: { 
        userId,
        read: false 
      },
    });
    
    return { totalNaoLidas: count };
  }

  // Marca uma notificação específica como lida
  async markAsRead(notificationId: string, userId: string) {
    const notification = await this.prisma.notification.findFirst({
      where: { id: notificationId, userId },
    });

    if (!notification) {
      throw new NotFoundException('Notificação não encontrada.');
    }

    await this.prisma.notification.update({
      where: { id: notificationId },
      data: { read: true },
    });

    return { lida: true };
  }

  // Marca todas as notificações do utilizador como lidas de uma só vez
  async markAllAsRead(userId: string) {
    const result = await this.prisma.notification.updateMany({
      where: { 
        userId,
        read: false 
      },
      data: { read: true },
    });

    return { atualizadas: result.count };
  }

  // (Função extra) Para os outros módulos usarem quando precisarem de enviar uma notificação
  async createNotification(userId: string, title: string, message: string, type?: string, linkId?: string) {
    return this.prisma.notification.create({
      data: {
        userId,
        title,
        message,
        type,
        linkId
      }
    });
  }
}