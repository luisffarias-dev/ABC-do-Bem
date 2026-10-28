// lib/widgets/sidebar/app_sidebar.dart

import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../voluntarios/home/voluntario_home_page.dart';
import '../../ongs/home/ong_home_page.dart';
import '../../voluntarios/buscar/buscar_ongs_page.dart';
import '../../eventos/voluntario/eventos_page.dart';
import '../../../notificacoes/notificacoes_page.dart';
import '../../../mensagens/mensagens_page.dart';
import '../../voluntarios/perfil/meu_perfil_page.dart';
import '../../ongs/painel_geral/painel_geral_page.dart';
import '../../ongs/gestao_eventos/gestao_eventos_page.dart';

import 'widgets/sidebar_header.dart';
import 'widgets/sidebar_menu_item.dart';
import 'widgets/sidebar_logout_dialog.dart';

class AppSidebar extends StatelessWidget {
  final int currentIndex;
  final String usuarioId;
  final String tipoUsuario; // "voluntario" ou "ong"

  const AppSidebar({
    super.key,
    required this.currentIndex,
    this.usuarioId = "voluntario-1",
    this.tipoUsuario = "voluntario",
  });

  bool get isOng => tipoUsuario.trim().toLowerCase() == "ong";

  String get _idResolvido {
    if (usuarioId.trim().isNotEmpty && usuarioId != "voluntario-1") {
      return usuarioId.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return usuarioId.trim();
  }

  void _navegarSemAnimacao(BuildContext context, Widget destino) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => destino,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFC2E4DC))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Topo: Logo + Identificador do Perfil
          SidebarHeader(isOng: isOng),
          const Divider(height: 1, color: Color(0xFFC2E4DC)),
          const SizedBox(height: 12),

          // 2. Lista de Menus (ONG ou Voluntário)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: isOng
                  ? _buildMenusOng(context)
                  : _buildMenusVoluntario(context),
            ),
          ),

          // 3. Rodapé: Logout
          const Divider(height: 1, color: Color(0xFFC2E4DC)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SidebarMenuItem(
              icon: Icons.logout_rounded,
              label: "Sair da conta",
              selecionado: false,
              corTexto: Colors.redAccent,
              onTap: () => SidebarLogoutDialog.exibir(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenusOng(BuildContext context) {
    final String idAtivo = _idResolvido;

    return [
      SidebarMenuItem(
        icon: Icons.home_rounded,
        label: "Home",
        selecionado: currentIndex == 0,
        onTap: () => _navegarSemAnimacao(
          context,
          OngHomePage(ongId: idAtivo),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.search_rounded,
        label: "Buscar",
        selecionado: currentIndex == 1,
        onTap: () => _navegarSemAnimacao(
          context,
          BuscarOngsPage(voluntarioId: idAtivo),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.notifications_rounded,
        label: "Avisos",
        selecionado: currentIndex == 2,
        onTap: () => _navegarSemAnimacao(
          context,
          NotificacoesPage(
            usuarioId: idAtivo,
            tipoUsuario: tipoUsuario,
          ),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.chat_bubble_rounded,
        label: "Chat",
        selecionado: currentIndex == 3,
        onTap: () => _navegarSemAnimacao(
          context,
          MensagensPage(
            usuarioId: idAtivo,
            tipoUsuario: tipoUsuario,
          ),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.settings_rounded,
        label: "Painel Geral",
        selecionado: currentIndex == 4,
        onTap: () => _navegarSemAnimacao(
          context,
          OngPainelGeralPage(
            ongId: idAtivo,
            tipoUsuario: tipoUsuario,
          ),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.event_note_rounded,
        label: "Eventos",
        selecionado: currentIndex == 5,
        onTap: () => _navegarSemAnimacao(
          context,
          GestaoEventosPage(
            ongId: idAtivo,
            tipoUsuario: tipoUsuario,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildMenusVoluntario(BuildContext context) {
    final String idAtivo = _idResolvido;

    return [
      SidebarMenuItem(
        icon: Icons.home_rounded,
        label: "Início",
        selecionado: currentIndex == 0,
        onTap: () => _navegarSemAnimacao(
          context,
          VoluntarioHomePage(
            voluntarioId: idAtivo,
            nomeUsuario: SessionService.instance.nomeUsuario,
            token: SessionService.instance.token,
          ),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.search_rounded,
        label: "Buscar ONGs",
        selecionado: currentIndex == 1,
        onTap: () => _navegarSemAnimacao(
          context,
          BuscarOngsPage(voluntarioId: idAtivo),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.event_available_rounded,
        label: "Eventos",
        selecionado: currentIndex == 2,
        onTap: () => _navegarSemAnimacao(
          context,
          EventosPage(voluntarioId: idAtivo),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.chat_bubble_rounded,
        label: "Mensagens",
        selecionado: currentIndex == 3,
        onTap: () => _navegarSemAnimacao(
          context,
          MensagensPage(
            usuarioId: idAtivo,
            tipoUsuario: tipoUsuario,
          ),
        ),
      ),
      SidebarMenuItem(
        icon: Icons.person_rounded,
        label: "Meu Painel",
        selecionado: currentIndex == 4,
        onTap: () => _navegarSemAnimacao(
          context,
          MeuPerfilPage(
            usuarioId: idAtivo,
            tipoUsuario: tipoUsuario,
            token: SessionService.instance.token,
          ),
        ),
      ),
    ];
  }
}
