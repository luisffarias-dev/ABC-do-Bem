// lib/eventos/detalhe/evento_detalhe_page.dart

import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../models/evento_model.dart';
import '../services/evento_service.dart';

import 'widgets/evento_detalhe_banner.dart';
import 'widgets/evento_detalhe_vagas_card.dart';
import 'widgets/evento_detalhe_participantes_list.dart';
import 'widgets/evento_detalhe_necessidades_section.dart';
import 'widgets/evento_detalhe_localizacao_section.dart';
import 'widgets/evento_detalhe_mural_caronas.dart';
import 'widgets/modal_confirmar_participacao.dart';
import 'widgets/evento_detalhe_chamada_modal.dart';

class EventoDetalhePage extends StatefulWidget {
  final String eventoId;
  final String? usuarioAtualId;
  final String? voluntarioId;
  final bool isOng;

  const EventoDetalhePage({
    super.key,
    required this.eventoId,
    this.usuarioAtualId,
    this.voluntarioId,
    this.isOng = false,
  });

  String get idAtivo {
    if (usuarioAtualId != null &&
        usuarioAtualId!.trim().isNotEmpty &&
        usuarioAtualId != "voluntario-1") {
      return usuarioAtualId!.trim();
    }
    if (voluntarioId != null &&
        voluntarioId!.trim().isNotEmpty &&
        voluntarioId != "voluntario-1") {
      return voluntarioId!.trim();
    }
    if (SessionService.instance.usuarioId != null &&
        SessionService.instance.usuarioId!.trim().isNotEmpty) {
      return SessionService.instance.usuarioId!.trim();
    }
    return "voluntario-1";
  }

  @override
  State<EventoDetalhePage> createState() => _EventoDetalhePageState();
}

class _EventoDetalhePageState extends State<EventoDetalhePage> {
  final EventoService _eventoService = EventoService();

  EventoModel? _evento;
  bool _carregando = true;

  bool get _isDonoDoEvento =>
      widget.isOng && _evento != null && _evento!.ongId == widget.idAtivo;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (!mounted) return;
    setState(() => _carregando = true);

    try {
      final ev = await _eventoService.buscarPorId(
        widget.eventoId,
        voluntarioId: widget.idAtivo,
        token: SessionService.instance.token,
      );

      if (mounted) {
        setState(() {
          _evento = ev;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _inscrever() {
    if (_evento == null) return;
    ModalConfirmarParticipacao.exibir(
      context,
      evento: _evento!,
      onConfirmar: () async {
        try {
          final ok = await _eventoService.inscreverVoluntario(
            _evento!.id,
            widget.idAtivo,
            token: SessionService.instance.token,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(ok ? "Inscrição confirmada!" : "Falha na inscrição"),
                backgroundColor:
                    ok ? const Color(0xFF0C6B6B) : Colors.redAccent,
              ),
            );
            _carregarDados();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceAll("Exception: ", "")),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _cancelar() async {
    if (_evento == null) return;
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancelar Inscrição?"),
        content: const Text(
          "Sua vaga será imediatamente liberada para outros voluntários do Grande ABC.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Manter"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text(
              "Cancelar Vaga",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      try {
        await _eventoService.cancelarInscricao(
          _evento!.id,
          widget.idAtivo,
          token: SessionService.instance.token,
        );
        _carregarDados();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll("Exception: ", "")),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  Future<void> _abrirGestaoChamada(EventoModel ev) async {
    final alterou = await EventoDetalheChamadaModal.exibir(context, ev);
    if (alterou == true && mounted) {
      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0FAF7),
        body: Center(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C6B6B)),
              ),
            ),
          ),
        ),
      );
    }

    if (_evento == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_rounded, color: Color(0xFF062222)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_busy_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                "Ação solidária não encontrada.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C6B6B)),
                child:
                    const Text("Voltar", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final ev = _evento!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: _buildBottomBar(ev),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EventoDetalheBanner(
              evento: ev,
              isDono: _isDonoDoEvento,
              onVoltar: () => Navigator.of(context).pop(),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev.titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${ev.ongNome} • ${ev.data} às ${ev.horario}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C6B6B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      EventoDetalheVagasCard(
                        evento: ev,
                        isDono: _isDonoDoEvento,
                      ),
                      const SizedBox(height: 14),
                      EventoDetalheParticipantesList(
                        evento: ev,
                        isDono: _isDonoDoEvento,
                        usuarioLogadoId: widget.idAtivo,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC2E4DC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sobre a Ação",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF062222),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ev.descricao,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      EventoDetalheNecessidadesSection(
                        evento: ev,
                        isDono: _isDonoDoEvento,
                      ),
                      const SizedBox(height: 14),
                      EventoDetalheLocalizacaoSection(
                        evento: ev,
                        isDono: _isDonoDoEvento,
                      ),
                      const SizedBox(height: 14),
                      EventoDetalheMuralCaronas(
                        evento: ev,
                        usuarioAtualId: widget.idAtivo,
                        isDono: _isDonoDoEvento,
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(EventoModel ev) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _isDonoDoEvento
            ? ElevatedButton.icon(
                onPressed: () => _abrirGestaoChamada(ev),
                icon: const Icon(
                  Icons.checklist_rtl_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Lista de Chamada & Gestão",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C6B6B),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : ev.isInscrito
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1F5EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF0C6B6B),
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Presença Confirmada",
                                style: TextStyle(
                                  color: Color(0xFF0C6B6B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _cancelar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancelar"),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: ev.isEsgotado ? null : _inscrever,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      disabledBackgroundColor: Colors.grey.shade300,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      ev.isEsgotado
                          ? "Vagas Esgotadas"
                          : "Quero Participar desta Ação",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
      ),
    );
  }
}
