import { 
  WebSocketGateway, SubscribeMessage, MessageBody, ConnectedSocket, 
  WebSocketServer, OnGatewayConnection, OnGatewayDisconnect 
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';

// O cors: true libera a conexão para o Live Server e para o Flutter
@WebSocketGateway({ cors: true })
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() 
  server: Server;

  // Um "dicionário" que guarda qual usuário (ID) está usando qual conexão (Socket)
  private activeUsers = new Map<string, string>();

  constructor(private readonly chatService: ChatService) {}

  // Quando o HTML/Flutter se conecta
  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    
    if (userId) {
      this.activeUsers.set(userId, client.id);
      console.log(`🟢 Usuário ${userId} conectou (Socket: ${client.id})`);
    }
  }

  // Quando o cliente fecha a aba ou perde a internet
  handleDisconnect(client: Socket) {
    const userId = [...this.activeUsers.entries()].find(([_, socketId]) => socketId === client.id)?.[0];
    if (userId) {
      this.activeUsers.delete(userId);
      console.log(`🔴 Usuário ${userId} desconectou`);
    }
  }

  // O evento que o HTML vai disparar quando você apertar "Enviar"
  @SubscribeMessage('sendMessage')
  async handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { receiverId: string; content: string },
  ) {
    // 1. Descobrir quem está enviando
    const senderId = [...this.activeUsers.entries()].find(([_, socketId]) => socketId === client.id)?.[0];
    
    if (!senderId) return { error: 'Usuário não identificado' };

    // 2. Salvar no Banco de Dados
    const savedMessage = await this.chatService.saveMessage(senderId, payload.receiverId, payload.content);

    // 3. Verificar se quem vai receber está online
    const receiverSocketId = this.activeUsers.get(payload.receiverId);

    if (receiverSocketId) {
      // Entrega instantânea
      this.server.to(receiverSocketId).emit('newMessage', savedMessage);
    }

    return savedMessage; 
  }
}