import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsArray } from 'class-validator';

export class UpdateUserDto {
  @ApiProperty({ description: 'Nome do voluntário ou Nome Fantasia da ONG', required: false })
  @IsOptional() @IsString() name?: string;

  @ApiProperty({ description: 'Foto de perfil ou Logo', required: false })
  @IsOptional() @IsString() avatar?: string;

  @ApiProperty({ description: 'Biografia ou Descrição da ONG', required: false })
  @IsOptional() @IsString() bio?: string; 
  @IsOptional() @IsString() descricao?: string; 

  @ApiProperty({ description: 'Telefone para contato', required: false })
  @IsOptional() @IsString() telefone?: string; 
  @IsOptional() @IsString() whatsapp?: string; 

  @ApiProperty({ description: 'Causa principal (apenas ONG)', required: false })
  @IsOptional() @IsString() causaPrincipal?: string;

  @ApiProperty({ description: 'Habilidades (Voluntário)', required: false })
  @IsOptional() @IsArray() habilidades?: string[];
}