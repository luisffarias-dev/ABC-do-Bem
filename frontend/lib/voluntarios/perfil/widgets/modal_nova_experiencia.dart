
// lib/voluntarios/perfil/widgets/modal_nova_experiencia.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalNovaExperiencia {
  static void abrir({
    required BuildContext context,
    required List<String> eventosConcluidos,
    required ImagePicker picker,
    required Function({
      required String texto,
      required String origem,
      required File? imagem,
      required BuildContext modalParentContext,
    }) onSolicitarConfirmacao,
  }) {
    final TextEditingController textoCtrl = TextEditingController();
    String? linkInserido;
    final List<File> midiasSelecionadas = [];

    String tipoOrigem = "evento";
    String? eventoSelecionado =
        eventosConcluidos.isNotEmpty ? eventosConcluidos.first : null;
    int palavrasContadas = 0;

    int contarPalavras(String str) {
      final limpo = str.trim();
      if (limpo.isEmpty) return 0;
      return limpo.split(RegExp(r'\s+')).length;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isLimiteExcedido = palavrasContadas > 1000;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Compartilhar Experiência",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Segmented (Evento vs Livre)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F5F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => tipoOrigem = "evento"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: tipoOrigem == "evento" ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  "Evento que participei",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: tipoOrigem == "evento"
                                        ? const Color(0xFF0C6B6B)
                                        : const Color(0xFF7AAAA0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => tipoOrigem = "livre"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: tipoOrigem == "livre" ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  "Postagem livre",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: tipoOrigem == "livre"
                                        ? const Color(0xFF0C6B6B)
                                        : const Color(0xFF7AAAA0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Dropdown de eventos concluídos
                  if (tipoOrigem == "evento") ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FAF7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFC2E4DC)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: eventoSelecionado,
                          isExpanded: true,
                          items: eventosConcluidos.map((ev) {
                            return DropdownMenuItem(
                              value: ev,
                              child: Text(
                                ev,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF062222)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => eventoSelecionado = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Campo de Texto
                  TextField(
                    controller: textoCtrl,
                    maxLines: 5,
                    onChanged: (val) {
                      setModalState(() => palavrasContadas = contarPalavras(val));
                    },
                    decoration: InputDecoration(
                      hintText: "Relate sua experiência como voluntário, aprendizados ou histórias marcantes...",
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF0FAF7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contador e anexos
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "$palavrasContadas / 1000 palavras",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isLimiteExcedido ? Colors.redAccent : const Color(0xFF7AAAA0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: (textoCtrl.text.trim().isEmpty || isLimiteExcedido)
                        ? null
                        : () {
                            onSolicitarConfirmacao(
                              texto: textoCtrl.text.trim(),
                              origem: tipoOrigem == "evento"
                                  ? (eventoSelecionado ?? "Ação Solidária")
                                  : "Postagem Livre",
                              imagem: midiasSelecionadas.isNotEmpty
                                  ? midiasSelecionadas.first
                                  : null,
                              modalParentContext: modalContext,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Publicar no Feed", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}