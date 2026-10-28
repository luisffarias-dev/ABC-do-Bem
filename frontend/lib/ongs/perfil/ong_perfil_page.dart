// lib/ongs/perfil/ong_perfil_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../../mensagens/mensagens_page.dart';
import '../../eventos/detalhe/evento_detalhe_page.dart';
import '../models/ong_detail_models.dart';
import '../../services/ong_detail_service.dart';

import 'widgets/ong_perfil_header.dart';
import 'widgets/ong_perfil_metricas_cards.dart';
import 'widgets/ong_perfil_oportunidades_section.dart';
import 'widgets/ong_perfil_necessidades_section.dart';
import 'widgets/ong_perfil_localizacao_section.dart';
import 'widgets/ong_perfil_feed_section.dart';

class OngPerfilPage extends StatefulWidget {
  final String ongId;
  final String voluntarioId;
  final String tipoUsuario; // "ong" ou "voluntario"

  const OngPerfilPage({
    super.key,
    required this.ongId,
    required this.voluntarioId,
    this.tipoUsuario = "voluntario",
  });

  @override
  State<OngPerfilPage> createState() => _OngPerfilPageState();
}

class _OngPerfilPageState extends State<OngPerfilPage> {
  final OngDetailService _service = OngDetailService();

  OngDetalheModel? _ong;
  bool _carregando = true;
  bool _alternandoSeguir = false;

  bool get isOng => widget.tipoUsuario.trim().toLowerCase() == "ong";

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

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    final dados = await _service.buscarDetalhesOng(
      widget.ongId,
      voluntarioId: _idResolvido,
    );
    if (mounted) {
      setState(() {
        _ong = dados;
        _carregando = false;
      });
    }
  }

  Future<void> _toggleSeguir() async {
    if (_ong == null || _alternandoSeguir) return;
    setState(() => _alternandoSeguir = true);

    final novoStatus = await _service.alternarSeguirOng(
      _ong!.id,
      _idResolvido,
      _ong!.isSeguindo,
    );

    if (mounted) {
      setState(() {
        _alternandoSeguir = false;
        _ong = OngDetalheModel(
          id: _ong!.id,
          nome: _ong!.nome,
          categoria: _ong!.categoria,
          cidade: _ong!.cidade,
          estado: _ong!.estado,
          enderecoCompleto: _ong!.enderecoCompleto,
          logoUrl: _ong!.logoUrl,
          bannerUrl: _ong!.bannerUrl,
          sobre: _ong!.sobre,
          voluntariosAtivos: _ong!.voluntariosAtivos,
          eventosRealizados: _ong!.eventosRealizados,
          anosAtuacao: _ong!.anosAtuacao,
          totalSeguidores: novoStatus
              ? _ong!.totalSeguidores + 1
              : (_ong!.totalSeguidores - 1).clamp(0, 999999),
          isSeguindo: novoStatus,
          necessidadesUrgentes: _ong!.necessidadesUrgentes,
          instagram: _ong!.instagram,
          facebook: _ong!.facebook,
          linkedin: _ong!.linkedin,
          whatsapp: _ong!.whatsapp,
          telefone: _ong!.telefone,
          oportunidadesAbertas: _ong!.oportunidadesAbertas,
          publicacoes: _ong!.publicacoes,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            novoStatus
                ? "Você agora segue ${_ong!.nome}! Notificaremos você de novas vagas."
                : "Você deixou de seguir ${_ong!.nome}.",
          ),
          backgroundColor: const Color(0xFF0C6B6B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _abrirChatComOng() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MensagensPage(
          usuarioId: _idResolvido,
          tipoUsuario: widget.tipoUsuario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final int navIndex = isOng ? 4 : 1;
    final String idAtivo = isOng ? widget.ongId : _idResolvido;

    return Scaffold(
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
                  nomeUsuario:
                      SessionService.instance.nomeUsuario ?? _ong?.nome,
                  fotoPerfilUrl: _ong?.logoUrl,
                  showBackButton: true,
                ),
                Expanded(
                  child: _carregando || _ong == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0C6B6B),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 24,
                            vertical: 16,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 860),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // 1. Header (Banner, Logo, Redes, Botões)
                                  OngPerfilHeader(
                                    ong: _ong!,
                                    isOng: isOng,
                                    isMobile: isMobile,
                                    onToggleSeguir: _toggleSeguir,
                                    onConversar: _abrirChatComOng,
                                    onEditarDados: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Abrindo edição institucional..."),
                                        ),
                                      );
                                    },
                                    onCriarEvento: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Abrindo criação de evento..."),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // 2. Métricas
                                  OngPerfilMetricasCards(
                                    voluntariosAtivos: _ong!.voluntariosAtivos,
                                    eventosRealizados: _ong!.eventosRealizados,
                                    anosAtuacao: _ong!.anosAtuacao,
                                  ),
                                  const SizedBox(height: 16),

                                  // 3. Oportunidades e Eventos Abertos
                                  OngPerfilOportunidadesSection(
                                    oportunidades: _ong!.oportunidadesAbertas,
                                    onVerEvento: (op) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EventoDetalhePage(
                                            eventoId: op.id,
                                            usuarioAtualId: _idResolvido,
                                            voluntarioId: _idResolvido,
                                            isOng: false,
                                          ),
                                        ),
                                      );
                                    },
                                    isMobile: isMobile,
                                  ),
                                  const SizedBox(height: 16),

                                  // 4. Sobre a Instituição
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFC2E4DC),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Sobre a Instituição",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF062222),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _ong!.sobre.isNotEmpty
                                              ? _ong!.sobre
                                              : "Instituição atuante na promoção de impacto social no Grande ABC.",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF3A6868),
                                            height: 1.45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // 5. Necessidades e Doações
                                  OngPerfilNecessidadesSection(
                                    necessidades: _ong!.necessidadesUrgentes,
                                  ),
                                  const SizedBox(height: 16),

                                  // 6. Sede e Localização
                                  OngPerfilLocalizacaoSection(
                                    enderecoCompleto: _ong!.enderecoCompleto,
                                    cidade: _ong!.cidade,
                                    isMobile: isMobile,
                                  ),
                                  const SizedBox(height: 24),

                                  // 7. Feed com Relatos Recentes
                                  OngPerfilFeedSection(
                                    publicacoes: _ong!.publicacoes,
                                    ongNome: _ong!.nome,
                                    logoUrl: _ong!.logoUrl,
                                    isMobile: isMobile,
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
}
