// lib/models/login_dto.dart

import 'dart:convert';

/// Schema de envio para POST /auth/login
class LoginDto {
  final String email;
  final String password;

  LoginDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email.trim().toLowerCase(),
      "password": password,
    };
  }
}

/// Schema de resposta do POST /auth/login
class RespostaLoginDto {
  final String accessToken;
  final String role;
  final String name;
  final String? usuarioId;

  RespostaLoginDto({
    required this.accessToken,
    required this.role,
    required this.name,
    this.usuarioId,
  });

  factory RespostaLoginDto.fromJson(Map<String, dynamic> json) {
    final token = (json['access_token'] ??
            json['accessToken'] ??
            json['token'] ??
            json['jwt'] ??
            '')
        .toString();

    // Extrai o UUID da claim 'sub' presente no JWT retornado
    String? subId;
    if (token.isNotEmpty) {
      try {
        final partes = token.split('.');
        if (partes.length == 3) {
          final payloadNormalizada = base64Url.normalize(partes[1]);
          final payloadDecodificada =
              utf8.decode(base64Url.decode(payloadNormalizada));
          final payloadMap = jsonDecode(payloadDecodificada);
          subId = payloadMap['sub']?.toString();
        }
      } catch (_) {}
    }

    return RespostaLoginDto(
      accessToken: token,
      role: (json['role'] ?? 'USER').toString(),
      name: (json['name'] ?? '').toString(),
      usuarioId: subId ?? json['id']?.toString(),
    );
  }
}
