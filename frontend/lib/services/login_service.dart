// lib/services/login_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse {
  final String token;
  final String? usuarioId;
  final String? tipoUsuario;
  final String? nome;

  LoginResponse({
    required this.token,
    this.usuarioId,
    this.tipoUsuario,
    this.nome,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['accessToken'] ?? json['jwt'] ?? '',
      usuarioId:
          json['id'] ?? json['usuarioId'] ?? json['userId'] ?? 'voluntario-1',
      tipoUsuario: json['tipo'] ?? json['role'] ?? 'voluntario',
      nome: json['nome'] ?? json['name'],
    );
  }
}

class LoginService {
  static const String baseUrl = 'https://abc-do-bem.onrender.com';

  Future<LoginResponse> autenticar({
    required String email,
    required String senha,
    required String perfil, // 'voluntario' ou 'ong'
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'senha': senha,
        'tipo': perfil,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return LoginResponse.fromJson(data);
    } else {
      String mensagemErro = 'Credenciais inválidas. Verifique seus dados.';
      try {
        final erroJson = jsonDecode(utf8.decode(response.bodyBytes));
        if (erroJson is Map && erroJson.containsKey('message')) {
          mensagemErro = erroJson['message'];
        } else if (erroJson is Map && erroJson.containsKey('erro')) {
          mensagemErro = erroJson['erro'];
        }
      } catch (_) {}
      throw Exception(mensagemErro);
    }
  }
}
