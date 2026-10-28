// lib/ongs/painel_geral/widgets/secao_voluntarios_destaque.dart

import 'package:flutter/material.dart';
import 'card_painel_base.dart';

class SecaoVoluntariosDestaque extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onNavegar;

  const SecaoVoluntariosDestaque({
    super.key,
    required this.isMobile,
    required this.onNavegar,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "3. Voluntários Guardiões",
      icone: Icons.workspace_premium_rounded,
      isMobile: isMobile,
      botaoAcao: TextButton(
        onPressed: () => onNavegar("Lista Completa"),
        child: const Text(
          "Ver Todos",
          style: TextStyle(
            color: Color(0xFF0C6B6B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      conteudo: Column(
        children: [
          _buildItemVoluntario(
            nome: "Carlos Eduardo Lima",
            presencas: "28 ações concluídas",
            tagDestaque: "Líder de Ação",
            fotoUrl:
                "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
          ),
          const SizedBox(height: 8),
          _buildItemVoluntario(
            nome: "Ana Carolina Santos",
            presencas: "14 ações concluídas",
            tagDestaque: "Destaque",
            fotoUrl:
                "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
          ),
        ],
      ),
    );
  }

  Widget _buildItemVoluntario({
    required String nome,
    required String presencas,
    required String tagDestaque,
    required String fotoUrl,
  }) {
    return Row(
      children: [
        CircleAvatar(radius: 16, backgroundImage: NetworkImage(fotoUrl)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                presencas,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFD1F5EE),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tagDestaque,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C6B6B),
            ),
          ),
        ),
      ],
    );
  }
}
