import { Controller, Get, Post, Body, Patch, Param, Delete, Query, ParseFloatPipe, ParseIntPipe } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { OpportunitiesService } from './opportunities.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';

@ApiTags('Opportunities (Vagas)')
@Controller('opportunities')
export class OpportunitiesController {
  constructor(private readonly opportunitiesService: OpportunitiesService) {}

  @Post(':ongId')
  @ApiOperation({ summary: 'Cria uma nova vaga de voluntariado' })
  @ApiParam({ name: 'ongId', description: 'ID da ONG criando a vaga' })
  create(@Param('ongId') ongId: string, @Body() createOpportunityDto: CreateOpportunityDto) {
    return this.opportunitiesService.create(ongId, createOpportunityDto);
  }

  @Get()
  @ApiOperation({ summary: 'Lista vagas (feed), aceita filtros de cidade e categoria' })
  @ApiQuery({ name: 'cidade', required: false, description: 'Ex: Santo André' })
  @ApiQuery({ name: 'categoria', required: false, description: 'Ex: Educação' })
  findAll(@Query('cidade') cidade?: string, @Query('categoria') categoria?: string) {
    return this.opportunitiesService.findAll(cidade, categoria);
  }

  @Get('nearby')
  @ApiOperation({ summary: '🌍 GEOLOCALIZAÇÃO: Retorna as vagas mais próximas (Em KM)' })
  @ApiQuery({ name: 'lat', type: Number, description: 'Latitude do Voluntário' })
  @ApiQuery({ name: 'lng', type: Number, description: 'Longitude do Voluntário' })
  @ApiQuery({ name: 'radius', type: Number, required: false, description: 'Raio de busca em KM (Padrão: 20)' })
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

  @Patch(':id/ong/:ongId')
  @ApiOperation({ summary: 'Atualiza os dados de uma vaga' })
  update(
    @Param('id') id: string,
    @Param('ongId') ongId: string,
    @Body() updateOpportunityDto: UpdateOpportunityDto,
  ) {
    return this.opportunitiesService.update(id, ongId, updateOpportunityDto);
  }

  @Delete(':id/ong/:ongId')
  @ApiOperation({ summary: 'Exclui uma vaga' })
  remove(@Param('id') id: string, @Param('ongId') ongId: string) {
    return this.opportunitiesService.remove(id, ongId);
  }
}