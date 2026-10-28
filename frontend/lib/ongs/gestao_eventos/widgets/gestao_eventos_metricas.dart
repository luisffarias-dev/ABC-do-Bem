// lib/ongs/gestao_eventos/widgets/gestao_eventos_metricas.dart

import 'package:flutter/material.dart';

class GestaoEventosMetricas extends StatelessWidget {
  final int totalRealizados;
  final int totalProximos;
  final int totalVoluntarios;
  final double taxaAssiduidade; // Valor em porcentagem (ex: 94.0)

  const GestaoEventosMetricas({
    super.key,
    required this.totalRealizados,
    required this.totalProximos,
    required this.totalVoluntarios,
    required this.taxaAssiduidade,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth < 600
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _cardMetrica(
              largura: cardWidth,
              titulo: "Realizados",
              valor: "$totalRealizados",
              icone: Icons.task_alt_rounded,
              corIcone: const Color(0xFF0C6B6B),
              corFundo: const Color(0xFFE3F5F1),
            ),
            _cardMetrica(
              largura: cardWidth,
              titulo: "Próximos",
              valor: "$totalProximos",
              icone: Icons.event_available_rounded,
              corIcone: const Color(0xFF1890FF),
              corFundo: const Color(0xFFE6F7FF),
            ),
            _cardMetrica(
              largura: cardWidth,
              titulo: "Voluntários",
              valor: "$totalVoluntarios",
              icone: Icons.people_alt_rounded,
              corIcone: const Color(0xFF52C41A),
              corFundo: const Color(0xFFF6FFED),
            ),
            _cardMetrica(
              largura: cardWidth,
              titulo: "Assiduidade",
              valor: "${taxaAssiduidade.toStringAsFixed(0)}%",
              icone: Icons.pie_chart_rounded,
              corIcone: const Color(0xFFFA8C16),
              corFundo: const Color(0xFFFFF7E6),
            ),
          ],
        );
      },
    );
  }

  Widget _cardMetrica({
    required double largura,
    required String titulo,
    required String valor,
    required IconData icone,
    required Color corIcone,
    required Color corFundo,
  }) {
    return Container(
      width: largura,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: corFundo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, size: 20, color: corIcone),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  valor,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
