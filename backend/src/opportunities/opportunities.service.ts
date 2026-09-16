import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOpportunityDto } from './dto/create-opportunity.dto';
import { UpdateOpportunityDto } from './dto/update-opportunity.dto';

@Injectable()
export class OpportunitiesService {
  constructor(private prisma: PrismaService) {}

  // 1. CRIAR
  async create(ongId: string, dto: CreateOpportunityDto) {
    const ong = await this.prisma.user.findUnique({ where: { id: ongId } });
    if (!ong || ong.role !== 'ONG') throw new NotFoundException('ONG não encontrada');

    return this.prisma.opportunity.create({
      data: {
        ...dto,
        eventDate: new Date(dto.eventDate),
        ongId,
      },
    });
  }

  // 2. LISTAR TODAS (Com suporte a filtros opcionais)
  async findAll(cidade?: string, categoria?: string) {
    return this.prisma.opportunity.findMany({
      where: {
        ...(cidade && { cidade: { contains: cidade, mode: 'insensitive' } }),
        ...(categoria && { categories: { has: categoria } }),
        eventDate: { gte: new Date() }, // Traz apenas eventos que ainda não aconteceram
      },
      include: {
        ong: { select: { name: true, avatar: true } },
        _count: { select: { applications: { where: { status: 'CONFIRMED' } } } }, // Conta quantas vagas já foram preenchidas
      },
      orderBy: { eventDate: 'asc' },
    });
  }

  // 3. BUSCAR AS MAIS PRÓXIMAS (O diferencial do TCC - Fórmula de Haversine em KM)
  async findNearby(lat: number, lng: number, maxDistanceKm: number = 20) {
    // Retorna as vagas em um raio específico, calculando a distância matemática
    const opportunities = await this.prisma.$queryRawUnsafe(`
      SELECT o.*, u.name as "ongName", u.avatar as "ongAvatar",
      (
        6371 * acos(
          cos(radians(${lat})) * cos(radians(o.latitude)) *
          cos(radians(o.longitude) - radians(${lng})) +
          sin(radians(${lat})) * sin(radians(o.latitude))
        )
      ) AS "distance_km"
      FROM "Opportunity" o
      JOIN "User" u ON o."ongId" = u.id
      WHERE o.latitude IS NOT NULL AND o.longitude IS NOT NULL
      AND o."eventDate" >= NOW()
      HAVING (
        6371 * acos(
          cos(radians(${lat})) * cos(radians(o.latitude)) *
          cos(radians(o.longitude) - radians(${lng})) +
          sin(radians(${lat})) * sin(radians(o.latitude))
        )
      ) <= ${maxDistanceKm}
      ORDER BY "distance_km" ASC
      LIMIT 15;
    `);
    
    return opportunities;
  }

  // 4. LISTAR VAGAS DE UMA ONG ESPECÍFICA (Para o Painel da ONG)
  async findByOng(ongId: string) {
    return this.prisma.opportunity.findMany({
      where: { ongId },
      include: {
        _count: { select: { applications: true } }, // Mostra quantos se candidataram
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  // 5. DETALHES DE UMA VAGA
  async findOne(id: string) {
    const opportunity = await this.prisma.opportunity.findUnique({
      where: { id },
      include: {
        ong: { select: { name: true, descricao: true, avatar: true, telefoneFixo: true, whatsapp: true } },
      },
    });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    return opportunity;
  }

  // 6. ATUALIZAR
  async update(id: string, ongId: string, dto: UpdateOpportunityDto) {
    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) throw new UnauthorizedException('Você só pode editar suas próprias vagas');

    return this.prisma.opportunity.update({
      where: { id },
      data: {
        ...dto,
        ...(dto.eventDate && { eventDate: new Date(dto.eventDate) }),
      },
    });
  }

  // 7. EXCLUIR
  async remove(id: string, ongId: string) {
    const opportunity = await this.prisma.opportunity.findUnique({ where: { id } });
    if (!opportunity) throw new NotFoundException('Vaga não encontrada');
    if (opportunity.ongId !== ongId) throw new UnauthorizedException('Você só pode deletar suas próprias vagas');

    return this.prisma.opportunity.delete({ where: { id } });
  }
}