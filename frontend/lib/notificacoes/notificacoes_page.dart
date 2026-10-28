// lib/notificacoes_page.dart

import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../services/session_service.dart';
import '../widgets/header/app_header.dart';
import '../widgets/sidebar/app_sidebar.dart';
import '../widgets/bottom_nav/app_bottom_nav.dart';
import '../models/notification_models.dart';
import '../services/notification_service.dart';

import 'widgets/notificacao_header_secao.dart';
import 'widgets/notificacao_tabs.dart';
import 'widgets/notificacao_card.dart';
import 'widgets/notificacao_detalhes_dialog.dart';
import 'widgets/notificacao_estado_vazio.dart';
import 'widgets/notificacao_estado_erro.dart';

class NotificacoesPage extends StatefulWidget {
  final String usuarioId;
  final String tipoUsuario; // "voluntario" ou "ong"

  const NotificacoesPage({
    super.key,
    this.usuarioId = "voluntario-1",
    this.tipoUsuario = "voluntario",
  });

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final NotificationService _notificationService = NotificationService();

  int _tabIndex = 0; // 0: Novas (Não lidas) | 1: Lidas
  bool _carregando = true;
  bool _erroConexao = false;
  List<NotificacaoModel> _notificacoes = [];

  bool get isOng => widget.tipoUsuario.toLowerCase() == "ong";

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

  @override
  void initState() {
    super.initState();
    _carregarNotificacoes();
  }

  Future<void> _carregarNotificacoes() async {
    setState(() {
      _carregando = true;
      _erroConexao = false;
    });

    try {
      final dados = await _notificationService.buscarNotificacoes(_idResolvido);
      if (mounted) {
        setState(() {
          _notificacoes = dados;
          _carregando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregando = false;
          _erroConexao = true;
        });
        _mostrarFeedback("Não foi possível carregar as notificações.",
            isErro: true);
      }
    }
  }

  Future<void> _marcarTodasComoLidas() async {
    setState(() {
      for (final n in _notificacoes) {
        n.lida = true;
      }
    });

    try {
      await _notificationService.marcarTodasComoLidas(_idResolvido);
      _mostrarFeedback("Todas as notificações foram marcadas como lidas.");
    } catch (e) {
      _mostrarFeedback("Erro ao sincronizar com o servidor.", isErro: true);
    }
  }

  void _abrirDetalhesNotificacao(NotificacaoModel notif, bool isMobile) {
    if (!notif.lida) {
      setState(() => notif.lida = true);
      _notificationService.marcarComoLida(notif.id);
    }

    NotificacaoDetalhesDialog.exibir(
      context,
      notificacao: notif,
      isMobile: isMobile,
      isOng: isOng,
      onCompartilhar: (msg) => _mostrarFeedback(msg),
    );
  }

  void _mostrarFeedback(String msg, {bool isErro = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isErro ? Colors.redAccent : const Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final String idAtivo = _idResolvido;

    final List<NotificacaoModel> naoLidas =
        _notificacoes.where((n) => !n.lida).toList();
    final List<NotificacaoModel> lidas =
        _notificacoes.where((n) => n.lida).toList();
    final List<NotificacaoModel> listaExibida =
        _tabIndex == 0 ? naoLidas : lidas;

    final int navIndex = isOng ? 2 : -1;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        bottomNavigationBar: isMobile
            ? AppBottomNav(
                currentIndex: navIndex,
                usuarioId: idAtivo,
                tipoUsuario: widget.tipoUsuario,
              )
            : null,
        body: Row(
          children: [
            if (isDesktop)
              AppSidebar(
                currentIndex: navIndex,
                usuarioId: idAtivo,
                tipoUsuario: widget.tipoUsuario,
              ),
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    usuarioId: idAtivo,
                    tipoUsuario: widget.tipoUsuario,
                    nomeUsuario: SessionService.instance.nomeUsuario,
                    showBackButton: true,
                    onVoltar: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              NotificacaoHeaderSecao(
                                isOng: isOng,
                                isMobile: isMobile,
                                hasNaoLidas: naoLidas.isNotEmpty,
                                onMarcarTodasComoLidas: _marcarTodasComoLidas,
                              ),
                              const SizedBox(height: 18),
                              NotificacaoTabs(
                                tabIndex: _tabIndex,
                                totalNaoLidas: naoLidas.length,
                                totalLidas: lidas.length,
                                onTabChanged: (idx) =>
                                    setState(() => _tabIndex = idx),
                              ),
                              const SizedBox(height: 18),
                              if (_carregando)
                                const Padding(
                                  padding: EdgeInsets.all(48.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Color(0xFF0C6B6B),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Buscando novidades...",
                                          style: TextStyle(
                                            color: Color(0xFF7AAAA0),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else if (_erroConexao)
                                NotificacaoEstadoErro(
                                  isOng: isOng,
                                  onTentarNovamente: _carregarNotificacoes,
                                )
                              else if (listaExibida.isEmpty)
                                NotificacaoEstadoVazio(
                                  isOng: isOng,
                                  isTabNovas: _tabIndex == 0,
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: listaExibida.length,
                                  itemBuilder: (context, index) {
                                    final notif = listaExibida[index];
                                    return NotificacaoCard(
                                      notificacao: notif,
                                      isMobile: isMobile,
                                      onTap: () => _abrirDetalhesNotificacao(
                                        notif,
                                        isMobile,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
