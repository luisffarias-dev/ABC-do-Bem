import { PartialType, ApiPropertyOptional } from '@nestjs/swagger';
import { CreateOpportunityDto } from './create-opportunity.dto';
import { IsOptional, IsString } from 'class-validator';

export class UpdateOpportunityDto extends PartialType(CreateOpportunityDto) {
  @ApiPropertyOptional({ description: 'ATIVA, LOTADA, CONCLUIDA ou CANCELADA' })
  @IsOptional() @IsString() status?: string;
}