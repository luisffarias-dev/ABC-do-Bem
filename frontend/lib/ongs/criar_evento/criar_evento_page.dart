// lib/ongs/criar_evento/criar_evento_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../utils/app_data.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../../eventos/models/evento_model.dart';
import '../../eventos/services/evento_service.dart';
import '../../services/nlp/ia_sugestao_causa_service.dart';
import '../widgets/revisao_criar_evento.dart';

import 'widgets/secao_dados_basicos.dart';
import 'widgets/secao_data_vagas.dart';
import 'widgets/secao_localizacao_cep.dart';
import 'widgets/secao_chips_appdata.dart';
import 'widgets/secao_foto_capa.dart';

class CriarEventoPage extends StatefulWidget {
  final String ongId;
  final String tipoUsuario;
  final EventoModel? eventoParaEditar;

  const CriarEventoPage({
    super.key,
    required this.ongId,
    this.tipoUsuario = "ong",
    this.eventoParaEditar,
  });

  @override
  State<CriarEventoPage> createState() => _CriarEventoPageState();
}

class _CriarEventoPageState extends State<CriarEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final EventoService _eventService = EventoService();

  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _vagasController;
  late final TextEditingController _bannerUrlController;
  late final TextEditingController _cepController;
  late final TextEditingController _logradouroController;
  late final TextEditingController _numeroController;
  late final TextEditingController _bairroController;
  late final TextEditingController _pontoReferenciaController;

  late List<String> _categorias;
  late String _formato;
  late String _cidade;
  late DateTime _data;
  late TimeOfDay _inicio;
  late TimeOfDay _termino;

  final Set<String> _requisitos = {};
  final Set<String> _necessidades = {};
  bool _salvando = false;

  bool get _isEdicao => widget.eventoParaEditar != null;
  bool get _isRemoto => _formato == "Apenas Remoto (Online)";

  @override
  void initState() {
    super.initState();

    final ev = widget.eventoParaEditar;

    if (ev != null) {
      _nomeController = TextEditingController(text: ev.titulo);
      _descricaoController = TextEditingController(text: ev.descricao);
      _vagasController = TextEditingController(text: ev.vagasTotais.toString());
      _bannerUrlController = TextEditingController(text: ev.imagemUrl);
      _cepController = TextEditingController();
      _logradouroController = TextEditingController(text: ev.endereco);
      _numeroController = TextEditingController();
      _bairroController = TextEditingController();
      _pontoReferenciaController = TextEditingController();

      // Carrega a categoria principal limpa e verifica se há uma segunda causa nas tags
      final causaPrimaria = IaSugestaoCausaService.removerEmojis(ev.categoria);
      _categorias = [causaPrimaria];

      final causasPossiveis = IaSugestaoCausaService.obterCausasLimpos();
      for (final tag in ev.tags) {
        final tagLimpa = IaSugestaoCausaService.removerEmojis(tag);
        if (_categorias.length < 2 &&
            tagLimpa != causaPrimaria &&
            causasPossiveis.contains(tagLimpa)) {
          _categorias.add(tagLimpa);
        }
      }

      _formato = ev.cidade.toLowerCase() == "remoto"
          ? "Apenas Remoto (Online)"
          : AppData.formatosVoluntariado.first;
      _cidade = ev.cidade.toLowerCase() == "remoto" ? "Santo André" : ev.cidade;

      _data = ev.dataHoraInicio;
      _inicio = TimeOfDay(
        hour: ev.dataHoraInicio.hour,
        minute: ev.dataHoraInicio.minute,
      );
      _termino = TimeOfDay(
        hour: (ev.dataHoraInicio.hour + 4) % 24,
        minute: ev.dataHoraInicio.minute,
      );

      _requisitos
          .addAll(ev.requisitos.map(IaSugestaoCausaService.removerEmojis));
      _necessidades
          .addAll(ev.necessidades.map(IaSugestaoCausaService.removerEmojis));
    } else {
      _nomeController = TextEditingController();
      _descricaoController = TextEditingController();
      _vagasController = TextEditingController(text: "15");
      _bannerUrlController = TextEditingController(
        text: "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800",
      );
      _cepController = TextEditingController();
      _logradouroController = TextEditingController();
      _numeroController = TextEditingController();
      _bairroController = TextEditingController();
      _pontoReferenciaController = TextEditingController();

      final todasCausas = IaSugestaoCausaService.obterCausasLimpos();
      _categorias = [todasCausas.first];

      _formato = AppData.formatosVoluntariado.first;
      _cidade = "Santo André";

      _data = DateTime.now().add(const Duration(days: 7));
      _inicio = const TimeOfDay(hour: 9, minute: 0);
      _termino = const TimeOfDay(hour: 13, minute: 0);

      final habsIniciais = AppData.habilidadesPorCausa.entries
          .firstWhere(
            (e) =>
                IaSugestaoCausaService.removerEmojis(e.key) ==
                _categorias.first,
            orElse: () => AppData.habilidadesPorCausa.entries.first,
          )
          .value;

      _requisitos.addAll(
        habsIniciais.take(2).map(IaSugestaoCausaService.removerEmojis),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _vagasController.dispose();
    _bannerUrlController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _pontoReferenciaController.dispose();
    super.dispose();
  }

  CriarEventoDTO _gerarDTO() {
    final horaInicio =
        "${_inicio.hour.toString().padLeft(2, '0')}:${_inicio.minute.toString().padLeft(2, '0')}";
    final horaTermino =
        "${_termino.hour.toString().padLeft(2, '0')}:${_termino.minute.toString().padLeft(2, '0')}";
    final dataStr =
        "${_data.day.toString().padLeft(2, '0')}/${_data.month.toString().padLeft(2, '0')}/${_data.year}";

    final pontoRef = _pontoReferenciaController.text.trim();
    final complementoRef = pontoRef.isNotEmpty ? " (Ref: $pontoRef)" : "";

    final endereco = _isRemoto
        ? "Remoto / Online"
        : "${_logradouroController.text}, ${_numeroController.text} - ${_bairroController.text}$complementoRef";

    // Causa primária para compatibilidade com campos simples de banco
    final causaPrincipal =
        _categorias.isNotEmpty ? _categorias.first : "Assistência social";

    return CriarEventoDTO(
      ongId: widget.ongId,
      ongNome: widget.eventoParaEditar?.ongNome ?? "Instituto Criança Cidadã",
      titulo: _nomeController.text.trim(),
      categoria: causaPrincipal,
      descricao: _descricaoController.text.trim(),
      cidade: _isRemoto ? "Remoto" : _cidade,
      endereco: endereco,
      data: dataStr,
      horario: "$horaInicio - $horaTermino",
      horarioInicio: horaInicio,
      horarioTermino: horaTermino,
      dataHoraInicio: DateTime(
        _data.year,
        _data.month,
        _data.day,
        _inicio.hour,
        _inicio.minute,
      ),
      imagemUrl: _bannerUrlController.text.trim(),
      // Ambas as causas são indexadas nas tags para permitir busca por qualquer uma delas
      tags: [..._categorias, ..._requisitos],
      vagasTotais: int.tryParse(_vagasController.text) ?? 15,
      requisitos: _requisitos.toList(),
      necessidades: _necessidades.toList(),
      emiteCertificado: true,
    );
  }

  Future<void> _submeterAcao() async {
    if (!_formKey.currentState!.validate()) return;
    final dto = _gerarDTO();

    if (_isEdicao) {
      setState(() => _salvando = true);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ação atualizada com sucesso!"),
          backgroundColor: Color(0xFF0C6B6B),
        ),
      );
      Navigator.pop(context, true);
    } else {
      RevisaoCriarEventoDialog.exibir(
        context,
        dto: dto,
        onConfirmar: (dtoConfirmado, canais) async {
          setState(() => _salvando = true);
          try {
            await _eventService.criarEvento(dtoConfirmado);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Ação '${dtoConfirmado.titulo}' cadastrada com sucesso!",
                ),
                backgroundColor: const Color(0xFF0C6B6B),
              ),
            );
            Navigator.pop(context, true);
          } catch (_) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Erro ao cadastrar evento."),
                backgroundColor: Colors.redAccent,
              ),
            );
          } finally {
            if (mounted) setState(() => _salvando = false);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
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
                  showBackButton: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 14 : 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _isEdicao
                                    ? "Editar Ação"
                                    : "Cadastrar Nova Ação",
                                style: TextStyle(
                                  fontSize: isMobile ? 22 : 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF062222),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 1. Dados Básicos com suporte a até 2 causas
                              SecaoDadosBasicos(
                                nomeCtrl: _nomeController,
                                descCtrl: _descricaoController,
                                categoriasSelecionadas: _categorias,
                                formato: _formato,
                                onCategoriasChanged: (novas) =>
                                    setState(() => _categorias = novas),
                                onFormatoChanged: (v) =>
                                    setState(() => _formato = v),
                              ),
                              const SizedBox(height: 14),

                              // 2. Data, Horário e Vagas
                              SecaoDataVagas(
                                data: _data,
                                inicio: _inicio,
                                termino: _termino,
                                vagasCtrl: _vagasController,
                                onDataChanged: (d) => setState(() => _data = d),
                                onInicioChanged: (h) =>
                                    setState(() => _inicio = h),
                                onTerminoChanged: (h) =>
                                    setState(() => _termino = h),
                              ),
                              const SizedBox(height: 14),

                              // 3. Localização com ViaCEP e Ponto de Referência
                              if (!_isRemoto) ...[
                                SecaoLocalizacaoCep(
                                  cepCtrl: _cepController,
                                  logradouroCtrl: _logradouroController,
                                  numeroCtrl: _numeroController,
                                  bairroCtrl: _bairroController,
                                  pontoReferenciaCtrl:
                                      _pontoReferenciaController,
                                  cidade: _cidade,
                                  onCidadeChanged: (c) =>
                                      setState(() => _cidade = c),
                                ),
                                const SizedBox(height: 14),
                              ],

                              // 4 e 5. Habilidades e Necessidades (Consolidadas para as causas escolhidas)
                              SecaoChipsAppData(
                                categorias: _categorias,
                                requisitos: _requisitos,
                                necessidades: _necessidades,
                              ),
                              const SizedBox(height: 14),

                              // 6. Capa do Evento
                              SecaoFotoCapa(
                                bannerUrlCtrl: _bannerUrlController,
                                onFotoAlterada: () => setState(() {}),
                              ),
                              const SizedBox(height: 24),

                              // Botão Final de Submissão
                              ElevatedButton(
                                onPressed: _salvando ? null : _submeterAcao,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0C6B6B),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                                    : Text(
                                        _isEdicao
                                            ? "Salvar Alterações"
                                            : "Criar Evento",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 30),
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
