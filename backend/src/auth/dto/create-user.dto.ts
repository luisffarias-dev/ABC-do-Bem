import { IsEmail, IsString, IsNotEmpty, IsOptional, Matches, IsArray, ArrayMinSize, ArrayMaxSize, MinLength, IsBoolean, Equals } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
  // --- Etapa 1: Dados Pessoais ---
  @ApiProperty({ example: 'Ana Carolina', description: 'Nome completo do voluntário' })
  @IsNotEmpty({ message: 'O nome completo é obrigatório' })
  @IsString()
  @Matches(/^[a-zA-Z0-9_ áéíóúãõâêîôûçÁÉÍÓÚÃÕÂÊÎÔÛÇ]+$/, { message: 'O nome contém caracteres inválidos' })
  name: string;

  @ApiProperty({ example: 'CPF', description: 'Tipo de documento de identificação' })
  @IsNotEmpty({ message: 'O tipo de documento é obrigatório' })
  tipoDocumento: string;

  @ApiProperty({ example: '123.456.789-00', description: 'CPF válido com pontuação' })
  @IsNotEmpty({ message: 'O CPF é obrigatório' })
  @Matches(/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/, { message: 'CPF inválido. Use o formato 000.000.000-00' })
  cpf: string;

  @ApiProperty({ example: '15/05/1995', description: 'Data de nascimento no formato DD/MM/AAAA' })
  @IsNotEmpty({ message: 'A data de nascimento é obrigatória' })
  nascimento: string;

  @ApiProperty({ example: 'ana.carolina@email.com', description: 'E-mail para login e contato' })
  @IsEmail({}, { message: 'E-mail inválido' })
  email: string;

  @ApiProperty({ example: 'SenhaForte@123', description: 'Senha de acesso (mínimo 8 caracteres)' })
  @IsNotEmpty({ message: 'A senha é obrigatória' })
  @MinLength(8, { message: 'A senha deve ter no mínimo 8 caracteres' })
  password: string;

  @ApiProperty({ example: '(11) 99999-9999', description: 'Telefone ou WhatsApp de contato' })
  @IsNotEmpty({ message: 'O telefone/WhatsApp é obrigatório' })
  telefone: string;

  // Endereço
  @ApiProperty({ example: '09390-000', description: 'CEP do endereço (formato 00000-000)' })
  @IsNotEmpty({ message: 'O CEP é obrigatório' })
  cep: string;

  @ApiProperty({ example: 'Rua das Flores', description: 'Logradouro retornado pelo CEP' })
  @IsNotEmpty({ message: 'O logradouro é obrigatório' })
  logradouro: string;

  @ApiProperty({ example: '123', description: 'Número da residência' })
  @IsNotEmpty({ message: 'O número é obrigatório' })
  numero: string;

  @ApiProperty({ example: 'Vila Assis Brasil', description: 'Bairro retornado pelo CEP' })
  @IsNotEmpty({ message: 'O bairro é obrigatório' })
  bairro: string;

  @ApiProperty({ example: 'Mauá', description: 'Cidade retornada pelo CEP' })
  @IsNotEmpty({ message: 'A cidade é obrigatória' })
  cidade: string;

  @ApiProperty({ example: 'SP', description: 'Estado (UF) retornado pelo CEP' })
  @IsNotEmpty({ message: 'O estado é obrigatório' })
  estado: string;

  @ApiPropertyOptional({ example: 'Sou apaixonada por educação infantil e busco ajudar...', description: 'Breve biografia' })
  @IsOptional()
  @IsString()
  bio?: string;

  // --- Etapa 2: Habilidades ---
  @ApiProperty({ 
    example: ['Organização', 'Limpeza', 'Apoio operacional', 'Eventos'], 
    description: 'Lista de 3 a 12 habilidades selecionadas pelo voluntário',
    type: [String]
  })
  @IsArray({ message: 'As habilidades devem ser enviadas em formato de array' })
  @ArrayMinSize(3, { message: 'Selecione no mínimo 3 características' })
  @ArrayMaxSize(12, { message: 'Selecione no máximo 12 características' })
  habilidades: string[];

  // --- Etapa 3: Disponibilidade e Termos ---
  @ApiProperty({ 
    example: ['Manhã', 'Sábado', 'Voluntariado presencial'], 
    description: 'Lista de disponibilidades do voluntário',
    type: [String]
  })
  @IsArray({ message: 'A disponibilidade deve ser enviada em formato de array' })
  disponibilidade: string[];

  @ApiProperty({ example: true, description: 'Aceite obrigatório dos Termos de Uso' })
  @Equals(true, { message: 'Você deve aceitar os Termos de Uso' })
  @IsBoolean()
  aceiteTermos: boolean;

  @ApiProperty({ example: true, description: 'Aceite obrigatório da LGPD' })
  @Equals(true, { message: 'Você deve autorizar o tratamento de dados pela LGPD' })
  @IsBoolean()
  aceiteLgpd: boolean;
}