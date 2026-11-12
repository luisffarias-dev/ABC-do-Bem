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
      include: {
        _count: { select: { likes: true } },
        likes: { where: { userId }, select: { id: true } }
      }
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
      include: {
        _count: { select: { likes: true } },
        likes: { where: { userId: ongId }, select: { id: true } } // Nota: pode ser ajustado para o id de quem consulta se necessário
      }
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
  // 3.1 SISTEMA DE CURTIDAS (LIKES)
  // ==========================================

  async toggleLikeOngPost(userId: string, postId: string) {
    const post = await this.prisma.ongPost.findUnique({ where: { id: postId } });
    if (!post) throw new NotFoundException('Postagem não encontrada.');

    const existingLike = await this.prisma.ongPostLike.findUnique({
      where: { userId_postId: { userId, postId } }
    });

    if (existingLike) {
      await this.prisma.ongPostLike.delete({ where: { id: existingLike.id } });
      return { liked: false, message: 'Curtida removida.' };
    } else {
      await this.prisma.ongPostLike.create({ data: { userId, postId } });
      return { liked: true, message: 'Post curtido com sucesso.' };
    }
  }

  async toggleLikeExperience(userId: string, experienceId: string) {
    const experience = await this.prisma.volunteerExperience.findUnique({ where: { id: experienceId } });
    if (!experience) throw new NotFoundException('Experiência não encontrada.');

    const existingLike = await this.prisma.volunteerExperienceLike.findUnique({
      where: { userId_experienceId: { userId, experienceId } }
    });

    if (existingLike) {
      await this.prisma.volunteerExperienceLike.delete({ where: { id: existingLike.id } });
      return { liked: false, message: 'Curtida removida.' };
    } else {
      await this.prisma.volunteerExperienceLike.create({ data: { userId, experienceId } });
      return { liked: true, message: 'Experiência curtida com sucesso.' };
    }
  }

  // ==========================================
  // 4. FEED UNIFICADO (COMUNIDADE)
  // ==========================================

  async getUnifiedFeed(dias: number = 10, limit: number = 20, currentUserId?: string) {
    const dateThreshold = new Date();
    dateThreshold.setDate(dateThreshold.getDate() - dias);

    const experiencesPromise = this.prisma.volunteerExperience.findMany({
      where: { createdAt: { gte: dateThreshold } },
      include: { 
        user: { select: { id: true, name: true, avatar: true } },
        _count: { select: { likes: true } },
        likes: currentUserId ? { where: { userId: currentUserId }, select: { id: true } } : false,
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    const ongPostsPromise = this.prisma.ongPost.findMany({
      where: { createdAt: { gte: dateThreshold } },
      include: { 
        ong: { select: { id: true, name: true, avatar: true } },
        _count: { select: { likes: true } },
        likes: currentUserId ? { where: { userId: currentUserId }, select: { id: true } } : false,
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    const [experiences, ongPosts] = await Promise.all([experiencesPromise, ongPostsPromise]);

    const mappedExperiences = experiences.map((exp) => ({
      id: exp.id,
      tipoAutor: 'VOLUNTARIO',
      autorId: exp.userId,
      autorNome: exp.user.name,
      autorFoto: exp.user.avatar,
      texto: exp.text,
      imagemUrl: exp.imageUrl,
      iniciativa: exp.ongName, 
      createdAt: exp.createdAt,
      likesCount: exp._count.likes,
      isLiked: currentUserId ? exp.likes.length > 0 : false,
    }));

    const mappedPosts = ongPosts.map((post) => ({
      id: post.id,
      tipoAutor: 'ONG',
      autorId: post.ongId,
      autorNome: post.ong.name,
      autorFoto: post.ong.avatar,
      texto: post.text,
      imagemUrl: post.imageUrl,
      iniciativa: post.title, 
      createdAt: post.createdAt,
      likesCount: post._count.likes,
      isLiked: currentUserId ? post.likes.length > 0 : false,
    }));

    return [...mappedExperiences, ...mappedPosts]
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .slice(0, limit);
  }
}