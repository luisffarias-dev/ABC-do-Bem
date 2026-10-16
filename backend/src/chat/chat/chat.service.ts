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

  // 3. Buscar a lista de contatos (Caixa de Entrada / Inbox)
  async getConversations(userId: string) {
    // Traz todas as mensagens que o utilizador enviou ou recebeu, ordenadas das mais recentes para as mais antigas
    const messages = await this.prisma.message.findMany({
      where: {
        OR: [
          { senderId: userId },
          { receiverId: userId },
        ],
      },
      orderBy: { createdAt: 'desc' },
      include: {
        sender: { select: { id: true, name: true, avatar: true } },
        receiver: { select: { id: true, name: true, avatar: true } },
      },
    });

    // Usamos um Map para agrupar por contato e garantir que só pegamos a ÚLTIMA mensagem de cada um
    const conversationsMap = new Map<string, any>();

    for (const msg of messages) {
      // Descobre quem é a "outra pessoa" na conversa (se eu enviei, o contato é o receiver, e vice-versa)
      const isSender = msg.senderId === userId;
      const contact = isSender ? msg.receiver : msg.sender;
      
      if (!contact) continue;

      const contactId = contact.id;

      // Como as mensagens vêm por ordem decrescente, a primeira vez que o contato aparece é a mensagem mais recente!
      if (!conversationsMap.has(contactId)) {
        conversationsMap.set(contactId, {
          contactId: contact.id,
          name: contact.name,
          avatar: contact.avatar,
          lastMessage: msg.content,
          lastMessageAt: msg.createdAt,
          // Conta como não lida se a mensagem não foi lida E quem recebeu fui eu
          isUnread: !msg.read && !isSender, 
        });
      }
    }

    // Transforma o Map num Array para devolver como JSON
    return Array.from(conversationsMap.values());
  }
}