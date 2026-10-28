// lib/voluntarios/perfil/voluntario_perfil_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../../login/login_page.dart';

import '../models/voluntario_profile_models.dart';
import '../services/voluntario_profile_service.dart';

import 'widgets/perfil_header_banner.dart';
import 'widgets/perfil_metricas_cards.dart';
import 'widgets/perfil_info_card.dart';
import 'widgets/perfil_redes_sociais_card.dart';
import 'widgets/perfil_feed_experiencias.dart';
import 'widgets/modal_foto_perfil.dart';
import 'widgets/modal_nova_experiencia.dart';
import 'widgets/modal_compartilhar_social.dart';

class VoluntarioPerfilPage extends StatefulWidget {
  final String usuarioId;
  final String? usuarioLogadoId;
  final String tipoUsuario;
  final String? token;

  const VoluntarioPerfilPage({
    super.key,
    required this.usuarioId,
    this.usuarioLogadoId,
    this.tipoUsuario = "voluntario",
    this.token,
  });

  @override
  State<VoluntarioPerfilPage> createState() => _VoluntarioPerfilPageState();
}

class _VoluntarioPerfilPageState extends State<VoluntarioPerfilPage> {
  final VoluntarioProfileService _service = VoluntarioProfileService();
  final ImagePicker _picker = ImagePicker();

  VoluntarioPerfilModel? _perfil;
  bool _carregando = true;
  File? _novaFotoPerfilArquivo;

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

  String? get _tokenResolvido =>
      (widget.token != null && widget.token!.trim().isNotEmpty)
          ? widget.token!.trim()
          : SessionService.instance.token;

  bool get _isMeuPerfil {
    final sessaoId = SessionService.instance.usuarioId;
    if (sessaoId != null && sessaoId.trim() == _idResolvido) {
      return true;
    }
    if (widget.usuarioLogadoId != null &&
        widget.usuarioLogadoId!.trim() == _idResolvido) {
      return true;
    }
    return widget.usuarioId == "voluntario-1" || sessaoId == null;
  }

  final List<String> _eventosConcluidos = [
    "Mutirão de Reforço Escolar - Instituto Criança Cidadã",
    "Plantio Comunitário Represa Billings - Ação Verde ABC",
    "Distribuição de Marmitas Solidárias - Prato Cheio ABC",
    "Campanha de Vacinação Pet - Anjos de Quatro Patas",
  ];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  @override
  void didUpdateWidget(covariant VoluntarioPerfilPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.usuarioId != widget.usuarioId ||
        oldWidget.token != widget.token) {
      _carregarPerfil();
    }
  }

  Future<void> _carregarPerfil() async {
    if (!mounted) return;
    setState(() => _carregando = true);

    try {
      final res = await _service.buscarPerfil(
        _idResolvido,
        token: _tokenResolvido,
      );
      if (mounted) {
        setState(() {
          _perfil = res;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _abrirSeletorFotoPerfil() {
    if (!_isMeuPerfil) return;
    ModalFotoPerfil.exibir(
      context,
      picker: _picker,
      onImagemArquivo: (file) async {
        setState(() => _novaFotoPerfilArquivo = file);
        await _service.atualizarPerfil(
          _idResolvido,
          {'avatar': file.path, 'fotoUrl': file.path},
          token: _tokenResolvido,
        );
        if (_perfil != null && mounted) {
          setState(() {
            _perfil = _perfil!.copyWith(fotoUrl: file.path);
          });
        }
      },
      onImagemUrl: (url) async {
        if (_perfil != null) {
          await _service.atualizarPerfil(
            _idResolvido,
            {'avatar': url, 'fotoUrl': url},
            token: _tokenResolvido,
          );
          if (mounted) {
            setState(() {
              _novaFotoPerfilArquivo = null;
              _perfil = _perfil!.copyWith(fotoUrl: url);
            });
          }
        }
      },
    );
  }

  void _abrirModalNovaExperiencia() {
    if (!_isMeuPerfil) return;
    ModalNovaExperiencia.abrir(
      context: context,
      eventosConcluidos: _eventosConcluidos,
      picker: _picker,
      onSolicitarConfirmacao: ({
        required String texto,
        required String origem,
        required File? imagem,
        required BuildContext modalParentContext,
      }) {
        _confirmarEPublicar(
          texto: texto,
          origem: origem,
          imagem: imagem,
          modalParentContext: modalParentContext,
        );
      },
    );
  }

  void _confirmarEPublicar({
    required String texto,
    required String origem,
    required File? imagem,
    required BuildContext modalParentContext,
  }) {
    showDialog(
      context: context,
      builder: (confirmCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirmar publicação?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        content: Text(
          "Sua experiência será publicada no seu mural do ABC do Bem.\n\nOrigem: $origem",
          style: const TextStyle(fontSize: 13, color: Color(0xFF3A6868)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmCtx),
            child: const Text("Revisar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(confirmCtx);
              Navigator.pop(modalParentContext);

              final imagemUrlFinal = imagem != null
                  ? "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600"
                  : null;

              await _service.publicarExperiencia(
                _idResolvido,
                texto,
                imagemUrlFinal,
                token: _tokenResolvido,
              );

              if (!mounted) return;

              final novaExp = ExperienciaFeedModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                ongNome: origem,
                dataFormatada: "Agora mesmo",
                texto: texto,
                imagemUrl: imagemUrlFinal,
                curtidas: 1,
              );

              setState(() {
                _perfil = _perfil?.copyWith(
                  experiencias: [novaExp, ...?_perfil?.experiencias],
                );
              });

              ModalCompartilharSocial.exibir(
                context,
                texto: texto,
                origem: origem,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
            ),
            child: const Text(
              "Sim, publicar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Sair da conta"),
        content: const Text("Deseja realmente desconectar do ABC do Bem?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);

              // Redireciona e remove as rotas anteriores da pilha
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Sair", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final int navIndex = _isMeuPerfil ? 4 : -1;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: isMobile
          ? AppBottomNav(
              currentIndex: navIndex,
              usuarioId: _idResolvido,
              tipoUsuario: widget.tipoUsuario,
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            AppSidebar(
              currentIndex: navIndex,
              usuarioId: _idResolvido,
              tipoUsuario: widget.tipoUsuario,
            ),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: _idResolvido,
                  tipoUsuario: widget.tipoUsuario,
                  nomeUsuario:
                      _perfil?.nome ?? SessionService.instance.nomeUsuario,
                  fotoPerfilUrl: _perfil?.fotoUrl,
                  showBackButton: !_isMeuPerfil,
                  onPerfilAtualizado: _carregarPerfil,
                ),
                Expanded(
                  child: _carregando || _perfil == null
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
                              constraints: const BoxConstraints(maxWidth: 820),
                              child: Column(
                                children: [
                                  PerfilHeaderBanner(
                                    perfil: _perfil!,
                                    novaFotoPerfilArquivo:
                                        _novaFotoPerfilArquivo,
                                    onAlterarFoto: _abrirSeletorFotoPerfil,
                                    onPerfilAtualizado: _carregarPerfil,
                                    isMobile: isMobile,
                                    isMeuPerfil: _isMeuPerfil,
                                    token: _tokenResolvido,
                                  ),
                                  const SizedBox(height: 16),
                                  PerfilMetricasCards(
                                    totalEventos: _perfil!.totalEventos,
                                    totalHoras: _perfil!.totalHoras,
                                    tempoAtivo: _perfil!.tempoAtivo,
                                  ),
                                  const SizedBox(height: 16),
                                  PerfilInfoCard(
                                    titulo: "Sobre mim",
                                    conteudo: Text(
                                      _perfil!.bio.isNotEmpty
                                          ? _perfil!.bio
                                          : "Voluntário atuando na comunidade do Grande ABC.",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF3A6868),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  PerfilInfoCard(
                                    titulo: "Habilidades & Competências",
                                    conteudo: _perfil!.habilidades.isEmpty
                                        ? const Text(
                                            "Nenhuma competência cadastrada.",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7AAAA0),
                                            ),
                                          )
                                        : Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: _perfil!.habilidades
                                                .map((h) => _buildBadge(
                                                      h,
                                                      Icons.palette_outlined,
                                                    ))
                                                .toList(),
                                          ),
                                  ),
                                  const SizedBox(height: 14),
                                  PerfilInfoCard(
                                    titulo: "Disponibilidade no ABC",
                                    conteudo: _perfil!.disponibilidade.isEmpty
                                        ? const Text(
                                            "A combinar com as instituições.",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7AAAA0),
                                            ),
                                          )
                                        : Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: _perfil!.disponibilidade
                                                .map((d) =>
                                                    _buildBadgeDisponibilidade(
                                                        d))
                                                .toList(),
                                          ),
                                  ),
                                  const SizedBox(height: 14),
                                  PerfilRedesSociaisCard(
                                    instagram: _perfil!.instagram,
                                    facebook: _perfil!.facebook,
                                    linkedin: _perfil!.linkedin,
                                    whatsapp: _perfil!.whatsapp,
                                  ),
                                  const SizedBox(height: 24),
                                  PerfilFeedExperiencias(
                                    experiencias: _perfil!.experiencias,
                                    fotoUsuario: _perfil!.fotoUrl,
                                    nomeUsuario: _perfil!.nome,
                                    onPublicarNova: _abrirModalNovaExperiencia,
                                    isMobile: isMobile,
                                    isMeuPerfil: _isMeuPerfil,
                                  ),
                                  const SizedBox(height: 24),
                                  if (_isMeuPerfil) ...[
                                    TextButton(
                                      onPressed: _confirmarLogout,
                                      child: const Text(
                                        "Sair da conta",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                  ] else
                                    const SizedBox(height: 24),
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

  Widget _buildBadge(String texto, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F5F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: const Color(0xFF0C6B6B)),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C6B6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeDisponibilidade(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF9FE8D8)),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF0C6B6B),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
