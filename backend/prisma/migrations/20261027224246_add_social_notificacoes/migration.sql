-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ApplicationStatus" ADD VALUE 'PRESENT';
ALTER TYPE "ApplicationStatus" ADD VALUE 'ABSENT';

-- AlterTable
ALTER TABLE "Application" ADD COLUMN     "autorizouContato" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "caronaOuSuporte" TEXT,
ADD COLUMN     "horasValidadas" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT,
    "linkId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VolunteerExperience" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ongName" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "imageUrl" TEXT,
    "formattedDate" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VolunteerExperience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OngPost" (
    "id" TEXT NOT NULL,
    "ongId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OngPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OngFollower" (
    "id" TEXT NOT NULL,
    "ongId" TEXT NOT NULL,
    "volunteerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OngFollower_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "OngFollower_ongId_volunteerId_key" ON "OngFollower"("ongId", "volunteerId");

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VolunteerExperience" ADD CONSTRAINT "VolunteerExperience_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OngPost" ADD CONSTRAINT "OngPost_ongId_fkey" FOREIGN KEY ("ongId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OngFollower" ADD CONSTRAINT "OngFollower_ongId_fkey" FOREIGN KEY ("ongId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OngFollower" ADD CONSTRAINT "OngFollower_volunteerId_fkey" FOREIGN KEY ("volunteerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
