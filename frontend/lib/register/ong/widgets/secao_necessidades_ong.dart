// lib/register/ong/widgets/secao_necessidades_ong.dart

import 'package:flutter/material.dart';
import '../data/register_ong_catalog_data.dart';

class SecaoNecessidadesOng extends StatelessWidget {
  final String causaPrincipal;
  final String? formatoVoluntariado;
  final Set<String> habilidadesSelecionadas;
  final Set<String> doacoesSelecionadas;
  final ValueChanged<String?> onFormatoChanged;
  final Function(String, bool) onAlternarHabilidade;
  final Function(String, bool) onAlternarDoacao;

  const SecaoNecessidadesOng({
    super.key,
    required this.causaPrincipal,
    required this.formatoVoluntariado,
    required this.habilidadesSelecionadas,
    required this.doacoesSelecionadas,
    required this.onFormatoChanged,
    required this.onAlternarHabilidade,
    required this.onAlternarDoacao,
  });

  @override
  Widget build(BuildContext context) {
    final habilidades = RegisterOngCatalogData.obterHabilidades(causaPrincipal);
    final doacoes = RegisterOngCatalogData.obterDoacoes(causaPrincipal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "O que vocês estão buscando?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Com base na causa ($causaPrincipal), selecione as demandas da ONG.",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),

        // Habilidades
        _buildLabel("Habilidades Voluntárias Buscadas", obrigatorio: true),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: habilidades.map((hab) {
            final selecionado = habilidadesSelecionadas.contains(hab);
            return _buildChip(
              label: hab,
              selecionado: selecionado,
              onSelected: (val) => onAlternarHabilidade(hab, val),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Formato
        _buildLabel("Formato de Voluntariado Aceito", obrigatorio: true),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                "Selecione o formato",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              value: formatoVoluntariado,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0C6B6B)),
              items: RegisterOngCatalogData.opcoesFormato.map((formato) {
                return DropdownMenuItem<String>(
                  value: formato,
                  child: Text(formato, style: const TextStyle(fontSize: 12)),
                );
              }).toList(), // Linha corrigida: parênteses fechados sem o caractere '>'
              onChanged: onFormatoChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Doações
        _buildLabel("A ONG aceita doações de:", obrigatorio: false),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: doacoes.map((item) {
            final selecionado = doacoesSelecionadas.contains(item);
            return _buildChip(
              label: item,
              selecionado: selecionado,
              corDestaque: const Color(0xFFD46B08),
              onSelected: (val) => onAlternarDoacao(item, val),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, {required bool obrigatorio}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF062222),
        ),
        children: [
          if (obrigatorio)
            const TextSpan(
              text: " *",
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.bold,
              ),
            )
          else
            const TextSpan(
              text: " (opcional)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selecionado,
    required ValueChanged<bool> onSelected,
    Color corDestaque = const Color(0xFF0C6B6B),
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: selecionado ? Colors.white : Colors.black87,
          fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selecionado,
      selectedColor: corDestaque,
      checkmarkColor: Colors.white,
      backgroundColor: const Color(0xFFF0FAF7),
      side: BorderSide(
        color: selecionado ? corDestaque : const Color(0xFFC2E4DC),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: onSelected,
    );
  }
}
