// lib/ongs/criar_evento/widgets/sugestao_causa_chips.dart

import 'package:flutter/material.dart';
import '../../../services/nlp/ia_sugestao_causa_service.dart';

class SugestaoCausaChips extends StatelessWidget {
  final List<String> sugestoes;
  final String categoriaAtual;
  final ValueChanged<String> onSelecionarCausa;

  const SugestaoCausaChips({
    super.key,
    required this.sugestoes,
    required this.categoriaAtual,
    required this.onSelecionarCausa,
  });

  @override
  Widget build(BuildContext context) {
    if (sugestoes.isEmpty) return const SizedBox.shrink();

    final categoriaAtualComparacao =
        IaSugestaoCausaService.limparParaComparacao(categoriaAtual);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF7F4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: Color(0xFF0C6B6B),
              ),
              SizedBox(width: 6),
              Text(
                "Sugestão da IA com base no título:",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C6B6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: sugestoes.take(2).map((sugestao) {
              final sugestaoLimpa =
                  IaSugestaoCausaService.removerEmojis(sugestao);
              final isAtiva =
                  IaSugestaoCausaService.limparParaComparacao(sugestao) ==
                      categoriaAtualComparacao;

              return ActionChip(
                avatar: Icon(
                  isAtiva
                      ? Icons.check_circle_rounded
                      : Icons.lightbulb_outline_rounded,
                  size: 14,
                  color: isAtiva ? Colors.white : const Color(0xFF0C6B6B),
                ),
                label: Text(
                  sugestaoLimpa,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isAtiva ? FontWeight.bold : FontWeight.w500,
                    color: isAtiva ? Colors.white : const Color(0xFF062222),
                  ),
                ),
                backgroundColor:
                    isAtiva ? const Color(0xFF0C6B6B) : Colors.white,
                side: BorderSide(
                  color: isAtiva
                      ? const Color(0xFF0C6B6B)
                      : const Color(0xFFC2E4DC),
                ),
                onPressed: () => onSelecionarCausa(sugestaoLimpa),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
