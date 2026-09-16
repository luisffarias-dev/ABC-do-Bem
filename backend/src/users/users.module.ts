import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule], // 👈 Fundamental para o Service falar com o banco
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}