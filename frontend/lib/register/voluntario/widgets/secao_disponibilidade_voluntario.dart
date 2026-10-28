// lib/register/voluntario/widgets/secao_disponibilidade_voluntario.dart

import 'package:flutter/material.dart';

class SecaoDisponibilidadeVoluntario extends StatelessWidget {
  final Set<String> disponibilidadeSelecionada;
  final bool enviando;
  final Function(String, bool) onAlternarDisponibilidade;
  final bool isMobile;

  static const List<String> opcoesDisponibilidade = [
    "Manhã",
    "Tarde",
    "Noite",
    "Dia inteiro",
    "Voluntariado presencial",
    "Voluntariado remoto",
    "Voluntariado em eventos",
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sábado",
    "Domingo",
    "Disponibilidade para emergências",
  ];

  const SecaoDisponibilidadeVoluntario({
    super.key,
    required this.disponibilidadeSelecionada,
    required this.enviando,
    required this.onAlternarDisponibilidade,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: const TextSpan(
            text: "Disponibilidade e perfil",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Selecione as formas de atuação que melhor combinam com a sua rotina",
          style: TextStyle(fontSize: 13, color: Color(0xFF3A6868)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F5F1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: Color(0xFF0C6B6B)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Os campos marcados com asterisco (*) e os consentimentos legais são de seleção obrigatória.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0C6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFC2E4DC)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: opcoesDisponibilidade.map((opcao) {
              final bool selecionada =
                  disponibilidadeSelecionada.contains(opcao);
              return FilterChip(
                label: Text(
                  opcao,
                  style: TextStyle(
                    fontSize: 11,
                    color: selecionada ? Colors.white : const Color(0xFF062222),
                    fontWeight:
                        selecionada ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: selecionada,
                selectedColor: const Color(0xFF0C6B6B),
                checkmarkColor: Colors.white,
                backgroundColor: const Color(0xFFF0FAF7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                side: BorderSide(
                  color: selecionada
                      ? const Color(0xFF0C6B6B)
                      : const Color(0xFFC2E4DC),
                ),
                onSelected: enviando
                    ? null
                    : (val) => onAlternarDisponibilidade(opcao, val),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
