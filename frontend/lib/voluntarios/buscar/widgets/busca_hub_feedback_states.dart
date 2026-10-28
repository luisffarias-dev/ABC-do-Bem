// lib/voluntarios/buscar/widgets/busca_hub_feedback_states.dart

import 'package:flutter/material.dart';

class BuscaHubEmptyState extends StatelessWidget {
  final VoidCallback onLimpar;

  const BuscaHubEmptyState({super.key, required this.onLimpar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded,
              size: 40, color: Color(0xFF7AAAA0)),
          const SizedBox(height: 10),
          const Text(
            "Nenhum resultado localizado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tente pesquisar com termos mais gerais ou selecione a aba 'Tudo'.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onLimpar,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0C6B6B)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Limpar filtros",
              style: TextStyle(
                color: Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuscaHubErrorState extends StatelessWidget {
  final VoidCallback onTentarNovamente;

  const BuscaHubErrorState({super.key, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded,
              color: Colors.redAccent, size: 38),
          const SizedBox(height: 10),
          const Text(
            "Falha ao carregar a busca",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Verifique sua conexão e tente novamente.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onTentarNovamente,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C6B6B)),
            child: const Text("Tentar novamente",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
