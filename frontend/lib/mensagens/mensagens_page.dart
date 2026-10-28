// lib/mensagens/mensagens_page.dart

import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../services/session_service.dart';
import '../widgets/header/app_header.dart';
import '../widgets/sidebar/app_sidebar.dart';
import '../widgets/bottom_nav/app_bottom_nav.dart';
import '../mensagens/models/chat_models.dart';
import '../mensagens/services/chat_service.dart';

import 'widgets/chat_lista_conversas.dart';
import 'widgets/chat_janela.dart';

class MensagensPage extends StatefulWidget {
  final String tipoUsuario; // 'voluntario' ou 'ong'
  final String usuarioId;

  const MensagensPage({
    super.key,
    this.tipoUsuario = 'voluntario',
    this.usuarioId = 'meu_id',
  });

  @override
  State<MensagensPage> createState() => _MensagensPageState();
}

class _MensagensPageState extends State<MensagensPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _mensagemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatConversation> _conversas = [];
  ChatConversation? _conversaSelecionada;
  List<ChatMessage> _mensagensAtuais = [];

  bool _carregandoConversas = true;
  bool _carregandoMensagens = false;
  String _filtroBusca = "";

  String get _idResolvido {
    if (widget.usuarioId.trim().isNotEmpty &&
        widget.usuarioId != 'meu_id' &&
        widget.usuarioId != 'voluntario-1') {
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
    _carregarListaConversas();
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _carregarListaConversas() async {
    setState(() => _carregandoConversas = true);
    try {
      final resultado = await _chatService.buscarConversas(
        usuarioId: _idResolvido,
        tipoUsuario: widget.tipoUsuario,
      );

      if (!mounted) return;
      setState(() {
        _conversas = resultado;
        _carregandoConversas = false;
      });

      final isDesktop = Responsive.isDesktop(context);
      if (isDesktop && _conversas.isNotEmpty && _conversaSelecionada == null) {
        _selecionarConversa(_conversas.first);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoConversas = false);
      _mostrarAlertaErro("Não foi possível carregar as conversas.");
    }
  }

  Future<void> _selecionarConversa(ChatConversation conversa) async {
    setState(() {
      _conversaSelecionada = conversa;
      _carregandoMensagens = true;
      conversa.naoLidas = 0;
    });

    _chatService.marcarComoLida(conversa.interlocutorId);

    try {
      final msgs = await _chatService.buscarMensagens(conversa.interlocutorId);
      if (!mounted) return;
      setState(() {
        _mensagensAtuais = msgs;
        _carregandoMensagens = false;
      });
      _rolarParaOFim();
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoMensagens = false);
      _mostrarAlertaErro("Erro ao carregar mensagens desta conversa.");
    }
  }

  Future<void> _enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty || _conversaSelecionada == null) return;

    _mensagemController.clear();

    try {
      final novaMsg = await _chatService.enviarMensagem(
        conversaId: _conversaSelecionada!.id,
        remetenteId: _idResolvido,
        texto: texto,
      );

      if (!mounted) return;
      setState(() {
        _mensagensAtuais.add(novaMsg);
        _conversaSelecionada!.ultimaMensagem = novaMsg;
      });

      _rolarParaOFim();
    } catch (e) {
      if (!mounted) return;
      _mostrarAlertaErro("Falha ao enviar mensagem. Tente novamente.");
    }
  }

  void _rolarParaOFim() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _mostrarAlertaErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _tratarAcaoVoltar() {
    if (_conversaSelecionada != null && !Responsive.isDesktop(context)) {
      setState(() => _conversaSelecionada = null);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final String idAtivo = _idResolvido;

    final conversasFiltradas = _conversas.where((c) {
      return c.interlocutorNome.toLowerCase().contains(
                _filtroBusca.toLowerCase(),
              ) ||
          c.interlocutorSubtitulo.toLowerCase().contains(
                _filtroBusca.toLowerCase(),
              );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        bottomNavigationBar: (isMobile && _conversaSelecionada == null)
            ? AppBottomNav(
                currentIndex: 3,
                usuarioId: idAtivo,
                tipoUsuario: widget.tipoUsuario,
              )
            : null,
        body: Row(
          children: [
            if (isDesktop)
              AppSidebar(
                currentIndex: 3,
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
                    showBackButton: _conversaSelecionada != null && isMobile,
                    onVoltar: _tratarAcaoVoltar,
                  ),
                  Expanded(
                    child: _carregandoConversas
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0C6B6B),
                            ),
                          )
                        : isDesktop
                            ? _buildDesktopLayout(conversasFiltradas)
                            : _buildMobileLayout(conversasFiltradas),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(List<ChatConversation> conversas) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 320,
              child: ChatListaConversas(
                conversas: conversas,
                conversaSelecionada: _conversaSelecionada,
                tipoUsuario: widget.tipoUsuario,
                isMobile: false,
                onBuscaChanged: (val) => setState(() => _filtroBusca = val),
                onSelecionarConversa: _selecionarConversa,
                onRecarregar: _carregarListaConversas,
              ),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFC2E4DC)),
            Expanded(
              child: _conversaSelecionada == null
                  ? Center(
                      child: Text(
                        widget.tipoUsuario == 'ong'
                            ? "Selecione um voluntário para conversar"
                            : "Selecione uma instituição para conversar",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : ChatJanela(
                      conversa: _conversaSelecionada!,
                      mensagens: _mensagensAtuais,
                      carregandoMensagens: _carregandoMensagens,
                      usuarioId: _idResolvido,
                      isMobile: false,
                      scrollController: _scrollController,
                      mensagemController: _mensagemController,
                      onVoltarMobile: () {},
                      onEnviarMensagem: _enviarMensagem,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<ChatConversation> conversas) {
    if (_conversaSelecionada != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          setState(() => _conversaSelecionada = null);
        },
        child: ChatJanela(
          conversa: _conversaSelecionada!,
          mensagens: _mensagensAtuais,
          carregandoMensagens: _carregandoMensagens,
          usuarioId: _idResolvido,
          isMobile: true,
          scrollController: _scrollController,
          mensagemController: _mensagemController,
          onVoltarMobile: () => setState(() => _conversaSelecionada = null),
          onEnviarMensagem: _enviarMensagem,
        ),
      );
    }

    return ChatListaConversas(
      conversas: conversas,
      conversaSelecionada: null,
      tipoUsuario: widget.tipoUsuario,
      isMobile: true,
      onBuscaChanged: (val) => setState(() => _filtroBusca = val),
      onSelecionarConversa: _selecionarConversa,
      onRecarregar: _carregarListaConversas,
    );
  }
}
