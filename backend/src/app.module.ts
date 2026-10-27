import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { PrismaModule } from './prisma/prisma.module';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { OpportunitiesModule } from './opportunities/opportunities.module'
import { UsersModule } from './users/users.module'
import { ChatModule } from './chat/chat.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SocialModule } from './social/social.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ThrottlerModule.forRoot([
      {
        name: 'default',
        ttl: 60000,
        limit: 10,
      },
    ]),
    AuthModule,
    PrismaModule,
    OpportunitiesModule,
    UsersModule,
    ChatModule,
    NotificationsModule,
    SocialModule,

  ],
  controllers: [], // Removido o AppController padrão
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ], // Removido o AppService padrão
})
export class AppModule {}