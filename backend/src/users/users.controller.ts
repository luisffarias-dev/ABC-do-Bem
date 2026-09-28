import { 
  Controller, Get, Body, Patch, Param, Query, UseGuards, Request 
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBearerAuth } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // VERIFIQUE ESTE CAMINHO

@ApiTags('Users (Perfis e Dashboard)')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // ==========================================
  // ROTAS PÚBLICAS
  // ==========================================

  @Get('ongs')
  @ApiOperation({ summary: 'Lista todas as ONGs (Para o ecrã de Busca)' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'causa', required: false })
  findAllOngs(@Query('cidade') cidade?: string, @Query('causa') causa?: string) {
    return this.usersService.findAllOngs(cidade, causa);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Exibe o perfil completo (Público)' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  // ==========================================
  // ROTAS PROTEGIDAS (Exigem Token JWT)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('dashboard/me') // Alterado: Não precisa mais de {id} no URL
  @ApiOperation({ summary: 'Retorna as estatísticas e o próximo evento do voluntário logado' })
  getDashboardData(@Request() req: any) {
    const userId = req.user.userId; // O sistema sabe quem é pelo Token!
    return this.usersService.getDashboardData(userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('profile/me') // Alterado: Não precisa mais de {id} no URL
  @ApiOperation({ summary: 'Atualiza dados do próprio perfil (Avatar, Bio, etc)' })
  update(@Request() req: any, @Body() updateUserDto: UpdateUserDto) {
    const userId = req.user.userId; // Garante que o utilizador só atualiza a si próprio
    return this.usersService.update(userId, updateUserDto);
  }
}