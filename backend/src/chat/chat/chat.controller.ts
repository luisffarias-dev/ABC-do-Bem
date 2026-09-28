import { Controller, Get, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard'; // Verifique o caminho

@ApiTags('Chat (Mensagens)')
@Controller('chat')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('history/:otherUserId')
  @ApiOperation({ summary: 'Recupera o histórico de mensagens entre o utilizador logado e outro utilizador' })
  @ApiParam({ name: 'otherUserId', description: 'ID da ONG ou Voluntário com quem se está a conversar' })
  getHistory(@Param('otherUserId') otherUserId: string, @Request() req: any) {
    const myUserId = req.user.userId; // Extraído do token com segurança
    return this.chatService.getChatHistory(myUserId, otherUserId);
  }
}