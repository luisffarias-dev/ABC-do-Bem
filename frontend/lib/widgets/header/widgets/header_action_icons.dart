// lib/widgets/header/widgets/header_action_icons.dart

import 'package:flutter/material.dart';

import '../../../notificacoes/notificacoes_page.dart';
import '../../../mensagens/mensagens_page.dart';
import '../../../services/notification_service.dart';

class HeaderActionIcons extends StatelessWidget {
  final String usuarioId;
  final String tipoUsuario;
  final bool isOng;
  final int notificacoesNaoLidas;
  final int mensagensNaoLidas;

  const HeaderActionIcons({
    super.key,
    required this.usuarioId,
    required this.tipoUsuario,
    required this.isOng,
    required this.notificacoesNaoLidas,
    required this.mensagensNaoLidas,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificacoesPage(
                  usuarioId: usuarioId,
                  tipoUsuario: isOng ? "ong" : "voluntario",
                ),
              ),
            ).then((_) {
              NotificationService().buscarTotalNaoLidas(usuarioId);
            });
          },
          tooltip: isOng ? "Avisos e Candidaturas" : "Minhas Notificações",
          icon: Badge(
            // Mostra o dot vermelho apenas se houver notificações não lidas
            isLabelVisible: notificacoesNaoLidas > 0,
            backgroundColor: const Color(0xFFE53935),
            smallSize: 8, // Diâmetro compacto do ponto indicador
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF0C6B6B),
            ),
          ),
        ),
        const SizedBox(width: 2),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MensagensPage(
                  usuarioId: usuarioId,
                  tipoUsuario: isOng ? "ong" : "voluntario",
                ),
              ),
            );
          },
          tooltip: isOng ? "Mensagens com Voluntários" : "Minhas Mensagens",
          icon: Badge(
            isLabelVisible: mensagensNaoLidas > 0,
            label: Text("$mensagensNaoLidas"),
            backgroundColor: const Color(0xFFE53935),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF0C6B6B),
            ),
          ),
        ),
      ],
    );
  }
}
