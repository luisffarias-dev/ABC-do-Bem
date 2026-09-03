import { IsEmail, IsString, IsNotEmpty, IsOptional, Matches, IsArray, ArrayMinSize, ArrayMaxSize, MinLength, IsBoolean, Equals } from 'class-validator';

export class CreateUserDto {
  // --- Etapa 1: Dados Pessoais ---
  @IsNotEmpty({ message: 'O nome completo é obrigatório' })
  @IsString()
  @Matches(/^[a-zA-Z0-9_ ]+$/, { message: 'O nome contém caracteres inválidos' })
  name: string;

  @IsNotEmpty({ message: 'O tipo de documento é obrigatório' })
  tipoDocumento: string;

  @IsNotEmpty({ message: 'O CPF é obrigatório' })
  @Matches(/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/, { message: 'CPF inválido' })
  cpf: string;

  @IsNotEmpty({ message: 'A data de nascimento é obrigatória' })
  nascimento: string;

  @IsEmail({}, { message: 'E-mail inválido' })
  email: string;

  @IsNotEmpty({ message: 'A senha é obrigatória' })
  @MinLength(8, { message: 'A senha deve ter no mínimo 8 caracteres' })
  password: string;

  @IsNotEmpty({ message: 'O telefone/WhatsApp é obrigatório' })
  telefone: string;

  // Endereço
  @IsNotEmpty({ message: 'O CEP é obrigatório' })
  cep: string;
  @IsNotEmpty({ message: 'O logradouro é obrigatório' })
  logradouro: string;
  @IsNotEmpty({ message: 'O número é obrigatório' })
  numero: string;
  @IsNotEmpty({ message: 'O bairro é obrigatório' })
  bairro: string;
  @IsNotEmpty({ message: 'A cidade é obrigatória' })
  cidade: string;
  @IsNotEmpty({ message: 'O estado é obrigatório' })
  estado: string;

  @IsOptional()
  @IsString()
  bio?: string;

  // --- Etapa 2: Habilidades (Valida regra de 3 a 12 itens) ---
  @IsArray({ message: 'As habilidades devem ser enviadas em formato de lista' })
  @ArrayMinSize(3, { message: 'Selecione no mínimo 3 características' })
  @ArrayMaxSize(12, { message: 'Selecione no máximo 12 características' })
  habilidades: string[];

  // --- Etapa 3: Disponibilidade e Termos ---
  @IsArray({ message: 'A disponibilidade deve ser enviada em formato de lista' })
  disponibilidade: string[];

  @Equals(true, { message: 'Você deve aceitar os Termos de Uso' })
  @IsBoolean()
  aceiteTermos: boolean;

  @Equals(true, { message: 'Você deve autorizar o tratamento de dados pela LGPD' })
  @IsBoolean()
  aceiteLgpd: boolean;
}