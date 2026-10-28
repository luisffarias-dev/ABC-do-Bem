// lib/ongs/home/widgets/ong_necessidades_section.dart

import 'package:flutter/material.dart';

class OngNecessidadesSection extends StatelessWidget {
  final List<String> necessidades;
  final VoidCallback onEditar;

  const OngNecessidadesSection({
    super.key,
    required this.necessidades,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Doações e Necessidades no Perfil",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
              ),
              TextButton.icon(
                onPressed: onEditar,
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 14,
                  color: Color(0xFF0C6B6B),
                ),
                label: const Text(
                  "Editar",
                  style: TextStyle(
                    color: Color(0xFF0C6B6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Itens visíveis publicamente na página da sua instituição para os voluntários:",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: necessidades
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD591)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 13,
                            color: Color(0xFFD46B08),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD46B08),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
