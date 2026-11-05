import { Injectable, NotFoundException, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVolunteerExperienceDto } from './dto/create-volunteer-experience.dto';
import { CreateOngPostDto } from './dto/create-ong-post.dto';

@Injectable()
export class SocialService {
  constructor(private prisma: PrismaService) {}

  // ==========================================
  // 1. EXPERIÊNCIAS DOS VOLUNTÁRIOS
  // ==========================================
  
  async createExperience(userId: string, dto: CreateVolunteerExperienceDto) {
    return this.prisma.volunteerExperience.create({
      data: {
        userId,
        ...dto,
      },
    });
  }

  async getUserExperiences(userId: string) {
    return this.prisma.volunteerExperience.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async deleteExperience(experienceId: string, userId: string) {
    const experience = await this.prisma.volunteerExperience.findUnique({ where: { id: experienceId } });
    
    if (!experience) throw new NotFoundException('Experiência não encontrada');
    if (experience.userId !== userId) throw new UnauthorizedException('Apenas o autor pode deletar esta experiência');

    await this.prisma.volunteerExperience.delete({ where: { id: experienceId } });
    return { success: true };
  }

  // ==========================================
  // 2. POSTAGENS / MURAL DAS ONGS
  // ==========================================

  async createOngPost(ongId: string, dto: CreateOngPostDto) {
    return this.prisma.ongPost.create({
      data: {
        ongId,
        ...dto,
      },
    });
  }

  async getOngPosts(ongId: string) {
    return this.prisma.ongPost.findMany({
      where: { ongId },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ==========================================
  // 3. SISTEMA DE SEGUIR ONGS (FOLLOWERS)
  // ==========================================

  async followOng(volunteerId: string, ongId: string) {
    const existingFollow = await this.prisma.ongFollower.findUnique({
      where: {
        ongId_volunteerId: { ongId, volunteerId },
      },
    });

    if (existingFollow) {
      throw new BadRequestException('Você já segue esta ONG.');
    }

    await this.prisma.ongFollower.create({
      data: { ongId, volunteerId },
    });

    return { seguindo: true };
  }

  async unfollowOng(volunteerId: string, ongId: string) {
    try {
      await this.prisma.ongFollower.delete({
        where: {
          ongId_volunteerId: { ongId, volunteerId },
        },
      });
      return { seguindo: false };
    } catch (error) {
      throw new BadRequestException('Você não estava a seguir esta ONG.');
    }
  }

  // ==========================================
  // 4. FEED UNIFICADO (COMUNIDADE)
  // ==========================================

  async getUnifiedFeed(dias: number = 10, limit: number = 20) {
    // Calcula a data de corte
    const dateThreshold = new Date();
    dateThreshold.setDate(dateThreshold.getDate() - dias);

    // 1. Busca os relatos dos voluntários com os dados do autor em paralelo
    const experiencesPromise = this.prisma.volunteerExperience.findMany({
      where: { createdAt: { gte: dateThreshold } },
      include: { user: { select: { id: true, name: true, avatar: true } } },
      orderBy: { createdAt: 'desc' },
      take: limit, // Pega o limite máximo possível para garantir a cota
    });

    // 2. Busca as postagens das ONGs com os dados do autor em paralelo
    const ongPostsPromise = this.prisma.ongPost.findMany({
      where: { createdAt: { gte: dateThreshold } },
      include: { ong: { select: { id: true, name: true, avatar: true } } },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    // Aguarda ambas as consultas terminarem
    const [experiences, ongPosts] = await Promise.all([experiencesPromise, ongPostsPromise]);

    // 3. Mapeamento padronizado (Voluntários)
    const mappedExperiences = experiences.map((exp) => ({
      id: exp.id,
      tipoAutor: 'VOLUNTARIO',
      autorId: exp.userId,
      autorNome: exp.user.name,
      autorFoto: exp.user.avatar,
      texto: exp.text,
      imagemUrl: exp.imageUrl,
      iniciativa: exp.ongName, // A ONG onde fez o voluntariado
      createdAt: exp.createdAt,
    }));

    // 4. Mapeamento padronizado (ONGs)
    const mappedPosts = ongPosts.map((post) => ({
      id: post.id,
      tipoAutor: 'ONG',
      autorId: post.ongId,
      autorNome: post.ong.name,
      autorFoto: post.ong.avatar,
      texto: post.text,
      imagemUrl: post.imageUrl,
      iniciativa: post.title, // Usa o título da postagem como iniciativa
      createdAt: post.createdAt,
    }));

    // 5. Junta, ordena de forma decrescente pela data e aplica o limite final
    return [...mappedExperiences, ...mappedPosts]
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .slice(0, limit);
  }
}