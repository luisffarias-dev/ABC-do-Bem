// lib/notificacoes/widgets/notificacao_estado_erro.dart

import 'package:flutter/material.dart';

class NotificacaoEstadoErro extends StatelessWidget {
  final bool isOng;
  final VoidCallback onTentarNovamente;

  const NotificacaoEstadoErro({
    super.key,
    required this.isOng,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Colors.redAccent,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Falha ao carregar notificações",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            isOng
                ? "Não foi possível sincronizar os avisos da instituição com o servidor."
                : "Não foi possível sincronizar suas mensagens com o servidor. Verifique sua conexão.",
            style:
                const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onTentarNovamente,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 18,
              color: Colors.white,
            ),
            label: const Text(
              "Tentar novamente",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
