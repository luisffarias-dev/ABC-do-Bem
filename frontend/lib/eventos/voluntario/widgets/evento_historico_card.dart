// lib/eventos/voluntario/widgets/evento_historico_card.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoHistoricoCard extends StatelessWidget {
  final InscricaoEventoModel inscricao;

  const EventoHistoricoCard({super.key, required this.inscricao});

  @override
  Widget build(BuildContext context) {
    final ev = inscricao.evento;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              ev?.imagemUrl ??
                  "https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=600",
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev?.titulo ?? "Ação Social",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF062222),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${ev?.ongNome ?? 'Instituição'} • ${ev?.cidade ?? 'Grande ABC'}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  "Participado em: ${ev?.data ?? ''}",
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF7AAAA0)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFD1F5EE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "${inscricao.horasValidadas}h",
              style: const TextStyle(
                color: Color(0xFF0C6B6B),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
