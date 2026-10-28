// lib/notificacoes/widgets/notificacao_detalhes_dialog.dart

import 'package:flutter/material.dart';
import '../../eventos/voluntario/eventos_page.dart';
import '../../models/notification_models.dart';

class NotificacaoDetalhesDialog {
  static void exibir(
    BuildContext context, {
    required NotificacaoModel notificacao,
    required bool isMobile,
    required bool isOng,
    required void Function(String mensagem) onCompartilhar,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.all(isMobile ? 18 : 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notificacao.corTema.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(notificacao.icone,
                      color: notificacao.corTema, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificacao.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222),
                        ),
                      ),
                      Text(
                        notificacao.dataRelativa,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              notificacao.mensagemCompleta,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF3A6868),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            _buildAcoes(
              dialogCtx,
              notificacao: notificacao,
              isMobile: isMobile,
              isOng: isOng,
              onCompartilhar: onCompartilhar,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAcoes(
    BuildContext context, {
    required NotificacaoModel notificacao,
    required bool isMobile,
    required bool isOng,
    required void Function(String mensagem) onCompartilhar,
  }) {
    void navegarParaEventos() {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const EventosPage(),
          transitionDuration: Duration.zero,
        ),
      );
    }

    if (notificacao.tipo == TipoNotificacao.evento ||
        notificacao.tipo == TipoNotificacao.aprovacao) {
      final labelPrincipal = notificacao.tipo == TipoNotificacao.evento
          ? (isOng ? "Ver Ação" : "Quero Participar")
          : "Ver em Meus Eventos";

      final btnPrincipal = ElevatedButton(
        onPressed: navegarParaEventos,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C6B6B),
          padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(
          labelPrincipal,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );

      final btnFechar = OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 13),
          side: const BorderSide(color: Color(0xFF0C6B6B)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "Fechar",
          style:
              TextStyle(color: Color(0xFF0C6B6B), fontWeight: FontWeight.bold),
        ),
      );

      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            btnPrincipal,
            const SizedBox(height: 8),
            btnFechar,
          ],
        );
      }

      return Row(
        children: [
          Expanded(child: btnPrincipal),
          const SizedBox(width: 10),
          Expanded(child: btnFechar),
        ],
      );
    }

    if (notificacao.tipo == TipoNotificacao.conquista) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onCompartilhar(
                    "Link de conquista copiado para a área de transferência!");
              },
              icon: const Icon(Icons.share_rounded,
                  size: 16, color: Colors.white),
              label: const Text(
                "Compartilhar",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C6B6B),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: Color(0xFF0C6B6B)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Fechar",
                style: TextStyle(
                    color: Color(0xFF0C6B6B), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C6B6B),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Text(
          "Entendido",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
