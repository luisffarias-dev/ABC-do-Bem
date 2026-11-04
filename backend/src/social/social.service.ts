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
}