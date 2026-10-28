// lib/eventos/detalhe/widgets/evento_detalhe_necessidades_section.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoDetalheNecessidadesSection extends StatelessWidget {
  final EventoModel evento;
  final bool isDono;
  final VoidCallback? onEditarItens;

  const EventoDetalheNecessidadesSection({
    super.key,
    required this.evento,
    required this.isDono,
    this.onEditarItens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Requisitos & Necessidades",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF062222),
                ),
              ),
              if (isDono)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Color(0xFF0C6B6B), size: 20),
                  onPressed: onEditarItens,
                  tooltip: "Adicionar item",
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Requisitos para participar:",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0C6B6B)),
          ),
          const SizedBox(height: 4),
          if (evento.requisitos.isEmpty)
            const Text("• Aberto a qualquer voluntário disposto a ajudar.",
                style: TextStyle(fontSize: 12, color: Colors.grey))
          else
            ...evento.requisitos
                .map((req) => _buildCheckItem(req, Icons.check_circle_outline)),
          const Divider(height: 20, color: Color(0xFFE2F4F0)),
          const Text(
            "O que levar / Necessidades do dia:",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0C6B6B)),
          ),
          const SizedBox(height: 4),
          if (evento.necessidades.isEmpty)
            const Text("• A instituição fornecerá todo o material necessário.",
                style: TextStyle(fontSize: 12, color: Colors.grey))
          else
            ...evento.necessidades
                .map((nec) => _buildCheckItem(nec, Icons.inventory_2_outlined)),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String texto, IconData icone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 15, color: const Color(0xFF0C6B6B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto,
                style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
          ),
        ],
      ),
    );
  }
}
