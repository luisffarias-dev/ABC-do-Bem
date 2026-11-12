import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, IsString, IsArray, IsBoolean, MinLength, IsInt } from 'class-validator';

export class CreateOngDto {
  @ApiProperty({ description: 'Razão social oficial registrada no CNPJ' })
  @IsNotEmpty() @IsString() razaoSocial: string;

  @ApiProperty({ description: 'Nome fantasia da ONG' })
  @IsNotEmpty() @IsString() name: string;

  @ApiProperty({ description: 'Número de CNPJ' })
  @IsNotEmpty() @IsString() cnpj: string;

  @ApiProperty({ description: 'Ano em que a ONG foi fundada' })
  @IsNotEmpty() @IsInt() anoFundacao: number;

  @ApiPropertyOptional({ description: 'Site oficial da organização' })
  @IsOptional() @IsString() site?: string;

  @ApiProperty({ description: 'Telefone comercial/institucional' })
  @IsNotEmpty() @IsString() telefoneFixo: string;

  @ApiProperty({ description: 'WhatsApp para contato' })
  @IsNotEmpty() @IsString() whatsapp: string;

  @ApiPropertyOptional({ description: 'Instagram da ONG' })
  @IsOptional() @IsString() instagram?: string;

  @ApiPropertyOptional({ description: 'Facebook da ONG' })
  @IsOptional() @IsString() facebook?: string;

  @ApiPropertyOptional({ description: 'TikTok da ONG' })
  @IsOptional() @IsString() tiktok?: string;

  // --- Endereço ---
  @ApiProperty() @IsNotEmpty() @IsString() cep: string;
  @ApiProperty() @IsNotEmpty() @IsString() logradouro: string;
  @ApiProperty() @IsNotEmpty() @IsString() numero: string;
  @ApiProperty() @IsNotEmpty() @IsString() bairro: string;
  @ApiProperty() @IsNotEmpty() @IsString() cidade: string;
  @ApiProperty() @IsNotEmpty() @IsString() estado: string;

  @ApiPropertyOptional({ description: 'URL pública ou Base64 da logo da ONG' })
  @IsOptional() @IsString() avatar?: string;

  // --- Dados Institucionais ---
  @ApiProperty({ description: 'Área principal de atuação (ex: Educação)' })
  @IsNotEmpty() @IsString() causaPrincipal: string;

  @ApiProperty({ description: 'Lista de atividades e serviços' })
  @IsArray() @IsString({ each: true }) servicosOferecidos: string[];

  @ApiProperty({ description: 'Grupos beneficiados pelas ações' })
  @IsArray() @IsString({ each: true }) publicoAtendido: string[];

  @ApiProperty({ description: 'Texto institucional apresentando a ONG' })
  @IsNotEmpty() @IsString() descricao: string;

  @ApiProperty({ description: 'Perfis e competências que a ONG mais precisa' })
  @IsArray() @IsString({ each: true }) habilidadesBuscadas: string[];

  @ApiProperty({ description: 'Presencial, Remoto ou Híbrido' })
  @IsNotEmpty() @IsString() formatoVoluntariado: string;

  // --- Doações e Necessidades ---
  @ApiPropertyOptional({ description: 'Categorias de doações aceitas' })
  @IsOptional() @IsArray() @IsString({ each: true }) aceitaDoacoes?: string[];

  @ApiPropertyOptional({ description: 'Itens urgentes exibidos no card de doações' })
  @IsOptional() @IsArray() @IsString({ each: true }) necessidadesAtuais?: string[];

  @ApiPropertyOptional({ description: 'Chave PIX institucional' })
  @IsOptional() @IsString() chavePix?: string;

  @ApiPropertyOptional({ description: 'Dias e horários para receber doações físicas' })
  @IsOptional() @IsString() horarioRecebimentoDoacoes?: string;

  // --- Acesso e Termos ---
  @ApiProperty({ description: 'E-mail de login' })
  @IsEmail() @IsNotEmpty() email: string;

  @ApiProperty({ description: 'Senha de acesso (mínimo 6 caracteres)' })
  @IsNotEmpty() @IsString() @MinLength(6) password: string;

  @ApiProperty({ description: 'Aceite dos Termos de Uso' })
  @IsBoolean() @IsNotEmpty() aceiteTermos: boolean;

  @ApiProperty({ description: 'Aceite da Política de Privacidade (LGPD)' })
  @IsBoolean() @IsNotEmpty() aceiteLgpd: boolean;
}