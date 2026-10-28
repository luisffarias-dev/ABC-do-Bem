// lib/models/notification_models.dart

import 'package:flutter/material.dart';

/// Tipos suportados de notificações no sistema
enum TipoNotificacao {
  evento, // Novo evento próximo ou match com o perfil
  aprovacao, // ONG aprovou a inscrição do voluntário
  conquista, // Gamificação (horas doadas, selo ouro, etc.)
  sistema, // Avisos de perfil incompleto, termos, etc.
}

/// Representa uma notificação enviada para o usuário (Voluntário ou ONG)
class NotificacaoModel {
  final String id;
  final String usuarioId;
  final TipoNotificacao tipo;
  final String titulo;
  final String descricaoCurta;
  final String mensagemCompleta;
  final DateTime criadoEm;
  bool lida;

  // Parâmetros opcionais contextuais para ações dinâmicas
  final String? eventoId;
  final String? ongId;
  final String? rotaDestino;

  NotificacaoModel({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.titulo,
    required this.descricaoCurta,
    required this.mensagemCompleta,
    required this.criadoEm,
    this.lida = false,
    this.eventoId,
    this.ongId,
    this.rotaDestino,
  });

  /// Factory para desserializar a resposta JSON da API RESTful
  factory NotificacaoModel.fromJson(Map<String, dynamic> json) {
    TipoNotificacao parseTipo(String? tipoStr) {
      switch (tipoStr?.toLowerCase()) {
        case 'evento':
          return TipoNotificacao.evento;
        case 'aprovacao':
          return TipoNotificacao.aprovacao;
        case 'conquista':
          return TipoNotificacao.conquista;
        default:
          return TipoNotificacao.sistema;
      }
    }

    return NotificacaoModel(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
      tipo: parseTipo(json['tipo']),
      titulo: json['titulo'] ?? '',
      descricaoCurta: json['descricaoCurta'] ?? '',
      mensagemCompleta: json['mensagemCompleta'] ?? '',
      criadoEm: json['criadoEm'] != null
          ? DateTime.tryParse(json['criadoEm'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lida: json['lida'] ?? false,
      eventoId: json['eventoId']?.toString(),
      ongId: json['ongId']?.toString(),
      rotaDestino: json['rotaDestino'],
    );
  }

  /// Serialização para envio de dados
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipo': tipo.name,
      'titulo': titulo,
      'descricaoCurta': descricaoCurta,
      'mensagemCompleta': mensagemCompleta,
      'criadoEm': criadoEm.toIso8601String(),
      'lida': lida,
      'eventoId': eventoId,
      'ongId': ongId,
      'rotaDestino': rotaDestino,
    };
  }

  // --- GETTERS AUXILIARES DE DESIGN SYSTEM ---

  /// Retorna o ícone Material correspondente ao tipo
  IconData get icone {
    switch (tipo) {
      case TipoNotificacao.evento:
        return Icons.event_available_rounded;
      case TipoNotificacao.aprovacao:
        return Icons.check_circle_outline_rounded;
      case TipoNotificacao.conquista:
        return Icons.emoji_events_rounded;
      case TipoNotificacao.sistema:
        return Icons.person_outline_rounded;
    }
  }

  /// Retorna a cor temática do card/badge da notificação
  Color get corTema {
    switch (tipo) {
      case TipoNotificacao.evento:
        return const Color(0xFF0C6B6B);
      case TipoNotificacao.aprovacao:
        return const Color(0xFF29B0A0);
      case TipoNotificacao.conquista:
        return const Color(0xFFD48806);
      case TipoNotificacao.sistema:
        return const Color(0xFF3A6868);
    }
  }

  /// Formatação de tempo relativo amigável (ex: "Há 15 min", "Há 2 horas", "Ontem")
  String get dataRelativa {
    final diff = DateTime.now().difference(criadoEm);

    if (diff.inMinutes < 1) {
      return "Agora mesmo";
    } else if (diff.inMinutes < 60) {
      return "Há ${diff.inMinutes} min";
    } else if (diff.inHours < 24) {
      return "Há ${diff.inHours} ${diff.inHours == 1 ? 'hora' : 'horas'}";
    } else if (diff.inDays == 1) {
      return "Ontem";
    } else if (diff.inDays < 7) {
      return "Há ${diff.inDays} dias";
    } else {
      final d = criadoEm.day.toString().padLeft(2, '0');
      final m = criadoEm.month.toString().padLeft(2, '0');
      return "$d/$m";
    }
  }
}
