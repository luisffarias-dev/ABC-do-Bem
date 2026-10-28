// lib/ongs/painel_geral/widgets/secao_operacoes_adicionais.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoOperacoesAdicionais extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoOperacoesAdicionais({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    final btnCertificados = OutlinedButton.icon(
      onPressed: () => onNavegar("Certificados"),
      icon: const Icon(
        Icons.school_rounded,
        size: 16,
        color: Color(0xFF0C6B6B),
      ),
      label: const Text(
        "Certificados e Horas",
        style: TextStyle(
          color: Color(0xFF0C6B6B),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
        side: const BorderSide(color: Color(0xFF0C6B6B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        ),
      ),
    );

    final btnFaltas = OutlinedButton.icon(
      onPressed: () => onNavegar("Controle de Faltas"),
      icon: const Icon(
        Icons.event_busy_rounded,
        size: 16,
        color: Color(0xFFD46B08),
      ),
      label: const Text(
        "Controle de Faltas (No-Show)",
        style: TextStyle(
          color: Color(0xFFD46B08),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
        side: const BorderSide(color: Color(0xFFD46B08)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        ),
      ),
    );

    return CardPainelBase(
      titulo: "Operações Adicionais",
      icone: Icons.admin_panel_settings_rounded,
      isMobile: isMobile,
      conteudo: isMobile
          ? Column(
              children: [
                SizedBox(width: double.infinity, child: btnCertificados),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: btnFaltas),
              ],
            )
          : Row(
              children: [
                Expanded(child: btnCertificados),
                const SizedBox(width: 10),
                Expanded(child: btnFaltas),
              ],
            ),
    );
  }
}
