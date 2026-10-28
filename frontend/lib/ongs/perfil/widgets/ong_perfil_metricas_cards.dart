// lib/ongs/perfil/widgets/ong_perfil_metricas_cards.dart

import 'package:flutter/material.dart';

class OngPerfilMetricasCards extends StatelessWidget {
  final int voluntariosAtivos;
  final int eventosRealizados;
  final int anosAtuacao;

  const OngPerfilMetricasCards({
    super.key,
    required this.voluntariosAtivos,
    required this.eventosRealizados,
    required this.anosAtuacao,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMetricaItem("$voluntariosAtivos", "Voluntários"),
        const SizedBox(width: 10),
        _buildMetricaItem("$eventosRealizados", "Ações e Eventos"),
        const SizedBox(width: 10),
        _buildMetricaItem("$anosAtuacao anos", "No Grande ABC"),
      ],
    );
  }

  Widget _buildMetricaItem(String valor, String rotulo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rotulo,
              style: const TextStyle(fontSize: 11, color: Color(0xFF7AAAA0)),
            ),
          ],
        ),
      ),
    );
  }
}
