// lib/eventos/voluntario/widgets/evento_vitrine_card.dart

import 'package:flutter/material.dart';

import '../../detalhe/evento_detalhe_page.dart';
import '../../models/evento_model.dart';

class EventoVitrineCard extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback onParticiparOuCancelar;
  final Function(String ongId)? onOngSelect;
  final Function(String eventId)? onShareEvent;
  final bool isMobile;
  final String usuarioAtualId;
  final bool isOng;

  const EventoVitrineCard({
    super.key,
    required this.evento,
    required this.onParticiparOuCancelar,
    this.onOngSelect,
    this.onShareEvent,
    this.isMobile = false,
    this.usuarioAtualId = "voluntario-1",
    this.isOng = false,
  });

  Color _obterCorPorCausa(String causa) {
    switch (causa.toLowerCase()) {
      case 'meio ambiente':
        return const Color(0xFF2E7D32);
      case 'educação':
        return const Color(0xFF1565C0);
      case 'saúde':
        return const Color(0xFFC62828);
      case 'cultura':
        return const Color(0xFF6A1B9A);
      case 'habitação':
      case 'assistência social':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF0C6B6B);
    }
  }

  void _abrirDetalhes(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventoDetalhePage(
          eventoId: evento.id,
          usuarioAtualId: usuarioAtualId,
          isOng: isOng,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corCausa = _obterCorPorCausa(evento.categoria);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _abrirDetalhes(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Imagem de Capa do Evento
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    evento.imagemUrl,
                    width: isMobile ? 85 : 110,
                    height: isMobile ? 85 : 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: isMobile ? 85 : 110,
                      height: isMobile ? 85 : 110,
                      color: const Color(0xFFD1F5EE),
                      child: Icon(Icons.event, color: corCausa, size: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Informações Textuais Centrais
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag de Causa / Categoria
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: corCausa.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          evento.categoria,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: corCausa,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Título do Evento
                      Text(
                        evento.titulo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),

                      // ONG Responsável e Cidade do ABC
                      Text(
                        "${evento.ongNome} • ${evento.cidade}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Data e Horário
                      Text(
                        "${evento.data} às ${evento.horario}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Ação Rápida de Inscrição / Participação
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: evento.isEsgotado && !evento.isInscrito
                        ? null
                        : onParticiparOuCancelar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: evento.isInscrito
                          ? const Color(0xFFD1F5EE)
                          : const Color(0xFF0C6B6B),
                      foregroundColor: evento.isInscrito
                          ? const Color(0xFF0C6B6B)
                          : Colors.white,
                      disabledBackgroundColor: Colors.grey.shade200,
                      disabledForegroundColor: Colors.grey.shade500,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      evento.isInscrito
                          ? "Inscrito"
                          : (evento.isEsgotado ? "Esgotado" : "Participar"),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
