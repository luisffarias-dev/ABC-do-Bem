import { Controller, Get, Body, Patch, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';

@ApiTags('Users (Perfis e Dashboard)')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('ongs')
  @ApiOperation({ summary: 'Lista todas as ONGs (Para a tela de Busca)' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'causa', required: false })
  findAllOngs(@Query('cidade') cidade?: string, @Query('causa') causa?: string) {
    return this.usersService.findAllOngs(cidade, causa);
  }

  @Get(':id/dashboard')
  @ApiOperation({ summary: '🚀 Retorna as estatísticas e o próximo evento do voluntário' })
  getDashboardData(@Param('id') id: string) {
    return this.usersService.getDashboardData(id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Exibe o perfil completo' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Atualiza dados do perfil (Avatar, Bio, etc)' })
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
  }
}