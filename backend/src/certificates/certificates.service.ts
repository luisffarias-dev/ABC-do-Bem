import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PDFDocument, rgb, StandardFonts, PDFFont } from 'pdf-lib';
import * as fontkit from '@pdf-lib/fontkit';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class CertificatesService {
  constructor(private prisma: PrismaService) {}

  async generateCertificatePdf(
    applicationId: string,
    requesterId: string,
  ): Promise<{ buffer: Buffer; filename: string }> {
    // 1. Busca a candidatura com os dados do voluntário, da vaga e da ONG
    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: {
        user: { select: { id: true, name: true, cpf: true } },
        opportunity: {
          include: {
            ong: { select: { id: true, name: true, razaoSocial: true, cnpj: true } },
          },
        },
      },
    });

    if (!application) {
      throw new NotFoundException('Candidatura não encontrada.');
    }

    // 2. Garante que apenas o próprio voluntário ou a ONG dona da vaga baixe o PDF
    const isVolunteer = application.userId === requesterId;
    const isOngOwner = application.opportunity.ongId === requesterId;
    if (!isVolunteer && !isOngOwner) {
      throw new ForbiddenException('Você não tem permissão para emitir este certificado.');
    }

    // 3. Regra de negócio: só emite se a presença foi validada pela ONG
    if (!application.attended) {
      throw new BadRequestException(
        'O certificado só fica disponível após a ONG confirmar sua presença no evento.',
      );
    }

    // 4. Carrega o template PDF base
    const templatePath = path.join(process.cwd(), 'src/assets/certificado-base.pdf');
    if (!fs.existsSync(templatePath)) {
      throw new NotFoundException('Template base de certificado não encontrado no servidor.');
    }

    const templateBytes = fs.readFileSync(templatePath);
    const pdfDoc = await PDFDocument.load(templateBytes);

    // Registra o fontkit para suportar a fonte Amsterdam.ttf
    pdfDoc.registerFontkit(fontkit);

    const page = pdfDoc.getPages()[0];
    const { width } = page.getSize();

    const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
    const fontRegular = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const fontItalic = await pdfDoc.embedFont(StandardFonts.HelveticaBoldOblique);

    // Carrega a fonte manuscrita Amsterdam.ttf de src/assets/
    const signatureFontPath = path.join(process.cwd(), 'src/assets/Amsterdam.ttf');
    const fontSignature = fs.existsSync(signatureFontPath)
      ? await pdfDoc.embedFont(fs.readFileSync(signatureFontPath))
      : fontItalic;

    // 5. Nome do Voluntário (Centralizado logo acima da linha central)
    const volunteerName = application.user.name.toUpperCase();
    const nameFontSize = 26;
    const nameWidth = fontBold.widthOfTextAtSize(volunteerName, nameFontSize);

    page.drawText(volunteerName, {
      x: (width - nameWidth) / 2,
      y: 272,
      size: nameFontSize,
      font: fontBold,
      color: rgb(0.08, 0.12, 0.16),
    });

    // 6. Texto descritivo centralizado linha por linha (abaixo da linha central)
    const eventDateFormatted = new Date(application.opportunity.eventDate).toLocaleDateString('pt-BR');
    const eventTitle = application.opportunity.title.toUpperCase();
    const hours = application.opportunity.durationHours;
    const ongDisplayName = application.opportunity.ong.name;

    const fullText = `PARTICIPOU DO ${eventTitle}, COM CARGA HORÁRIA DE ${hours} HORA(S), EM ${eventDateFormatted}.`;

    const lines = this.wrapText(fullText, fontRegular, 14, 620);
    let currentY = 215;

    for (const line of lines) {
      const lineWidth = fontRegular.widthOfTextAtSize(line, 14);
      page.drawText(line, {
        x: (width - lineWidth) / 2,
        y: currentY,
        size: 14,
        font: fontRegular,
        color: rgb(0.1, 0.1, 0.1),
      });
      currentY -= 22;
    }

    // 7. Assinatura caligráfica da ONG com Amsterdam.ttf (Acima da linha direita)
    const rightSignatureCenterX = width * 0.725;
    const sigFontSize = 13;
    const sigWidth = fontSignature.widthOfTextAtSize(ongDisplayName, sigFontSize);

    page.drawText(ongDisplayName, {
      x: rightSignatureCenterX - sigWidth / 2,
      y: 96,
      size: sigFontSize,
      font: fontSignature,
      color: rgb(0.12, 0.12, 0.12),
    });

    // 8. Nome impresso da ONG (Abaixo da linha direita, alinhado com "ABC do Bem")
    const ongFontSize = 12;
    const ongWidth = fontItalic.widthOfTextAtSize(ongDisplayName, ongFontSize);

    page.drawText(ongDisplayName, {
      x: rightSignatureCenterX - ongWidth / 2,
      y: 73,
      size: ongFontSize,
      font: fontItalic,
      color: rgb(0.1, 0.1, 0.1),
    });

    // 9. Código de Autenticidade no rodapé
    const validationCode = application.id.toUpperCase();
    const footerText = `Código de Autenticidade: ${validationCode}`;
    const footerWidth = fontRegular.widthOfTextAtSize(footerText, 9);

    page.drawText(footerText, {
      x: (width - footerWidth) / 2,
      y: 55,
      size: 9,
      font: fontRegular,
      color: rgb(0.45, 0.45, 0.45),
    });

    const pdfBytes = await pdfDoc.save();
    const safeFilename = `certificado-${application.opportunity.title
      .toLowerCase()
      .replace(/[^a-z0-9]/g, '-')}.pdf`;

    return {
      buffer: Buffer.from(pdfBytes),
      filename: safeFilename,
    };
  }

  // ==========================================
  // ROTA PÚBLICA DE VALIDAÇÃO (PARA FACULDADES / TERCEIROS)
  // ==========================================
  async verifyCertificate(applicationId: string) {
    const application = await this.prisma.application.findUnique({
      where: { id: applicationId },
      include: {
        user: { select: { name: true } },
        opportunity: {
          select: {
            title: true,
            eventDate: true,
            durationHours: true,
            ong: { select: { name: true, cnpj: true } },
          },
        },
      },
    });

    if (!application || !application.attended) {
      return {
        valid: false,
        message: 'Certificado inválido ou presença ainda não confirmada pela instituição.',
      };
    }

    return {
      valid: true,
      codigoValidacao: application.id.toUpperCase(),
      voluntario: application.user.name,
      evento: application.opportunity.title,
      instituicao: application.opportunity.ong.name,
      cnpjInstituicao: application.opportunity.ong.cnpj,
      dataRealizacao: application.opportunity.eventDate,
      cargaHoraria: application.opportunity.durationHours,
    };
  }

  private wrapText(text: string, font: PDFFont, fontSize: number, maxWidth: number): string[] {
    const words = text.split(' ');
    const lines: string[] = [];
    let currentLine = '';

    for (const word of words) {
      const testLine = currentLine ? `${currentLine} ${word}` : word;
      if (font.widthOfTextAtSize(testLine, fontSize) <= maxWidth) {
        currentLine = testLine;
      } else {
        if (currentLine) lines.push(currentLine);
        currentLine = word;
      }
    }
    if (currentLine) lines.push(currentLine);
    return lines;
  }
}