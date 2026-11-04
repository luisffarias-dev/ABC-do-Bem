import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsArray, IsEmail } from 'class-validator';

export class UpdateUserDto {
  @ApiPropertyOptional({ description: 'Nome do voluntário ou Nome Fantasia da ONG' })
  @IsOptional() @IsString() name?: string;

  @ApiPropertyOptional({ description: 'Novo e-mail (Ficará pendente até confirmação)' })
  @IsOptional() @IsEmail() email?: string;

  @ApiPropertyOptional({ description: 'Foto de perfil, Logo ou imagem Base64' })
  @IsOptional() @IsString() avatar?: string;

  @ApiPropertyOptional({ description: 'Biografia do Voluntário' })
  @IsOptional() @IsString() bio?: string; 

  @ApiPropertyOptional({ description: 'Descricao da ONG' })
  @IsOptional() @IsString() descricao?: string; 

  @ApiPropertyOptional({ description: 'Telefone para contato' })
  @IsOptional() @IsString() telefone?: string; 

  @ApiPropertyOptional({ description: 'WhatsApp para contato' })
  @IsOptional() @IsString() whatsapp?: string; 

  @ApiPropertyOptional({ description: 'Causa principal (apenas ONG)' })
  @IsOptional() @IsString() causaPrincipal?: string;

  @ApiPropertyOptional({ description: 'Habilidades (Voluntário)' })
  @IsOptional() @IsArray() habilidades?: string[];

  @ApiPropertyOptional({ description: 'Disponibilidade de atuação (Voluntário)' })
  @IsOptional() @IsArray() disponibilidade?: string[];

  // --- Novos Campos Adicionais: Endereço ---
  @ApiPropertyOptional() @IsOptional() @IsString() cep?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() logradouro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() numero?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() bairro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() cidade?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() estado?: string;
}