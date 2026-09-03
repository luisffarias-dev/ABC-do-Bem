import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { CreateUserDto } from './dto/create-user.dto'; 
import { CreateOngDto } from './dto/create-ong.dto'; 
import { LoginDto } from './dto/login.dto'; 

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService
  ) {}

  // ROTA DE LOGIN
  async login(loginDto: LoginDto) {
    const { email, password } = loginDto;

    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new UnauthorizedException('E-mail ou senha inválidos.');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('E-mail ou senha inválidos.');
    }

    const payload = { 
      sub: user.id, 
      email: user.email,
      role: user.role 
    };
    
    return {
      access_token: await this.jwtService.signAsync(payload),
      role: user.role, // Opcional: útil para o front-end saber para qual tela redirecionar
      name: user.name,
    };
  }

  // ROTA DE CADASTRO UNIFICADA
  async register(dto: CreateUserDto | CreateOngDto, role: 'USER' | 'ONG' = 'USER') {
    // 1. Verificação de duplicidade de e-mail (comum a ambos)
    const emailExists = await this.prisma.user.findUnique({ where: { email: dto.email } });
    if (emailExists) throw new BadRequestException('Este e-mail já está em uso.');

    // 2. Verificações específicas por Role (CPF ou CNPJ)
    if (role === 'USER') {
      const userDto = dto as CreateUserDto;
      const cpfExists = await this.prisma.user.findUnique({ where: { cpf: userDto.cpf } });
      if (cpfExists) throw new BadRequestException('Este CPF já está cadastrado.');
    } else {
      const ongDto = dto as CreateOngDto;
      const cnpjExists = await this.prisma.user.findUnique({ where: { cnpj: ongDto.cnpj } });
      if (cnpjExists) throw new BadRequestException('Este CNPJ já está cadastrado.');
    }

    // 3. Criptografia
    const hashedPassword = await bcrypt.hash(dto.password, 10);

    // 4. Criação no Banco
    // Separa a senha do restante do DTO para injetar tudo dinamicamente
    const { password, ...dadosRestantes } = dto;
    
    const newUser = await this.prisma.user.create({
      data: {
        ...dadosRestantes, // 👈 Injeta automaticamente o CEP, Habilidades, Bio, etc.
        password: hashedPassword,
        role,
      },
    });

    const { password: _, ...result } = newUser;
    return result;
  }
}