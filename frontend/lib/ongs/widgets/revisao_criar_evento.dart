// lib/ongs/widgets/revisao_criar_evento.dart

import 'package:flutter/material.dart';
import '../../eventos/models/evento_model.dart';

class RevisaoCriarEventoDialog extends StatefulWidget {
  final CriarEventoDTO dto;
  final void Function(CriarEventoDTO dto, Map<String, bool> canaisDivulgacao)
      onConfirmar;

  const RevisaoCriarEventoDialog({
    super.key,
    required this.dto,
    required this.onConfirmar,
  });

  static Future<void> exibir(
    BuildContext context, {
    required CriarEventoDTO dto,
    required void Function(
            CriarEventoDTO dto, Map<String, bool> canaisDivulgacao)
        onConfirmar,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RevisaoCriarEventoDialog(
        dto: dto,
        onConfirmar: onConfirmar,
      ),
    );
  }

  @override
  State<RevisaoCriarEventoDialog> createState() =>
      _RevisaoCriarEventoDialogState();
}

class _RevisaoCriarEventoDialogState extends State<RevisaoCriarEventoDialog> {
  int _etapaAtual = 0; // 0: Revisão | 1: Divulgação

  // Canais de divulgação selecionáveis
  bool _publicarFeed = true;
  bool _notificarSeguidores = true;
  bool _enviarEmails = false;
  bool _destacarVitrine = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      title: Row(
        children: [
          Icon(
            _etapaAtual == 0
                ? Icons.visibility_outlined
                : Icons.campaign_rounded,
            color: const Color(0xFF0C6B6B),
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _etapaAtual == 0
                  ? "1/2 • Revisar Ação"
                  : "2/2 • Opções de Divulgação",
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _etapaAtual == 0 ? _buildAbaRevisao() : _buildAbaDivulgacao(),
        ),
      ),
      actions: [
        if (_etapaAtual == 0) ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Editar Campos",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => _etapaAtual = 1),
            icon: const Icon(Icons.arrow_forward_rounded,
                size: 16, color: Colors.white),
            label: const Text("Avançar para Divulgação",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ] else ...[
          TextButton(
            onPressed: () => setState(() => _etapaAtual = 0),
            child: const Text("Voltar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirmar(widget.dto, {
                'feed': _publicarFeed,
                'push': _notificarSeguidores,
                'email': _enviarEmails,
                'destaque': _destacarVitrine,
              });
            },
            icon: const Icon(Icons.rocket_launch_rounded,
                size: 16, color: Colors.white),
            label: const Text("Publicar Evento",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ],
    );
  }

  // --- ABA 1: RESUMO DO EVENTO ---
  Widget _buildAbaRevisao() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.dto.imagemUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 80,
                color: const Color(0xFFC7EBE3),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.dto.titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.dto.categoria} • ${widget.dto.vagasTotais} vagas disponíveis",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const Divider(height: 20),
          _itemLinha(Icons.calendar_today_rounded, "Data e Horário",
              "${widget.dto.data} • ${widget.dto.horario}"),
          const SizedBox(height: 8),
          _itemLinha(Icons.location_on_rounded, "Localização",
              "${widget.dto.endereco} (${widget.dto.cidade})"),
          const SizedBox(height: 8),
          _itemLinha(
              Icons.description_outlined, "Descrição", widget.dto.descricao),
          if (widget.dto.requisitos.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text("Habilidades Requeridas:",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.dto.requisitos
                  .map((r) => Chip(
                        label: Text(r,
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFF0C6B6B))),
                        backgroundColor: const Color(0xFFD1F5EE),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ],
          if (widget.dto.necessidades.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text("Necessidades & Doações:",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.dto.necessidades
                  .map((n) => Chip(
                        label: Text(n,
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFFD46B08))),
                        backgroundColor: const Color(0xFFFFF7E6),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // --- ABA 2: CANAIS DE COMUNICAÇÃO E MARKETING ---
  Widget _buildAbaDivulgacao() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selecione como quer notificar a comunidade sobre a nova ação:",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          _itemSwitch(
            titulo: "Publicar no Feed da ONG",
            subtitulo:
                "Gera um post institucional na timeline pública da sua página",
            icone: Icons.dynamic_feed_rounded,
            valor: _publicarFeed,
            onChanged: (v) => setState(() => _publicarFeed = v),
          ),
          const SizedBox(height: 8),
          _itemSwitch(
            titulo: "Notificação Push para Voluntários",
            subtitulo:
                "Dispara alerta no app para quem segue a ONG ou tem match de habilidades",
            icone: Icons.notifications_active_outlined,
            valor: _notificarSeguidores,
            onChanged: (v) => setState(() => _notificarSeguidores = v),
          ),
          const SizedBox(height: 8),
          _itemSwitch(
            titulo: "Disparar E-mail Marketing",
            subtitulo:
                "Envia resumo da oportunidade para voluntários guardiões cadastrados",
            icone: Icons.mark_email_read_outlined,
            valor: _enviarEmails,
            onChanged: (v) => setState(() => _enviarEmails = v),
          ),
          const SizedBox(height: 8),
          _itemSwitch(
            titulo: "Destaque Regional (${widget.dto.cidade})",
            subtitulo:
                "Fixa o evento com selo prioritário na vitrine do Grande ABC",
            icone: Icons.star_border_rounded,
            valor: _destacarVitrine,
            onChanged: (v) => setState(() => _destacarVitrine = v),
          ),
        ],
      ),
    );
  }

  Widget _itemSwitch({
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: valor ? const Color(0xFFF0FAF7) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: valor ? const Color(0xFF0C6B6B) : const Color(0xFFE0E0E0),
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        secondary: Icon(icone,
            color: valor ? const Color(0xFF0C6B6B) : Colors.grey, size: 22),
        title: Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: valor ? const Color(0xFF062222) : Colors.black87,
          ),
        ),
        subtitle: Text(subtitulo,
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
        value: valor,
        activeColor: const Color(0xFF0C6B6B),
        onChanged: onChanged,
      ),
    );
  }

  Widget _itemLinha(IconData icon, String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF0C6B6B)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
              Text(valor,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF062222))),
            ],
          ),
        ),
      ],
    );
  }
}
