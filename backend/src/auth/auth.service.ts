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

  // ROTA DE LOGIN - Agora recebe o LoginDto
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
    };
  }

  // ROTA DE CADASTRO - Recebe o CreateUserDto e remove o parâmetro role
 // No AuthService
async register(createUserDto: CreateUserDto | CreateOngDto, role: 'USER' | 'ONG' = 'USER') {
  const { email, name, password } = createUserDto;

  // 1. Verificação de duplicidade
  const [userExists, nameExists] = await Promise.all([
    this.prisma.user.findUnique({ where: { email } }),
    this.prisma.user.findUnique({ where: { name } }),
  ]);
  
  if (userExists) throw new BadRequestException('Este e-mail já está em uso.');
  if (nameExists) throw new BadRequestException('Este Apelido já está em uso.');

  // 2. Criptografia
  const hashedPassword = await bcrypt.hash(password, 10);

  // 3. Criação no Banco
  const newUser = await this.prisma.user.create({
    data: {
      name,
      email,
      password: hashedPassword,
      role, // A role agora é injetada dinamicamente
    },
  });

  const { password: _, ...result } = newUser;
  return result;
}
   
}