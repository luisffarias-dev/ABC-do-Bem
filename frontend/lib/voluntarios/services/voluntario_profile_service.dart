// lib/voluntarios/services/voluntario_profile_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/session_service.dart';
import '../models/voluntario_profile_models.dart';

class VoluntarioProfileService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  /// Recupera o token prioritariamente via argumento ou pela sessão ativa
  String? _obterToken(String? tokenParametro) {
    if (tokenParametro != null && tokenParametro.trim().isNotEmpty) {
      return tokenParametro.trim();
    }
    return SessionService.instance.token;
  }

  /// GET /users/{id}
  Future<VoluntarioPerfilModel> buscarPerfil(
    String usuarioId, {
    String? token,
    String? fallbackNome,
  }) async {
    final url = Uri.parse("$baseUrl/users/$usuarioId");
    final tokenFinal = _obterToken(token);

    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== BUSCANDO PERFIL DO USUÁRIO ===");
    debugPrint("URL: $url");
    debugPrint("Headers: $headers");

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 12));

      debugPrint("Status Code Perfil: ${response.statusCode}");
      debugPrint("Body Perfil: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> dados =
            jsonDecode(utf8.decode(response.bodyBytes));
        return VoluntarioPerfilModel.fromJson(dados);
      }
    } catch (e) {
      debugPrint("Erro ao buscar perfil real: $e");
    }

    await Future.delayed(const Duration(milliseconds: 250));
    return _obterMockPorId(
      usuarioId,
      nomeFallback: fallbackNome ?? SessionService.instance.nomeUsuario,
    );
  }

  /// PATCH /users/profile/me
  Future<void> atualizarPerfil(
    String usuarioId,
    Map<String, dynamic> dadosAtualizados, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/users/profile/me");
    final tokenFinal = _obterToken(token);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    final payloadJson = jsonEncode(dadosAtualizados);

    debugPrint("=== ENVIANDO ATUALIZAÇÃO DE PERFIL ===");
    debugPrint("URL: $url");
    debugPrint("Headers: $headers");
    debugPrint("Payload: $payloadJson");

    try {
      final response = await http
          .patch(
            url,
            headers: headers,
            body: payloadJson,
          )
          .timeout(const Duration(seconds: 15));

      final String responseBody = utf8.decode(response.bodyBytes);

      debugPrint("=== RESPOSTA DA ATUALIZAÇÃO ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint("Perfil atualizado com sucesso no backend!");
        return;
      } else {
        String mensagemErro = "Erro ao salvar alterações no servidor.";
        try {
          final erroJson = jsonDecode(responseBody);
          if (erroJson is Map && erroJson.containsKey('message')) {
            final msg = erroJson['message'];
            mensagemErro = msg is List ? msg.join(', ') : msg.toString();
          }
        } catch (_) {}
        throw Exception(mensagemErro);
      }
    } catch (e) {
      debugPrint("=== ERRO AO ATUALIZAR PERFIL ===");
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// POST /social/voluntarios/experiencias
  Future<void> publicarExperiencia(
    String usuarioId,
    String texto,
    String? imagemUrl, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/social/voluntarios/experiencias");
    final tokenFinal = _obterToken(token);

    try {
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (tokenFinal != null && tokenFinal.isNotEmpty)
            "Authorization": "Bearer $tokenFinal",
        },
        body: jsonEncode({
          "texto": texto,
          "imagemUrl": imagemUrl,
        }),
      );
    } catch (_) {}
  }

  VoluntarioPerfilModel _obterMockPorId(String id, {String? nomeFallback}) {
    if (nomeFallback != null && nomeFallback.trim().isNotEmpty) {
      return VoluntarioPerfilModel(
        id: id,
        nome: nomeFallback.trim(),
        cpf: "341.883.713-15",
        nascimento: "06/02/1991",
        cidade: "Mauá",
        estado: "SP",
        cep: "09360-160",
        logradouro: "Rua Carlos Tamagnini",
        numero: "1203",
        bairro: "Vila Nossa Senhora das Vitórias",
        fotoUrl:
            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400",
        bannerUrl:
            "https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=1200",
        totalEventos: 0,
        totalHoras: 0,
        tempoAtivo: "Recém-chegado",
        bio: "Voluntário cadastrado no ABC do Bem",
        habilidades: const [
          "Desenvolvimento de aplicativos",
          "Tecnologia da informação"
        ],
        disponibilidade: const ["Voluntariado presencial"],
        escolaridade: "Superior",
        curso: "Tecnologia",
        instagram: "",
        facebook: "",
        linkedin: "",
        whatsapp: "(11) 99221-8058",
        experiencias: const [],
      );
    }

    return const VoluntarioPerfilModel(
      id: "voluntario-1",
      nome: "Ana Carolina Silva",
      cpf: "123.456.789-00",
      nascimento: "15/05/1995",
      cidade: "Santo André",
      estado: "SP",
      cep: "09390-000",
      logradouro: "Rua das Flores",
      numero: "123",
      bairro: "Vila Assis Brasil",
      fotoUrl:
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400",
      bannerUrl:
          "https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=1200",
      totalEventos: 23,
      totalHoras: 187,
      tempoAtivo: "6a",
      bio:
          "Professora apaixonada por educação inclusiva e impacto social. Voluntária há 4 anos no ABC.",
      habilidades: ["Design Gráfico", "Educação", "Fotografia"],
      disponibilidade: ["Manhãs", "Tardes", "Noites", "Fins de semana"],
      escolaridade: "Superior",
      curso: "Pedagogia / Licenciatura",
      instagram: "@anacarolina",
      facebook: "facebook.com/anacarolina",
      linkedin: "linkedin.com/in/anacarolina",
      whatsapp: "(11) 98765-4321",
      experiencias: [
        ExperienciaFeedModel(
          id: "1",
          ongNome: "Instituto Criança Cidadã",
          dataFormatada: "Há 3 dias",
          texto:
              "Tarde incrível ensinando leitura lúdica e arte para mais de 30 crianças no Parque Central! Gratidão total.",
          imagemUrl:
              "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600",
          curtidas: 14,
        ),
      ],
    );
  }
}
