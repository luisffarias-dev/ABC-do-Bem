import { IsEmail, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger'; // Adicione esta linha

export class LoginDto {
  @ApiProperty({ example: 'abcdobem@abcdobem.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: '123456', minLength: 6 })
  @IsString()
  password: string;
}