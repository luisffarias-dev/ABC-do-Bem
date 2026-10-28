// lib/notificacoes/widgets/notificacao_estado_vazio.dart

import 'package:flutter/material.dart';

class NotificacaoEstadoVazio extends StatelessWidget {
  final bool isOng;
  final bool isTabNovas;

  const NotificacaoEstadoVazio({
    super.key,
    required this.isOng,
    required this.isTabNovas,
  });

  @override
  Widget build(BuildContext context) {
    final titulo = isTabNovas
        ? (isOng
            ? "Não há novos avisos para a instituição"
            : "Você não tem notificações novas")
        : "Nenhuma notificação lida por enquanto";

    final subtitulo = isOng
        ? "Novas candidaturas de voluntários e confirmações aparecerão aqui."
        : "Novidades sobre eventos e ações da comunidade aparecerão aqui.";

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        children: [
          const Text("🔔", style: TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
