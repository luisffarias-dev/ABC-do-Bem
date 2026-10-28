// lib/ongs/gestao_eventos/dialogs/sucesso_cancelamento_dialog.dart

import 'package:flutter/material.dart';
import '../../../eventos/models/evento_model.dart';

class SucessoCancelamentoDialog extends StatelessWidget {
  final EventoModel evento;
  final String motivo;

  const SucessoCancelamentoDialog({
    super.key,
    required this.evento,
    required this.motivo,
  });

  static Future<void> exibir(
    BuildContext context, {
    required EventoModel evento,
    required String motivo,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SucessoCancelamentoDialog(
        evento: evento,
        motivo: motivo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.redAccent,
                size: 38,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Ação Cancelada com Sucesso",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "'${evento.titulo}' foi encerrada no sistema.",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),

            // Card com resumo dos disparos e atualizações
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2EEEE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ações automáticas executadas:",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C6B6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _itemStatus(
                    icon: Icons.notifications_active_outlined,
                    texto: "Notificação push enviada aos voluntários inscritos",
                  ),
                  const SizedBox(height: 6),
                  _itemStatus(
                    icon: Icons.mark_email_read_outlined,
                    texto: "E-mail de aviso disparado com o motivo informado",
                  ),
                  const SizedBox(height: 6),
                  _itemStatus(
                    icon: Icons.dynamic_feed_rounded,
                    texto: "Status atualizado como 'Cancelado' no feed público",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Exibição do motivo registrado
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Motivo registrado: $motivo",
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0C6B6B),
            minimumSize: const Size.fromHeight(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Entendido",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _itemStatus({required IconData icon, required String texto}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0C6B6B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 11, color: Color(0xFF062222)),
          ),
        ),
      ],
    );
  }
}
