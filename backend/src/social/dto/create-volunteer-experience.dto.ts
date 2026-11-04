import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateVolunteerExperienceDto {
  @ApiProperty({ 
    description: 'Nome da ONG onde o trabalho voluntário foi realizado', 
    example: 'ONG Amigos do Bem' 
  })
  @IsNotEmpty()
  @IsString()
  ongName: string;

  @ApiProperty({ 
    description: 'Depoimento/relato do voluntário sobre a ação', 
    example: 'Foi uma experiência incrível colaborar na distribuição de cestas básicas!' 
  })
  @IsNotEmpty()
  @IsString()
  text: string;

  @ApiProperty({ 
    description: 'Mês e ano da ação formatados', 
    example: 'Novembro/2026' 
  })
  @IsNotEmpty()
  @IsString()
  formattedDate: string;

  @ApiPropertyOptional({ 
    description: 'URL da imagem ou foto codificada em Base64', 
    example: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...' 
  })
  @IsOptional()
  @IsString()
  imageUrl?: string;
}