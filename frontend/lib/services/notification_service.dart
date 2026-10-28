// lib/services/notification_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/notification_models.dart';
import 'session_service.dart';

/// Serviço responsável por gerenciar e persistir as notificações durante a sessão.
class NotificationService {
  // Notificador global do Badge mantido na memória da sessão
  static final ValueNotifier<int> totalNaoLidasNotifier = ValueNotifier<int>(2);

  // Registro estático persistente durante toda a sessão do app
  static final Set<String> _idsLidosLocalmente = {};

  final String baseUrl;
  final String? authToken;

  NotificationService({
    this.baseUrl = "https://abc-do-bem.onrender.com",
    this.authToken,
  });

  String? get _tokenFinal => (authToken != null && authToken!.trim().isNotEmpty)
      ? authToken!.trim()
      : SessionService.instance.token;

  Map<String, String> _montarHeaders(String? tokenParametro) {
    final token = (tokenParametro != null && tokenParametro.trim().isNotEmpty)
        ? tokenParametro.trim()
        : _tokenFinal;

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  /// 1. GET /notificacoes
  Future<List<NotificacaoModel>> buscarNotificacoes(
    String usuarioId, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/notificacoes');
    final headers = _montarHeaders(token);

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(response.bodyBytes));
        if (corpo is List && corpo.isNotEmpty) {
          final notificacoesApi = corpo
              .whereType<Map<String, dynamic>>()
              .map((json) => NotificacaoModel.fromJson(json))
              .where((n) =>
                  n.titulo.trim().isNotEmpty ||
                  n.descricaoCurta.trim().isNotEmpty)
              .map((n) {
            if (_idsLidosLocalmente.contains(n.id)) {
              n.lida = true;
            }
            return n;
          }).toList();

          if (notificacoesApi.isNotEmpty) {
            final pendentes = notificacoesApi.where((n) => !n.lida).length;
            totalNaoLidasNotifier.value = pendentes;
            return notificacoesApi;
          }
        }
      }
    } catch (_) {}

    final padrao = _obterNotificacoesPadraoOnboarding(usuarioId);
    final totalPendentes = padrao.where((n) => !n.lida).length;
    totalNaoLidasNotifier.value = totalPendentes;
    return padrao;
  }

  /// 2. GET /notificacoes/total-nao-lidas
  Future<int> buscarTotalNaoLidas(
    String usuarioId, {
    String? token,
  }) async {
    // Se o usuário já leu todas as notificações nesta sessão, não restaura o indicador
    final padrao = _obterNotificacoesPadraoOnboarding(usuarioId);
    final pendentesLocal = padrao.where((n) => !n.lida).length;

    if (pendentesLocal == 0) {
      totalNaoLidasNotifier.value = 0;
      return 0;
    }

    final url = Uri.parse('$baseUrl/notificacoes/total-nao-lidas');
    final headers = _montarHeaders(token);

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final dados = jsonDecode(utf8.decode(response.bodyBytes));
        int total = 0;
        if (dados is Map<String, dynamic>) {
          total = (dados['total'] ??
                      dados['totalNaoLidas'] ??
                      dados['count'] as num?)
                  ?.toInt() ??
              0;
        } else if (dados is num) {
          total = dados.toInt();
        }

        if (total > 0 && _idsLidosLocalmente.isEmpty) {
          totalNaoLidasNotifier.value = total;
          return total;
        }
      }
    } catch (_) {}

    totalNaoLidasNotifier.value = pendentesLocal;
    return pendentesLocal;
  }

  /// 3. PATCH /notificacoes/{id}/ler
  Future<void> marcarComoLida(
    String notificacaoId, {
    String? token,
  }) async {
    _idsLidosLocalmente.add(notificacaoId);

    // Recalcula imediatamente os pendentes com base nas lidas
    final pendentes =
        _obterNotificacoesPadraoOnboarding("").where((n) => !n.lida).length;
    totalNaoLidasNotifier.value = pendentes;

    final url = Uri.parse('$baseUrl/notificacoes/$notificacaoId/ler');
    final headers = _montarHeaders(token);

    try {
      await http
          .patch(url, headers: headers)
          .timeout(const Duration(seconds: 4));
    } catch (_) {}
  }

  /// 4. PATCH /notificacoes/ler-todas
  Future<void> marcarTodasComoLidas(
    String usuarioId, {
    String? token,
  }) async {
    _idsLidosLocalmente.add("notif-bem-vindo");
    _idsLidosLocalmente.add("notif-complete-perfil");

    totalNaoLidasNotifier.value = 0;

    final url = Uri.parse('$baseUrl/notificacoes/ler-todas');
    final headers = _montarHeaders(token);

    try {
      await http
          .patch(url, headers: headers)
          .timeout(const Duration(seconds: 4));
    } catch (_) {}
  }

  // --- DADOS COM VERIFICAÇÃO DE LEITURA NA SESSÃO ---
  List<NotificacaoModel> _obterNotificacoesPadraoOnboarding(String usuarioId) {
    final nomeUsuario = SessionService.instance.nomeUsuario;
    final primeiroNome = (nomeUsuario != null && nomeUsuario.trim().isNotEmpty)
        ? nomeUsuario.trim().split(' ').first
        : 'Voluntário';

    return [
      NotificacaoModel(
        id: "notif-bem-vindo",
        usuarioId: usuarioId,
        tipo: TipoNotificacao.sistema,
        titulo: "Boas-vindas ao ABC do Bem! 🤝",
        descricaoCurta:
            "Olá, $primeiroNome! Sua jornada de impacto social começa aqui.",
        mensagemCompleta:
            "Seja muito bem-vindo à nossa rede solidária! Aqui você pode descobrir oportunidades de voluntariado, apoiar ONGs da sua região e transformar vidas através da sua dedicação.",
        criadoEm: DateTime.now().subtract(const Duration(minutes: 5)),
        lida: _idsLidosLocalmente.contains("notif-bem-vindo"),
      ),
      NotificacaoModel(
        id: "notif-complete-perfil",
        usuarioId: usuarioId,
        tipo: TipoNotificacao.conquista,
        titulo: "Atualize e complete o seu perfil 📝",
        descricaoCurta:
            "Adicione sua foto, causas favoritas e habilidades para conectar-se melhor.",
        mensagemCompleta:
            "Com o seu perfil completo e foto atualizada, as instituições locais conseguem conhecer melhor suas habilidades e você terá recomendações mais alinhadas aos seus interesses.",
        criadoEm: DateTime.now().subtract(const Duration(minutes: 15)),
        lida: _idsLidosLocalmente.contains("notif-complete-perfil"),
      ),
    ];
  }
}
