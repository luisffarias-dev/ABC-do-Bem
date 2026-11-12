import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsArray, IsInt, IsEmail } from 'class-validator';

export class UpdateOngDto {
  @ApiPropertyOptional({ description: 'Razão social oficial registrada no CNPJ' })
  @IsOptional() @IsString() razaoSocial?: string;

  @ApiPropertyOptional({ description: 'Nome fantasia da ONG' })
  @IsOptional() @IsString() name?: string;

  @ApiPropertyOptional({ description: 'Número de CNPJ' })
  @IsOptional() @IsString() cnpj?: string;

  @ApiPropertyOptional({ description: 'Ano de fundação da ONG' })
  @IsOptional() @IsInt() anoFundacao?: number;

  @ApiPropertyOptional({ description: 'Site oficial' })
  @IsOptional() @IsString() site?: string;

  @ApiPropertyOptional({ description: 'Telefone fixo institucional' })
  @IsOptional() @IsString() telefoneFixo?: string;

  @ApiPropertyOptional({ description: 'WhatsApp para contato' })
  @IsOptional() @IsString() whatsapp?: string;

  @ApiPropertyOptional({ description: 'Instagram da ONG' })
  @IsOptional() @IsString() instagram?: string;

  @ApiPropertyOptional({ description: 'Facebook da ONG' })
  @IsOptional() @IsString() facebook?: string;

  @ApiPropertyOptional({ description: 'TikTok da ONG' })
  @IsOptional() @IsString() tiktok?: string;

  // --- Endereço ---
  @ApiPropertyOptional() @IsOptional() @IsString() cep?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() logradouro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() numero?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() bairro?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() cidade?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() estado?: string;

  // --- Dados Institucionais e Atuação ---
  @ApiPropertyOptional({ description: 'URL da logo' })
  @IsOptional() @IsString() avatar?: string;

  @ApiPropertyOptional({ description: 'Causa principal de atuação' })
  @IsOptional() @IsString() causaPrincipal?: string;

  @ApiPropertyOptional({ description: 'Serviços oferecidos' })
  @IsOptional() @IsArray() @IsString({ each: true }) servicosOferecidos?: string[];

  @ApiPropertyOptional({ description: 'Público atendido pela ONG' })
  @IsOptional() @IsArray() @IsString({ each: true }) publicoAtendido?: string[];

  @ApiPropertyOptional({ description: 'Descrição e história da ONG' })
  @IsOptional() @IsString() descricao?: string;

  @ApiPropertyOptional({ description: 'Habilidades que a ONG mais precisa' })
  @IsOptional() @IsArray() @IsString({ each: true }) habilidadesBuscadas?: string[];

  @ApiPropertyOptional({ description: 'Formato de voluntariado: PRESENCIAL, REMOTO ou HIBRIDO' })
  @IsOptional() @IsString() formatoVoluntariado?: string;

  // --- Doações e Necessidades (Novos) ---
  @ApiPropertyOptional({ description: 'Categorias de doações aceitas (Ex: Alimentos, Roupas)' })
  @IsOptional() @IsArray() @IsString({ each: true }) aceitaDoacoes?: string[];

  @ApiPropertyOptional({ description: 'Lista de itens urgentes para o card de doações' })
  @IsOptional() @IsArray() @IsString({ each: true }) necessidadesAtuais?: string[];

  @ApiPropertyOptional({ description: 'Chave PIX institucional' })
  @IsOptional() @IsString() chavePix?: string;

  @ApiPropertyOptional({ description: 'Dias e horários para receber doações físicas' })
  @IsOptional() @IsString() horarioRecebimentoDoacoes?: string;

  // --- Acesso ---
  @ApiPropertyOptional({ description: 'Novo e-mail (Ficará pendente até confirmação)' })
  @IsOptional() @IsEmail() email?: string;
}