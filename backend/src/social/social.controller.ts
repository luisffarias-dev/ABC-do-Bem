import { Controller, Get, Post, Body, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { SocialService } from './social.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateVolunteerExperienceDto } from './dto/create-volunteer-experience.dto';
import { CreateOngPostDto } from './dto/create-ong-post.dto';

@ApiTags('Social (Feed, Experiências e Seguidores)')
@Controller('social')
export class SocialController {
  constructor(private readonly socialService: SocialService) {}

  // ==========================================
  // ROTAS: VOLUNTÁRIOS (EXPERIÊNCIAS)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('voluntarios/experiencias')
  @ApiOperation({ summary: 'Cria um novo relato de experiência (Voluntário)' })
  @ApiBody({ type: CreateVolunteerExperienceDto })
  createExperience(@Request() req: any, @Body() dto: CreateVolunteerExperienceDto) {
    const userId = req.user.userId;
    return this.socialService.createExperience(userId, dto);
  }

  @Get('voluntarios/:userId/experiencias')
  @ApiOperation({ summary: 'Lista o feed de publicações/experiências de um voluntário' })
  getUserExperiences(@Param('userId') userId: string) {
    return this.socialService.getUserExperiences(userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('voluntarios/experiencias/:id')
  @ApiOperation({ summary: 'Deleta um relato de experiência próprio' })
  deleteExperience(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId;
    return this.socialService.deleteExperience(id, userId);
  }

  // ==========================================
  // ROTAS: ONGS (MURAL DE POSTAGENS)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/postagens')
  @ApiOperation({ summary: 'Publica uma nova notícia no mural (Apenas ONG)' })
  @ApiBody({ type: CreateOngPostDto })
  createOngPost(@Request() req: any, @Body() dto: CreateOngPostDto) {
    const ongId = req.user.userId;
    return this.socialService.createOngPost(ongId, dto);
  }

  @Get('ongs/:ongId/postagens')
  @ApiOperation({ summary: 'Lista as novidades/postagens do mural da ONG' })
  getOngPosts(@Param('ongId') ongId: string) {
    return this.socialService.getOngPosts(ongId);
  }

  // ==========================================
  // ROTAS: SEGUIDORES (FOLLOW / UNFOLLOW)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ongs/:ongId/seguir')
  @ApiOperation({ summary: 'Voluntário autenticado segue a ONG' })
  followOng(@Param('ongId') ongId: string, @Request() req: any) {
    const volunteerId = req.user.userId;
    return this.socialService.followOng(volunteerId, ongId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('ongs/:ongId/seguir')
  @ApiOperation({ summary: 'Voluntário deixa de seguir a ONG' })
  unfollowOng(@Param('ongId') ongId: string, @Request() req: any) {
    const volunteerId = req.user.userId;
    return this.socialService.unfollowOng(volunteerId, ongId);
  }
}