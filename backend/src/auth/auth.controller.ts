// 👇 ADICIONADO: UseGuards na importação do @nestjs/common
import { Body, Controller, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { CreateUserDto } from './dto/create-user.dto';
import { CreateOngDto } from './dto/create-ong.dto';
import { LoginDto } from './dto/login.dto';
import { ThrottlerGuard } from '@nestjs/throttler';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @ApiOperation({ summary: 'Cadastra um novo usuario' })
  @Post('userRegister')
  // Usando o DTO, o NestJS já limpa o que não deve entrar
  async userregister(@Body() createUserDto: CreateUserDto) {
    return this.authService.register(createUserDto, 'USER');
  }

  @ApiOperation({ summary: 'Cadastra uma nova ong' })
  @Post('ongRegister')
  // Usando o DTO, o NestJS já limpa o que não deve entrar
  async ongregister(@Body() createOngDto: CreateOngDto) {
    return this.authService.register(createOngDto, 'ONG');
  }

  // 👇 AGORA SIM, rodando perfeitamente!
  @UseGuards(ThrottlerGuard)
  @ApiOperation({ summary: 'Realiza o login e retorna o Token JWT' })
  @HttpCode(HttpStatus.OK)
  @Post('login')
  async login(@Body() loginDto: LoginDto) { 
    return this.authService.login(loginDto);
  }
}