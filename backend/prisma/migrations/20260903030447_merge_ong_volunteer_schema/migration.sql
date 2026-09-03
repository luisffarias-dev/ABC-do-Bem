/*
  Warnings:

  - A unique constraint covering the columns `[cpf]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[cnpj]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "User_name_key";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "aceitaDoacoes" TEXT[],
ADD COLUMN     "aceiteLgpd" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "aceiteTermos" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "anoFundacao" INTEGER,
ADD COLUMN     "bairro" TEXT,
ADD COLUMN     "bio" TEXT,
ADD COLUMN     "causaPrincipal" TEXT,
ADD COLUMN     "cep" TEXT,
ADD COLUMN     "cidade" TEXT,
ADD COLUMN     "cnpj" TEXT,
ADD COLUMN     "cpf" TEXT,
ADD COLUMN     "descricao" TEXT,
ADD COLUMN     "disponibilidade" TEXT[],
ADD COLUMN     "estado" TEXT,
ADD COLUMN     "facebook" TEXT,
ADD COLUMN     "formatoVoluntariado" TEXT,
ADD COLUMN     "habilidades" TEXT[],
ADD COLUMN     "habilidadesBuscadas" TEXT[],
ADD COLUMN     "instagram" TEXT,
ADD COLUMN     "logradouro" TEXT,
ADD COLUMN     "nascimento" TEXT,
ADD COLUMN     "numero" TEXT,
ADD COLUMN     "publicoAtendido" TEXT[],
ADD COLUMN     "razaoSocial" TEXT,
ADD COLUMN     "servicosOferecidos" TEXT[],
ADD COLUMN     "site" TEXT,
ADD COLUMN     "telefone" TEXT,
ADD COLUMN     "telefoneFixo" TEXT,
ADD COLUMN     "tiktok" TEXT,
ADD COLUMN     "tipoDocumento" TEXT,
ADD COLUMN     "whatsapp" TEXT,
ALTER COLUMN "avatar" DROP DEFAULT;

-- CreateIndex
CREATE UNIQUE INDEX "User_cpf_key" ON "User"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "User_cnpj_key" ON "User"("cnpj");
