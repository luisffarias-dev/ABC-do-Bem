import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { NotificationsController } from './notifications.controller';
import { PrismaModule } from '../prisma/prisma.module'; // Importante: Ajuste o caminho do seu PrismaModule

@Module({
  imports: [PrismaModule], // Injetar o Prisma para que o Service possa aceder à base de dados
  controllers: [NotificationsController],
  providers: [NotificationsService],
  exports: [NotificationsService], // Exportar o Service para que outros módulos possam usá-lo para enviar notificações
})
export class NotificationsModule {}