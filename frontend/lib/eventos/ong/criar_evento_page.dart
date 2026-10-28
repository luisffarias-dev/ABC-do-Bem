// lib/eventos/ong/criar_evento_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../models/evento_model.dart';
import '../services/evento_service.dart';

import 'widgets/criar_evento_secao_basica.dart';
import 'widgets/criar_evento_secao_localizacao.dart';
import 'widgets/criar_evento_secao_logistica.dart';
import 'widgets/criar_evento_secao_detalhes.dart';

class CriarEventoPage extends StatefulWidget {
  final String ongId;
  final String ongNome;

  const CriarEventoPage({
    super.key,
    this.ongId = "ong-1",
    this.ongNome = "Instituto ABC Solidário",
  });

  @override
  State<CriarEventoPage> createState() => _CriarEventoPageState();
}

class _CriarEventoPageState extends State<CriarEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final EventoService _eventoService = EventoService();

  // Controladores
  final _tituloCtrl = TextEditingController();
  final _imagemUrlCtrl = TextEditingController();
  final _localNomeCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();
  final _comoChegarCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _horarioCtrl = TextEditingController();
  final _vagasCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _tagInputCtrl = TextEditingController();
  final _necessidadeInputCtrl = TextEditingController();

  // Seleções
  String _categoriaSelecionada = "Educação";
  String _cidadeSelecionada = "Santo André";
  bool _salvando = false;

  final List<String> _categorias = [
    "Educação",
    "Meio Ambiente",
    "Saúde",
    "Cultura",
    "Habitação",
    "Assistência Social",
  ];

  final List<String> _cidadesABC = [
    "Santo André",
    "São Bernardo do Campo",
    "São Caetano do Sul",
    "Mauá",
    "Diadema",
    "Ribeirão Pires",
    "Rio Grande da Serra",
  ];

  final List<String> _tags = [];
  final List<String> _necessidades = [];

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _imagemUrlCtrl.dispose();
    _localNomeCtrl.dispose();
    _enderecoCtrl.dispose();
    _comoChegarCtrl.dispose();
    _dataCtrl.dispose();
    _horarioCtrl.dispose();
    _vagasCtrl.dispose();
    _descricaoCtrl.dispose();
    _tagInputCtrl.dispose();
    _necessidadeInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0C6B6B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF062222),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dataCtrl.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _adicionarTag() {
    final text = _tagInputCtrl.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagInputCtrl.clear();
      });
    }
  }

  void _adicionarNecessidade() {
    final text = _necessidadeInputCtrl.text.trim();
    if (text.isNotEmpty && !_necessidades.contains(text)) {
      setState(() {
        _necessidades.add(text);
        _necessidadeInputCtrl.clear();
      });
    }
  }

  Future<void> _salvarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    DateTime dataParsed;
    try {
      final partes = _dataCtrl.text.trim().split('/');
      dataParsed = DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );
    } catch (_) {
      dataParsed = DateTime.now().add(const Duration(days: 1));
    }

    final String local = _localNomeCtrl.text.trim();
    final String end = _enderecoCtrl.text.trim();
    final String dicas = _comoChegarCtrl.text.trim();
    final String enderecoFormatado = [
      if (local.isNotEmpty) local,
      if (end.isNotEmpty) end,
      if (dicas.isNotEmpty) "(Ref: $dicas)",
    ].join(' - ');

    final novoEventoDto = CriarEventoDTO(
      ongId: widget.ongId,
      ongNome: widget.ongNome,
      titulo: _tituloCtrl.text.trim(),
      categoria: _categoriaSelecionada,
      descricao: _descricaoCtrl.text.trim(),
      cidade: _cidadeSelecionada,
      endereco:
          enderecoFormatado.trim().isEmpty ? '' : enderecoFormatado.trim(),
      data: _dataCtrl.text.trim(),
      horario: _horarioCtrl.text.trim(),
      dataHoraInicio: dataParsed,
      imagemUrl: _imagemUrlCtrl.text.trim(),
      tags: _tags.isEmpty ? [_categoriaSelecionada] : _tags,
      vagasTotais: int.parse(_vagasCtrl.text.trim()),
      necessidades: _necessidades,
    );

    try {
      await _eventoService.criarEvento(novoEventoDto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ação voluntária publicada com sucesso!"),
            backgroundColor: Color(0xFF0C6B6B),
          ),
        );
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao publicar evento. Tente novamente."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: Row(
        children: [
          if (isDesktop) AppSidebar(currentIndex: 2, usuarioId: widget.ongId),
          Expanded(
            child: Column(
              children: [
                AppHeader(usuarioId: widget.ongId, showBackButton: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Color(0xFF0C6B6B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Abrir Nova Ação Voluntária",
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF062222),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CriarEventoSecaoBasica(
                                tituloCtrl: _tituloCtrl,
                                imagemUrlCtrl: _imagemUrlCtrl,
                                categoriaSelecionada: _categoriaSelecionada,
                                categoriasDisponiveis: _categorias,
                                onCategoriaChanged: (val) {
                                  if (val != null) {
                                    setState(() => _categoriaSelecionada = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              CriarEventoSecaoLocalizacao(
                                localNomeCtrl: _localNomeCtrl,
                                enderecoCtrl: _enderecoCtrl,
                                comoChegarCtrl: _comoChegarCtrl,
                                cidadeSelecionada: _cidadeSelecionada,
                                cidadesABC: _cidadesABC,
                                onCidadeChanged: (val) {
                                  if (val != null) {
                                    setState(() => _cidadeSelecionada = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              CriarEventoSecaoLogistica(
                                dataCtrl: _dataCtrl,
                                horarioCtrl: _horarioCtrl,
                                vagasCtrl: _vagasCtrl,
                                onSelectData: _selecionarData,
                              ),
                              const SizedBox(height: 16),
                              CriarEventoSecaoDetalhes(
                                descricaoCtrl: _descricaoCtrl,
                                tagInputCtrl: _tagInputCtrl,
                                necessidadeInputCtrl: _necessidadeInputCtrl,
                                tagsSelecionadas: _tags,
                                necessidades: _necessidades,
                                onAddTag: _adicionarTag,
                                onRemoveTag: (t) =>
                                    setState(() => _tags.remove(t)),
                                onAddNecessidade: _adicionarNecessidade,
                                onRemoveNecessidade: (n) =>
                                    setState(() => _necessidades.remove(n)),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _salvando ? null : _salvarEvento,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0C6B6B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _salvando
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Publicar Ação Voluntária",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
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
