import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty } from 'class-validator';

export class ValidatePresenceDto {
  @ApiProperty({ description: 'True se o voluntário compareceu, False se faltou' })
  @IsNotEmpty()
  @IsBoolean()
  attended: boolean;
}