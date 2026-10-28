// lib/ongs/painel_geral/widgets/card_painel_base.dart

import 'package:flutter/material.dart';

class CardPainelBase extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Widget conteudo;
  final bool isMobile;
  final Widget? botaoAcao;

  const CardPainelBase({
    super.key,
    required this.titulo,
    required this.icone,
    required this.conteudo,
    required this.isMobile,
    this.botaoAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 17, color: const Color(0xFF0C6B6B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (botaoAcao != null) botaoAcao!,
            ],
          ),
          const SizedBox(height: 10),
          conteudo,
        ],
      ),
    );
  }
}
