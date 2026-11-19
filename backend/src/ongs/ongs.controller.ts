import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { OngsService } from './ongs.service';
import { CreateGoalDto, UpdateGoalDto } from './dto/goal.dto';
import {
  CreateSupplyDto,
  UpdateSupplyDto,
  CreatePledgeDto,
  UpdatePledgeStatusDto,
} from './dto/supply.dto';

@ApiTags('ONGs (Metas e Suprimentos / ERP)')
@Controller('ongs')
export class OngsController {
  constructor(private readonly ongsService: OngsService) {}

  // ==========================================
  // 1. ROTAS DA ONG — METAS INSTITUCIONAIS (Card 4)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('me/goals')
  @ApiOperation({ summary: '[ONG] Lista as metas institucionais da ONG autenticada' })
  getMyGoals(@Request() req: any) {
    return this.ongsService.getMyGoals(req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('me/goals')
  @ApiOperation({ summary: '[ONG] Cria uma nova meta institucional' })
  createGoal(@Request() req: any, @Body() dto: CreateGoalDto) {
    return this.ongsService.createGoal(req.user.userId, req.user.role, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('me/goals/:id')
  @ApiOperation({ summary: '[ONG] Atualiza o progresso ou dados de uma meta' })
  updateGoal(@Param('id') id: string, @Request() req: any, @Body() dto: UpdateGoalDto) {
    return this.ongsService.updateGoal(id, req.user.userId, req.user.role, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('me/goals/:id')
  @ApiOperation({ summary: '[ONG] Exclui uma meta institucional' })
  deleteGoal(@Param('id') id: string, @Request() req: any) {
    return this.ongsService.deleteGoal(id, req.user.userId, req.user.role);
  }

  // ==========================================
  // 2. ROTAS DA ONG — MINI-ERP DE SUPRIMENTOS (Card 5)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('me/supplies')
  @ApiOperation({ summary: '[ONG] Lista todos os suprimentos e compromissos de doação da ONG' })
  getMySupplies(@Request() req: any) {
    return this.ongsService.getMySupplies(req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('me/supplies')
  @ApiOperation({ summary: '[ONG] Cadastra nova necessidade/suprimento, sincroniza perfil e notifica voluntários' })
  createSupply(@Request() req: any, @Body() dto: CreateSupplyDto) {
    return this.ongsService.createSupply(req.user.userId, req.user.role, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('me/supplies/:id')
  @ApiOperation({ summary: '[ONG] Atualiza um item de suprimento e sincroniza necessidadesAtuais' })
  updateSupply(@Param('id') id: string, @Request() req: any, @Body() dto: UpdateSupplyDto) {
    return this.ongsService.updateSupply(id, req.user.userId, req.user.role, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('me/supplies/:id')
  @ApiOperation({ summary: '[ONG] Exclui um item de suprimento' })
  deleteSupply(@Param('id') id: string, @Request() req: any) {
    return this.ongsService.deleteSupply(id, req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('me/supplies/pledges/:pledgeId/status')
  @ApiOperation({ summary: '[ONG] Atualiza status do compromisso de doação (ENTREGUE / CANCELADO / ATRASADO)' })
  updatePledgeStatus(
    @Param('pledgeId') pledgeId: string,
    @Request() req: any,
    @Body() dto: UpdatePledgeStatusDto,
  ) {
    return this.ongsService.updatePledgeStatus(pledgeId, req.user.userId, req.user.role, dto);
  }

  // ==========================================
  // 3. ROTAS DO VOLUNTÁRIO & PÚBLICAS (Doações)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('supplies/:id/pledges')
  @ApiOperation({ summary: '[Voluntário/ONG] Registra compromisso ("Posso ajudar") para doar um item' })
  @ApiParam({ name: 'id', description: 'ID do item de suprimento (OngSupply)' })
  createPledge(@Param('id') supplyId: string, @Request() req: any, @Body() dto: CreatePledgeDto) {
    return this.ongsService.createPledge(supplyId, req.user, dto);
  }

  @Get(':ongId/supplies')
  @ApiOperation({ summary: '[Público] Lista os itens de suprimento em aberto de uma ONG' })
  getPublicOngSupplies(@Param('ongId') ongId: string) {
    return this.ongsService.getPublicOngSupplies(ongId);
  }
}