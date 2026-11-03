import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway {
  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  // Mapeia conexões de usuários para salas ou conexões diretas
  @SubscribeMessage('sendMessage')
  async handleMessage(
    @MessageBody() data: { senderId: string; receiverId: string; content: string },
    @ConnectedSocket() client: Socket,
  ) {
    // 1. Salva no banco de dados
    const savedMessage = await this.chatService.saveMessage(
      data.senderId,
      data.receiverId,
      data.content,
    );

    // 2. Emite o evento 'newMessage' em tempo real para os clientes conectados
    this.server.emit(`newMessage_${data.receiverId}`, savedMessage);
    this.server.emit(`newMessage_${data.senderId}`, savedMessage);

    return savedMessage;
  }
}