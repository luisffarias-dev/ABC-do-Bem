import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  UseGuards,
  Request,
  Query,
  UnauthorizedException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiBody, ApiQuery } from '@nestjs/swagger';
import { SocialService } from './social.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateVolunteerExperienceDto } from './dto/create-volunteer-experience.dto';
import { CreateOngPostDto } from './dto/create-ong-post.dto';

@ApiTags('Social (Feed, Experiências e Seguidores)')
@Controller('social')
export class SocialController {
  constructor(private readonly socialService: SocialService) {}

  // ==========================================
  // 1. ROTAS DA ONG (MURAL DE POSTAGENS)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/postagens')
  @ApiOperation({ summary: '[ONG] Publica uma nova notícia ou campanha no mural' })
  @ApiBody({ type: CreateOngPostDto })
  createOngPost(@Request() req: any, @Body() dto: CreateOngPostDto) {
    if (req.user.role !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem publicar no mural institucional.');
    }
    return this.socialService.createOngPost(req.user.userId, dto);
  }

  // ==========================================
  // 2. ROTAS DO VOLUNTÁRIO (EXPERIÊNCIAS E SEGUIDORES)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('voluntarios/experiencias')
  @ApiOperation({ summary: '[Voluntário] Cria um novo relato de experiência' })
  @ApiBody({ type: CreateVolunteerExperienceDto })
  createExperience(@Request() req: any, @Body() dto: CreateVolunteerExperienceDto) {
    return this.socialService.createExperience(req.user.userId, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('voluntarios/experiencias/:id')
  @ApiOperation({ summary: '[Voluntário] Deleta um relato de experiência próprio' })
  deleteExperience(@Param('id') id: string, @Request() req: any) {
    return this.socialService.deleteExperience(id, req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/:ongId/seguir')
  @ApiOperation({ summary: '[Voluntário] Passa a seguir uma ONG' })
  followOng(@Param('ongId') ongId: string, @Request() req: any) {
    return this.socialService.followOng(req.user.userId, ongId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('ongs/:ongId/seguir')
  @ApiOperation({ summary: '[Voluntário] Deixa de seguir uma ONG' })
  unfollowOng(@Param('ongId') ongId: string, @Request() req: any) {
    return this.socialService.unfollowOng(req.user.userId, ongId);
  }

  // ==========================================
  // 3. INTERAÇÕES AUTENTICADAS (CURTIDAS E COMENTÁRIOS)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('voluntarios/experiencias/:id/like')
  @ApiOperation({ summary: '[Autenticado] Curte ou descurte um relato de experiência' })
  toggleLikeExperience(@Param('id') experienceId: string, @Request() req: any) {
    return this.socialService.toggleLikeExperience(req.user.userId, experienceId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/postagens/:id/like')
  @ApiOperation({ summary: '[Autenticado] Curte ou descurte uma postagem de ONG' })
  toggleLikeOngPost(@Param('id') postId: string, @Request() req: any) {
    return this.socialService.toggleLikeOngPost(req.user.userId, postId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/postagens/:id/comments')
  @ApiOperation({ summary: '[Autenticado] Adiciona um comentário em uma postagem da ONG' })
  createOngPostComment(
    @Param('id') postId: string,
    @Body() body: { content?: string; text?: string; comentario?: string },
    @Request() req: any,
  ) {
    const content = body.content ?? body.text ?? body.comentario ?? '';
    return this.socialService.createOngPostComment(postId, req.user.userId, content);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('ongs/postagens/comments/:commentId')
  @ApiOperation({ summary: '[Autenticado] Remove um comentário próprio (ou da ONG dona do post)' })
  deleteOngPostComment(@Param('commentId') commentId: string, @Request() req: any) {
    return this.socialService.deleteOngPostComment(commentId, req.user.userId);
  }

  // ==========================================
  // 4. ROTAS PÚBLICAS (FEED E LEITURA DE POSTS/COMENTÁRIOS)
  // ==========================================

  @Get('feed')
  @ApiOperation({ summary: '[Público] Retorna o feed unificado da Comunidade (com curtidas e contagem de comentários)' })
  @ApiQuery({ name: 'dias', required: false, type: Number, description: 'Postagens dos últimos X dias (padrão 10)' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Limite de itens retornados (padrão 20)' })
  getUnifiedFeed(
    @Query('dias') dias?: string,
    @Query('limit') limit?: string,
    @Request() req?: any,
  ) {
    const diasNumber = dias ? parseInt(dias, 10) : 10;
    const limitNumber = limit ? parseInt(limit, 10) : 20;
    const currentUserId = req?.user?.userId;

    return this.socialService.getUnifiedFeed(diasNumber, limitNumber, currentUserId);
  }

  @Get('ongs/:ongId/postagens')
  @ApiOperation({ summary: '[Público] Lista as postagens do mural da ONG (com _count.comments e commentsCount)' })
  getOngPosts(@Param('ongId') ongId: string, @Request() req?: any) {
    return this.socialService.getOngPosts(ongId, req?.user?.userId);
  }

  @Get('ongs/postagens/:id/comments')
  @ApiOperation({ summary: '[Público] Lista todos os comentários de uma postagem da ONG' })
  getOngPostComments(@Param('id') postId: string) {
    return this.socialService.getOngPostComments(postId);
  }

  @Get('voluntarios/:userId/experiencias')
  @ApiOperation({ summary: '[Público] Lista o feed de experiências de um voluntário' })
  getUserExperiences(@Param('userId') userId: string) {
    return this.socialService.getUserExperiences(userId);
  }
}