import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, IsInt, IsArray, IsDateString, IsNumber } from 'class-validator';

export class CreateOpportunityDto {
  @ApiProperty({ example: 'Mutirão de Reforço Escolar', description: 'Título da vaga' })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiProperty({ example: 'Precisamos de voluntários para ajudar crianças com matemática.', description: 'Descrição detalhada' })
  @IsNotEmpty()
  @IsString()
  description: string;

  @ApiProperty({ example: 'https://link-da-imagem.com/foto.jpg', required: false })
  @IsOptional()
  @IsString()
  banner?: string;

  @ApiProperty({ example: '2026-09-12T08:00:00Z', description: 'Data e hora do evento' })
  @IsNotEmpty()
  @IsDateString()
  eventDate: string;

  @ApiProperty({ example: 4, description: 'Duração do evento em horas' })
  @IsNotEmpty()
  @IsInt()
  durationHours: number;

  @ApiProperty({ example: 7, description: 'Quantidade total de vagas disponíveis' })
  @IsNotEmpty()
  @IsInt()
  totalVacancies: number;

  @ApiProperty({ example: ['Educação', 'Crianças'], description: 'Categorias para o filtro' })
  @IsArray()
  @IsString({ each: true })
  categories: string[];

  // --- Endereço e Geolocalização ---
  @ApiProperty({ example: '09000-000' })
  @IsNotEmpty()
  @IsString()
  cep: string;

  @ApiProperty({ example: 'Rua do Bem' })
  @IsNotEmpty()
  @IsString()
  logradouro: string;

  @ApiProperty({ example: '123' })
  @IsNotEmpty()
  @IsString()
  numero: string;

  @ApiProperty({ example: 'Centro' })
  @IsNotEmpty()
  @IsString()
  bairro: string;

  @ApiProperty({ example: 'Santo André' })
  @IsNotEmpty()
  @IsString()
  cidade: string;

  @ApiProperty({ example: 'SP' })
  @IsNotEmpty()
  @IsString()
  estado: string;

  @ApiProperty({ example: -23.6666, description: 'Latitude (opcional, calculada pelo front ou via API)' })
  @IsOptional()
  @IsNumber()
  latitude?: number;

  @ApiProperty({ example: -46.5322, description: 'Longitude (opcional, calculada pelo front ou via API)' })
  @IsOptional()
  @IsNumber()
  longitude?: number;
}