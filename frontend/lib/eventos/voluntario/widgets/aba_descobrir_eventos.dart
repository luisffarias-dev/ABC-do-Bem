// lib/eventos/voluntario/widgets/aba_descobrir_eventos.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';
import 'eventos_calendario_section.dart';
import 'evento_vitrine_card.dart';
import 'eventos_mapa_section.dart';

class AbaDescobrirEventos extends StatelessWidget {
  final String viewMode; // "list", "map", "calendar"
  final bool carregando;
  final bool erroConexao;
  final List<EventoModel> eventos;
  final DateTime currentMonthDate;
  final String? selectedDate;
  final Set<String> eventDates;
  final bool isMobile;
  final VoidCallback onRetry;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<String?> onSelectDate;
  final void Function(EventoModel evento) onAcaoInscricao;
  final Function(String ongId)? onOngSelect;
  final Function(String eventId)? onShareEvent;

  const AbaDescobrirEventos({
    super.key,
    required this.viewMode,
    required this.carregando,
    required this.erroConexao,
    required this.eventos,
    required this.currentMonthDate,
    required this.selectedDate,
    required this.eventDates,
    required this.isMobile,
    required this.onRetry,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDate,
    required this.onAcaoInscricao,
    this.onOngSelect,
    this.onShareEvent,
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
              "Falha ao carregar eventos da vitrine",
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

    // 1. VISUALIZAÇÃO EM MAPA
    if (viewMode == "map") {
      if (eventos.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              "Nenhum evento com localização disponível para o filtro selecionado.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return EventosMapaSection(
        eventos: eventos,
        isMobile: isMobile,
        onAcaoInscricao: onAcaoInscricao,
      );
    }

    // 2. VISUALIZAÇÃO EM CALENDÁRIO OU LISTA
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (viewMode == "calendar") ...[
          EventosCalendarioSection(
            currentMonthDate: currentMonthDate,
            selectedDate: selectedDate,
            eventDates: eventDates,
            onPrevMonth: onPrevMonth,
            onNextMonth: onNextMonth,
            onSelectDate: onSelectDate,
          ),
          const SizedBox(height: 18),
        ],
        if (eventos.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                "Nenhum evento localizado para o filtro selecionado.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final ev = eventos[index];
              return EventoVitrineCard(
                evento: ev,
                onParticiparOuCancelar: () => onAcaoInscricao(ev),
                onOngSelect: onOngSelect,
                onShareEvent: onShareEvent,
                isMobile: isMobile,
              );
            },
          ),
      ],
    );
  }
}
