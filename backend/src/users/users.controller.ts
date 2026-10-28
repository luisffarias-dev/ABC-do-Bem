import { 
  Controller, Get, Body, Patch, Param, Query, UseGuards, Request 
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBearerAuth } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Users (Perfis e Dashboard)')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // ==========================================
  // ROTAS PÚBLICAS ESTÁTICAS (Ficam no topo)
  // ==========================================

  @Get('ongs')
  @ApiOperation({ summary: 'Lista todas as ONGs (Para o ecrã de Busca)' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'causa', required: false })
  findAllOngs(@Query('cidade') cidade?: string, @Query('causa') causa?: string) {
    return this.usersService.findAllOngs(cidade, causa);
  }

  @Get('voluntarios')
  @ApiOperation({ summary: 'Lista todos os voluntários (para busca/vitrine), com filtros opcionais' })
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

  // ==========================================
  // ROTAS PROTEGIDAS ESTÁTICAS
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('dashboard/me')
  @ApiOperation({ summary: 'Retorna as estatísticas e o próximo evento do voluntário logado' })
  getDashboardData(@Request() req: any) {
    const userId = req.user.userId;
    return this.usersService.getDashboardData(userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('profile/me')
  @ApiOperation({ summary: 'Atualiza dados do próprio perfil (Avatar, Bio, etc)' })
  update(@Request() req: any, @Body() updateUserDto: UpdateUserDto) {
    const userId = req.user.userId;
    return this.usersService.update(userId, updateUserDto);
  }

  // ==========================================
  // ROTAS DINÂMICAS (DEVEM FICAR POR ÚLTIMO)
  // ==========================================

  @Get(':id')
  @ApiOperation({ summary: 'Exibe o perfil completo (Público)' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }
}