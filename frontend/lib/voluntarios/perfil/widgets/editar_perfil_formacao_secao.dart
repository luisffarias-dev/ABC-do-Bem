// lib/voluntarios/perfil/widgets/editar_perfil_formacao_secao.dart

import 'package:flutter/material.dart';

class EditarPerfilFormacaoSecao extends StatelessWidget {
  final String escolaridadeSelecionada;
  final List<String> opcoesEscolaridade;
  final TextEditingController cursoController;
  final ValueChanged<String?> onEscolaridadeChanged;
  final bool isMobile;

  const EditarPerfilFormacaoSecao({
    super.key,
    required this.escolaridadeSelecionada,
    required this.opcoesEscolaridade,
    required this.cursoController,
    required this.onEscolaridadeChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Formação Acadêmica",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          _buildDropdown(),
          const SizedBox(height: 14),
          _buildCampoCurso(),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildDropdown()),
              const SizedBox(width: 14),
              Expanded(flex: 3, child: _buildCampoCurso()),
            ],
          ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Escolaridade",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FAF7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: escolaridadeSelecionada,
              isExpanded: true,
              items: opcoesEscolaridade.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: onEscolaridadeChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoCurso() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Curso / Formação",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: cursoController,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0FAF7),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      ],
    );
  }
}
