import { Module } from '@nestjs/common';
import { SocialService } from './social.service';
import { SocialController } from './social.controller';
import { PrismaModule } from '../prisma/prisma.module'; // Importante para aceder ao prisma

@Module({
  imports: [PrismaModule], // Adicione esta linha!
  controllers: [SocialController],
  providers: [SocialService],
})
export class SocialModule {}