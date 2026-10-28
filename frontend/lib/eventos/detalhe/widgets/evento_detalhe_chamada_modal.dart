// lib/eventos/detalhe/widgets/evento_detalhe_chamada_modal.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';
import '../../services/evento_service.dart';

class EventoDetalheChamadaModal extends StatefulWidget {
  final EventoModel evento;

  const EventoDetalheChamadaModal({
    super.key,
    required this.evento,
  });

  static Future<bool?> exibir(BuildContext context, EventoModel evento) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => EventoDetalheChamadaModal(evento: evento),
    );
  }

  @override
  State<EventoDetalheChamadaModal> createState() =>
      _EventoDetalheChamadaModalState();
}

class _EventoDetalheChamadaModalState extends State<EventoDetalheChamadaModal> {
  final EventoService _eventoService = EventoService();
  final Map<String, bool> _presencas = {};
  int _horasPadrao = 4;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    // Extrai horas estimadas da string de horário (ex: "09:00 - 13:00" = 4h)
    _horasPadrao = _calcularHorasEstimadas(widget.evento.horario);
    for (final p in widget.evento.participantesConfirmados) {
      _presencas[p.id] = true; // Por padrão inicializa marcados
    }
  }

  int _calcularHorasEstimadas(String horario) {
    try {
      final partes = horario.split('-');
      if (partes.length == 2) {
        final inicio = int.parse(partes[0].trim().split(':').first);
        final fim = int.parse(partes[1].trim().split(':').first);
        final diff = fim - inicio;
        if (diff > 0) return diff;
      }
    } catch (_) {}
    return 4;
  }

  void _alternarTodos(bool marcar) {
    setState(() {
      for (final key in _presencas.keys) {
        _presencas[key] = marcar;
      }
    });
  }

  Future<void> _salvarChamada() async {
    setState(() => _salvando = true);

    try {
      // Simulação de chamada de serviço/API
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Lista de presença salva com sucesso! (${_presencas.values.where((v) => v).length} presenças validadas)",
            ),
            backgroundColor: const Color(0xFF0C6B6B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao salvar lista de chamada. Tente novamente."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantes = widget.evento.participantesConfirmados;
    final int totalPresentes = _presencas.values.where((v) => v).length;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior de arraste
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Cabeçalho do Modal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lista de Chamada & Horas",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062222),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.evento.titulo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7AAAA0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Ajuste de Horas e Ações Rápidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FAF8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 20, color: Color(0xFF0C6B6B)),
                        const SizedBox(width: 8),
                        const Text(
                          "Horas por voluntário:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF062222),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Color(0xFF0C6B6B), size: 22),
                          onPressed: _horasPadrao > 1
                              ? () => setState(() => _horasPadrao--)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${_horasPadrao}h",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C6B6B),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_circle_outline,
                              color: Color(0xFF0C6B6B), size: 22),
                          onPressed: _horasPadrao < 12
                              ? () => setState(() => _horasPadrao++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Controles de Seleção Rápida
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Confirmados: $totalPresentes de ${participantes.length}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062222),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _alternarTodos(true),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text("Todos",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF0C6B6B))),
                      ),
                      const Text("|", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () => _alternarTodos(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text("Nenhum",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de Voluntários
            Expanded(
              child: participantes.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum participante inscrito nesta ação.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      itemCount: participantes.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, index) {
                        final p = participantes[index];
                        final bool presente = _presencas[p.id] ?? false;

                        return CheckboxListTile(
                          value: presente,
                          activeColor: const Color(0xFF0C6B6B),
                          checkColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            setState(() {
                              _presencas[p.id] = val ?? false;
                            });
                          },
                          secondary: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFD1F5EE),
                            backgroundImage: p.fotoUrl != null &&
                                    p.fotoUrl!.trim().isNotEmpty
                                ? NetworkImage(p.fotoUrl!)
                                : null,
                            child:
                                (p.fotoUrl == null || p.fotoUrl!.trim().isEmpty)
                                    ? const Icon(
                                        Icons.person_rounded,
                                        color: Color(0xFF0C6B6B),
                                        size: 20,
                                      )
                                    : null,
                          ),
                          title: Text(
                            p.nome,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: presente
                                  ? const Color(0xFF062222)
                                  : Colors.grey,
                            ),
                          ),
                          subtitle: Text(
                            presente
                                ? "Presença confirmada (+${_horasPadrao}h no perfil)"
                                : "Ausente / Falta",
                            style: TextStyle(
                              fontSize: 11,
                              color: presente
                                  ? const Color(0xFF0C6B6B)
                                  : Colors.redAccent,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Botão Inferior de Confirmação
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _salvando || participantes.isEmpty
                        ? null
                        : _salvarChamada,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Salvar e Validar Horas",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
