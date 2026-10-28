// lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/voluntario_cadastro_dto.dart';

/// Serviço responsável pelo registro e login de voluntários e ONGs
class AuthService {
  final String baseUrl;

  AuthService({this.baseUrl = "https://abc-do-bem.onrender.com"});

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  /// POST /auth/userRegister
  /// Envia todos os dados acumulados das 3 etapas para criar o voluntário no backend
  Future<RespostaCadastroVoluntario> cadastrarVoluntario(
    VoluntarioCadastroDTO dto,
  ) async {
    final url = Uri.parse('$baseUrl/auth/userRegister');
    final payloadJson = jsonEncode(dto.toJson());

    debugPrint("=== ENVIANDO PARA A API ===");
    debugPrint("URL: $url");
    debugPrint("Payload: $payloadJson");

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: payloadJson,
      );

      final String responseBody = utf8.decode(response.bodyBytes);

      debugPrint("=== RESPOSTA DO BACKEND ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: $responseBody");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return RespostaCadastroVoluntario.fromJson(jsonDecode(responseBody));
      } else {
        String mensagemErro = "Erro ${response.statusCode}: ";
        try {
          final erroBody = jsonDecode(responseBody);
          if (erroBody is Map) {
            mensagemErro += (erroBody['message'] ??
                    erroBody['mensagem'] ??
                    erroBody['error'] ??
                    responseBody)
                .toString();
          } else {
            mensagemErro += responseBody;
          }
        } catch (_) {
          mensagemErro += responseBody;
        }
        throw Exception(mensagemErro);
      }
    } catch (e) {
      debugPrint("=== ERRO CAPTURADO ===");
      debugPrint(e.toString());
      rethrow;
    }
  }
}
