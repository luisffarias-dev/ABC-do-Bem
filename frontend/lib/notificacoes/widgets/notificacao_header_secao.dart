// lib/notificacoes/widgets/notificacao_header_secao.dart

import 'package:flutter/material.dart';

class NotificacaoHeaderSecao extends StatelessWidget {
  final bool isOng;
  final bool isMobile;
  final bool hasNaoLidas;
  final VoidCallback onMarcarTodasComoLidas;

  const NotificacaoHeaderSecao({
    super.key,
    required this.isOng,
    required this.isMobile,
    required this.hasNaoLidas,
    required this.onMarcarTodasComoLidas,
  });

  @override
  Widget build(BuildContext context) {
    final titulo = isOng ? "Avisos da Instituição" : "Notificações";
    final subtitulo = isOng
        ? "Acompanhe candidaturas de voluntários e avisos da rede"
        : "Fique por dentro das novidades da sua comunidade";

    final botaoMarcarLidas = TextButton.icon(
      onPressed: onMarcarTodasComoLidas,
      icon: const Icon(
        Icons.done_all_rounded,
        size: 16,
        color: Color(0xFF0C6B6B),
      ),
      label: Text(
        isMobile ? "Marcar todas como lidas" : "Marcar lidas",
        style: const TextStyle(
          color: Color(0xFF0C6B6B),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7AAAA0),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasNaoLidas) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: botaoMarcarLidas,
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitulo,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7AAAA0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (hasNaoLidas) botaoMarcarLidas,
      ],
    );
  }
}
