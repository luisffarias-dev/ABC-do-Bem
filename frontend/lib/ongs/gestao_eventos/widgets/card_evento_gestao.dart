// lib/ongs/gestao_eventos/widgets/card_evento_gestao.dart

import 'package:flutter/material.dart';
import '../../../eventos/models/evento_model.dart';
import '../dialogs/cancelar_evento_dialog.dart';
import '../dialogs/sucesso_cancelamento_dialog.dart';
import '../../criar_evento/criar_evento_page.dart';

class CardEventoGestao extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback onAtualizar;

  const CardEventoGestao({
    super.key,
    required this.evento,
    required this.onAtualizar,
  });

  bool get _isAtivo => evento.dataHoraInicio.isAfter(DateTime.now());

  void _abrirEdicao(BuildContext context) async {
    final atualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CriarEventoPage(
          ongId: evento.ongId,
          tipoUsuario: "ong",
          eventoParaEditar: evento, // Modo edição preenchido com todos os dados
        ),
      ),
    );

    if (atualizado == true) onAtualizar();
  }

  void _abrirCancelamento(BuildContext context) async {
    String motivoCapturado = "";

    final cancelado = await CancelarEventoDialog.exibir(
      context,
      evento: evento,
      onConfirmar: (motivo) async {
        motivoCapturado = motivo;
        // Chamada de cancelamento no backend / sincronização
        await Future.delayed(const Duration(milliseconds: 300));
      },
    );

    if (cancelado == true && context.mounted) {
      // Exibe o pop-up confirmando disparos de e-mail, notificações e feed
      await SucessoCancelamentoDialog.exibir(
        context,
        evento: evento,
        motivo: motivoCapturado,
      );

      onAtualizar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner com Imagem e Status
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(11)),
                child: Image.network(
                  evento.imagemUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    color: const Color(0xFFC7EBE3),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isAtivo
                        ? const Color(0xFF0C6B6B)
                        : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _isAtivo ? "Inscrições Abertas" : "Encerrada",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Informações e Ações
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 13, color: Color(0xFF0C6B6B)),
                    const SizedBox(width: 4),
                    Text(
                      "${evento.data} • ${evento.horario}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 13, color: Color(0xFF0C6B6B)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${evento.endereco} (${evento.cidade})",
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people_alt_rounded,
                        size: 13, color: Color(0xFF0C6B6B)),
                    const SizedBox(width: 4),
                    Text(
                      "Vagas: ${evento.vagasRestantes}/${evento.vagasTotais} disponíveis",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Botões de Ação: Cancelar e Editar
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isAtivo) ...[
                      TextButton.icon(
                        onPressed: () => _abrirCancelamento(context),
                        icon: const Icon(Icons.cancel_outlined,
                            size: 14, color: Colors.redAccent),
                        label: const Text(
                          "Cancelar Ação",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: () => _abrirEdicao(context),
                      icon: const Icon(Icons.edit_outlined,
                          size: 14, color: Color(0xFF0C6B6B)),
                      label: const Text(
                        "Editar",
                        style: TextStyle(
                            color: Color(0xFF0C6B6B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0C6B6B)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
