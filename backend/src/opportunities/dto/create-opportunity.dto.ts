import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, IsInt, IsArray, IsNumber, IsDateString } from 'class-validator';

export class CreateOpportunityDto {
  @ApiProperty() @IsNotEmpty() @IsString() title: string;
  @ApiProperty() @IsNotEmpty() @IsString() description: string;
  @ApiPropertyOptional() @IsOptional() @IsString() banner?: string;
  
  @ApiProperty({ description: 'PRESENCIAL, REMOTO ou HIBRIDO' }) 
  @IsNotEmpty() @IsString() modality: string;
  
  @ApiProperty() @IsNotEmpty() @IsDateString() eventDate: string;
  @ApiPropertyOptional() @IsOptional() @IsDateString() endDate?: string;
  
  @ApiProperty() @IsNotEmpty() @IsInt() durationHours: number;
  @ApiProperty() @IsNotEmpty() @IsInt() totalVacancies: number;
  
  @ApiProperty() @IsArray() @IsString({ each: true }) categories: string[];
  
  // --- NOVOS CAMPOS: Regras de Negócio ---
  @ApiPropertyOptional() @IsOptional() @IsArray() @IsString({ each: true }) requiredSkills?: string[];
  @ApiPropertyOptional() @IsOptional() @IsInt() minAge?: number;
  @ApiPropertyOptional() @IsOptional() @IsArray() @IsString({ each: true }) requirements?: string[];

  // --- Endereço (Opcional para vagas remotas) ---
  @ApiPropertyOptional() @IsOptional() @IsString() cep?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() logradouro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() numero?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() bairro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() cidade?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() estado?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() latitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() longitude?: number;
}