# ABC do Bem — Backend API

## Autores

- Luis Fernando França Farias
- Douglas Barbosa de Oliveira
- Ryan Pereira da Mota

## Sobre o Projeto

O ABC do Bem é uma plataforma solidária desenvolvida para aproximar Voluntários e ONGs (Organizações Não Governamentais). Este repositório hospeda o Backend oficial, construído com arquitetura modular em NestJS, utilizando Prisma ORM com PostgreSQL, comunicação em tempo real via WebSockets, e integração com um microsserviço de Machine Learning (TF-IDF) em Python/Flask para recomendação inteligente de vagas.

## Principais Funcionalidades

### 1. Autenticação e Perfis (JWT & Role-Based Access)
* Gestão unificada de utilizadores com suporte a múltiplos papéis (USER para voluntários e ONG para instituições).
* Atualização parcial de perfil (UpdateUserDto) com suporte a imagens em Base64 (payload estendido até 10MB).
* Regra de alteração de e-mail com fluxo de confirmação pendente (pendingEmail e emailConfirmationToken).
* Proteção estrita contra Mass Assignment (bloqueio de alteração direta de campos sensíveis como cpf e role).

### 2. Gestão de Oportunidades e Candidaturas
* Criação e listagem de vagas de voluntariado pelas ONGs.
* Vitrine inteligente com identificadores de inscrição em tempo real (isApplied e applicationStatus).
* Ciclo de vida completo da candidatura: inscrição (POST), desistência voluntária (DELETE), aprovação/recusa pela ONG (PATCH) e validação de presenças/horas solidárias.

### 3. Sistema de Recomendação por Inteligência Artificial
* Integração com microserviço Flask hospedado no Render que calcula a compatibilidade por similaridade de texto (TF-IDF).
* Filtro inteligente que exclui automaticamente as vagas em que o utilizador já se encontra inscrito.

### 4. Chat em Tempo Real e Mensageria
* Comunicação privada bidirecional via WebSockets (Socket.io).
* Caixa de entrada (Inbox) unificada com contador de mensagens não lidas (unreadCount).
* Histórico de mensagens paginado.
* Soft Hide: Funcionalidade de limpeza de conversas por utilizador (DELETE /chat/conversations/:id), preservando o histórico para auditoria sem afetar a visualização da outra parte.

### 5. Feed Social Comunitário
* Endpoint unificado (GET /social/feed) que combina publicações do mural das ONGs (OngPost) e relatos dos voluntários (VolunteerExperience) em ordem cronológica decrescente.
* Sistema de seguidores (Follow / Unfollow) entre voluntários e ONGs.

### 6. Notificações Transacionais Automáticas
* Disparo e registo automático de avisos na base de dados para voluntários e ONGs sempre que ocorrem interações críticas (ex: novas candidaturas).

## Tecnologias Utilizadas
* Framework: NestJS (Node.js / TypeScript)
* ORM: Prisma
* Base de Dados: PostgreSQL
* Tempo Real: WebSockets (Socket.io)
* Inteligência Artificial: Python / Flask (Microserviço de Recomendação TF-IDF)
* Documentação: Swagger UI

## Arquitetura Modular

```
src/
├── auth/           # Estratégias JWT, Guards e Autenticação
├── chat/           # Módulo de WebSockets, Salas e Mensageria
├── opportunities/  # Gestão de Vagas e Inscrições
├── prisma/         # Conexão e Schema do Banco de Dados
├── social/         # Feed Comunitário, Relatos e Seguidores
├── users/          # Gestão de Perfis, Dashboard e Endereço
├── app.module.ts   # Módulo Raiz
└── main.ts         # Bootstrap, Cors e Body-Parser (10MB)
```

## Como Executar o Projeto Localmente

### Pré-requisitos
* Node.js (v18+) instalado
* Instância de base de dados PostgreSQL configurada

### Passo a passo
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-utilizador/abc-do-bem-backend.git
   cd abc-do-bem-backend
   ```
2. Instale as dependências:
   ```bash
   npm install
   ```
3. Configure as Variáveis de Ambiente:
   Crie um ficheiro `.env` na raiz do projeto com base no exemplo abaixo:
   ```env
   DATABASE_URL="postgresql://usuario:senha@localhost:5432/abc_do_bem?schema=public"
   JWT_SECRET="sua_chave_secreta_jwt"
   FLASK_ML_URL="https://seu-servico-ml.onrender.com"
   PORT=3000
   ```
4. Execute as Migrações do Prisma:
   ```bash
   npx prisma db push
   ```
5. Inicie o Servidor em Modo de Desenvolvimento:
   ```bash
   npm run start:dev
   ```

O servidor estará rodando em `http://localhost:3000`.

## Documentação da API (Swagger)

Com a aplicação a correr, acesse a documentação interativa gerada automaticamente pelo Swagger em:
`http://localhost:3000/api`

## Contribuição

Desenvolvido com foco em impacto social e alta performance para o ecossistema do ABC do Bem.
