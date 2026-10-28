// lib/eventos/detalhe/widgets/evento_detalhe_vagas_card.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoDetalheVagasCard extends StatelessWidget {
  final EventoModel evento;
  final bool isDono;
  final VoidCallback? onAjustarVagas;

  const EventoDetalheVagasCard({
    super.key,
    required this.evento,
    required this.isDono,
    this.onAjustarVagas,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Sanitização defensiva dos valores numéricos
    final int total = evento.vagasTotais > 0 ? evento.vagasTotais : 0;
    final int restantes = evento.vagasRestantes.clamp(0, total > 0 ? total : 0);
    final int preenchidas = (total - restantes).clamp(0, total > 0 ? total : 0);

    // 2. Cálculo do progresso protegido contra divisão por zero (0 / 0 = NaN)
    final double progressoCalculado = total > 0 ? (preenchidas / total) : 0.0;
    final double progressoValido =
        (progressoCalculado.isNaN || progressoCalculado.isInfinite)
            ? 0.0
            : progressoCalculado.clamp(0.0, 1.0);

    final int porcentagemExibicao = (progressoValido * 100).round();
    final bool esgotado = total > 0 && restantes <= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total == 0
                    ? "Vagas a definir"
                    : "Ocupação das Vagas ($preenchidas de $total)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF062222),
                ),
              ),
              Text(
                "$porcentagemExibicao%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF0C6B6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Barra de progresso protegida contra valores inválidos
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressoValido,
              minHeight: 8,
              backgroundColor: const Color(0xFFD1F5EE),
              valueColor: AlwaysStoppedAnimation<Color>(
                esgotado ? Colors.redAccent : const Color(0xFF0C6B6B),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total == 0
                    ? "Defina a quantidade de vagas para abrir inscrições"
                    : esgotado
                        ? "Todas as vagas preenchidas"
                        : "$restantes vagas restantes disponíveis",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: esgotado ? Colors.redAccent : const Color(0xFF3A6868),
                ),
              ),
              if (isDono)
                TextButton.icon(
                  onPressed: onAjustarVagas,
                  icon: const Icon(Icons.tune_rounded, size: 14),
                  label: const Text(
                    "Ajustar Vagas",
                    style: TextStyle(fontSize: 11),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0C6B6B),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
