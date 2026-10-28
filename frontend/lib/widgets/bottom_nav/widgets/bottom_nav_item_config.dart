// lib/widgets/bottom_nav/widgets/bottom_nav_item_config.dart

import 'package:flutter/material.dart';

import '../../../services/session_service.dart';
import '../../../voluntarios/home/voluntario_home_page.dart';
import '../../../ongs/home/ong_home_page.dart';
import '../../../eventos/voluntario/eventos_page.dart';
import '../../../notificacoes/notificacoes_page.dart';
import '../../../mensagens/mensagens_page.dart';
import '../../../ongs/painel_geral/painel_geral_page.dart';
import '../../../voluntarios/perfil/meu_perfil_page.dart';
import '../../../voluntarios/buscar/buscar_ongs_page.dart';

class BottomNavItemConfig {
  final IconData icon;
  final String label;
  final Widget Function(
      BuildContext context, String usuarioId, String tipoUsuario) builder;

  const BottomNavItemConfig({
    required this.icon,
    required this.label,
    required this.builder,
  });

  static List<BottomNavItemConfig> itensOng() => [
        BottomNavItemConfig(
          icon: Icons.home_rounded,
          label: "Home",
          builder: (_, id, __) => OngHomePage(ongId: id),
        ),
        BottomNavItemConfig(
          icon: Icons.search_rounded,
          label: "Buscar",
          builder: (_, id, __) => BuscarOngsPage(voluntarioId: id),
        ),
        BottomNavItemConfig(
          icon: Icons.notifications_rounded,
          label: "Avisos",
          builder: (_, id, tipo) => NotificacoesPage(
            usuarioId: id,
            tipoUsuario: tipo,
          ),
        ),
        BottomNavItemConfig(
          icon: Icons.chat_bubble_rounded,
          label: "Chat",
          builder: (_, id, tipo) => MensagensPage(
            usuarioId: id,
            tipoUsuario: tipo,
          ),
        ),
        BottomNavItemConfig(
          icon: Icons.settings_rounded,
          label: "Painel",
          builder: (_, id, tipo) => OngPainelGeralPage(
            ongId: id,
            tipoUsuario: tipo,
          ),
        ),
      ];

  static List<BottomNavItemConfig> itensVoluntario() => [
        BottomNavItemConfig(
          icon: Icons.home_rounded,
          label: "Home",
          builder: (_, id, __) => VoluntarioHomePage(
            voluntarioId: id,
            nomeUsuario: SessionService.instance.nomeUsuario,
            token: SessionService.instance.token,
          ),
        ),
        BottomNavItemConfig(
          icon: Icons.search_rounded,
          label: "Buscar",
          builder: (_, id, __) => BuscarOngsPage(voluntarioId: id),
        ),
        BottomNavItemConfig(
          icon: Icons.event_available_rounded,
          label: "Eventos",
          builder: (_, id, __) => EventosPage(voluntarioId: id),
        ),
        BottomNavItemConfig(
          icon: Icons.chat_bubble_rounded,
          label: "Mensagens",
          builder: (_, id, tipo) => MensagensPage(
            usuarioId: id,
            tipoUsuario: tipo,
          ),
        ),
        BottomNavItemConfig(
          icon: Icons.person_rounded,
          label: "Meu Perfil",
          builder: (_, id, tipo) => MeuPerfilPage(
            usuarioId: id,
            tipoUsuario: tipo,
            token: SessionService.instance.token,
          ),
        ),
      ];
}
