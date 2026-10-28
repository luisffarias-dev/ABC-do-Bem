// lib/voluntarios/perfil/widgets/perfil_info_card.dart

import 'package:flutter/material.dart';

class PerfilInfoCard extends StatelessWidget {
  final String titulo;
  final Widget conteudo;

  const PerfilInfoCard({
    super.key,
    required this.titulo,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 10),
          conteudo,
        ],
      ),
    );
  }
}
