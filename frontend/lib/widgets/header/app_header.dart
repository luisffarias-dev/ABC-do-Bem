// lib/widgets/header/app_header.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../services/notification_service.dart';
import '../../mensagens/services/chat_service.dart';

import 'widgets/header_brand_section.dart';
import 'widgets/header_action_icons.dart';
import 'widgets/header_user_avatar.dart';
import 'widgets/header_user_menu_modal.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  final String usuarioId;
  final String tipoUsuario; // "voluntario" ou "ong"
  final String? nomeUsuario;
  final String? fotoPerfilUrl;

  /// Controla a visibilidade do botão voltar.
  final bool showBackButton;
  final VoidCallback? onVoltar;
  final VoidCallback? onPerfilAtualizado;

  const AppHeader({
    super.key,
    this.usuarioId = "voluntario-1",
    this.tipoUsuario = "voluntario",
    this.nomeUsuario,
    this.fotoPerfilUrl,
    this.showBackButton = false,
    this.onVoltar,
    this.onPerfilAtualizado,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _AppHeaderState extends State<AppHeader> {
  final NotificationService _notificationService = NotificationService();
  final ChatService _chatService = ChatService();

  int _mensagensNaoLidas = 0;

  bool get isOng => widget.tipoUsuario.trim().toLowerCase() == "ong";

  String get _idResolvido {
    if (widget.usuarioId.trim().isNotEmpty &&
        widget.usuarioId != "voluntario-1") {
      return widget.usuarioId.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return widget.usuarioId.trim();
  }

  String get _nomeExibicao {
    if (widget.nomeUsuario != null && widget.nomeUsuario!.trim().isNotEmpty) {
      return widget.nomeUsuario!.trim();
    }
    if (SessionService.instance.nomeUsuario != null &&
        SessionService.instance.nomeUsuario!.trim().isNotEmpty) {
      return SessionService.instance.nomeUsuario!.trim();
    }
    return isOng ? "Instituto Criança Cidadã" : "Voluntário";
  }

  String get _fotoExibicao {
    if (widget.fotoPerfilUrl != null &&
        widget.fotoPerfilUrl!.trim().isNotEmpty) {
      return widget.fotoPerfilUrl!.trim();
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    _carregarContadoresApi();
  }

  @override
  void didUpdateWidget(covariant AppHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.usuarioId != widget.usuarioId ||
        oldWidget.tipoUsuario != widget.tipoUsuario ||
        oldWidget.fotoPerfilUrl != widget.fotoPerfilUrl ||
        oldWidget.nomeUsuario != widget.nomeUsuario) {
      _carregarContadoresApi();
    }
  }

  Future<void> _carregarContadoresApi() async {
    final idAtivo = _idResolvido;
    try {
      final resultados = await Future.wait([
        _notificationService.buscarTotalNaoLidas(idAtivo),
        _chatService.buscarConversas(
          usuarioId: idAtivo,
          tipoUsuario: widget.tipoUsuario,
        ),
      ]);

      if (!mounted) return;

      final conversas = resultados[1] is List ? (resultados[1] as List) : [];

      final totalMensagens = conversas.fold<int>(
        0,
        (acumulado, conversa) {
          int count = 0;
          if (conversa is Map) {
            count = (conversa['naoLidas'] as num?)?.toInt() ?? 0;
          } else {
            try {
              count = (conversa.naoLidas as num?)?.toInt() ?? 0;
            } catch (_) {
              count = 0;
            }
          }
          return acumulado + count;
        },
      );

      setState(() {
        _mensagensNaoLidas = totalMensagens;
      });
    } catch (_) {}
  }

  void _abrirMenuUsuario() {
    HeaderUserMenuModal.exibir(
      context,
      usuarioId: _idResolvido,
      tipoUsuario: widget.tipoUsuario,
      isOng: isOng,
      nomeExibicao: _nomeExibicao,
      fotoExibicao: _fotoExibicao,
    );
  }

  void _aoClicarVoltar() {
    if (widget.onVoltar != null) {
      widget.onVoltar!();
    } else if (Navigator.canPop(context)) {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFC2E4DC))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderBrandSection(
            showBackButton: widget.showBackButton,
            isDesktop: isDesktop,
            isOng: isOng,
            onVoltar: _aoClicarVoltar,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Conectado ao ValueNotifier de notificações para atualização em tempo real
              ValueListenableBuilder<int>(
                valueListenable: NotificationService.totalNaoLidasNotifier,
                builder: (context, totalNotificacoes, _) {
                  return HeaderActionIcons(
                    usuarioId: _idResolvido,
                    tipoUsuario: widget.tipoUsuario,
                    isOng: isOng,
                    notificacoesNaoLidas: totalNotificacoes,
                    mensagensNaoLidas: _mensagensNaoLidas,
                  );
                },
              ),
              const SizedBox(width: 8),
              HeaderUserAvatar(
                nomeExibicao: _nomeExibicao,
                fotoExibicao: _fotoExibicao,
                isDesktop: isDesktop,
                isOng: isOng,
                onTap: _abrirMenuUsuario,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
