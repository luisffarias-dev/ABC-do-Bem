import { Controller, Get, Delete, Patch, Param, Body, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // Ajuste o caminho conforme seu projeto
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@ApiTags('Admin (Moderação e Métricas)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMIN') // Exige que a role do Token seja ADMIN em todas as rotas deste controller
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  // GET /admin/stats
  @Get('stats')
  @ApiOperation({ summary: 'Retorna estatísticas e métricas gerais do sistema' })
  getStats() {
    return this.adminService.getDashboardStats();
  }

  // GET /admin/users
  @Get('users')
  @ApiOperation({ summary: 'Lista todos os usuários do sistema com filtro opcional de Role' })
  @ApiQuery({ name: 'role', enum: Role, required: false })
  listUsers(@Query('role') role?: Role) {
    return this.adminService.listAllUsers(role);
  }

  // PATCH /admin/users/:id/role
  @Patch('users/:id/role')
  @ApiOperation({ summary: 'Altera o privilégio/role de um usuário (ex: Promover para ADMIN)' })
  updateRole(@Param('id') id: string, @Body('role') role: Role) {
    return this.adminService.updateUserRole(id, role);
  }

  // DELETE /admin/users/:id
  @Delete('users/:id')
  @ApiOperation({ summary: 'Bane/Remove um usuário ou ONG do sistema' })
  deleteUser(@Param('id') id: string) {
    return this.adminService.deleteUser(id);
  }

  // DELETE /admin/opportunities/:id
  @Delete('opportunities/:id')
  @ApiOperation({ summary: 'Remove uma vaga/evento inapropriado ou fake' })
  deleteOpportunity(@Param('id') id: string) {
    return this.adminService.deleteOpportunity(id);
  }

  // DELETE /admin/social/posts/:id
  @Delete('social/posts/:id')
  @ApiOperation({ summary: 'Remove uma postagem de ONG do feed social' })
  deletePost(@Param('id') id: string) {
    return this.adminService.deleteOngPost(id);
  }

  // DELETE /admin/social/experiences/:id
  @Delete('social/experiences/:id')
  @ApiOperation({ summary: 'Remove um relato de voluntário do feed social' })
  deleteExperience(@Param('id') id: string) {
    return this.adminService.deleteVolunteerExperience(id);
  }
}