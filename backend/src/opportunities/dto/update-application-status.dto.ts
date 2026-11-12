import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsIn } from 'class-validator';

export class UpdateApplicationStatusDto {
  @ApiProperty({ description: 'Status da análise: ACCEPTED ou REJECTED' })
  @IsNotEmpty()
  @IsString()
  @IsIn(['ACCEPTED', 'REJECTED'])
  status: 'ACCEPTED' | 'REJECTED';
}