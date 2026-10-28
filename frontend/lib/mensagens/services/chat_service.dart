// lib/mensagens/services/chat_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/session_service.dart';
import '../models/chat_models.dart';

class ChatService {
  final String baseUrl;
  final String? authToken;

  ChatService({
    this.baseUrl = "https://abc-do-bem.onrender.com",
    this.authToken,
  });

  String? get _tokenFinal => (authToken != null && authToken!.trim().isNotEmpty)
      ? authToken!.trim()
      : SessionService.instance.token;

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (_tokenFinal != null && _tokenFinal!.isNotEmpty)
          "Authorization": "Bearer $_tokenFinal",
      };

  /// 1. GET /chat/conversations
  /// Carrega a Caixa de Entrada (Inbox) baseada no usuário autenticado via token JWT.
  Future<List<ChatConversation>> buscarConversas({
    required String usuarioId,
    required String tipoUsuario,
  }) async {
    final uri = Uri.parse('$baseUrl/chat/conversations');
    debugPrint("=== BUSCANDO CONVERSAS DO CHAT ===");
    debugPrint("URL: $uri");

    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      debugPrint("Status Code Conversas: ${response.statusCode}");
      debugPrint("Body Conversas: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final List dados = json.decode(utf8.decode(response.bodyBytes));
        return dados
            .map((c) => ChatConversation.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint("Erro ao buscar conversas na API: $e");
    }

    // Fallback de demonstração limpo
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockConversas(tipoUsuario);
  }

  /// 2. GET /chat/history/{otherUserId}
  /// Procura o histórico de mensagens entre o usuário logado e o interlocutor.
  Future<List<ChatMessage>> buscarMensagens(String otherUserId) async {
    final uri = Uri.parse('$baseUrl/chat/history/$otherUserId');
    debugPrint("=== BUSCANDO MENSAGENS ===");
    debugPrint("URL: $uri");

    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      debugPrint("Status Code Mensagens: ${response.statusCode}");
      debugPrint("Body Mensagens: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final List dados = json.decode(utf8.decode(response.bodyBytes));
        return dados
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint("Erro ao buscar histórico de mensagens na API: $e");
    }

    await Future.delayed(const Duration(milliseconds: 200));
    return _mockMensagens(otherUserId);
  }

  /// 3. POST /chat/send
  /// Envio de mensagem direta
  Future<ChatMessage> enviarMensagem({
    required String conversaId,
    required String remetenteId,
    required String texto,
  }) async {
    final uri = Uri.parse('$baseUrl/chat/send');
    final payload = json.encode({
      'recipientId': conversaId,
      'senderId': remetenteId,
      'text': texto,
    });

    debugPrint("=== ENVIANDO MENSAGEM ===");
    debugPrint("URL: $uri");
    debugPrint("Payload: $payload");

    try {
      final response = await http
          .post(uri, headers: _headers, body: payload)
          .timeout(const Duration(seconds: 10));

      debugPrint("Status Code Envio Mensagem: ${response.statusCode}");
      debugPrint("Body Envio Mensagem: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatMessage.fromJson(
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint("Erro ao enviar mensagem na API: $e");
    }

    await Future.delayed(const Duration(milliseconds: 150));
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversaId: conversaId,
      remetenteId: remetenteId,
      texto: texto,
      dataHora: DateTime.now(),
      lida: false,
    );
  }

  /// 4. PATCH /chat/read/{otherUserId}
  /// Marcação de mensagens como lidas
  Future<void> marcarComoLida(String otherUserId) async {
    final uri = Uri.parse('$baseUrl/chat/read/$otherUserId');
    debugPrint("=== MARCANDO MENSAGENS COMO LIDAS: $uri ===");

    try {
      final response = await http
          .patch(uri, headers: _headers)
          .timeout(const Duration(seconds: 5));

      debugPrint("Status Code Marcar Lida: ${response.statusCode}");
    } catch (e) {
      debugPrint("Erro ao marcar lida na API: $e");
    }
  }

  // --- DADOS DE APOIO / FALLBACK ---

  List<ChatConversation> _mockConversas(String tipoUsuario) {
    if (tipoUsuario.toLowerCase() == 'ong') {
      return [
        ChatConversation(
          id: "vol-1",
          interlocutorId: "vol-1",
          interlocutorNome: "Ana Carolina",
          interlocutorFoto:
              "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400",
          interlocutorSubtitulo: "Voluntária • Santo André",
          online: true,
          naoLidas: 1,
          ultimaMensagem: ChatMessage(
            id: "m-1",
            conversaId: "vol-1",
            remetenteId: "vol-1",
            texto: "Preciso levar algum documento para a ação?",
            dataHora: DateTime.now().subtract(const Duration(minutes: 5)),
            lida: false,
          ),
        ),
      ];
    } else {
      return [
        ChatConversation(
          id: "ong-1",
          interlocutorId: "ong-1",
          interlocutorNome: "Instituto Criança Cidadã",
          interlocutorFoto:
              "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
          interlocutorSubtitulo: "Santo André • Educação",
          online: true,
          naoLidas: 0,
          ultimaMensagem: ChatMessage(
            id: "m-10",
            conversaId: "ong-1",
            remetenteId: "ong-1",
            texto:
                "Olá! Agradecemos o interesse em participar de nossas ações no ABC.",
            dataHora: DateTime.now().subtract(const Duration(minutes: 2)),
            lida: true,
          ),
        ),
      ];
    }
  }

  List<ChatMessage> _mockMensagens(String otherUserId) {
    final meuId = SessionService.instance.usuarioId ?? "meu_id";
    return [
      ChatMessage(
        id: "msg-1",
        conversaId: otherUserId,
        remetenteId: otherUserId,
        texto:
            "Olá! Agradecemos o interesse em participar de nossas ações no ABC.",
        dataHora: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      ChatMessage(
        id: "msg-2",
        conversaId: otherUserId,
        remetenteId: meuId,
        texto: "Muito obrigado pelo retorno!",
        dataHora: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];
  }
}
