// lib/eventos/voluntario/widgets/modal_confirmar_inscricao.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class ModalConfirmarInscricao {
  static void exibir(
    BuildContext context, {
    required EventoModel evento,
    required Future<void> Function(bool autorizouContato) onConfirmar,
    required bool isMobile,
  }) {
    bool autorizouContato = false;
    bool enviando = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(isMobile ? 18 : 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.event_available_rounded,
                      color: Color(0xFF0C6B6B), size: 26),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Confirmar Participação",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062222),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                evento.titulo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C6B6B),
                ),
              ),
              const SizedBox(height: 12),
              _buildRow(Icons.business_rounded, "Instituição:", evento.ongNome),
              const SizedBox(height: 8),
              _buildRow(Icons.calendar_today_rounded, "Data:", evento.data),
              const SizedBox(height: 8),
              _buildRow(Icons.access_time_rounded, "Horário:", evento.horario),
              const SizedBox(height: 8),
              _buildRow(Icons.location_on_outlined, "Local:", evento.cidade),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5F1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: Color(0xFF0C6B6B)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Ao confirmar, enviaremos a sua solicitação diretamente para a instituição responsável.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF062222),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: autorizouContato,
                      activeColor: const Color(0xFF0C6B6B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onChanged: enviando
                          ? null
                          : (val) => setDialogState(
                              () => autorizouContato = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: enviando
                          ? null
                          : () => setDialogState(
                              () => autorizouContato = !autorizouContato),
                      child: const Text(
                        "Autorizo que a instituição entre em contato comigo pelo app, e-mail ou WhatsApp.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF062222),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            ElevatedButton(
              onPressed: (!autorizouContato || enviando)
                  ? null
                  : () async {
                      setDialogState(() => enviando = true);
                      await onConfirmar(autorizouContato);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C6B6B),
                disabledBackgroundColor: Colors.grey.shade300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: enviando
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Sim, quero participar",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            OutlinedButton(
              onPressed: enviando ? null : () => Navigator.pop(dialogCtx),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                side: const BorderSide(color: Color(0xFF0C6B6B)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Fechar",
                  style: TextStyle(
                      color: Color(0xFF0C6B6B), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF7AAAA0)),
        const SizedBox(width: 6),
        Text(
          "$label ",
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF3A6868)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
