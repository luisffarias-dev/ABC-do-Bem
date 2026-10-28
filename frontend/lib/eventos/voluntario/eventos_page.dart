// lib/eventos/voluntario/eventos_page.dart

import 'dart:async';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../services/session_service.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../models/evento_model.dart';
import '../services/evento_service.dart';

import 'widgets/eventos_tabs_header.dart';
import 'widgets/eventos_vitrine_header.dart';
import 'widgets/eventos_tags_selector.dart';
import 'widgets/aba_descobrir_eventos.dart';
import 'widgets/aba_meus_eventos.dart';
import 'widgets/modal_confirmar_inscricao.dart';
import 'widgets/modal_cancelar_inscricao.dart';

class EventosPage extends StatefulWidget {
  final Function(String ongId)? onOngSelect;
  final Function(String eventId)? onShareEvent;
  final String? voluntarioId;

  const EventosPage({
    super.key,
    this.onOngSelect,
    this.onShareEvent,
    this.voluntarioId,
  });

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final EventoService _service = EventoService();

  int _mainTabIndex = 0; // 0: Descobrir | 1: Meus Eventos
  String _selectedTag = "Todos";
  String _viewMode = "list";

  late DateTime _currentMonthDate;
  String? _selectedDate;

  Timer? _countdownTimer;
  DateTime _now = DateTime.now();

  bool _carregandoEventos = true;
  bool _carregandoMeusEventos = false;
  bool _erroConexaoEventos = false;
  bool _erroConexaoMeusEventos = false;

  List<EventoModel> _events = [];
  List<InscricaoEventoModel> _proximosEventos = [];
  List<InscricaoEventoModel> _eventosConcluidos = [];

  final List<String> _tags = [
    "Todos",
    "Educação",
    "Meio Ambiente",
    "Saúde",
    "Cultura",
    "Habitação",
  ];

  String get _idResolvido {
    if (widget.voluntarioId != null &&
        widget.voluntarioId!.trim().isNotEmpty &&
        widget.voluntarioId != "voluntario-1") {
      return widget.voluntarioId!.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return widget.voluntarioId ?? "voluntario-1";
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonthDate = DateTime(now.year, now.month, 1);

    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    _carregarEventosVitrine();
    _carregarMeusEventos();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _carregarEventosVitrine() async {
    setState(() {
      _carregandoEventos = true;
      _erroConexaoEventos = false;
    });

    try {
      final eventos = await _service.listarEventos(
        categoria: _selectedTag == "Todos" ? null : _selectedTag,
      );
      if (mounted) {
        setState(() {
          _events = eventos;
          _carregandoEventos = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _carregandoEventos = false;
          _erroConexaoEventos = true;
        });
      }
    }
  }

  Future<void> _carregarMeusEventos() async {
    setState(() {
      _carregandoMeusEventos = true;
      _erroConexaoMeusEventos = false;
    });

    try {
      // Busca as inscrições reais do usuário logado
      final inscricoes = await _service.listarMinhasInscricoes(
        _idResolvido,
        token: SessionService.instance.token,
      );

      if (mounted) {
        setState(() {
          final now = DateTime.now();
          _proximosEventos = inscricoes.where((ins) {
            final dataEv = ins.evento?.dataHoraInicio;
            if (dataEv == null) return ins.status != "Concluído";
            return dataEv.isAfter(now) && ins.status != "Cancelado";
          }).toList();

          _eventosConcluidos = inscricoes.where((ins) {
            final dataEv = ins.evento?.dataHoraInicio;
            if (dataEv == null) return ins.status == "Concluído";
            return dataEv.isBefore(now) || ins.status == "Concluído";
          }).toList();

          _carregandoMeusEventos = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _carregandoMeusEventos = false;
          _erroConexaoMeusEventos = true;
        });
      }
    }
  }

  void _tratarAcaoInscricao(EventoModel ev, bool isMobile) {
    if (ev.isInscrito) {
      ModalCancelarInscricao.exibir(
        context,
        eventoId: ev.id,
        titulo: ev.titulo,
        ongNome: ev.ongNome,
        isMobile: isMobile,
        onConfirmarCancelamento: (_) async {
          try {
            await _service.cancelarInscricao(
              ev.id,
              _idResolvido,
              token: SessionService.instance.token,
            );
          } catch (_) {}
          _carregarEventosVitrine();
          _carregarMeusEventos();
        },
      );
    } else {
      ModalConfirmarInscricao.exibir(
        context,
        evento: ev,
        isMobile: isMobile,
        onConfirmar: (_) async {
          try {
            await _service.inscreverVoluntario(
              ev.id,
              _idResolvido,
              token: SessionService.instance.token,
            );
          } catch (_) {}
          if (mounted) {
            Navigator.pop(context);
            _carregarEventosVitrine();
            _carregarMeusEventos();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final eventDates = _events.map((e) => e.data).toSet();
    final filteredEvents = _events.where((ev) {
      final matchTag = _selectedTag == "Todos" ||
          ev.categoria == _selectedTag ||
          ev.tags.contains(_selectedTag);
      final matchDate = _selectedDate == null || ev.data == _selectedDate;
      return matchTag && matchDate;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: isMobile
          ? AppBottomNav(currentIndex: 2, usuarioId: _idResolvido)
          : null,
      body: Row(
        children: [
          if (isDesktop) AppSidebar(currentIndex: 2, usuarioId: _idResolvido),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: _idResolvido,
                  tipoUsuario: "voluntario",
                  nomeUsuario: SessionService.instance.nomeUsuario,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            EventosTabsHeader(
                              selectedIndex: _mainTabIndex,
                              totalInscricoesAtivas: _proximosEventos.length,
                              onTabChanged: (idx) =>
                                  setState(() => _mainTabIndex = idx),
                            ),
                            SizedBox(height: isMobile ? 16 : 24),
                            if (_mainTabIndex == 0) ...[
                              EventosVitrineHeader(
                                viewMode: _viewMode,
                                isMobile: isMobile,
                                onViewModeChanged: (mode) =>
                                    setState(() => _viewMode = mode),
                              ),
                              const SizedBox(height: 14),
                              EventosTagsSelector(
                                tags: _tags,
                                selectedTag: _selectedTag,
                                onTagSelected: (tag) {
                                  setState(() => _selectedTag = tag);
                                  _carregarEventosVitrine();
                                },
                              ),
                              const SizedBox(height: 18),
                              AbaDescobrirEventos(
                                viewMode: _viewMode,
                                carregando: _carregandoEventos,
                                erroConexao: _erroConexaoEventos,
                                eventos: filteredEvents,
                                currentMonthDate: _currentMonthDate,
                                selectedDate: _selectedDate,
                                eventDates: eventDates,
                                isMobile: isMobile,
                                onRetry: _carregarEventosVitrine,
                                onPrevMonth: () => setState(() =>
                                    _currentMonthDate = DateTime(
                                        _currentMonthDate.year,
                                        _currentMonthDate.month - 1,
                                        1)),
                                onNextMonth: () => setState(() =>
                                    _currentMonthDate = DateTime(
                                        _currentMonthDate.year,
                                        _currentMonthDate.month + 1,
                                        1)),
                                onSelectDate: (d) =>
                                    setState(() => _selectedDate = d),
                                onAcaoInscricao: (ev) =>
                                    _tratarAcaoInscricao(ev, isMobile),
                                onOngSelect: widget.onOngSelect,
                                onShareEvent: widget.onShareEvent,
                              ),
                            ] else
                              AbaMeusEventos(
                                carregando: _carregandoMeusEventos,
                                erroConexao: _erroConexaoMeusEventos,
                                proximosEventos: _proximosEventos,
                                eventosConcluidos: _eventosConcluidos,
                                now: _now,
                                isMobile: isMobile,
                                onRetry: _carregarMeusEventos,
                                onCancelar: (ins) {
                                  ModalCancelarInscricao.exibir(
                                    context,
                                    eventoId: ins.evento!.id,
                                    titulo: ins.evento!.titulo,
                                    ongNome: ins.evento!.ongNome,
                                    isMobile: isMobile,
                                    onConfirmarCancelamento: (_) async {
                                      try {
                                        await _service.cancelarInscricao(
                                          ins.evento!.id,
                                          _idResolvido,
                                          token: SessionService.instance.token,
                                        );
                                      } catch (_) {}
                                      _carregarEventosVitrine();
                                      _carregarMeusEventos();
                                    },
                                  );
                                },
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
