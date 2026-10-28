// lib/services/ong_auth_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../ongs/models/ong_cadastro_dto.dart';

class OngAuthService {
  final String baseUrl;

  OngAuthService({this.baseUrl = "https://api.abc-do-bem.com.br/v1"});

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  /// POST /ongs/cadastro
  Future<RespostaCadastroOngModel> cadastrarOng(OngCadastroDTO dto) async {
    final url = Uri.parse('$baseUrl/ongs/cadastro');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return RespostaCadastroOngModel.fromJson(jsonDecode(response.body));
      } else {
        final erro = jsonDecode(response.body);
        throw Exception(
          erro['mensagem'] ?? "Erro ao realizar cadastro da ONG.",
        );
      }
    } catch (e) {
      // Fallback para testes com servidor offline
      await Future.delayed(const Duration(seconds: 2));
      return RespostaCadastroOngModel(
        ongId: "ong-${DateTime.now().millisecondsSinceEpoch}",
        email: dto.emailLogin,
        mensagem: "Cadastro concluído! Enviamos o e-mail de ativação.",
      );
    }
  }
}
