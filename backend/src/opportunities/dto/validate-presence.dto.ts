import { IsBoolean, IsOptional, IsString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ValidatePresenceDto {
  @ApiProperty({ example: true, description: 'Indica se o voluntário compareceu ao evento' })
  @IsBoolean()
  attended: boolean;

  @ApiPropertyOptional({ example: 'Excelente proatividade no plantio das mudas!', description: 'Feedback da ONG para o voluntário' })
  @IsOptional()
  @IsString()
  feedbackOng?: string;
}