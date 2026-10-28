// lib/ongs/gestao_eventos/dialogs/cancelar_evento_dialog.dart

import 'package:flutter/material.dart';
import '../../../eventos/models/evento_model.dart';

class CancelarEventoDialog extends StatefulWidget {
  final EventoModel evento;
  final Future<void> Function(String motivo) onConfirmar;

  const CancelarEventoDialog({
    super.key,
    required this.evento,
    required this.onConfirmar,
  });

  static Future<bool?> exibir(
    BuildContext context, {
    required EventoModel evento,
    required Future<void> Function(String motivo) onConfirmar,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CancelarEventoDialog(
        evento: evento,
        onConfirmar: onConfirmar,
      ),
    );
  }

  @override
  State<CancelarEventoDialog> createState() => _CancelarEventoDialogState();
}

class _CancelarEventoDialogState extends State<CancelarEventoDialog> {
  final _motivoDetalhadoController = TextEditingController();
  bool _enviando = false;

  final List<String> _motivosPreDefinidos = [
    "Condições climáticas adversas",
    "Falta de quórum mínimo",
    "Imprevisto com o local/espaço",
    "Ação adiada para nova data",
    "Outros",
  ];

  late String _motivoSelecionado;

  @override
  void initState() {
    super.initState();
    _motivoSelecionado = _motivosPreDefinidos.first;
  }

  @override
  void dispose() {
    _motivoDetalhadoController.dispose();
    super.dispose();
  }

  String get _motivoFinal {
    if (_motivoSelecionado == "Outros") {
      final detalhe = _motivoDetalhadoController.text.trim();
      return detalhe.isNotEmpty ? "Outros: $detalhe" : "Outros";
    }
    return _motivoSelecionado;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutros = _motivoSelecionado == "Outros";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
          SizedBox(width: 8),
          Text(
            "Cancelar Ação",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF062222),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tem certeza que deseja cancelar '${widget.evento.titulo}'?",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              const Text(
                "Os voluntários inscritos serão notificados com o motivo selecionado abaixo:",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 14),
              const Text(
                "Selecione o motivo:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Chips de motivos pré-definidos
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _motivosPreDefinidos.map((motivo) {
                  final sel = _motivoSelecionado == motivo;
                  return ChoiceChip(
                    label: Text(
                      motivo,
                      style: TextStyle(
                        fontSize: 11,
                        color: sel ? Colors.white : Colors.black87,
                        fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: sel,
                    selectedColor: Colors.redAccent,
                    backgroundColor: const Color(0xFFF0F4F4),
                    side: BorderSide(
                      color: sel ? Colors.redAccent : const Color(0xFFC2E4DC),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _motivoSelecionado = motivo);
                    },
                  );
                }).toList(),
              ),

              // Campo de texto exibido apenas se "Outros" estiver marcado
              if (isOutros) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _motivoDetalhadoController,
                  maxLines: 2,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Descreva o motivo do cancelamento...",
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _enviando ? null : () => Navigator.pop(context, false),
          child: const Text("Voltar", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _enviando
              ? null
              : () async {
                  setState(() => _enviando = true);
                  await widget.onConfirmar(_motivoFinal);
                  if (mounted) Navigator.pop(context, true);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _enviando
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text("Confirmar Cancelamento",
                  style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
