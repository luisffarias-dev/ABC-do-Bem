import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, IsString, IsArray, IsBoolean, MinLength } from 'class-validator';

export class CreateUserDto {
  @ApiProperty({ description: 'Nome completo do voluntário' })
  @IsNotEmpty() @IsString() name: string;

  @ApiProperty({ description: 'Tipo de documento (ex: CPF, Passaporte)' })
  @IsNotEmpty() @IsString() tipoDocumento: string;

  @ApiProperty({ description: 'Documento de identificação (CPF)' })
  @IsNotEmpty() @IsString() cpf: string;

  @ApiProperty({ description: 'Data de nascimento ISO 8601' })
  @IsNotEmpty() @IsString() nascimento: string;

  @ApiProperty({ description: 'E-mail de login' })
  @IsEmail() @IsNotEmpty() email: string;

  @ApiProperty({ description: 'Senha de acesso (mínimo 6 caracteres)' })
  @IsNotEmpty() @IsString() @MinLength(6) password: string;

  @ApiProperty({ description: 'Telefone ou WhatsApp' })
  @IsNotEmpty() @IsString() telefone: string;

  @ApiPropertyOptional({ description: 'URL pública ou Base64 da foto de perfil' })
  @IsOptional() @IsString() avatar?: string;

  // --- Endereço ---
  @ApiProperty() @IsNotEmpty() @IsString() cep: string;
  @ApiProperty() @IsNotEmpty() @IsString() logradouro: string;
  @ApiProperty() @IsNotEmpty() @IsString() numero: string;
  @ApiProperty() @IsNotEmpty() @IsString() bairro: string;
  @ApiProperty() @IsNotEmpty() @IsString() cidade: string;
  @ApiProperty() @IsNotEmpty() @IsString() estado: string;

  // --- Perfil Voluntário ---
  @ApiPropertyOptional({ description: 'Breve apresentação pessoal' })
  @IsOptional() @IsString() bio?: string;

  @ApiProperty({ description: 'Competências do voluntário' })
  @IsArray() @IsString({ each: true }) habilidades: string[];

  @ApiProperty({ description: 'Dias e turnos livres' })
  @IsArray() @IsString({ each: true }) disponibilidade: string[];

  // --- Termos ---
  @ApiProperty({ description: 'Aceite dos Termos de Uso' })
  @IsBoolean() @IsNotEmpty() aceiteTermos: boolean;

  @ApiProperty({ description: 'Aceite da Política de Privacidade (LGPD)' })
  @IsBoolean() @IsNotEmpty() aceiteLgpd: boolean;
}