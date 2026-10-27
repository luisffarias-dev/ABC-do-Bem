import { Injectable, NotFoundException, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service'; // Ajuste o caminho conforme o seu projeto

@Injectable()
export class SocialService {
  constructor(private prisma: PrismaService) {}

  // ==========================================
  // 1. EXPERIÊNCIAS DOS VOLUNTÁRIOS
  // ==========================================
  
  async createExperience(userId: string, ongName: string, text: string, formattedDate: string, imageUrl?: string) {
    return this.prisma.volunteerExperience.create({
      data: {
        userId,
        ongName,
        text,
        formattedDate,
        imageUrl
      }
    });
  }

  async getUserExperiences(userId: string) {
    return this.prisma.volunteerExperience.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' }
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

  async createOngPost(ongId: string, title: string, text: string, imageUrl?: string) {
    return this.prisma.ongPost.create({
      data: {
        ongId,
        title,
        text,
        imageUrl
      }
    });
  }

  async getOngPosts(ongId: string) {
    return this.prisma.ongPost.findMany({
      where: { ongId },
      orderBy: { createdAt: 'desc' }
    });
  }

  // ==========================================
  // 3. SISTEMA DE SEGUIR ONGS (FOLLOWERS)
  // ==========================================

  async followOng(volunteerId: string, ongId: string) {
    // Verifica se já segue
    const existingFollow = await this.prisma.ongFollower.findUnique({
      where: {
        ongId_volunteerId: { ongId, volunteerId } // Usa a chave composta definida no prisma
      }
    });

    if (existingFollow) {
      throw new BadRequestException('Você já segue esta ONG.');
    }

    await this.prisma.ongFollower.create({
      data: { ongId, volunteerId }
    });

    return { seguindo: true };
  }

  async unfollowOng(volunteerId: string, ongId: string) {
    try {
      await this.prisma.ongFollower.delete({
        where: {
          ongId_volunteerId: { ongId, volunteerId }
        }
      });
      return { seguindo: false };
    } catch (error) {
      throw new BadRequestException('Você não estava a seguir esta ONG.');
    }
  }
}