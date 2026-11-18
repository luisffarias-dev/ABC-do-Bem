import { 
  Controller, Get, Post, Body, Patch, Param, Delete, Query, 
  ParseFloatPipe, UseGuards, Request, Res 
} from '@nestjs/common';
import type { Response } from 'express';
import { ApiTags, ApiOperation, ApiQuery, ApiParam, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { OpportunitiesService } from './opportunities.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';
import { ApplyOpportunityDto } from './dto/apply-opportunity.dto';
import { UpdateApplicationStatusDto } from './dto/update-application-status.dto';
import { ValidatePresenceDto } from './dto/validate-presence.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; 

@ApiTags('Opportunities')
@Controller('opportunities')
export class OpportunitiesController {
  constructor(private readonly opportunitiesService: OpportunitiesService) {}

  // ==========================================
  // 1. ROTAS DA ONG (Gestão de Vagas, Status, Candidatos e Certificados)
  // ==========================================

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth() 
  @Post() 
  @ApiOperation({ summary: '[ONG] Cria uma nova vaga de voluntariado' })
  create(@Request() req: any, @Body() createOpportunityDto: CreateOpportunityDto) {
    return this.opportunitiesService.create(req.user.userId, createOpportunityDto, req.user.role);
  }

  @Get('ong/:ongId')
  @ApiOperation({ summary: '[ONG] Lista todas as vagas publicadas por uma ONG específica' })
  findByOng(@Param('ongId') ongId: string) {
    return this.opportunitiesService.findByOng(ongId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch(':id') 
  @ApiOperation({ summary: '[ONG] Atualiza os dados ou status (ATIVA, LOTADA, CONCLUIDA, CANCELADA) de uma vaga' })
  update(
    @Param('id') id: string,
    @Request() req: any,
    @Body() updateOpportunityDto: UpdateOpportunityDto,
  ) {
    return this.opportunitiesService.update(id, req.user.userId, updateOpportunityDto, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete(':id') 
  @ApiOperation({ summary: '[ONG] Exclui uma vaga' })
  remove(@Param('id') id: string, @Request() req: any) {
    return this.opportunitiesService.remove(id, req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get(':id/applications')
  @ApiOperation({ summary: '[ONG] Lista os voluntários inscritos em uma vaga' })
  getApplications(@Param('id') id: string, @Request() req: any) {
    return this.opportunitiesService.getApplications(id, req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('applications/:applicationId/status')
  @ApiOperation({ summary: '[ONG] Aceita ou rejeita a candidatura de um voluntário' })
  @ApiBody({ type: UpdateApplicationStatusDto })
  updateApplicationStatus(
    @Param('applicationId') applicationId: string,
    @Body() dto: UpdateApplicationStatusDto, 
    @Request() req: any
  ) {
    return this.opportunitiesService.updateApplicationStatus(applicationId, req.user.userId, req.user.role, dto.status);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch('applications/:applicationId/presenca')
  @ApiOperation({ summary: '[ONG] Valida a presença e feedback do voluntário no dia do evento (Gera horas)' })
  @ApiBody({ type: ValidatePresenceDto })
  async validatePresence(
    @Param('applicationId') applicationId: string,
    @Body() dto: ValidatePresenceDto,
    @Request() req: any,
  ) {
    return this.opportunitiesService.validatePresence(applicationId, req.user.userId, dto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/finalize-certificates')
  @ApiOperation({ summary: '[ONG] Finaliza o evento, emite certificados para todos os presentes e envia notificações' })
  finalizeAndIssueCertificates(@Param('id') id: string, @Request() req: any) {
    return this.opportunitiesService.finalizeAndIssueCertificates(id, req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete('applications/:applicationId')
  @ApiOperation({ summary: '[ONG] Remove fisicamente um candidato da vaga' })
  removeApplication(@Param('applicationId') applicationId: string, @Request() req: any) {
    return this.opportunitiesService.removeApplication(applicationId, req.user.userId, req.user.role);
  }

  // ==========================================
  // 2. ROTAS DO VOLUNTÁRIO (Exploração, IA, Inscrições e Certificados)
  // ==========================================

  @UseGuards(JwtAuthGuard) 
  @ApiBearerAuth()
  @Get()
  @ApiOperation({ summary: '[Voluntário] Lista vagas ativas (feed) com filtros de cidade e categoria' })
  @ApiQuery({ name: 'cidade', required: false })
  @ApiQuery({ name: 'categoria', required: false })
  findAll(
    @Query('cidade') cidade?: string, 
    @Query('categoria') categoria?: string,
    @Request() req?: any
  ) {
    return this.opportunitiesService.findAll(cidade, categoria, req?.user?.userId);
  }

  @Get('nearby')
  @ApiOperation({ summary: '[Voluntário] Retorna as vagas ativas mais próximas por geolocalização (Em KM)' })
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

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('recommended')
  @ApiOperation({ summary: '[Voluntário] Retorna vagas recomendadas com base em IA/ML' })
  async getRecommended(@Request() req: any) {
    return this.opportunitiesService.getRecommendedOpportunities(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('my-applications')
  @ApiOperation({ summary: '[Voluntário] Lista todas as vagas em que o voluntário logado se inscreveu (Minhas Vagas)' })
  getMyApplications(@Request() req: any) {
    return this.opportunitiesService.getMyApplications(req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('applications/:applicationId/certificate')
  @ApiOperation({ summary: '[Voluntário] Baixa o certificado em PDF de uma participação concluída' })
  async downloadCertificate(
    @Param('applicationId') applicationId: string,
    @Request() req: any,
    @Res() res: Response,
  ) {
    const { buffer, filename } = await this.opportunitiesService.generateCertificatePdf(
      applicationId,
      req.user.userId,
    );

    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="${filename}"`,
      'Content-Length': buffer.length,
    });

    res.end(buffer);
  }

  @Get(':id')
  @ApiOperation({ summary: '[Voluntário] Exibe os detalhes de uma única vaga' })
  findOne(@Param('id') id: string) {
    return this.opportunitiesService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/apply')
  @ApiOperation({ summary: '[Voluntário] Inscreve o voluntário logado em uma vaga específica' })
  @ApiParam({ name: 'id', description: 'ID da Vaga' })
  @ApiBody({ type: ApplyOpportunityDto })
  apply(
    @Param('id') id: string, 
    @Request() req: any,
    @Body() applyOpportunityDto: ApplyOpportunityDto
  ) {
    return this.opportunitiesService.applyToOpportunity(id, req.user.userId, req.user.role, applyOpportunityDto);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Delete(':id/apply')
  @ApiOperation({ summary: '[Voluntário] Cancela a candidatura de um voluntário a uma vaga' })
  cancelApplication(@Param('id') id: string, @Request() req: any) {
    return this.opportunitiesService.cancelApplication(id, req.user.userId, req.user.role);
  }
}