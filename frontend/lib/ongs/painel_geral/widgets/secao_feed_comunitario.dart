// lib/ongs/painel_geral/widgets/secao_feed_comunitario.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoFeedComunitario extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoFeedComunitario({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "6. Feed Comunitário",
      icone: Icons.campaign_rounded,
      isMobile: isMobile,
      botaoAcao: ElevatedButton.icon(
        onPressed: () => onNavegar("Nova Postagem"),
        icon: const Icon(Icons.post_add_rounded, size: 13, color: Colors.white),
        label: const Text(
          "Publicar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C6B6B),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      conteudo: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.feed_outlined, color: Color(0xFF0C6B6B), size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Último post: Entrega dos kits escolares",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062222),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "38 curtidas • 7 comentários • Publicado",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
