// lib/login/services/login_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/login_dto.dart';

class LoginService {
  final String baseUrl;

  LoginService({this.baseUrl = "https://abc-do-bem.onrender.com"});

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  /// POST /auth/login
  Future<RespostaLoginDto> autenticar(LoginDto dto) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final payloadJson = jsonEncode(dto.toJson());

    debugPrint("=== ENVIANDO LOGIN PARA A API ===");
    debugPrint("URL: $url");
    debugPrint("Payload: $payloadJson");

    try {
      final response = await http
          .post(
            url,
            headers: _headers,
            body: payloadJson,
          )
          .timeout(const Duration(seconds: 15));

      final String responseBody = utf8.decode(response.bodyBytes);

      debugPrint("=== RESPOSTA DO LOGIN ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dados = jsonDecode(responseBody) as Map<String, dynamic>;
        return RespostaLoginDto.fromJson(dados);
      } else {
        String mensagemErro = "Credenciais inválidas.";
        try {
          final erroBody = jsonDecode(responseBody);
          if (erroBody is Map) {
            final msg = erroBody['message'] ??
                erroBody['mensagem'] ??
                erroBody['error'];
            mensagemErro = msg is List ? msg.join(', ') : msg.toString();
          }
        } catch (_) {}
        throw Exception(mensagemErro);
      }
    } catch (e) {
      debugPrint("=== ERRO CAPTURADO NO LOGIN ===");
      debugPrint(e.toString());
      rethrow;
    }
  }
}
