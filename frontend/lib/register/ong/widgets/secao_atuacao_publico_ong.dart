// lib/register/ong/widgets/secao_atuacao_publico_ong.dart

import 'package:flutter/material.dart';
import '../data/register_ong_catalog_data.dart';

class SecaoAtuacaoPublicoOng extends StatelessWidget {
  final String? causaSelecionada;
  final Set<String> servicosSelecionados;
  final Set<String> publicosSelecionados;
  final ValueChanged<String?> onCausaChanged;
  final Function(String, bool) onAlternarServico;
  final Function(String, bool) onAlternarPublico;

  const SecaoAtuacaoPublicoOng({
    super.key,
    required this.causaSelecionada,
    required this.servicosSelecionados,
    required this.publicosSelecionados,
    required this.onCausaChanged,
    required this.onAlternarServico,
    required this.onAlternarPublico,
  });

  @override
  Widget build(BuildContext context) {
    final servicosDisponiveis = causaSelecionada != null
        ? RegisterOngCatalogData.mapaOferecimentos[causaSelecionada] ?? []
        : <String>[];

    final publicosDisponiveis = causaSelecionada != null
        ? RegisterOngCatalogData.mapaPublico[causaSelecionada] ?? []
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "A Essência do Projeto",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 16),

        // Causa Principal
        _buildLabel("Causa Principal", obrigatorio: true),
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
                "Selecione a área de atuação principal",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              value: causaSelecionada,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF0C6B6B),
              ),
              items: RegisterOngCatalogData.causas.map((causa) {
                return DropdownMenuItem<String>(
                  value: causa,
                  child: Text(causa, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: onCausaChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Serviços Oferecidos
        _buildLabel(
          "O que a ONG oferece? (Atividades/Serviços)",
          obrigatorio: true,
        ),
        const SizedBox(height: 8),
        if (causaSelecionada == null)
          _buildAvisoVazio(
            "Selecione a Causa Principal acima para ver os serviços correspondentes.",
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: servicosDisponiveis.map((servico) {
              final selecionado = servicosSelecionados.contains(servico);
              return _buildChip(
                label: servico,
                selecionado: selecionado,
                onSelected: (val) => onAlternarServico(servico, val),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),

        // Público Atendido
        _buildLabel(
          "Público Atendido (Selecione um ou mais)",
          obrigatorio: true,
        ),
        const SizedBox(height: 8),
        if (causaSelecionada == null)
          _buildAvisoVazio(
            "Selecione a Causa Principal para ver os públicos correspondentes.",
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: publicosDisponiveis.map((publico) {
              final selecionado = publicosSelecionados.contains(publico);
              return _buildChip(
                label: publico,
                selecionado: selecionado,
                onSelected: (val) => onAlternarPublico(publico, val),
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
            ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selecionado,
    required ValueChanged<bool> onSelected,
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
      selectedColor: const Color(0xFF0C6B6B),
      checkmarkColor: Colors.white,
      backgroundColor: const Color(0xFFF0FAF7),
      side: BorderSide(
        color: selecionado ? const Color(0xFF0C6B6B) : const Color(0xFFC2E4DC),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: onSelected,
    );
  }

  Widget _buildAvisoVazio(String mensagem) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Center(
        child: Text(
          mensagem,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF3A6868),
            fontStyle: FontStyle.italic,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
