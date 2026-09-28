import { Module } from '@nestjs/common';
import { ChatService } from './chat/chat.service';
import { ChatGateway } from './chat/chat.gateway';
import { PrismaModule } from '../prisma/prisma.module'; 
import { ChatController } from './chat/chat.controller';

@Module({
  imports: [PrismaModule], // Permite o acesso ao banco de dados
  controllers: [ChatController],
  providers: [ChatGateway, ChatService],
})
export class ChatModule {}