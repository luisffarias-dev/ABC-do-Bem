// lib/ongs/criar_evento/widgets/secao_dados_basicos.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/nlp/ia_sugestao_causa_service.dart';
import 'sugestao_causa_chips.dart';
import '../../../utils/app_data.dart';

class SecaoDadosBasicos extends StatefulWidget {
  final TextEditingController nomeCtrl;
  final TextEditingController descCtrl;
  final List<String> categoriasSelecionadas;
  final String formato;
  final ValueChanged<List<String>> onCategoriasChanged;
  final ValueChanged<String> onFormatoChanged;

  const SecaoDadosBasicos({
    super.key,
    required this.nomeCtrl,
    required this.descCtrl,
    required this.categoriasSelecionadas,
    required this.formato,
    required this.onCategoriasChanged,
    required this.onFormatoChanged,
  });

  @override
  State<SecaoDadosBasicos> createState() => _SecaoDadosBasicosState();
}

class _SecaoDadosBasicosState extends State<SecaoDadosBasicos> {
  Timer? _debounceTimer;
  List<String> _sugestoesIa = [];
  bool _usuarioAlterouManualmente = false;

  @override
  void initState() {
    super.initState();
    if (widget.nomeCtrl.text.trim().isNotEmpty) {
      _sugestoesIa = IaSugestaoCausaService.inferirCausas(widget.nomeCtrl.text);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _aoDigitarTitulo(String texto) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      final inferencias = IaSugestaoCausaService.inferirCausas(texto);
      if (mounted) {
        setState(() => _sugestoesIa = inferencias);
      }

      // Sugere e seleciona automaticamente as até 2 causas mais pontuadas
      if (!_usuarioAlterouManualmente && inferencias.isNotEmpty) {
        final novas = inferencias.take(2).toList();
        widget.onCategoriasChanged(novas);
      }
    });
  }

  void _alternarCausa(String causa) {
    setState(() => _usuarioAlterouManualmente = true);
    final listaAtual = List<String>.from(widget.categoriasSelecionadas);

    if (listaAtual.contains(causa)) {
      // Regra de segurança: impede desselecionar se for a única restante
      if (listaAtual.length > 1) {
        listaAtual.remove(causa);
        widget.onCategoriasChanged(listaAtual);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("O evento precisa de pelo menos 1 causa selecionada."),
            backgroundColor: Color(0xFFD46B08),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Limite rígido de no máximo 2 causas
      if (listaAtual.length < 2) {
        listaAtual.add(causa);
        widget.onCategoriasChanged(listaAtual);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Você pode selecionar no máximo 2 causas por evento."),
            backgroundColor: Color(0xFF0C6B6B),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todasCausas = IaSugestaoCausaService.obterCausasLimpos();
    final qtd = widget.categoriasSelecionadas.length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFF0C6B6B)),
              SizedBox(width: 6),
              Text(
                "1. Informações Básicas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Título
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nome do Evento",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: widget.nomeCtrl,
                onChanged: _aoDigitarTitulo,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Campo obrigatório"
                    : null,
                decoration: InputDecoration(
                  hintText: "Ex: Sopão Solidário e Distribuição de Agasalhos",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                  ),
                ),
              ),
            ],
          ),

          // Sugestões IA
          SugestaoCausaChips(
            sugestoes: _sugestoesIa,
            categoriaAtual: widget.categoriasSelecionadas.isNotEmpty
                ? widget.categoriasSelecionadas.first
                : '',
            onSelecionarCausa: _alternarCausa,
          ),
          const SizedBox(height: 12),

          // Seletor Livre de Chips de Causas (Mín 1, Máx 2)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Causas Oficiais do Evento",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$qtd de 2 selecionadas",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: qtd == 2 ? const Color(0xFF0C6B6B) : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: todasCausas.map((causa) {
                  final selecionada =
                      widget.categoriasSelecionadas.contains(causa);
                  final atingiuLimite = !selecionada && qtd >= 2;

                  return FilterChip(
                    label: Text(
                      causa,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selecionada ? FontWeight.bold : FontWeight.normal,
                        color: selecionada
                            ? Colors.white
                            : (atingiuLimite
                                ? Colors.grey.shade400
                                : Colors.black87),
                      ),
                    ),
                    selected: selecionada,
                    selectedColor: const Color(0xFF0C6B6B),
                    checkmarkColor: Colors.white,
                    backgroundColor: const Color(0xFFF0FAF7),
                    side: BorderSide(
                      color: selecionada
                          ? const Color(0xFF0C6B6B)
                          : (atingiuLimite
                              ? Colors.grey.shade200
                              : const Color(0xFFC2E4DC)),
                    ),
                    onSelected:
                        atingiuLimite ? null : (_) => _alternarCausa(causa),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Formato da Ação
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Formato da Ação",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: widget.formato,
                    items: AppData.formatosVoluntariado.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(f, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) widget.onFormatoChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Descrição
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Descrição da Ação",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: widget.descCtrl,
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Campo obrigatório"
                    : null,
                decoration: InputDecoration(
                  hintText:
                      "Descreva as metas, rotinas e orientações aos voluntários...",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
