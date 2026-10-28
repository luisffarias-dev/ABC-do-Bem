// lib/voluntarios/buscar/buscar_ongs_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../eventos/detalhe/evento_detalhe_page.dart';
import '../../ongs/perfil/ong_perfil_page.dart';
import '../perfil/meu_perfil_page.dart';

import 'models/resultado_busca_model.dart';
import 'services/busca_hub_service.dart';
import 'widgets/busca_hub_header_filter.dart';
import 'widgets/busca_resultado_card.dart';
import 'widgets/busca_hub_feedback_states.dart';

class BuscarOngsPage extends StatefulWidget {
  final String voluntarioId;

  const BuscarOngsPage({
    super.key,
    this.voluntarioId = "voluntario-1",
  });

  @override
  State<BuscarOngsPage> createState() => _BuscarOngsPageState();
}

class _BuscarOngsPageState extends State<BuscarOngsPage> {
  final BuscaHubService _service = BuscaHubService();
  final TextEditingController _buscaController = TextEditingController();

  String _abaSelecionada = "Tudo";
  bool _carregando = true;
  bool _erroConexao = false;
  List<ResultadoBuscaItem> _todosResultados = [];

  String get _idResolvido {
    if (widget.voluntarioId.trim().isNotEmpty &&
        widget.voluntarioId != "voluntario-1") {
      return widget.voluntarioId.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return widget.voluntarioId.trim();
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erroConexao = false;
    });

    try {
      final res = await _service.buscarTodos();
      if (mounted) {
        setState(() {
          _todosResultados = res;
          _carregando = false;
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

  void _aoClicarItem(ResultadoBuscaItem item) {
    switch (item.tipo) {
      case TipoResultadoBusca.ong:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OngPerfilPage(
              ongId: item.id,
              voluntarioId: _idResolvido,
              tipoUsuario: "voluntario",
            ),
          ),
        );
        break;

      case TipoResultadoBusca.voluntario:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeuPerfilPage(
              usuarioId: item.id,
              token: SessionService.instance.token,
            ),
          ),
        );
        break;

      case TipoResultadoBusca.evento:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventoDetalhePage(
              eventoId: item.id,
              usuarioAtualId: _idResolvido,
              voluntarioId: _idResolvido,
              isOng: false,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final String idAtivo = _idResolvido;

    // Filtragem polimórfica (por texto e por aba)
    final resultadosFiltrados = _todosResultados.where((item) {
      // 1. Filtro da Aba
      bool matchAba = true;
      if (_abaSelecionada == "ONGs") {
        matchAba = item.tipo == TipoResultadoBusca.ong;
      } else if (_abaSelecionada == "Eventos") {
        matchAba = item.tipo == TipoResultadoBusca.evento;
      } else if (_abaSelecionada == "Voluntários") {
        matchAba = item.tipo == TipoResultadoBusca.voluntario;
      }

      // 2. Filtro Textual
      final termo = _buscaController.text.trim().toLowerCase();
      final matchTexto = termo.isEmpty ||
          item.tituloPrincipal.toLowerCase().contains(termo) ||
          item.subtitulo.toLowerCase().contains(termo) ||
          item.tagOuCategoria.toLowerCase().contains(termo);

      return matchAba && matchTexto;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: isMobile
          ? AppBottomNav(
              currentIndex: 1,
              usuarioId: idAtivo,
              tipoUsuario: "voluntario",
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            AppSidebar(
              currentIndex: 1,
              usuarioId: idAtivo,
              tipoUsuario: "voluntario",
            ),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: idAtivo,
                  tipoUsuario: "voluntario",
                  nomeUsuario: SessionService.instance.nomeUsuario,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 860),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            BuscaHubHeaderFilter(
                              controller: _buscaController,
                              abaAtiva: _abaSelecionada,
                              onAbaAlterada: (aba) =>
                                  setState(() => _abaSelecionada = aba),
                              onBuscaAlterada: (_) => setState(() {}),
                              isMobile: isMobile,
                            ),
                            SizedBox(height: isMobile ? 18 : 24),
                            if (_carregando)
                              const Padding(
                                padding: EdgeInsets.all(48.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0C6B6B),
                                  ),
                                ),
                              )
                            else if (_erroConexao)
                              BuscaHubErrorState(
                                onTentarNovamente: _carregarDados,
                              )
                            else if (resultadosFiltrados.isEmpty)
                              BuscaHubEmptyState(
                                onLimpar: () {
                                  setState(() {
                                    _abaSelecionada = "Tudo";
                                    _buscaController.clear();
                                  });
                                },
                              )
                            else ...[
                              Text(
                                "${resultadosFiltrados.length} resultados encontrados",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3A6868),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: resultadosFiltrados.length,
                                itemBuilder: (context, index) {
                                  final item = resultadosFiltrados[index];
                                  return BuscaResultadoCard(
                                    item: item,
                                    onTap: () => _aoClicarItem(item),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                            ],
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
}
