// lib/voluntarios/perfil/widgets/perfil_redes_sociais_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'perfil_info_card.dart';

class PerfilRedesSociaisCard extends StatelessWidget {
  final String? instagram;
  final String? facebook;
  final String? linkedin;
  final String? whatsapp;

  const PerfilRedesSociaisCard({
    super.key,
    this.instagram,
    this.facebook,
    this.linkedin,
    this.whatsapp,
  });

  bool get _temAlgumaRede {
    return (instagram != null && instagram!.trim().isNotEmpty) ||
        (facebook != null && facebook!.trim().isNotEmpty) ||
        (linkedin != null && linkedin!.trim().isNotEmpty) ||
        (whatsapp != null && whatsapp!.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (!_temAlgumaRede) {
      return const SizedBox
          .shrink(); // Ou exibe um PerfilInfoCard com aviso amigável
    }

    return PerfilInfoCard(
      titulo: "Redes Sociais e Contato",
      conteudo: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          if (instagram != null && instagram!.trim().isNotEmpty)
            _buildRedeButton(FontAwesomeIcons.instagram, instagram!.trim()),
          if (facebook != null && facebook!.trim().isNotEmpty)
            _buildRedeButton(FontAwesomeIcons.facebook, facebook!.trim()),
          if (linkedin != null && linkedin!.trim().isNotEmpty)
            _buildRedeButton(FontAwesomeIcons.linkedin, linkedin!.trim()),
          if (whatsapp != null && whatsapp!.trim().isNotEmpty)
            _buildRedeButton(FontAwesomeIcons.whatsapp, whatsapp!.trim()),
        ],
      ),
    );
  }

  Widget _buildRedeButton(IconData icon, String link) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: const Color(0xFF0C6B6B)),
          const SizedBox(width: 6),
          Text(
            link,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
