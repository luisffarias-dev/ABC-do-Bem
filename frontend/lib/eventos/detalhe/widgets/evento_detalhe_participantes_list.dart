// lib/eventos/detalhe/widgets/evento_detalhe_participantes_list.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';
import '../../../voluntarios/perfil/voluntario_perfil_page.dart';

class EventoDetalheParticipantesList extends StatelessWidget {
  final EventoModel evento;
  final bool isDono;
  final String? usuarioLogadoId;

  const EventoDetalheParticipantesList({
    super.key,
    required this.evento,
    required this.isDono,
    this.usuarioLogadoId,
  });

  void _abrirPerfilVoluntario(BuildContext context, String participanteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoluntarioPerfilPage(
          usuarioId: participanteId,
          usuarioLogadoId: usuarioLogadoId,
          tipoUsuario: "voluntario",
        ),
      ),
    );
  }

  String _extrairPrimeiroNome(String nomeCompleto) {
    final partes = nomeCompleto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return "Voluntário";
    return partes.first;
  }

  @override
  Widget build(BuildContext context) {
    final participantes = evento.participantesConfirmados;

    if (participantes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: const Text(
          "Seja o primeiro voluntário a confirmar presença nesta ação!",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF7AAAA0),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      width: double.infinity,
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
              Text(
                "Presenças Confirmadas (${participantes.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF062222),
                ),
              ),
              const Text(
                "Toque para ver o perfil",
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7AAAA0),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: participantes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (ctx, index) {
                final p = participantes[index];
                final bool isEu =
                    usuarioLogadoId != null && p.id == usuarioLogadoId;
                final String primeiroNome =
                    isEu ? "Você" : _extrairPrimeiroNome(p.nome);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _abrirPerfilVoluntario(context, p.id),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 44,
                              height: 44,
                              color: isEu
                                  ? const Color(0xFF0C6B6B)
                                  : const Color(0xFFD1F5EE),
                              child: (p.fotoUrl != null &&
                                      p.fotoUrl!.trim().isNotEmpty)
                                  ? Image.network(
                                      p.fotoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: isEu
                                              ? Colors.white
                                              : const Color(0xFF0C6B6B),
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: isEu
                                            ? Colors.white
                                            : const Color(0xFF0C6B6B),
                                        size: 24,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 62,
                            child: Text(
                              primeiroNome,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isEu ? FontWeight.bold : FontWeight.w600,
                                color: isEu
                                    ? const Color(0xFF0C6B6B)
                                    : const Color(0xFF062222),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
