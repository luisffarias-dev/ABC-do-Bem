import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateOngPostDto {
  @ApiProperty({ 
    description: 'Título da notícia ou postagem', 
    example: 'Nova Campanha de Agasalho 2026' 
  })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiProperty({ 
    description: 'Conteúdo do post', 
    example: 'Estamos iniciando a arrecadação de agasalhos para o inverno...' 
  })
  @IsNotEmpty()
  @IsString()
  text: string;

  @ApiPropertyOptional({ 
    description: 'URL da imagem do banner ou Base64', 
    example: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...' 
  })
  @IsOptional()
  @IsString()
  imageUrl?: string;
}