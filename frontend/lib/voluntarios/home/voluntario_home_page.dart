// lib/voluntarios/home/voluntario_home_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../eventos/voluntario/eventos_page.dart';
import '../../eventos/detalhe/evento_detalhe_page.dart';
import '../../ongs/perfil/ong_perfil_page.dart';
import '../perfil/meu_perfil_page.dart';
import '../../models/dashboard_volunteer_models.dart';
import '../../../eventos/models/evento_model.dart';
import '../../services/dashboard_volunteer_service.dart';
import '../buscar/buscar_ongs_page.dart';
import 'widgets/home_welcome_banner.dart';
import 'widgets/home_impact_gallery_section.dart';
import 'widgets/home_recomendados_section.dart';
import 'widgets/home_quem_seguir_section.dart';
import 'widgets/home_feed_comunidade_section.dart';

class VoluntarioHomePage extends StatefulWidget {
  final String voluntarioId;
  final String? nomeUsuario;
  final String? token;

  const VoluntarioHomePage({
    super.key,
    required this.voluntarioId,
    this.nomeUsuario,
    this.token,
  });

  @override
  State<VoluntarioHomePage> createState() => _VoluntarioHomePageState();
}

class _VoluntarioHomePageState extends State<VoluntarioHomePage> {
  final DashboardService _dashboardService = DashboardService();
  final PageController _impactPageController = PageController();

  bool _carregando = true;
  bool _erroConexao = false;
  VoluntarioDashboardModel? _dashboard;
  int _currentImpactPage = 0;

  // Inicia vazia: novos voluntários não possuem eventos cadastrados até se inscreverem
  final List<EventoModel> _meusEventosCadastrados = [];

  final List<Map<String, dynamic>> _sugestoesParaSeguir = [
    {
      "id": "1",
      "nome": "Instituto Criança Cidadã",
      "tipo": "ONG",
      "subtitulo": "Educação • Santo André",
      "foto":
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
      "seguindo": false,
    },
    {
      "id": "vol-2",
      "nome": "Carlos Eduardo Lima",
      "tipo": "Voluntário",
      "subtitulo": "Ativo há 3 anos • 42 eventos",
      "foto":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
      "seguindo": false,
    },
  ];

  final List<Map<String, dynamic>> _postagensRelevantes = [
    {
      "autor": "Instituto Criança Cidadã",
      "tipoAutor": "ONG",
      "autorId": "1",
      "fotoAutor":
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
      "tempo": "Há 2 horas",
      "texto":
          "Finalizamos hoje a entrega de kits escolares! Obrigado aos voluntários.",
      "imagemPost":
          "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800",
      "curtidas": 38,
      "comentarios": 7,
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _impactPageController.dispose();
    super.dispose();
  }

  String _resolverNomeUsuario() {
    if (widget.nomeUsuario != null && widget.nomeUsuario!.trim().isNotEmpty) {
      return widget.nomeUsuario!.trim();
    }
    if (SessionService.instance.nomeUsuario != null &&
        SessionService.instance.nomeUsuario!.trim().isNotEmpty) {
      return SessionService.instance.nomeUsuario!.trim();
    }
    return "Voluntário";
  }

  String _resolverIdUsuario() {
    if (widget.voluntarioId.trim().isNotEmpty &&
        widget.voluntarioId != 'voluntario-1') {
      return widget.voluntarioId.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return widget.voluntarioId.trim();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erroConexao = false;
    });

    final String idUsuario = _resolverIdUsuario();
    final String nomeReal = _resolverNomeUsuario();

    try {
      final dados = await _dashboardService.buscarDashboard(idUsuario);

      if (mounted) {
        setState(() {
          _dashboard = VoluntarioDashboardModel(
            voluntarioId: idUsuario,
            nome: nomeReal,
            fotoUrl: dados.fotoUrl.isNotEmpty
                ? dados.fotoUrl
                : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400",
            cidade: dados.cidade.isNotEmpty ? dados.cidade : "Mauá",
            metricas: dados.metricas,
            proximoEvento: dados.proximoEvento,
          );
          _carregando = false;
        });
      }
    } catch (_) {
      try {
        final mockDados =
            await _dashboardService.buscarDashboard("voluntario-1");
        if (mounted) {
          setState(() {
            _dashboard = VoluntarioDashboardModel(
              voluntarioId: idUsuario,
              nome: nomeReal,
              fotoUrl: mockDados.fotoUrl,
              cidade: "Mauá",
              metricas: mockDados.metricas,
              proximoEvento: mockDados.proximoEvento,
            );
            _carregando = false;
            _erroConexao = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _carregando = false;
            _erroConexao = true;
          });
        }
      }
    }
  }

  void _abrirDetalhesEvento(String eventoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventoDetalhePage(
          eventoId: eventoId,
          usuarioAtualId: _resolverIdUsuario(),
          voluntarioId: _resolverIdUsuario(),
          isOng: false,
        ),
      ),
    );
  }

  void _aoClicarPerfil(Map<String, dynamic> item) {
    if (item["tipo"] == "ONG") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OngPerfilPage(
            ongId: item["id"] as String,
            voluntarioId: _resolverIdUsuario(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MeuPerfilPage(
            usuarioId: item["id"] as String,
            token: widget.token ?? SessionService.instance.token,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final String idAtivo = _resolverIdUsuario();
    final String nomeExibicao = _resolverNomeUsuario();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar:
          isMobile ? AppBottomNav(currentIndex: 0, usuarioId: idAtivo) : null,
      body: Row(
        children: [
          if (isDesktop) AppSidebar(currentIndex: 0, usuarioId: idAtivo),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: idAtivo,
                  tipoUsuario: "voluntario",
                  nomeUsuario: nomeExibicao,
                  fotoPerfilUrl: _dashboard?.fotoUrl,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 880),
                        child: _carregando
                            ? const Padding(
                                padding: EdgeInsets.all(80.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0C6B6B),
                                  ),
                                ),
                              )
                            : _erroConexao
                                ? _buildErrorState()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      HomeWelcomeBanner(
                                        dashboard: _dashboard!,
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 20 : 28),
                                      if (_meusEventosCadastrados
                                          .isNotEmpty) ...[
                                        HomeImpactGallerySection(
                                          eventos: _meusEventosCadastrados,
                                          pageController: _impactPageController,
                                          currentPage: _currentImpactPage,
                                          onPageChanged: (idx) => setState(
                                              () => _currentImpactPage = idx),
                                          onAbrirDetalhes: _abrirDetalhesEvento,
                                          onVerTodos: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const EventosPage(),
                                              ),
                                            );
                                          },
                                          isMobile: isMobile,
                                        ),
                                        SizedBox(height: isMobile ? 22 : 30),
                                      ],
                                      if (_dashboard?.proximoEvento !=
                                          null) ...[
                                        HomeRecomendadosSection(
                                          evento: _dashboard!.proximoEvento,
                                          onAbrirDetalhes: _abrirDetalhesEvento,
                                          onVerTodos: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const EventosPage(),
                                              ),
                                            );
                                          },
                                          isMobile: isMobile,
                                        ),
                                        SizedBox(height: isMobile ? 22 : 30),
                                      ],
                                      HomeQuemSeguirSection(
                                        perfis: _sugestoesParaSeguir,
                                        onPerfilTap: _aoClicarPerfil,
                                        onToggleSeguir: (idx) {
                                          setState(() {
                                            _sugestoesParaSeguir[idx]
                                                    ["seguindo"] =
                                                !(_sugestoesParaSeguir[idx]
                                                    ["seguindo"] as bool);
                                          });
                                        },
                                        onVerOngs: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const BuscarOngsPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: isMobile ? 22 : 30),
                                      HomeFeedComunidadeSection(
                                        postagens: _postagensRelevantes,
                                        onAutorTap: _aoClicarPerfil,
                                        isMobile: isMobile,
                                      ),
                                      const SizedBox(height: 32),
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
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: Colors.redAccent,
            size: 36,
          ),
          const SizedBox(height: 10),
          const Text(
            "Não foi possível carregar seu painel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Verifique sua conexão e tente novamente.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _carregarDados,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
            ),
            child: const Text(
              "Tentar novamente",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
