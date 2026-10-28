// lib/ongs/criar_evento/widgets/secao_chips_appdata.dart

import 'package:flutter/material.dart';
import '../../../utils/app_data.dart';
import '../../../services/nlp/ia_sugestao_causa_service.dart';

class SecaoChipsAppData extends StatefulWidget {
  final List<String> categorias;
  final Set<String> requisitos;
  final Set<String> necessidades;

  const SecaoChipsAppData({
    super.key,
    required this.categorias,
    required this.requisitos,
    required this.necessidades,
  });

  @override
  State<SecaoChipsAppData> createState() => _SecaoChipsAppDataState();
}

class _SecaoChipsAppDataState extends State<SecaoChipsAppData> {
  // Catálogo completo sem duplicatas e sem emojis de toda a plataforma
  late final List<String> _todasHabilidadesPlataforma;
  late final List<String> _todasDoacoesPlataforma;

  @override
  void initState() {
    super.initState();
    _todasHabilidadesPlataforma = AppData.habilidadesPorCausa.values
        .expand((list) => list)
        .map(IaSugestaoCausaService.removerEmojis)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    _todasDoacoesPlataforma = AppData.doacoesPorCausa.values
        .expand((list) => list)
        .map(IaSugestaoCausaService.removerEmojis)
        .where((d) => d.toLowerCase() != "outros")
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  String _obterChaveOriginalAppData(String categoriaLimpa) {
    return AppData.habilidadesPorCausa.keys.firstWhere(
      (k) =>
          IaSugestaoCausaService.limparParaComparacao(k) ==
          IaSugestaoCausaService.limparParaComparacao(categoriaLimpa),
      orElse: () => AppData.habilidadesPorCausa.keys.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Habilidades sugeridas pelas causas selecionadas
    final Set<String> habsSugeridas = {};
    final Set<String> doacoesSugeridas = {};

    for (final cat in widget.categorias) {
      final chave = _obterChaveOriginalAppData(cat);
      habsSugeridas.addAll(
        (AppData.habilidadesPorCausa[chave] ?? [])
            .map(IaSugestaoCausaService.removerEmojis),
      );
      doacoesSugeridas.addAll(
        (AppData.doacoesPorCausa[chave] ?? [])
            .map(IaSugestaoCausaService.removerEmojis),
      );
    }

    // 2. Garante que itens escolhidos fora da causa continuem visíveis como chips selecionados
    final habsExibicao = {...habsSugeridas, ...widget.requisitos}.toList();
    final doacoesExibicao =
        {...doacoesSugeridas, ...widget.necessidades}.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- 4. HABILIDADES DEMANDADAS ---
        _buildCard(
          titulo: "4. Habilidades Demandadas",
          icone: Icons.psychology_rounded,
          children: [
            if (habsExibicao.isEmpty)
              const Text(
                "Nenhuma habilidade associada.",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: habsExibicao.map((hab) {
                  final selecionada = widget.requisitos.contains(hab);

                  return FilterChip(
                    label: Text(
                      hab,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selecionada ? FontWeight.bold : FontWeight.normal,
                        color: selecionada ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: selecionada,
                    selectedColor: const Color(0xFF0C6B6B),
                    checkmarkColor: Colors.white,
                    backgroundColor: const Color(0xFFF0FAF7),
                    side: BorderSide(
                      color: selecionada
                          ? const Color(0xFF0C6B6B)
                          : const Color(0xFFC2E4DC),
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          widget.requisitos.add(hab);
                        } else {
                          widget.requisitos.remove(hab);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Autocomplete de Outras Habilidades da Plataforma
            _buildAutocompleteCampo(
              hint: "Buscar outra habilidade...",
              listaOpcoes: _todasHabilidadesPlataforma,
              itensJaSelecionados: widget.requisitos,
              icone: Icons.search_rounded,
              onSelecionado: (novaHab) {
                setState(() => widget.requisitos.add(novaHab));
              },
            ),
          ],
        ),
        const SizedBox(height: 14),

        // --- 5. NECESSIDADES E DOAÇÕES ---
        _buildCard(
          titulo: "5. Necessidades e Doações",
          icone: Icons.volunteer_activism_rounded,
          children: [
            if (doacoesExibicao.isEmpty)
              const Text(
                "Nenhum item encontrado.",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: doacoesExibicao.map((item) {
                  final selecionada = widget.necessidades.contains(item);

                  return FilterChip(
                    label: Text(
                      item,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selecionada ? FontWeight.bold : FontWeight.normal,
                        color: selecionada ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: selecionada,
                    selectedColor: const Color(0xFFD46B08),
                    checkmarkColor: Colors.white,
                    backgroundColor: const Color(0xFFFFF7E6),
                    side: BorderSide(
                      color: selecionada
                          ? const Color(0xFFD46B08)
                          : const Color(0xFFFFD591),
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          widget.necessidades.add(item);
                        } else {
                          widget.necessidades.remove(item);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Autocomplete de Outros Itens/Doações da Plataforma
            _buildAutocompleteCampo(
              hint: "Buscar...",
              listaOpcoes: _todasDoacoesPlataforma,
              itensJaSelecionados: widget.necessidades,
              icone: Icons.add_shopping_cart_rounded,
              onSelecionado: (novoItem) {
                setState(() => widget.necessidades.add(novoItem));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAutocompleteCampo({
    required String hint,
    required List<String> listaOpcoes,
    required Set<String> itensJaSelecionados,
    required IconData icone,
    required ValueChanged<String> onSelecionado,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim();
            if (query.length < 2) {
              return const Iterable<String>.empty();
            }

            final queryNorm =
                IaSugestaoCausaService.limparParaComparacao(query);

            return listaOpcoes.where((opcao) {
              final opcaoNorm =
                  IaSugestaoCausaService.limparParaComparacao(opcao);
              return opcaoNorm.contains(queryNorm) &&
                  !itensJaSelecionados.contains(opcao);
            });
          },
          onSelected: onSelecionado,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                prefixIcon:
                    Icon(icone, size: 16, color: const Color(0xFF0C6B6B)),
                isDense: true,
                filled: true,
                fillColor: const Color(0xFFF3F7F7),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 180,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF062222),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 16,
                          color: Color(0xFF0C6B6B),
                        ),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard({
    required String titulo,
    required IconData icone,
    required List<Widget> children,
  }) {
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
          Row(
            children: [
              Icon(icone, size: 18, color: const Color(0xFF0C6B6B)),
              const SizedBox(width: 6),
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF062222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
