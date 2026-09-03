import { IsEmail, IsString, IsNotEmpty, IsOptional, Matches, IsArray, MinLength, IsBoolean, Equals } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOngDto {
  // --- Etapa 1 ---
  @ApiProperty({ example: 'Associação Mãos que Fazem', description: 'Razão Social registrada no CNPJ' })
  @IsNotEmpty({ message: 'A razão social é obrigatória' })
  @IsString()
  razaoSocial: string;

  @ApiProperty({ example: 'Mãos que Fazem', description: 'Nome fantasia da ONG' })
  @IsNotEmpty({ message: 'O nome fantasia é obrigatório' })
  @IsString()
  name: string;

  @ApiProperty({ example: '00.000.000/0001-00', description: 'CNPJ válido com pontuação' })
  @IsNotEmpty({ message: 'O CNPJ é obrigatório' })
  @Matches(/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/, { message: 'CNPJ inválido. Use o formato 00.000.000/0000-00' })
  cnpj: string;

  @ApiProperty({ example: 2015, description: 'Ano de fundação da organização' })
  @IsNotEmpty({ message: 'O ano de fundação é obrigatório' })
  anoFundacao: number;

  @ApiPropertyOptional({ example: 'www.maosquefazem.org.br', description: 'Site da ONG' })
  @IsOptional() 
  @IsString() 
  site?: string;

  @ApiProperty({ example: '(11) 4545-0000', description: 'Telefone fixo da organização' })
  @IsNotEmpty({ message: 'O telefone fixo é obrigatório' })
  telefoneFixo: string;

  @ApiProperty({ example: '(11) 99999-9999', description: 'WhatsApp institucional' })
  @IsNotEmpty({ message: 'O WhatsApp é obrigatório' })
  whatsapp: string;

  @ApiPropertyOptional({ example: '@maosquefazem', description: 'Arroba ou link do Instagram' })
  @IsOptional() instagram?: string;
  
  @ApiPropertyOptional({ example: 'facebook.com/maosquefazem', description: 'Página do Facebook' })
  @IsOptional() facebook?: string;
  
  @ApiPropertyOptional({ example: '@maosquefazem_oficial', description: 'Arroba do TikTok' })
  @IsOptional() tiktok?: string;

  @ApiProperty({ example: '09015-330', description: 'CEP do endereço físico (formato 00000-000)' })
  @IsNotEmpty({ message: 'O CEP é obrigatório' })
  cep: string;

  @ApiProperty({ example: 'Avenida Capitão João', description: 'Logradouro' })
  @IsNotEmpty({ message: 'O logradouro é obrigatório' })
  logradouro: string;

  @ApiProperty({ example: '1500', description: 'Número' })
  @IsNotEmpty({ message: 'O número é obrigatório' })
  numero: string;

  @ApiProperty({ example: 'Matriz', description: 'Bairro' })
  @IsNotEmpty({ message: 'O bairro é obrigatório' })
  bairro: string;

  @ApiProperty({ example: 'Mauá', description: 'Cidade' })
  @IsNotEmpty({ message: 'A cidade é obrigatória' })
  cidade: string;

  @ApiProperty({ example: 'SP', description: 'Estado (UF)' })
  @IsNotEmpty({ message: 'O estado é obrigatório' })
  estado: string;

  // --- Etapa 2 ---
  @ApiPropertyOptional({ example: 'https://storage.xyz/logo.png', description: 'URL da logo ou foto da ONG' })
  @IsOptional() 
  @IsString() 
  avatar?: string;

  @ApiProperty({ example: 'Educação', description: 'Causa principal de atuação' })
  @IsNotEmpty({ message: 'A causa principal é obrigatória' })
  @IsString()
  causaPrincipal: string;

  @ApiProperty({ example: ['Reforço Escolar', 'Atividades Lúdicas'], type: [String], description: 'Serviços prestados' })
  @IsArray() 
  servicosOferecidos: string[];

  @ApiProperty({ example: ['Crianças', 'Adolescentes'], type: [String], description: 'Público que recebe o apoio' })
  @IsArray() 
  publicoAtendido: string[];

  @ApiProperty({ example: 'Nossa missão é garantir educação complementar para crianças da rede pública de Mauá...', description: 'Descrição da história e missão (mín. 200 caracteres)' })
  @IsNotEmpty({ message: 'A descrição da ONG é obrigatória' })
  @MinLength(200, { message: 'A descrição deve ter no mínimo 200 caracteres' })
  descricao: string;

  // --- Etapa 3 ---
  @ApiProperty({ example: ['Atendimento', 'Apoio operacional'], type: [String], description: 'Tipos de habilidades mais procuradas nos voluntários' })
  @IsArray({ message: 'Selecione ao menos uma habilidade buscada' })
  habilidadesBuscadas: string[];

  @ApiProperty({ example: 'Apenas Presencial', description: 'Formato do trabalho' })
  @IsNotEmpty({ message: 'O formato de voluntariado é obrigatório' })
  @IsString()
  formatoVoluntariado: string;

  @ApiPropertyOptional({ example: ['Doações Financeiras (Pix/Conta)', 'Alimentos'], type: [String], description: 'O que a ONG aceita receber' })
  @IsOptional()
  @IsArray()
  aceitaDoacoes?: string[];

  @ApiProperty({ example: 'contato@maosquefazem.org.br', description: 'E-mail para login no sistema' })
  @IsEmail({}, { message: 'E-mail institucional inválido' })
  email: string;

  @ApiProperty({ example: 'SenhaForte@123', description: 'Senha de acesso (mín. 8 caracteres)' })
  @IsNotEmpty({ message: 'A senha é obrigatória' })
  @MinLength(8, { message: 'A senha deve ter no mínimo 8 caracteres' })
  password: string;

  @ApiProperty({ example: true, description: 'Aceite obrigatório dos Termos' })
  @Equals(true, { message: 'Você deve aceitar os Termos e Condições de Uso' })
  @IsBoolean()
  aceiteTermos: boolean;

  @ApiProperty({ example: true, description: 'Aceite obrigatório da LGPD' })
  @Equals(true, { message: 'Você deve concordar com a Política de Privacidade e LGPD' })
  @IsBoolean()
  aceiteLgpd: boolean;
}