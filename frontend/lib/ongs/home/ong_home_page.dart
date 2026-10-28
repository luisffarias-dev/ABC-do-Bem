// lib/ongs/home/ong_home_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../eventos/detalhe/evento_detalhe_page.dart';
import '../../voluntarios/perfil/meu_perfil_page.dart';
import '../../ongs/models/ong_dashboard_models.dart';
import '../services/ong_dashboard_service.dart';
import 'widgets/ong_banner_header.dart';
import 'widgets/ong_gestao_rapida_grid.dart';
import 'widgets/ong_candidaturas_section.dart';
import 'widgets/ong_meus_eventos_section.dart';
import 'widgets/ong_necessidades_section.dart';
import 'widgets/modal_editar_necessidades.dart';

class OngHomePage extends StatefulWidget {
  final String ongId;

  const OngHomePage({super.key, this.ongId = "ong-1"});

  @override
  State<OngHomePage> createState() => _OngHomePageState();
}

class _OngHomePageState extends State<OngHomePage> {
  final OngDashboardService _service = OngDashboardService();

  OngDashboardModel? _dashboard;
  bool _carregando = true;
  bool _erroConexao = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erroConexao = false;
    });

    try {
      final dados = await _service.buscarDashboardOng(widget.ongId);
      if (mounted) {
        setState(() {
          _dashboard = dados;
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

  Future<void> _responderCandidatura(
    CandidatoVoluntarioModel candidato,
    bool aprovado,
  ) async {
    await _service.responderCandidatura(candidato.solicitacaoId, aprovado);

    setState(() {
      _dashboard!.candidaturasPendentes
          .removeWhere((c) => c.solicitacaoId == candidato.solicitacaoId);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          aprovado
              ? "Candidatura de ${candidato.nome} aprovada com sucesso!"
              : "Candidatura de ${candidato.nome} recusada.",
        ),
        backgroundColor:
            aprovado ? const Color(0xFF0C6B6B) : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _abrirModalNecessidades() {
    ModalEditarNecessidades.exibir(
      context,
      necessidadesIniciais: _dashboard!.necessidadesAtuais,
      onSalvar: (tempLista) async {
        await _service.atualizarNecessidades(widget.ongId, tempLista);
        setState(() {
          _dashboard = OngDashboardModel(
            id: _dashboard!.id,
            nome: _dashboard!.nome,
            categoria: _dashboard!.categoria,
            cidade: _dashboard!.cidade,
            logoUrl: _dashboard!.logoUrl,
            totalVoluntariosEngajados: _dashboard!.totalVoluntariosEngajados,
            vagasAbertas: _dashboard!.vagasAbertas,
            horasGeradas: _dashboard!.horasGeradas,
            candidaturasPendentesCount: _dashboard!.candidaturasPendentesCount,
            necessidadesAtuais: tempLista,
            candidaturasPendentes: _dashboard!.candidaturasPendentes,
            eventosAtivos: _dashboard!.eventosAtivos,
          );
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Necessidades da instituição atualizadas!"),
            backgroundColor: Color(0xFF0C6B6B),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: isMobile
          ? AppBottomNav(
              currentIndex: 0,
              usuarioId: widget.ongId,
              tipoUsuario: "ong",
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            AppSidebar(
              currentIndex: 0,
              usuarioId: widget.ongId,
              tipoUsuario: "ong",
            ),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: widget.ongId,
                  tipoUsuario: "ong",
                  nomeUsuario: _dashboard?.nome ?? "Instituição Parceira",
                  fotoPerfilUrl: _dashboard?.logoUrl,
                ),
                Expanded(
                  child: _carregando
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0C6B6B),
                          ),
                        )
                      : _erroConexao || _dashboard == null
                          ? _buildErrorState()
                          : SingleChildScrollView(
                              padding: EdgeInsets.all(isMobile ? 14 : 24),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 880),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // 1. Banner com métricas
                                      OngBannerHeader(
                                        dashboard: _dashboard!,
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 18 : 24),

                                      // 2. Ações rápidas
                                      OngGestaoRapidaGrid(
                                        totalCandidaturas: _dashboard!
                                            .candidaturasPendentes.length,
                                        onNovoEvento: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Abrindo tela de criação de evento...",
                                              ),
                                            ),
                                          );
                                        },
                                        onEditarNecessidades:
                                            _abrirModalNecessidades,
                                        onAbrirCandidatos: () {},
                                        onAbrirMensagens: () {},
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 22 : 30),

                                      // 3. Aprovações de Voluntários
                                      OngCandidaturasSection(
                                        candidaturas:
                                            _dashboard!.candidaturasPendentes,
                                        onResponder: _responderCandidatura,
                                        onVerPerfil: (vId) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MeuPerfilPage(
                                                usuarioId: vId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: isMobile ? 22 : 30),

                                      // 4. Meus Eventos Ativos
                                      OngMeusEventosSection(
                                        eventos: _dashboard!.eventosAtivos,
                                        onEditarEvento: (evId) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EventoDetalhePage(
                                                eventoId: evId,
                                                usuarioAtualId: widget.ongId,
                                                isOng: true,
                                              ),
                                            ),
                                          );
                                        },
                                        onGerenciarTodos: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Acessando painel completo de eventos...",
                                              ),
                                            ),
                                          );
                                        },
                                        isMobile: isMobile,
                                      ),
                                      SizedBox(height: isMobile ? 22 : 30),

                                      // 5. Necessidades e Doações
                                      OngNecessidadesSection(
                                        necessidades:
                                            _dashboard!.necessidadesAtuais,
                                        onEditar: _abrirModalNecessidades,
                                      ),
                                      const SizedBox(height: 36),
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
      padding: const EdgeInsets.all(36),
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
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            "Erro ao carregar o painel da ONG",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Verifique sua conexão e tente novamente.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
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
