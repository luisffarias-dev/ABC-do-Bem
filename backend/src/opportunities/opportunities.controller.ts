import { 
  Controller, Get, Post, Body, Patch, Param, Delete, Query, 
  ParseFloatPipe, ParseIntPipe, UseGuards, Request 
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam, ApiBearerAuth } from '@nestjs/swagger';
import { OpportunitiesService } from './opportunities.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // VERIFIQUE ESTE CAMINHO
import { ApplicationStatus } from '@prisma/client';

@ApiTags('Opportunities (Vagas)')
@Controller('opportunities')
export class OpportunitiesController {
  constructor(private readonly opportunitiesService: OpportunitiesService) {}

  // ==========================================
  // ROTAS PROTEGIDAS (Exigem Token JWT)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth() 
  @Post() 
  @ApiOperation({ summary: 'Cria uma nova vaga de voluntariado (Apenas ONG)' })
  create(@Request() req: any, @Body() createOpportunityDto: CreateOpportunityDto) {
    const ongId = req.user.userId;
    const role = req.user.role; // Extraindo a Role do JWT
    return this.opportunitiesService.create(ongId, createOpportunityDto, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/apply')
  @ApiOperation({ summary: 'Inscreve o voluntário logado em uma vaga específica (Apenas Voluntário)' })
  @ApiParam({ name: 'id', description: 'ID da Vaga' })
  apply(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId; 
    const role = req.user.role; // Extraindo a Role do JWT
    return this.opportunitiesService.applyToOpportunity(id, userId, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch(':id') 
  @ApiOperation({ summary: 'Atualiza os dados de uma vaga (Apenas ONG)' })
  update(
    @Param('id') id: string,
    @Request() req: any,
    @Body() updateOpportunityDto: UpdateOpportunityDto,
  ) {
    const ongId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.update(id, ongId, updateOpportunityDto, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete(':id') 
  @ApiOperation({ summary: 'Exclui uma vaga (Apenas ONG)' })
  remove(@Param('id') id: string, @Request() req: any) {
    const ongId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.remove(id, ongId, role);
  }

  // ==========================================
  // ROTAS PÚBLICAS (Qualquer um pode ver o feed)
  // ==========================================

  @Get()
  @ApiOperation({ summary: 'Lista vagas (feed), aceita filtros de cidade e categoria' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'categoria', required: false })
  findAll(@Query('cidade') cidade?: string, @Query('categoria') categoria?: string) {
    return this.opportunitiesService.findAll(cidade, categoria);
  }

  @Get('nearby')
  @ApiOperation({ summary: 'GEOLOCALIZAÇÃO: Retorna as vagas mais próximas (Em KM)' })
  @ApiQuery({ name: 'lat', type: Number })
  @ApiQuery({ name: 'lng', type: Number })
  @ApiQuery({ name: 'radius', type: Number, required: false })
  findNearby(
    @Query('lat', ParseFloatPipe) lat: number,
    @Query('lng', ParseFloatPipe) lng: number,
    @Query('radius') radius?: string,
  ) {
    const maxRadius = radius ? parseInt(radius, 10) : 20;
    return this.opportunitiesService.findNearby(lat, lng, maxRadius);
  }

  @Get('ong/:ongId')
  @ApiOperation({ summary: 'Painel da ONG: Lista todas as vagas publicadas por uma ONG específica' })
  findByOng(@Param('ongId') ongId: string) {
    return this.opportunitiesService.findByOng(ongId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Exibe os detalhes de uma única vaga' })
  findOne(@Param('id') id: string) {
    return this.opportunitiesService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get(':id/applications')
  @ApiOperation({ summary: 'Lista os voluntários inscritos em uma vaga (Acesso restrito à ONG dona)' })
  getApplications(@Param('id') id: string, @Request() req: any) {
    const ongId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.getApplications(id, ongId, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('applications/:applicationId/status')
  @ApiOperation({ summary: 'Aceita ou rejeita um candidato (Apenas ONG)' })
  updateApplicationStatus(
    @Param('applicationId') applicationId: string,
    @Body('status') status: ApplicationStatus, // Espera receber { "status": "CONFIRMED" } ou "REJECTED"
    @Request() req: any
  ) {
    const ongId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.updateApplicationStatus(applicationId, ongId, role, status);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('applications/:applicationId/presenca')
  @ApiOperation({ summary: 'Valida a presença do voluntário no dia do evento (Gera horas)' })
  async validatePresence(
    @Param('applicationId') applicationId: string,
    @Body() body: { status: ApplicationStatus; horasValidadas: number },
    @Request() req: any,
  ) {
    const ongId = req.user.userId;
    return this.opportunitiesService.validatePresence(
      applicationId,
      ongId,
      body.status,
      body.horasValidadas,
    );
  }
}