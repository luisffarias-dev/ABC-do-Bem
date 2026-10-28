// lib/ongs/home/widgets/ong_gestao_rapida_grid.dart

import 'package:flutter/material.dart';

class OngGestaoRapidaGrid extends StatelessWidget {
  final int totalCandidaturas;
  final VoidCallback onNovoEvento;
  final VoidCallback onEditarNecessidades;
  final VoidCallback onAbrirCandidatos;
  final VoidCallback onAbrirMensagens;
  final bool isMobile;

  const OngGestaoRapidaGrid({
    super.key,
    required this.totalCandidaturas,
    required this.onNovoEvento,
    required this.onEditarNecessidades,
    required this.onAbrirCandidatos,
    required this.onAbrirMensagens,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final botoes = [
      {
        "titulo": "Novo Evento",
        "sub": "Abrir vagas",
        "icon": Icons.add_circle_outline_rounded,
        "cor": const Color(0xFF0C6B6B),
        "bg": const Color(0xFFE3F5F1),
        "onTap": onNovoEvento,
      },
      {
        "titulo": "Necessidades",
        "sub": "Editar doações",
        "icon": Icons.volunteer_activism_rounded,
        "cor": const Color(0xFFD46B08),
        "bg": const Color(0xFFFFF7E6),
        "onTap": onEditarNecessidades,
      },
      {
        "titulo": "Candidatos",
        "sub": "$totalCandidaturas pendentes",
        "icon": Icons.how_to_reg_rounded,
        "cor": const Color(0xFF1A528F),
        "bg": const Color(0xFFE3EDF5),
        "onTap": onAbrirCandidatos,
      },
      {
        "titulo": "Mensagens",
        "sub": "Conversar",
        "icon": Icons.chat_rounded,
        "cor": const Color(0xFF8F1A73),
        "bg": const Color(0xFFF5E3F0),
        "onTap": onAbrirMensagens,
      },
    ];

    return isMobile
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
            ),
            itemCount: botoes.length,
            itemBuilder: (context, i) => _buildCard(botoes[i]),
          )
        : Row(
            children: botoes
                .map((b) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _buildCard(b),
                      ),
                    ))
                .toList(),
          );
  }

  Widget _buildCard(Map<String, dynamic> b) {
    return InkWell(
      onTap: b["onTap"] as VoidCallback,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: b["bg"] as Color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: (b["cor"] as Color).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(b["icon"] as IconData, color: b["cor"] as Color, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b["titulo"] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: b["cor"] as Color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    b["sub"] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                    overflow: TextOverflow.ellipsis,
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
