import { Controller, Get, Post, Delete, Patch, Param, Body, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiParam, ApiQuery } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';

@ApiTags('Chat (Mensagens)')
@Controller('chat')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('conversations')
  @ApiOperation({ summary: 'Lista de conversas do usuário (Inbox)' })
  getConversations(@Request() req: any) {
    const userId = req.user.userId;
    return this.chatService.getConversations(userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('conversations/:id/messages')
  @ApiOperation({ summary: 'Histórico de mensagens de uma sala/contato com paginação' })
  @ApiParam({ name: 'id', description: 'ID do outro usuário (participante)' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  getMessages(
    @Param('id') otherUserId: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Request() req?: any,
  ) {
    const userId = req.user.userId;
    const pageNumber = page ? parseInt(page, 10) : 1;
    const limitNumber = limit ? parseInt(limit, 10) : 30;
    return this.chatService.getChatHistory(userId, otherUserId, pageNumber, limitNumber);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('conversations/:id/messages')
  @ApiOperation({ summary: 'Enviar mensagem para um contato' })
  @ApiParam({ name: 'id', description: 'ID do usuário destinatário' })
  async sendMessage(
    @Param('id') receiverId: string,
    @Body('content') content: string,
    @Request() req: any,
  ) {
    const senderId = req.user.userId;
    return this.chatService.saveMessage(senderId, receiverId, content);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('conversations/:id/read')
  @ApiOperation({ summary: 'Marcar mensagens da conversa como lidas (zera unreadCount)' })
  @ApiParam({ name: 'id', description: 'ID do usuário remetente' })
  markAsRead(@Param('id') otherUserId: string, @Request() req: any) {
    const userId = req.user.userId;
    return this.chatService.markAsRead(userId, otherUserId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('conversations/:id')
  @ApiOperation({ summary: 'Limpa a conversa (Soft Hide) apenas para o utilizador que solicitou' })
  hideConversation(@Param('id') otherUserId: string, @Request() req: any) {
    const userId = req.user.userId;
    return this.chatService.hideConversation(userId, otherUserId);
  }
}