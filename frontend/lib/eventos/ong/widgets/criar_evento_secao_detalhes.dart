// lib/eventos/ong/widgets/criar_evento_secao_detalhes.dart

import 'package:flutter/material.dart';
import '../../../../utils/app_validators.dart';

class CriarEventoSecaoDetalhes extends StatelessWidget {
  final TextEditingController descricaoCtrl;
  final TextEditingController tagInputCtrl;
  final TextEditingController necessidadeInputCtrl;
  final List<String> tagsSelecionadas;
  final List<String> necessidades;
  final VoidCallback onAddTag;
  final ValueChanged<String> onRemoveTag;
  final VoidCallback onAddNecessidade;
  final ValueChanged<String> onRemoveNecessidade;

  const CriarEventoSecaoDetalhes({
    super.key,
    required this.descricaoCtrl,
    required this.tagInputCtrl,
    required this.necessidadeInputCtrl,
    required this.tagsSelecionadas,
    required this.necessidades,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.onAddNecessidade,
    required this.onRemoveNecessidade,
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
          const Text(
            "Descrição e Demandas da Ação",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: descricaoCtrl,
            maxLines: 4,
            decoration: _inputDecoration(
              label: "Descrição Completa",
              hint:
                  "Explique o objetivo da ação, cronograma do dia e orientações.",
              icon: Icons.description_rounded,
            ),
            validator: (v) {
              final obrigatorio = AppValidators.validarObrigatorio(v,
                  mensagem: "Informe a descrição da ação.");
              if (obrigatorio != null) return obrigatorio;
              if (v!.trim().length < 20)
                return "A descrição deve conter pelo menos 20 caracteres.";
              return null;
            },
          ),
          const SizedBox(height: 18),
          const Text(
            "Tags e Palavras-chave",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: tagInputCtrl,
                  decoration: _inputDecoration(
                    label: "Adicionar Tag",
                    hint: "Ex: Pintura, Reforço, Alimentos",
                    icon: Icons.tag_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: onAddTag,
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0C6B6B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tagsSelecionadas.map((tag) {
              return Chip(
                label: Text(tag,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF0C6B6B))),
                backgroundColor: const Color(0xFFE3F5F1),
                side: const BorderSide(color: Color(0xFFC2E4DC)),
                deleteIconColor: const Color(0xFF0C6B6B),
                onDeleted: () => onRemoveTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Text(
            "O Que a Ação Precisa (Materiais / Suprimentos)",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: necessidadeInputCtrl,
                  decoration: _inputDecoration(
                    label: "Adicionar Necessidade",
                    hint: "Ex: Luvas de proteção, pincéis",
                    icon: Icons.checklist_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: onAddNecessidade,
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0C6B6B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: necessidades.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 16, color: Color(0xFF0C6B6B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF062222))),
                    ),
                    InkWell(
                      onTap: () => onRemoveNecessidade(item),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0C6B6B), size: 20),
      filled: true,
      fillColor: const Color(0xFFF0FAF7),
      labelStyle: const TextStyle(color: Color(0xFF3A6868), fontSize: 13),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
      ),
    );
  }
}
