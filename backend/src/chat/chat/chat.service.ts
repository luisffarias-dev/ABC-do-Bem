import { Injectable, NotFoundException } from '@nestjs/common';
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
        read: false,
      },
      include: {
        sender: { select: { id: true, name: true, avatar: true, role: true } },
      },
    });
  }

  // 2. Buscar o histórico de conversa com paginação (?page=1&limit=30)
  // 2. Buscar o histórico de conversa com paginação (Ocultando mensagens apagadas pelo usuário)
  async getChatHistory(userId: string, otherUserId: string, page: number = 1, limit: number = 30) {
    const skip = (page - 1) * limit;

    const messages = await this.prisma.message.findMany({
      where: {
        OR: [
          // Se eu enviei, só trago se eu não tiver apagado
          { senderId: userId, receiverId: otherUserId, deletedForSender: false },
          // Se eu recebi, só trago se eu não tiver apagado
          { senderId: otherUserId, receiverId: userId, deletedForReceiver: false },
        ],
      },
      orderBy: { createdAt: 'asc' }, // Cronológico ascendente
      skip,
      take: limit,
      include: {
        sender: { select: { id: true, name: true, avatar: true, role: true } },
      },
    });

    return messages;
  }

  // 3. Buscar a lista de conversas (Inbox) com a estrutura exata do contrato (Filtrando as ocultas)
  async getConversations(userId: string) {
    const messages = await this.prisma.message.findMany({
      where: {
        OR: [
          // Traz mensagens que enviei e não apaguei
          { senderId: userId, deletedForSender: false },
          // Traz mensagens que recebi e não apaguei
          { receiverId: userId, deletedForReceiver: false },
        ],
      },
      orderBy: { createdAt: 'desc' },
      include: {
        sender: { select: { id: true, name: true, avatar: true, role: true } },
        receiver: { select: { id: true, name: true, avatar: true, role: true } },
      },
    });

    const conversationsMap = new Map<string, any>();

    for (const msg of messages) {
      const isSender = msg.senderId === userId;
      const contact = isSender ? msg.receiver : msg.sender;
      
      if (!contact) continue;
      const contactId = contact.id;

      if (!conversationsMap.has(contactId)) {
        // Conta todas as mensagens não lidas enviadas por este contato para mim
        const unreadCount = messages.filter(
          (m) => m.senderId === contactId && m.receiverId === userId && !m.read
        ).length;

        conversationsMap.set(contactId, {
          id: contact.id, // ID do participante/sala
          participant: {
            id: contact.id,
            name: contact.name,
            avatar: contact.avatar,
            role: contact.role,
          },
          lastMessage: msg.content,
          lastMessageAt: msg.createdAt,
          unreadCount: unreadCount, // Inteiro exigido pela especificação
        });
      }
    }

    return Array.from(conversationsMap.values());
  }

  // 4. Marcar mensagens de uma conversa como lidas
  async markAsRead(userId: string, otherUserId: string) {
    return this.prisma.message.updateMany({
      where: {
        senderId: otherUserId,
        receiverId: userId,
        read: false,
      },
      data: {
        read: true,
      },
    });
  }

  // Aplicar Soft Hide na conversa
  async hideConversation(userId: string, otherUserId: string) {
    // Se fui eu que enviei, marco deletedForSender = true
    await this.prisma.message.updateMany({
      where: { senderId: userId, receiverId: otherUserId },
      data: { deletedForSender: true },
    });

    // Se fui eu que recebi, marco deletedForReceiver = true
    await this.prisma.message.updateMany({
      where: { senderId: otherUserId, receiverId: userId },
      data: { deletedForReceiver: true },
    });

    return { message: 'Conversa limpa com sucesso.' };
  }
}