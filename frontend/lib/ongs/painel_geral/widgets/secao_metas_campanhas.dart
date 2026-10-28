// lib/ongs/painel_geral/widgets/secao_metas_campanhas.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoMetasCampanhas extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoMetasCampanhas({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "4. Metas da Instituição",
      icone: Icons.flag_rounded,
      isMobile: isMobile,
      botaoAcao: TextButton(
        onPressed: () => onNavegar("Configurar Metas"),
        child: const Text(
          "+ Meta",
          style: TextStyle(
            color: Color(0xFF0C6B6B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      conteudo: const Column(
        children: [
          _ItemMeta(
            titulo: "Arrecadação de Cestas Básicas",
            progressoTexto: "112 de 150",
            porcentagem: 0.74,
          ),
          SizedBox(height: 10),
          _ItemMeta(
            titulo: "Capacitação Pedagógica",
            progressoTexto: "18 de 20",
            porcentagem: 0.90,
          ),
        ],
      ),
    );
  }
}

class _ItemMeta extends StatelessWidget {
  final String titulo;
  final String progressoTexto;
  final double porcentagem;

  const _ItemMeta({
    required this.titulo,
    required this.progressoTexto,
    required this.porcentagem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              progressoTexto,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: porcentagem,
            backgroundColor: const Color(0xFFE3F5F1),
            color: const Color(0xFF0C6B6B),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
