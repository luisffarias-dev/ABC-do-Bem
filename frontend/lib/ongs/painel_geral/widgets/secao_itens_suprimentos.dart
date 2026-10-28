// lib/ongs/painel_geral/widgets/secao_itens_suprimentos.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoItensSuprimentos extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoItensSuprimentos({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "5. Itens e Suprimentos",
      icone: Icons.volunteer_activism_rounded,
      isMobile: isMobile,
      botaoAcao: TextButton(
        onPressed: () => onNavegar("Gerenciar Doações"),
        child: const Text(
          "Gerenciar",
          style: TextStyle(
            color: Color(0xFF0C6B6B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      conteudo: const Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _ChipItem(
            texto: "Leite em Pó (Faltam 24)",
            bg: Color(0xFFFFF1F0),
            corTexto: Color(0xFFCF1322),
          ),
          _ChipItem(
            texto: "Papel Sulfite A4 (Faltam 8)",
            bg: Color(0xFFFFF7E6),
            corTexto: Color(0xFFD46B08),
          ),
          _ChipItem(
            texto: "Lápis de Cor (Meta Atingida)",
            bg: Color(0xFFF6FFED),
            corTexto: Color(0xFF389E0D),
          ),
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String texto;
  final Color bg;
  final Color corTexto;

  const _ChipItem({
    required this.texto,
    required this.bg,
    required this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: corTexto.withOpacity(0.4)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: corTexto,
        ),
      ),
    );
  }
}
