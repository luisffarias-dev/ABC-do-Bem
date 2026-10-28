// lib/eventos/voluntario/widgets/modal_cancelar_inscricao.dart

import 'package:flutter/material.dart';

class ModalCancelarInscricao {
  static void exibir(
    BuildContext context, {
    required String eventoId,
    required String titulo,
    required String ongNome,
    required Future<void> Function(String motivo) onConfirmarCancelamento,
    required bool isMobile,
  }) {
    String? motivoSelecionado;
    bool cancelamentoEnviado = false;
    bool enviando = false;
    String? erroMotivo;

    final List<String> opcoesMotivos = [
      "Saúde / Mal-estar",
      "Compromisso de Trabalho",
      "Motivos Pessoais",
      "Ajuda em outra instituição",
      "Dificuldade de Transporte",
      "Conflito de Horário",
      "Outros",
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(isMobile ? 18 : 24),
          content: cancelamentoEnviado
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1F5EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_rounded,
                          color: Color(0xFF0C6B6B), size: 36),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Cancelamento Enviado",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Avisamos a $ongNome sobre a sua desistência.\n\nSabemos que imprevistos acontecem! Seu apoio faz toda a diferença para o Grande ABC e esperamos você na próxima. 💚",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF3A6868), height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogCtx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C6B6B),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Entendido, até a próxima!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.amber, size: 26),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Cancelar Participação?",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF062222)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Você está prestes a liberar sua vaga no evento $titulo. Deseja prosseguir?",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF3A6868), height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Qual o motivo da desistência?",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: opcoesMotivos.map((motivo) {
                        final isSelected = motivoSelecionado == motivo;
                        return ChoiceChip(
                          label: Text(motivo),
                          selected: isSelected,
                          selectedColor: const Color(0xFFD1F5EE),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF0C6B6B)
                                : const Color(0xFF062222),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF0C6B6B)
                                  : const Color(0xFFC2E4DC),
                            ),
                          ),
                          onSelected: enviando
                              ? null
                              : (selected) {
                                  setDialogState(() {
                                    motivoSelecionado =
                                        selected ? motivo : null;
                                    if (motivoSelecionado != null)
                                      erroMotivo = null;
                                  });
                                },
                        );
                      }).toList(),
                    ),
                    if (erroMotivo != null) ...[
                      const SizedBox(height: 6),
                      Text(erroMotivo!,
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: enviando
                                ? null
                                : () async {
                                    if (motivoSelecionado == null) {
                                      setDialogState(() =>
                                          erroMotivo = "Selecione uma opção.");
                                      return;
                                    }
                                    setDialogState(() => enviando = true);
                                    await onConfirmarCancelamento(
                                        motivoSelecionado!);
                                    setDialogState(() {
                                      enviando = false;
                                      cancelamentoEnviado = true;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: enviando
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : const Text("Confirmar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: enviando
                                ? null
                                : () => Navigator.pop(dialogCtx),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF0C6B6B)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Voltar",
                                style: TextStyle(
                                    color: Color(0xFF0C6B6B),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
