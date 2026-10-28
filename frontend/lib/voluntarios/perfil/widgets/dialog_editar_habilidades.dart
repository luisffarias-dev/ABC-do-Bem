// lib/voluntarios/perfil/widgets/dialog_editar_habilidades.dart

import 'package:flutter/material.dart';
import '../../../utils/app_data.dart';

class DialogEditarHabilidades extends StatefulWidget {
  final List<String> habilidadesIniciais;
  final ValueChanged<List<String>> onConfirmar;

  const DialogEditarHabilidades({
    super.key,
    required this.habilidadesIniciais,
    required this.onConfirmar,
  });

  static void exibir(
    BuildContext context, {
    required List<String> habilidadesIniciais,
    required ValueChanged<List<String>> onConfirmar,
  }) {
    showDialog(
      context: context,
      builder: (_) => DialogEditarHabilidades(
        habilidadesIniciais: habilidadesIniciais,
        onConfirmar: onConfirmar,
      ),
    );
  }

  @override
  State<DialogEditarHabilidades> createState() =>
      _DialogEditarHabilidadesState();
}

class _DialogEditarHabilidadesState extends State<DialogEditarHabilidades> {
  late final Set<String> _tempHabilidades;

  @override
  void initState() {
    super.initState();
    _tempHabilidades = Set.from(widget.habilidadesIniciais);
  }

  @override
  Widget build(BuildContext context) {
    final int total = _tempHabilidades.length;
    final bool valido =
        total >= AppData.minHabilidades && total <= AppData.maxHabilidades;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Minhas Habilidades",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
              fontSize: 18,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: valido ? const Color(0xFFD1F5EE) : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: valido ? const Color(0xFF0C6B6B) : Colors.redAccent,
              ),
            ),
            child: Text(
              "$total/${AppData.maxHabilidades}",
              style: TextStyle(
                color: valido ? const Color(0xFF0C6B6B) : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selecione de ${AppData.minHabilidades} a ${AppData.maxHabilidades} competências navegando pelas categorias:",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (_tempHabilidades.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selecionadas no momento:",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C6B6B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _tempHabilidades.map((hab) {
                        return Chip(
                          label: Text(hab),
                          labelStyle: const TextStyle(
                            color: Color(0xFF0C6B6B),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          backgroundColor: Colors.white,
                          deleteIcon: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Color(0xFF0C6B6B),
                          ),
                          onDeleted: () {
                            setState(() => _tempHabilidades.remove(hab));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF9FE8D8)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AppData.categoriasHabilidades.entries.map((entry) {
                    final String categoria = entry.key;
                    final List<String> itens = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoria,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF062222),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: itens.map((hab) {
                              final selecionada =
                                  _tempHabilidades.contains(hab);
                              return FilterChip(
                                label: Text(hab),
                                selected: selecionada,
                                selectedColor: const Color(0xFFD1F5EE),
                                checkmarkColor: const Color(0xFF0C6B6B),
                                labelStyle: TextStyle(
                                  color: selecionada
                                      ? const Color(0xFF0C6B6B)
                                      : const Color(0xFF062222),
                                  fontWeight: selecionada
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 11,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: selecionada
                                        ? const Color(0xFF0C6B6B)
                                        : const Color(0xFFC2E4DC),
                                  ),
                                ),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      if (_tempHabilidades.length <
                                          AppData.maxHabilidades) {
                                        _tempHabilidades.add(hab);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Limite de ${AppData.maxHabilidades} habilidades atingido.",
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } else {
                                      _tempHabilidades.remove(hab);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (total < AppData.minHabilidades)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Selecione no mínimo ${AppData.minHabilidades} habilidades.",
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: valido
              ? () {
                  widget.onConfirmar(_tempHabilidades.toList());
                  Navigator.pop(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0C6B6B),
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Confirmar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
