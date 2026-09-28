import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}

  // 1. Salvar uma nova mensagem no banco
  async saveMessage(senderId: string, receiverId: string, content: string) {
    return this.prisma.message.create({
      data: {
        senderId,
        receiverId,
        content,
      },
    });
  }

  // 2. Buscar o histórico de conversa entre dois usuários (Voluntário e ONG)
  async getChatHistory(userOneId: string, userTwoId: string) {
    return this.prisma.message.findMany({
      where: {
        OR: [
          { senderId: userOneId, receiverId: userTwoId },
          { senderId: userTwoId, receiverId: userOneId },
        ],
      },
      orderBy: { createdAt: 'asc' }, // As mais antigas primeiro, igual WhatsApp
    });
  }
}