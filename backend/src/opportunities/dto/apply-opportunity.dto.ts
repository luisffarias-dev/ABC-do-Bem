import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class ApplyOpportunityDto {
  @ApiPropertyOptional({ description: 'NENHUMA, PRECISA_CARONA ou OFERECE_CARONA' })
  @IsOptional() @IsString() tipoCarona?: string;

  @ApiPropertyOptional({ description: 'Ponto de encontro ou quantidade de vagas no carro' })
  @IsOptional() @IsString() detalhesCarona?: string;
}