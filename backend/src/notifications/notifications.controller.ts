import { Controller, Get, Patch, Param, UseGuards, Req } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // Ajuste o caminho do seu guard
import type { Request } from 'express';

// Expondo na rota /api/v1/notificacoes (assumindo que o prefixo global /api/v1 está no main.ts)
@Controller('notificacoes')
@UseGuards(JwtAuthGuard) // Todas as rotas de notificações exigem utilizador logado
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  // GET /notificacoes
  @Get()
  async getMyNotifications(@Req() req: Request) {
    // req.user contém o payload do JWT. Ajuste de acordo com o seu formato de token.
    const userId = (req.user as any).id; 
    return this.notificationsService.getUserNotifications(userId);
  }

  // GET /notificacoes/total-nao-lidas
  @Get('total-nao-lidas')
  async getUnreadCount(@Req() req: Request) {
    const userId = (req.user as any).id;
    return this.notificationsService.countUnread(userId);
  }

  // PATCH /notificacoes/ler-todas (Importante colocar ANTES da rota com :id para não dar conflito)
  @Patch('ler-todas')
  async markAllAsRead(@Req() req: Request) {
    const userId = (req.user as any).id;
    return this.notificationsService.markAllAsRead(userId);
  }

  // PATCH /notificacoes/:id/ler
  @Patch(':id/ler')
  async markAsRead(@Param('id') id: string, @Req() req: Request) {
    const userId = (req.user as any).id;
    return this.notificationsService.markAsRead(id, userId);
  }
}