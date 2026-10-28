// lib/voluntarios/perfil/editar_perfil_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../utils/responsive.dart';
import '../../utils/app_data.dart';
import '../../widgets/header/app_header.dart';
import '../models/voluntario_profile_models.dart';
import '../services/voluntario_profile_service.dart';

import 'widgets/editar_perfil_avatar.dart';
import 'widgets/editar_perfil_habilidades_secao.dart';
import 'widgets/editar_perfil_formacao_secao.dart';
import 'widgets/editar_perfil_redes_secao.dart';
import 'widgets/editar_perfil_endereco_secao.dart';
import 'widgets/dialog_editar_habilidades.dart';
import 'widgets/modal_foto_perfil.dart';

class EditarPerfilPage extends StatefulWidget {
  final String usuarioId;
  final String? token;
  final VoluntarioPerfilModel? perfilAtual;

  const EditarPerfilPage({
    super.key,
    required this.usuarioId,
    this.token,
    this.perfilAtual,
  });

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final VoluntarioProfileService _service = VoluntarioProfileService();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nomeController;
  late final TextEditingController _bioController;
  late final TextEditingController _cursoController;
  late final TextEditingController _instagramController;
  late final TextEditingController _facebookController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _cepController;
  late final TextEditingController _ruaController;
  late final TextEditingController _numeroController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _estadoController;

  String _fotoAtualUrl = '';
  List<String> _habilidadesSelecionadas = [];
  String _escolaridadeSelecionada = "Superior";

  final List<String> _opcoesEscolaridade = [
    "Ensino Médio",
    "Técnico",
    "Superior",
  ];

  bool _carregandoInicial = false;
  bool _isLoadingCep = false;
  bool _salvando = false;

  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController();
    _bioController = TextEditingController();
    _cursoController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _linkedinController = TextEditingController();
    _whatsappController = TextEditingController();
    _cepController = TextEditingController();
    _ruaController = TextEditingController();
    _numeroController = TextEditingController();
    _bairroController = TextEditingController();
    _cidadeController = TextEditingController();
    _estadoController = TextEditingController();

    if (widget.perfilAtual != null) {
      _preencherCampos(widget.perfilAtual!);
    } else {
      _carregarPerfilRemoto();
    }
  }

  void _preencherCampos(VoluntarioPerfilModel p) {
    _fotoAtualUrl = p.fotoUrl;
    _habilidadesSelecionadas = List<String>.from(p.habilidades);

    _nomeController.text = p.nome;
    _bioController.text = p.bio;
    _cursoController.text = p.curso;
    _instagramController.text = p.instagram ?? '';
    _facebookController.text = p.facebook ?? '';
    _linkedinController.text = p.linkedin ?? '';
    _whatsappController.text = p.whatsapp ?? '';
    _cepController.text = p.cep;
    _ruaController.text = p.logradouro;
    _numeroController.text = p.numero;
    _bairroController.text = p.bairro;
    _cidadeController.text = p.cidade;
    _estadoController.text = p.estado;

    if (_opcoesEscolaridade.contains(p.escolaridade)) {
      _escolaridadeSelecionada = p.escolaridade;
    }
  }

  Future<void> _carregarPerfilRemoto() async {
    setState(() => _carregandoInicial = true);
    try {
      final res = await _service.buscarPerfil(
        widget.usuarioId,
        token: widget.token,
      );
      if (mounted) {
        setState(() {
          _preencherCampos(res);
          _carregandoInicial = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _carregandoInicial = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _bioController.dispose();
    _cursoController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _whatsappController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return;

    setState(() => _isLoadingCep = true);

    try {
      final res = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'),
      );
      if (res.statusCode == 200) {
        final dados = json.decode(res.body);
        if (dados['erro'] == true) {
          _mostrarSnack("CEP não localizado.", isErro: true);
          return;
        }
        setState(() {
          _ruaController.text = dados['logradouro'] ?? '';
          _bairroController.text = dados['bairro'] ?? '';
          _cidadeController.text = dados['localidade'] ?? '';
          _estadoController.text = dados['uf'] ?? '';
        });
      }
    } catch (_) {
      _mostrarSnack("Erro ao consultar CEP.", isErro: true);
    } finally {
      if (mounted) setState(() => _isLoadingCep = false);
    }
  }

  void _mostrarSnack(String msg, {bool isErro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isErro ? Colors.redAccent : const Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _abrirModalFoto() {
    ModalFotoPerfil.exibir(
      context,
      picker: _picker,
      onImagemUrl: (url) {
        setState(() {
          _fotoAtualUrl = url;
        });
      },
    );
  }

  Future<void> _salvarAlteracoes() async {
    if (_nomeController.text.trim().isEmpty) {
      _mostrarSnack("Por favor, preencha o seu nome.", isErro: true);
      return;
    }
    if (_habilidadesSelecionadas.length < AppData.minHabilidades) {
      _mostrarSnack(
        "Selecione ao menos ${AppData.minHabilidades} habilidades.",
        isErro: true,
      );
      return;
    }

    setState(() => _salvando = true);

    // Payload filtrado contendo apenas campos aceitos pelo UpdateUserDto
    final Map<String, dynamic> payload = {
      "name": _nomeController.text.trim(),
      "bio": _bioController.text.trim(),
      "habilidades": _habilidadesSelecionadas,
    };

    final telefone = _whatsappController.text.trim();
    if (telefone.isNotEmpty) {
      payload["whatsapp"] = telefone;
    }

    if (_fotoAtualUrl.trim().isNotEmpty && _fotoAtualUrl.startsWith('http')) {
      payload["avatar"] = _fotoAtualUrl.trim();
    }

    try {
      await _service.atualizarPerfil(
        widget.usuarioId,
        payload,
        token: widget.token,
      );
      if (!mounted) return;
      setState(() => _salvando = false);
      _mostrarSnack("Perfil atualizado com sucesso!");
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      _mostrarSnack(e.toString().replaceAll("Exception: ", ""), isErro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: Column(
        children: [
          AppHeader(
            usuarioId: widget.usuarioId,
            showBackButton: true,
          ),
          Expanded(
            child: _carregandoInicial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0C6B6B),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 18 : 28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC2E4DC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Editar Meu Perfil",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF062222),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Atualize sua foto, biografia, competências, formação e redes sociais.",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 20),

                              // Avatar
                              EditarPerfilAvatar(
                                fotoAtualUrl: _fotoAtualUrl,
                                novaFotoArquivo: null,
                                onTrocarFoto: _abrirModalFoto,
                                isMobile: isMobile,
                              ),
                              const SizedBox(height: 20),

                              // Nome e Bio
                              _buildField(
                                "Nome Completo",
                                _nomeController,
                              ),
                              const SizedBox(height: 14),
                              _buildField(
                                "Sobre mim (Bio)",
                                _bioController,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 20),

                              // Habilidades
                              EditarPerfilHabilidadesSecao(
                                habilidades: _habilidadesSelecionadas,
                                onEditar: () {
                                  DialogEditarHabilidades.exibir(
                                    context,
                                    habilidadesIniciais:
                                        _habilidadesSelecionadas,
                                    onConfirmar: (novas) {
                                      setState(
                                        () => _habilidadesSelecionadas = novas,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              // Formação
                              EditarPerfilFormacaoSecao(
                                escolaridadeSelecionada:
                                    _escolaridadeSelecionada,
                                opcoesEscolaridade: _opcoesEscolaridade,
                                cursoController: _cursoController,
                                onEscolaridadeChanged: (v) {
                                  if (v != null) {
                                    setState(
                                        () => _escolaridadeSelecionada = v);
                                  }
                                },
                                isMobile: isMobile,
                              ),
                              const SizedBox(height: 20),

                              // Redes Sociais
                              EditarPerfilRedesSecao(
                                instagramController: _instagramController,
                                facebookController: _facebookController,
                                linkedinController: _linkedinController,
                                whatsappController: _whatsappController,
                                telefoneMask: _telefoneMask,
                                isMobile: isMobile,
                              ),
                              const SizedBox(height: 20),

                              // Endereço
                              EditarPerfilEnderecoSecao(
                                cepController: _cepController,
                                ruaController: _ruaController,
                                numeroController: _numeroController,
                                bairroController: _bairroController,
                                cidadeController: _cidadeController,
                                estadoController: _estadoController,
                                cepMask: _cepMask,
                                isLoadingCep: _isLoadingCep,
                                onCepChanged: (v) {
                                  if (v.length >= 9) _buscarCep(v);
                                },
                                isMobile: isMobile,
                              ),
                              const SizedBox(height: 32),

                              // Botões
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _salvando
                                          ? null
                                          : () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        side: const BorderSide(
                                          color: Color(0xFF0C6B6B),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(
                                          color: Color(0xFF0C6B6B),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          _salvando ? null : _salvarAlteracoes,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0C6B6B),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: _salvando
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              "Salvar Alterações",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0FAF7),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
