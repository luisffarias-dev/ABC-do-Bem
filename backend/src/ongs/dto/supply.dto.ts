import { IsString, IsOptional, IsNumber, IsDateString, IsBoolean, IsIn, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateSupplyDto {
  @ApiProperty({ example: 'Arroz Tipo 1' })
  @IsString()
  nome: string;

  @ApiProperty({ example: 'kg' })
  @IsString()
  unidade: string;

  @ApiProperty({ example: 100 })
  @IsNumber()
  @Min(0.1)
  quantidadeMeta: number;

  @ApiPropertyOptional({ example: 0 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  quantidadeRecebida?: number;

  @ApiPropertyOptional({ example: '2026-12-15T23:59:59.000Z' })
  @IsOptional()
  @IsDateString()
  prazoLimite?: string;

  @ApiPropertyOptional({ enum: ['BAIXA', 'MEDIA', 'ALTA', 'URGENTE'], default: 'MEDIA' })
  @IsOptional()
  @IsIn(['BAIXA', 'MEDIA', 'ALTA', 'URGENTE'])
  prioridade?: string;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  sincronizarPerfil?: boolean;

  @ApiPropertyOptional({ default: true, description: 'Dispara notificação interna para seguidores e voluntários compatíveis' })
  @IsOptional()
  @IsBoolean()
  notificarVoluntarios?: boolean;

  @ApiPropertyOptional({ default: false, description: 'Opcional: cria também uma postagem no mural da ONG' })
  @IsOptional()
  @IsBoolean()
  publicarNoFeed?: boolean;
}

export class UpdateSupplyDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  nome?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  unidade?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0.1)
  quantidadeMeta?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(0)
  quantidadeRecebida?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  prazoLimite?: string;

  @ApiPropertyOptional({ enum: ['BAIXA', 'MEDIA', 'ALTA', 'URGENTE'] })
  @IsOptional()
  @IsIn(['BAIXA', 'MEDIA', 'ALTA', 'URGENTE'])
  prioridade?: string;

  @ApiPropertyOptional({ enum: ['ABERTO', 'PARCIAL', 'ATENDIDO', 'CANCELADO'] })
  @IsOptional()
  @IsIn(['ABERTO', 'PARCIAL', 'ATENDIDO', 'CANCELADO'])
  status?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  sincronizarPerfil?: boolean;
}

export class CreatePledgeDto {
  @ApiPropertyOptional({ description: 'Opcional se o usuário estiver autenticado (puxa o nome automaticamente)' })
  @IsOptional()
  @IsString()
  doadorNome?: string;

  @ApiPropertyOptional({ example: '(11) 99999-9999' })
  @IsOptional()
  @IsString()
  doadorContato?: string;

  @ApiProperty({ example: 10 })
  @IsNumber()
  @Min(0.1)
  quantidade: number;

  @ApiPropertyOptional({ example: '2026-12-10T18:00:00.000Z' })
  @IsOptional()
  @IsDateString()
  dataLimiteEntrega?: string;

  @ApiPropertyOptional({ example: 'Entrego no sábado pela manhã' })
  @IsOptional()
  @IsString()
  observacoes?: string;
}

export class UpdatePledgeStatusDto {
  @ApiProperty({ enum: ['PROMETIDO', 'ENTREGUE', 'ATRASADO', 'CANCELADO'] })
  @IsIn(['PROMETIDO', 'ENTREGUE', 'ATRASADO', 'CANCELADO'])
  status: 'PROMETIDO' | 'ENTREGUE' | 'ATRASADO' | 'CANCELADO';

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  observacoes?: string;
}