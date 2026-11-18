import { 
  Controller, Get, Body, Patch, Param, Query, UseGuards, Request, UnauthorizedException 
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { UpdateOngDto } from './dto/update-ong.dto';

@ApiTags('Users (Perfis e Dashboard)')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // ==========================================
  // 1. ROTAS DA ONG (Dashboard e Perfil Institucional)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('dashboard/ong')
  @ApiOperation({ summary: '[ONG] Carrega os indicadores do painel principal da ONG' })
  async getOngDashboard(@Request() req: any) {
    if (req.user.role !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem acessar ao dashboard institucional.');
    }
    return this.usersService.getOngDashboard(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('ongs/me')
  @ApiOperation({ summary: '[ONG] Atualiza o perfil da ONG autenticada' })
  @ApiBody({ type: UpdateOngDto })
  async updateOngProfile(@Request() req: any, @Body() dto: UpdateOngDto) {
    if (req.user.role !== 'ONG') {
      throw new UnauthorizedException('Apenas ONGs podem acessar a esta rota.');
    }
    return this.usersService.updateOng(req.user.userId, dto);
  }

  // ==========================================
  // 2. ROTAS DO VOLUNTÁRIO (Dashboard e Perfil Pessoal)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('dashboard/me')
  @ApiOperation({ summary: '[Voluntário] Retorna estatísticas, próximo evento e o histórico de candidaturas' })
  getDashboardData(@Request() req: any) {
    return this.usersService.getDashboardData(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('profile/me')
  @ApiOperation({ summary: '[Voluntário] Atualiza dados do próprio perfil (Avatar, Bio, Habilidades, etc)' })
  update(@Request() req: any, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(req.user.userId, updateUserDto);
  }

  // ==========================================
  // 3. ROTAS PÚBLICAS (Busca e Visualização de Perfis)
  // ==========================================

  @Get('ongs')
  @ApiOperation({ summary: '[Público] Lista todas as ONGs (Para a tela de Busca)' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'causa', required: false })
  findAllOngs(@Query('cidade') cidade?: string, @Query('causa') causa?: string) {
    return this.usersService.findAllOngs(cidade, causa);
  }

  @Get('voluntarios')
  @ApiOperation({ summary: '[Público] Lista todos os voluntários (Vitrine), com filtros opcionais' })
  @ApiQuery({ name: 'busca', required: false, description: 'Filtra por nome ou bio' })
  @ApiQuery({ name: 'cidade', required: false, description: 'Filtra por cidade' })
  @ApiQuery({ name: 'habilidade', required: false, description: 'Filtra por habilidade específica' })
  async getVoluntarios(
    @Query('busca') busca?: string,
    @Query('cidade') cidade?: string,
    @Query('habilidade') habilidade?: string,
  ) {
    return this.usersService.getVoluntarios(busca, cidade, habilidade);
  }

  @Get(':id')
  @ApiOperation({ summary: '[Público] Exibe o perfil completo (Com feedbacks, certificados e horas)' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }
}