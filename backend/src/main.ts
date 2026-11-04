import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { json, urlencoded } from 'express'; // NOVO: Importação necessária

async function bootstrap() {
  // Cria a instância da aplicação baseada no AppModule
  const app = await NestFactory.create(AppModule);

  // ==========================================
  // NOVO: Aumento do limite de Payload para 10MB (Suporte a imagens Base64)
  // ==========================================
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

  // 1. Configuração do ValidationPipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // Remove campos do corpo da requisição que não estão no DTO
      forbidNonWhitelisted: true, // Retorna erro se enviarem campos extras
      transform: true, // Converte tipos automaticamente
    }),
  );

  // 2. Configuração do Swagger
  const config = new DocumentBuilder()
    .setTitle('ABC do Bem')
    .setDescription('API de Webhooks e Gerenciamento de ONGs e Voluntarios')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  // 3. Habilita o CORS (Importante para front-end/mobile)
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: '*',
  });

  // Inicia o servidor na porta
  await app.listen(process.env.PORT || 3000, '0.0.0.0');
  console.log(`Application is running on: ${await app.getUrl()}`);
}
bootstrap();