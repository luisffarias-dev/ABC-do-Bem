import { IsString, IsOptional, IsNumber, IsDateString, IsIn, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateGoalDto {
  @ApiProperty({ example: 'Arrecadar 200 cestas básicas de Natal' })
  @IsString()
  titulo: string;

  @ApiPropertyOptional({ example: 'Campanha voltada às famílias do Jardim Zaíra' })
  @IsOptional()
  @IsString()
  descricao?: string;

  @ApiPropertyOptional({ example: 0 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  valorAtual?: number;

  @ApiProperty({ example: 200 })
  @IsNumber()
  @Min(0.1)
  valorMeta: number;

  @ApiProperty({ example: 'cestas' })
  @IsString()
  unidade: string;

  @ApiPropertyOptional({ example: '2026-12-20T23:59:59.000Z' })
  @IsOptional()
  @IsDateString()
  prazoLimite?: string;
}

export class UpdateGoalDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  titulo?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  descricao?: string;

  @ApiPropertyOptional({ example: 120 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  valorAtual?: number;

  @ApiPropertyOptional({ example: 200 })
  @IsOptional()
  @IsNumber()
  @Min(0.1)
  valorMeta?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  unidade?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  prazoLimite?: string;

  @ApiPropertyOptional({ enum: ['EM_ANDAMENTO', 'CONCLUIDA', 'ATRASADA'] })
  @IsOptional()
  @IsIn(['EM_ANDAMENTO', 'CONCLUIDA', 'ATRASADA'])
  status?: string;
}