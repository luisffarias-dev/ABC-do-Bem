// lib/register/voluntario/widgets/secao_habilidades_voluntario.dart

import 'package:flutter/material.dart';
import '../../../utils/app_data.dart';

class SecaoHabilidadesVoluntario extends StatelessWidget {
  final Set<String> habilidadesSelecionadas;
  final Function(String, bool) onAlternarHabilidade;

  const SecaoHabilidadesVoluntario({
    super.key,
    required this.habilidadesSelecionadas,
    required this.onAlternarHabilidade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Suas habilidades",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Selecione as suas competências e características para ONGs te encontrarem.",
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF3A6868),
          ),
        ),
        const SizedBox(height: 16),

        // Banner informativo com contador dinâmico
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F5F1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 20,
                color: Color(0xFF0C6B6B),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Selecione de ${AppData.minHabilidades} a ${AppData.maxHabilidades} características.\n"
                  "Competências: ${habilidadesSelecionadas.length} de ${AppData.maxHabilidades} selecionadas.",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF062222),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Lista de Categorias via ExpansionTile
        ...AppData.categoriasHabilidades.entries.map((entry) {
          final String categoria = entry.key;
          final List<String> itens = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC2E4DC)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              title: Text(
                categoria,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                  fontSize: 14,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              collapsedIconColor: const Color(0xFF0C6B6B),
              iconColor: const Color(0xFF0C6B6B),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: itens.map((habilidade) {
                      final bool selecionada =
                          habilidadesSelecionadas.contains(habilidade);

                      return FilterChip(
                        label: Text(
                          habilidade,
                          style: TextStyle(
                            fontSize: 11,
                            color: selecionada
                                ? Colors.white
                                : const Color(0xFF062222),
                            fontWeight: selecionada
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: selecionada,
                        selectedColor: const Color(0xFF0C6B6B),
                        checkmarkColor: Colors.white,
                        backgroundColor: const Color(0xFFF0FAF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: selecionada
                              ? const Color(0xFF0C6B6B)
                              : const Color(0xFFC2E4DC),
                        ),
                        onSelected: (val) =>
                            onAlternarHabilidade(habilidade, val),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
