// lib/eventos/voluntario/widgets/aba_meus_eventos.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';
import 'evento_meu_inscrito_card.dart';
import 'evento_historico_card.dart';

class AbaMeusEventos extends StatelessWidget {
  final bool carregando;
  final bool erroConexao;
  final List<InscricaoEventoModel> proximosEventos;
  final List<InscricaoEventoModel> eventosConcluidos;
  final DateTime now;
  final bool isMobile;
  final VoidCallback onRetry;
  final void Function(InscricaoEventoModel inscricao) onCancelar;

  const AbaMeusEventos({
    super.key,
    required this.carregando,
    required this.erroConexao,
    required this.proximosEventos,
    required this.eventosConcluidos,
    required this.now,
    required this.isMobile,
    required this.onRetry,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0C6B6B)),
        ),
      );
    }

    if (erroConexao) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: Colors.redAccent, size: 36),
            const SizedBox(height: 8),
            const Text(
              "Falha ao carregar suas inscrições",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF062222)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C6B6B)),
              child: const Text("Tentar novamente",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Próximas Participações",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (proximosEventos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Você não possui inscrições ativas no momento.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: proximosEventos.length,
            itemBuilder: (context, index) {
              final ins = proximosEventos[index];
              return EventoMeuInscritoCard(
                inscricao: ins,
                now: now,
                onCancelar: () => onCancelar(ins),
                isMobile: isMobile,
              );
            },
          ),
        const SizedBox(height: 24),
        const Text(
          "Histórico Concluído",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (eventosConcluidos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Nenhum evento concluído ainda.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eventosConcluidos.length,
            itemBuilder: (context, index) {
              return EventoHistoricoCard(
                inscricao: eventosConcluidos[index],
              );
            },
          ),
      ],
    );
  }
}
