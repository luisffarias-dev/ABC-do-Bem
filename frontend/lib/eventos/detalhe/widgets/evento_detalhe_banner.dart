// lib/eventos/detalhe/widgets/evento_detalhe_banner.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoDetalheBanner extends StatelessWidget {
  final EventoModel evento;
  final bool isDono;
  final VoidCallback onVoltar;
  final VoidCallback? onEditar;
  final VoidCallback? onPausar;
  final VoidCallback? onCancelarEvento;

  const EventoDetalheBanner({
    super.key,
    required this.evento,
    required this.isDono,
    required this.onVoltar,
    this.onEditar,
    this.onPausar,
    this.onCancelarEvento,
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
      default:
        return const Color(0xFF0C6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            evento.imagemUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFD1F5EE),
              child:
                  const Icon(Icons.event, size: 54, color: Color(0xFF0C6B6B)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Color(0xFF062222)),
                    onPressed: onVoltar,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: Color(0xFF062222)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Link da ação copiado!")),
                          );
                        },
                      ),
                    ),
                    if (isDono) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded,
                              color: Color(0xFF062222)),
                          onSelected: (value) {
                            if (value == 'editar') onEditar?.call();
                            if (value == 'pausar') onPausar?.call();
                            if (value == 'cancelar') onCancelarEvento?.call();
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'editar',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text("Editar Ação"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'pausar',
                              child: Row(
                                children: [
                                  Icon(Icons.pause_circle_outline, size: 18),
                                  SizedBox(width: 8),
                                  Text("Pausar Inscrições"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'cancelar',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18, color: Colors.redAccent),
                                  SizedBox(width: 8),
                                  Text("Cancelar Evento",
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildBadge(
                    evento.categoria, _obterCorPorCausa(evento.categoria)),
                if (evento.emiteCertificado)
                  _buildBadge("Emite Certificado", const Color(0xFF1565C0)),
                if (evento.isQuaseEsgotado)
                  _buildBadge("Últimas Vagas", const Color(0xFFC62828)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
