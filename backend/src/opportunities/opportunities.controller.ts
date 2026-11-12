import { 
  Controller, Get, Post, Body, Patch, Param, Delete, Query, 
  ParseFloatPipe, UseGuards, Request 
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { OpportunitiesService } from './opportunities.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';
import { ApplyOpportunityDto } from './dto/apply-opportunity.dto';
import { UpdateApplicationStatusDto } from './dto/update-application-status.dto';
import { ValidatePresenceDto } from './dto/validate-presence.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; 

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
    const role = req.user.role; 
    return this.opportunitiesService.create(ongId, createOpportunityDto, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/apply')
  @ApiOperation({ summary: 'Inscreve o voluntário logado em uma vaga específica (Apenas Voluntário)' })
  @ApiParam({ name: 'id', description: 'ID da Vaga' })
  @ApiBody({ type: ApplyOpportunityDto })
  apply(
    @Param('id') id: string, 
    @Request() req: any,
    @Body() applyOpportunityDto: ApplyOpportunityDto
  ) {
    const userId = req.user.userId; 
    const role = req.user.role; 
    return this.opportunitiesService.applyToOpportunity(id, userId, role, applyOpportunityDto);
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

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('recommended')
  @ApiOperation({ summary: 'Retorna vagas recomendadas para o voluntário logado com base em IA/ML' })
  async getRecommended(@Request() req: any) {
    const userId = req.user.userId;
    return this.opportunitiesService.getRecommendedOpportunities(userId);
  }

  // ==========================================
  // ROTAS PÚBLICAS (Qualquer um pode ver o feed)
  // ==========================================

  @UseGuards(JwtAuthGuard) 
  @ApiBearerAuth()
  @Get()
  @ApiOperation({ summary: 'Lista vagas (feed), aceita filtros de cidade e categoria. Verifica se o voluntário está inscrito.' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'categoria', required: false })
  findAll(
    @Query('cidade') cidade?: string, 
    @Query('categoria') categoria?: string,
    @Request() req?: any
  ) {
    const userId = req?.user?.userId;
    return this.opportunitiesService.findAll(cidade, categoria, userId);
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
  @ApiBody({ type: UpdateApplicationStatusDto })
  updateApplicationStatus(
    @Param('applicationId') applicationId: string,
    @Body() dto: UpdateApplicationStatusDto, 
    @Request() req: any
  ) {
    const ongId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.updateApplicationStatus(applicationId, ongId, role, dto.status);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('applications/:applicationId/presenca')
  @ApiOperation({ summary: 'Valida a presença do voluntário no dia do evento (Gera horas)' })
  @ApiBody({ type: ValidatePresenceDto })
  async validatePresence(
    @Param('applicationId') applicationId: string,
    @Body() dto: ValidatePresenceDto,
    @Request() req: any,
  ) {
    const ongId = req.user.userId;
    return this.opportunitiesService.validatePresence(
      applicationId,
      ongId,
      dto
    );
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete(':id/apply')
  @ApiOperation({ summary: 'Cancela a candidatura de um voluntário a uma vaga' })
  cancelApplication(@Param('id') id: string, @Request() req: any) {
    const userId = req.user.userId;
    const role = req.user.role;
    return this.opportunitiesService.cancelApplication(id, userId, role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('applications/:applicationId')
  @ApiOperation({ summary: 'Remove fisicamente um candidato da vaga (Apenas ONG)' })
  removeApplication(@Param('applicationId') applicationId: string, @Request() req: any) {
    return this.opportunitiesService.removeApplication(applicationId, req.user.userId, req.user.role);
  }
}