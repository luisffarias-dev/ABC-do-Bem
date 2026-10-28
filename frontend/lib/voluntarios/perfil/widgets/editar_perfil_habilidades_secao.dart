// lib/voluntarios/perfil/widgets/editar_perfil_habilidades_secao.dart

import 'package:flutter/material.dart';
import '../../../utils/app_data.dart';

class EditarPerfilHabilidadesSecao extends StatelessWidget {
  final List<String> habilidades;
  final VoidCallback onEditar;

  const EditarPerfilHabilidadesSecao({
    super.key,
    required this.habilidades,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Minhas Habilidades",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
                Text(
                  "${habilidades.length}/${AppData.maxHabilidades} selecionadas (mín. ${AppData.minHabilidades})",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
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
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FAF7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: habilidades.isEmpty
              ? const Text(
                  "Nenhuma habilidade adicionada ainda.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: habilidades.map((hab) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF9FE8D8)),
                      ),
                      child: Text(
                        hab,
                        style: const TextStyle(
                          color: Color(0xFF0C6B6B),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
