// lib/ongs/painel_geral/widgets/secao_gestao_acoes.dart

import 'package:flutter/material.dart';
import '../../criar_evento/criar_evento_page.dart';
import 'card_painel_base.dart';

class SecaoGestaoAcoes extends StatelessWidget {
  final String ongId;
  final String tipoUsuario;
  final bool isMobile;
  final ValueChanged<String> onNavegar;
  final VoidCallback onEventoCriado;

  const SecaoGestaoAcoes({
    super.key,
    required this.ongId,
    required this.tipoUsuario,
    required this.isMobile,
    required this.onNavegar,
    required this.onEventoCriado,
  });

  @override
  Widget build(BuildContext context) {
    return CardPainelBase(
      titulo: "2. Gestão de Ações",
      icone: Icons.event_available_rounded,
      isMobile: isMobile,
      botaoAcao: ElevatedButton.icon(
        onPressed: () async {
          final criado =
              await Navigator.of(context, rootNavigator: true).push<bool>(
            MaterialPageRoute(
              builder: (_) => CriarEventoPage(
                ongId: ongId,
                tipoUsuario: tipoUsuario,
              ),
            ),
          );
          if (criado == true) onEventoCriado();
        },
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          size: 13,
          color: Colors.white,
        ),
        label: const Text(
          "Novo Evento",
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C6B6B),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      conteudo: Column(
        children: [
          _buildItemEvento(
            titulo: "Mutirão de Reforço Escolar",
            dataInfo: "Sáb, 19/Set - 09:00",
            vagasInfo: "16/20 vagas",
            pct: 0.80,
          ),
          const SizedBox(height: 8),
          _buildItemEvento(
            titulo: "Oficina de Robótica Lúdica",
            dataInfo: "Sáb, 26/Set - 14:00",
            vagasInfo: "8/15 vagas",
            pct: 0.53,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onNavegar("Histórico de Ações"),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                "Ver histórico completo ->",
                style: TextStyle(
                  color: Color(0xFF0C6B6B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemEvento({
    required String titulo,
    required String dataInfo,
    required String vagasInfo,
    required double pct,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF062222),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: Color(0xFF0C6B6B),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onNavegar("Editar $titulo"),
              ),
            ],
          ),
          Text(
            dataInfo,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: const Color(0xFFC2E4DC),
                    color: const Color(0xFF0C6B6B),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                vagasInfo,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C6B6B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
