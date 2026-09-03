import { IsEmail, IsString, IsNotEmpty, IsOptional, Matches, IsArray, MinLength, IsBoolean, Equals } from 'class-validator';

export class CreateOngDto {
  // --- Etapa 1 ---
  @IsNotEmpty({ message: 'A razão social é obrigatória' })
  @IsString()
  razaoSocial: string;

  @IsNotEmpty({ message: 'O nome fantasia é obrigatório' })
  @IsString()
  name: string;

  @IsNotEmpty({ message: 'O CNPJ é obrigatório' })
  @Matches(/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/, { message: 'CNPJ inválido' })
  cnpj: string;

  @IsNotEmpty({ message: 'O ano de fundação é obrigatório' })
  anoFundacao: number;

  @IsOptional() @IsString() site?: string;

  @IsNotEmpty({ message: 'O telefone fixo é obrigatório' })
  telefoneFixo: string;

  @IsNotEmpty({ message: 'O WhatsApp é obrigatório' })
  whatsapp: string;

  @IsOptional() instagram?: string;
  @IsOptional() facebook?: string;
  @IsOptional() tiktok?: string;

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

  // --- Etapa 2 ---
  @IsOptional() @IsString() avatar?: string;

  @IsNotEmpty({ message: 'A causa principal é obrigatória' })
  @IsString()
  causaPrincipal: string;

  @IsArray() servicosOferecidos: string[];
  @IsArray() publicoAtendido: string[];

  @IsNotEmpty({ message: 'A descrição da ONG é obrigatória' })
  @MinLength(200, { message: 'A descrição deve ter no mínimo 200 caracteres' })
  descricao: string;

  // --- Etapa 3 ---
  @IsArray({ message: 'Selecione ao menos uma habilidade buscada' })
  habilidadesBuscadas: string[];

  @IsNotEmpty({ message: 'O formato de voluntariado é obrigatório' })
  @IsString()
  formatoVoluntariado: string;

  @IsOptional()
  @IsArray()
  aceitaDoacoes?: string[];

  @IsEmail({}, { message: 'E-mail institucional inválido' })
  email: string;

  @IsNotEmpty({ message: 'A senha é obrigatória' })
  @MinLength(8, { message: 'A senha deve ter no mínimo 8 caracteres' })
  password: string;

  // Validação dos Termos e LGPD (Obrigatório vir como true)
  @Equals(true, { message: 'Você deve aceitar os Termos e Condições de Uso' })
  @IsBoolean()
  aceiteTermos: boolean;

  @Equals(true, { message: 'Você deve concordar com a Política de Privacidade e LGPD' })
  @IsBoolean()
  aceiteLgpd: boolean;
}