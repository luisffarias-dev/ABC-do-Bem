// lib/ongs/home/widgets/ong_meus_eventos_section.dart

import 'package:flutter/material.dart';

class OngMeusEventosSection extends StatelessWidget {
  final List<dynamic> eventos;
  final Function(String) onEditarEvento;
  final VoidCallback onGerenciarTodos;
  final bool isMobile;

  const OngMeusEventosSection({
    super.key,
    required this.eventos,
    required this.onEditarEvento,
    required this.onGerenciarTodos,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Meus Eventos Cadastrados",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            TextButton(
              onPressed: onGerenciarTodos,
              child: const Text(
                "Gerenciar todos",
                style: TextStyle(
                  color: Color(0xFF0C6B6B),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (eventos.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: const Center(
              child: Text(
                "Nenhum evento ativo cadastrado no momento.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
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
              final int inscritos = ev.inscritosCount ?? 0;
              final int vagas = ev.vagasTotais > 0 ? ev.vagasTotais : 1;
              final pct = (inscritos / vagas).clamp(0.0, 1.0);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ev.imagemUrl ?? '',
                        width: isMobile ? 65 : 85,
                        height: isMobile ? 65 : 85,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: isMobile ? 65 : 85,
                          height: isMobile ? 65 : 85,
                          color: const Color(0xFFE3F5F1),
                          child: const Icon(
                            Icons.event_rounded,
                            color: Color(0xFF0C6B6B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ev.titulo ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF062222),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "📅 ${ev.dataFormatada ?? ''} • ${ev.horario ?? ''}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: const Color(0xFFE3F5F1),
                                    color: const Color(0xFF0C6B6B),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$inscritos/$vagas vagas",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C6B6B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => onEditarEvento(ev.id.toString()),
                      icon: const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFF0C6B6B),
                        size: 24,
                      ),
                      tooltip: "Editar evento",
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
