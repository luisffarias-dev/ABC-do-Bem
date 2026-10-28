// lib/voluntarios/perfil/widgets/perfil_metricas_cards.dart

import 'package:flutter/material.dart';

class PerfilMetricasCards extends StatelessWidget {
  final int totalEventos;
  final int totalHoras;
  final String tempoAtivo;

  const PerfilMetricasCards({
    super.key,
    required this.totalEventos,
    required this.totalHoras,
    required this.tempoAtivo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMetricaItem("$totalEventos", "Eventos"),
        const SizedBox(width: 10),
        _buildMetricaItem("${totalHoras}h", "Horas"),
        const SizedBox(width: 10),
        _buildMetricaItem(tempoAtivo, "Ativo"),
      ],
    );
  }

  Widget _buildMetricaItem(String valor, String rotulo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rotulo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7AAAA0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
