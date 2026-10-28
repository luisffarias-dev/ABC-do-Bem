// lib/voluntarios/buscar/widgets/busca_hub_header_filter.dart

import 'package:flutter/material.dart';

class BuscaHubHeaderFilter extends StatelessWidget {
  final TextEditingController controller;
  final String abaAtiva;
  final ValueChanged<String> onAbaAlterada;
  final ValueChanged<String> onBuscaAlterada;
  final bool isMobile;

  const BuscaHubHeaderFilter({
    super.key,
    required this.controller,
    required this.abaAtiva,
    required this.onAbaAlterada,
    required this.onBuscaAlterada,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final abas = ["Tudo", "ONGs", "Eventos", "Voluntários"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Explorar o ABC Solidário",
          style: TextStyle(
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Encontre instituições, pessoas e ações em Santo André, São Bernardo, São Caetano e região.",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        SizedBox(height: isMobile ? 14 : 18),

        // Campo Universal de Busca
        TextField(
          controller: controller,
          onChanged: onBuscaAlterada,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: "Buscar por nome, causa, cidade ou habilidade...",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF0C6B6B),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        size: 18, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      onBuscaAlterada('');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Abas de Segmentação Rápida
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: abas.map((aba) {
              final bool selecionada = abaAtiva == aba;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(aba),
                  selected: selecionada,
                  selectedColor: const Color(0xFF0C6B6B),
                  labelStyle: TextStyle(
                    color: selecionada ? Colors.white : const Color(0xFF062222),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: selecionada
                        ? const Color(0xFF0C6B6B)
                        : const Color(0xFFC2E4DC),
                  ),
                  onSelected: (_) => onAbaAlterada(aba),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
