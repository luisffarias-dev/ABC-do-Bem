// lib/eventos/voluntario/widgets/evento_meu_inscrito_card.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoMeuInscritoCard extends StatelessWidget {
  final InscricaoEventoModel inscricao;
  final DateTime now;
  final VoidCallback onCancelar;
  final bool isMobile;

  const EventoMeuInscritoCard({
    super.key,
    required this.inscricao,
    required this.now,
    required this.onCancelar,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final ev = inscricao.evento!;
    final diff = ev.dataHoraInicio.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    final String status = inscricao.status;
    final bool isAprovado = status.toLowerCase() == "aprovado";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9FE8D8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C6B6B).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF062222), Color(0xFF0C5252)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                diff.isNegative
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Em andamento",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              color: Color(0xFF9FE8D8), size: 15),
                          const SizedBox(width: 4),
                          const Text(
                            "Início: ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _buildUnit("$days", "d"),
                          const Text(" : ",
                              style: TextStyle(color: Colors.white)),
                          _buildUnit(hours.toString().padLeft(2, '0'), "h"),
                          const Text(" : ",
                              style: TextStyle(color: Colors.white)),
                          _buildUnit(minutes.toString().padLeft(2, '0'), "m"),
                        ],
                      ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isAprovado
                        ? const Color(0xFF29B0A0)
                        : Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAprovado
                            ? Icons.check_circle_outline_rounded
                            : Icons.hourglass_top_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    ev.imagemUrl,
                    width: isMobile ? 56 : 70,
                    height: isMobile ? 56 : 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev.titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 14 : 15,
                          color: const Color(0xFF062222),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "🏢 ${ev.ongNome}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0C6B6B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "📅 ${ev.data} • ${ev.horario} • 📍 ${ev.cidade}",
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onCancelar,
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnit(String value, String unit) {
    return Text(
      "$value$unit",
      style: const TextStyle(
        color: Color(0xFF9FE8D8),
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );
  }
}
