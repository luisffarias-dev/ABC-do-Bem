// lib/ongs/painel_geral/painel_geral_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import 'widgets/painel_header.dart';
import 'widgets/secao_dashboard_impacto.dart';
import 'widgets/secao_gestao_acoes.dart';
import 'widgets/secao_voluntarios_destaque.dart';
import 'widgets/secao_metas_campanhas.dart';
import 'widgets/secao_itens_suprimentos.dart';
import 'widgets/secao_feed_comunitario.dart';
import 'widgets/secao_operacoes_adicionais.dart';

class OngPainelGeralPage extends StatefulWidget {
  final String ongId;
  final String tipoUsuario;

  const OngPainelGeralPage({
    super.key,
    required this.ongId,
    this.tipoUsuario = "ong",
  });

  @override
  State<OngPainelGeralPage> createState() => _OngPainelGeralPageState();
}

class _OngPainelGeralPageState extends State<OngPainelGeralPage> {
  final bool _carregando = false;

  void _navegarAcao(String rotaNome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Acessando: $rotaNome"),
        backgroundColor: const Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        bottomNavigationBar: isMobile
            ? AppBottomNav(
                currentIndex: 4,
                usuarioId: widget.ongId,
                tipoUsuario: widget.tipoUsuario,
              )
            : null,
        body: Row(
          children: [
            if (isDesktop)
              AppSidebar(
                currentIndex: 4,
                usuarioId: widget.ongId,
                tipoUsuario: widget.tipoUsuario,
              ),
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    usuarioId: widget.ongId,
                    tipoUsuario: widget.tipoUsuario,
                    nomeUsuario: "Instituto Criança Cidadã",
                    fotoPerfilUrl:
                        "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400",
                    showBackButton: false,
                  ),
                  Expanded(
                    child: _carregando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0C6B6B),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 24,
                              vertical: isMobile ? 14 : 20,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 880),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    PainelHeader(isMobile: isMobile),
                                    const SizedBox(height: 16),
                                    SecaoDashboardImpacto(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoGestaoAcoes(
                                      ongId: widget.ongId,
                                      tipoUsuario: widget.tipoUsuario,
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                      onEventoCriado: () => setState(() {}),
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoVoluntariosDestaque(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoMetasCampanhas(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoItensSuprimentos(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoFeedComunitario(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
                                    ),
                                    const SizedBox(height: 16),
                                    SecaoOperacoesAdicionais(
                                      isMobile: isMobile,
                                      onNavegar: _navegarAcao,
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
      ),
    );
  }
}
