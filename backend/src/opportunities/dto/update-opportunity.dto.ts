import { PartialType, ApiPropertyOptional } from '@nestjs/swagger';
import { CreateOpportunityDto } from './create-opportunity.dto';
import { IsOptional, IsString, IsIn } from 'class-validator';

export class UpdateOpportunityDto extends PartialType(CreateOpportunityDto) {
  @ApiPropertyOptional({
    description: 'Estado do evento: ATIVA, LOTADA, CONCLUIDA ou CANCELADA',
    enum: ['ATIVA', 'LOTADA', 'CONCLUIDA', 'CANCELADA'],
  })
  @IsOptional()
  @IsString()
  @IsIn(['ATIVA', 'LOTADA', 'CONCLUIDA', 'CANCELADA'])
  status?: string;
}