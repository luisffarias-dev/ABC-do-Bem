// lib/mensagens/models/chat_models.dart

/// Representa uma mensagem individual trocada no chat.
class ChatMessage {
  final String id;
  final String conversaId;
  final String remetenteId;
  final String texto;
  final DateTime dataHora;
  final bool lida;

  ChatMessage({
    required this.id,
    required this.conversaId,
    required this.remetenteId,
    required this.texto,
    required this.dataHora,
    this.lida = false,
  });

  /// Factory para converter a resposta JSON da API RESTful com suporte a camelCase e snake_case
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime dataParsed = DateTime.now();
    final rawData = json['dataHora'] ??
        json['createdAt'] ??
        json['created_at'] ??
        json['timestamp'];
    if (rawData != null) {
      dataParsed =
          DateTime.tryParse(rawData.toString())?.toLocal() ?? DateTime.now();
    }

    return ChatMessage(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      conversaId:
          (json['conversaId'] ?? json['conversation_id'] ?? '').toString(),
      remetenteId:
          (json['remetenteId'] ?? json['senderId'] ?? json['sender_id'] ?? '')
              .toString(),
      texto:
          (json['texto'] ?? json['text'] ?? json['content'] ?? '').toString(),
      dataHora: dataParsed,
      lida: json['lida'] ?? json['read'] ?? false,
    );
  }

  /// Converte o objeto para JSON no envio via POST.
  Map<String, dynamic> toJson() {
    return {
      'conversaId': conversaId,
      'remetenteId': remetenteId,
      'texto': texto,
    };
  }

  /// Retorna o horário contextual: "HH:mm" se for hoje, "Ontem" ou "DD/MM" se for anterior
  String get horarioFormatado {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final dataMsg = DateTime(dataHora.year, dataHora.month, dataHora.day);

    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');

    if (dataMsg == hoje) {
      return '$hora:$minuto';
    } else if (dataMsg == hoje.subtract(const Duration(days: 1))) {
      return 'Ontem';
    } else {
      final dia = dataHora.day.toString().padLeft(2, '0');
      final mes = dataHora.month.toString().padLeft(2, '0');
      return '$dia/$mes';
    }
  }
}

/// Representa um item da lista de conversas ativas.
class ChatConversation {
  final String id;
  final String interlocutorId;
  final String interlocutorNome;
  final String interlocutorFoto;
  final String interlocutorSubtitulo;
  final bool online;
  int naoLidas;
  ChatMessage? ultimaMensagem;

  ChatConversation({
    required this.id,
    required this.interlocutorId,
    required this.interlocutorNome,
    required this.interlocutorFoto,
    required this.interlocutorSubtitulo,
    this.online = false,
    this.naoLidas = 0,
    this.ultimaMensagem,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    // Parsing robusto para naoLidas (aceita int, string ou fallback 0)
    int unreadCount = 0;
    final rawUnread =
        json['naoLidas'] ?? json['unreadCount'] ?? json['unread_count'];
    if (rawUnread != null) {
      unreadCount = int.tryParse(rawUnread.toString()) ?? 0;
    }

    ChatMessage? ultimaMsg;
    final rawUltima =
        json['ultimaMensagem'] ?? json['lastMessage'] ?? json['last_message'];
    if (rawUltima != null && rawUltima is Map<String, dynamic>) {
      ultimaMsg = ChatMessage.fromJson(rawUltima);
    }

    final rawFoto = json['interlocutorFoto'] ??
        json['avatarUrl'] ??
        json['avatar_url'] ??
        json['foto'];
    final fotoFinal = (rawFoto != null && rawFoto.toString().trim().isNotEmpty)
        ? rawFoto.toString()
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400';

    return ChatConversation(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      interlocutorId: (json['interlocutorId'] ??
              json['otherUserId'] ??
              json['other_user_id'] ??
              '')
          .toString(),
      interlocutorNome: (json['interlocutorNome'] ??
              json['name'] ??
              json['nome'] ??
              'Usuário')
          .toString(),
      interlocutorFoto: fotoFinal,
      interlocutorSubtitulo: (json['interlocutorSubtitulo'] ??
              json['subtitle'] ??
              json['cidade'] ??
              '')
          .toString(),
      online: json['online'] ?? json['isOnline'] ?? false,
      naoLidas: unreadCount,
      ultimaMensagem: ultimaMsg,
    );
  }
}
