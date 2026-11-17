import { Controller, Get, Param, UseGuards, Request, Res } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiProduces } from '@nestjs/swagger';
import type { Response } from 'express';
import { CertificatesService } from './certificates.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Certificados de Voluntariado')
@Controller('certificates')
export class CertificatesController {
  constructor(private readonly certificatesService: CertificatesService) {}

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('applications/:applicationId/download')
  @ApiProduces('application/pdf') // <-- Faz o Swagger reconhecer e baixar como .pdf
  @ApiOperation({ summary: 'Gera e baixa o certificado em PDF (requer presença validada)' })
  async downloadCertificate(
    @Param('applicationId') applicationId: string,
    @Request() req: any,
    @Res() res: Response,
  ) {
    const { buffer, filename } = await this.certificatesService.generateCertificatePdf(
      applicationId,
      req.user.userId,
    );

    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="${filename}"`,
      'Content-Length': buffer.length,
    });

    res.end(buffer);
  }

  @Get('verify/:applicationId')
  @ApiOperation({ summary: 'Valida publicamente a autenticidade de um certificado pelo código' })
  verifyCertificate(@Param('applicationId') applicationId: string) {
    return this.certificatesService.verifyCertificate(applicationId);
  }
}