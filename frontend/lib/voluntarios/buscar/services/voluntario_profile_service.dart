// lib/voluntarios/services/voluntario_profile_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../services/session_service.dart';
import '../models/voluntario_profile_models.dart';

class VoluntarioProfileService {
  final String baseUrl = "https://abc-do-bem.onrender.com";
  final String? authToken;

  VoluntarioProfileService({this.authToken});

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

  /// 1. Busca os dados reais via GET /users/dashboard/me e GET /users/{id}
  Future<VoluntarioPerfilModel> buscarPerfil(
    String usuarioId, {
    String? token,
  }) async {
    final headers = _montarHeaders(token);
    final sessaoId = SessionService.instance.usuarioId;

    // Se o ID for 'voluntario-1' ou o UUID do login, busca o dashboard próprio
    final isMeuUsuario = (sessaoId != null &&
        (sessaoId == usuarioId || usuarioId == "voluntario-1"));

    Map<String, dynamic> dadosUsuario = {};
    Map<String, dynamic> dadosDashboard = {};
    List<ExperienciaFeedModel> experiencias = [];

    // 1. GET /users/dashboard/me (Métricas e estatísticas)
    if (isMeuUsuario && headers.containsKey("Authorization")) {
      try {
        final urlDash = Uri.parse("$baseUrl/users/dashboard/me");
        final resDash = await http
            .get(urlDash, headers: headers)
            .timeout(const Duration(seconds: 8));

        if (resDash.statusCode == 200) {
          final dynamic body = jsonDecode(utf8.decode(resDash.bodyBytes));
          if (body is Map<String, dynamic>) {
            dadosDashboard = body;
          }
        }
      } catch (e) {
        debugPrint("Erro em /users/dashboard/me: $e");
      }
    }

    // 2. GET /users/{id} (Dados cadastrais)
    final idParaBuscar = (usuarioId == "voluntario-1" && sessaoId != null)
        ? sessaoId
        : usuarioId;
    try {
      final urlUser = Uri.parse("$baseUrl/users/$idParaBuscar");
      final resUser = await http
          .get(urlUser, headers: headers)
          .timeout(const Duration(seconds: 8));

      if (resUser.statusCode == 200) {
        final dynamic body = jsonDecode(utf8.decode(resUser.bodyBytes));
        if (body is Map<String, dynamic>) {
          dadosUsuario = body;
        }
      }
    } catch (e) {
      debugPrint("Erro em /users/$idParaBuscar: $e");
    }

    // 3. GET /social/voluntarios/{userId}/experiencias
    try {
      final urlExp =
          Uri.parse("$baseUrl/social/voluntarios/$idParaBuscar/experiencias");
      final resExp = await http
          .get(urlExp, headers: headers)
          .timeout(const Duration(seconds: 6));

      if (resExp.statusCode == 200) {
        final dynamic corpoExp = jsonDecode(utf8.decode(resExp.bodyBytes));
        if (corpoExp is List) {
          experiencias = corpoExp.map((item) {
            return ExperienciaFeedModel(
              id: item['id']?.toString() ?? '',
              ongNome: item['ong']?['name']?.toString() ?? 'ABC do Bem',
              dataFormatada: 'Recente',
              texto: item['texto']?.toString() ??
                  item['content']?.toString() ??
                  '',
              imagemUrl: item['imagemUrl']?.toString(),
              curtidas: (item['curtidas'] as num?)?.toInt() ?? 0,
            );
          }).toList();
        }
      }
    } catch (_) {}

    if (dadosUsuario.isNotEmpty || dadosDashboard.isNotEmpty) {
      return _mesclarDadosApi(
        usuarioId: idParaBuscar,
        usuarioData: dadosUsuario,
        dashboardData: dadosDashboard,
        experienciasApi: experiencias,
      );
    }

    // Fallback integrado com o login real
    return _obterMockPorId(idParaBuscar);
  }

  /// 2. Atualiza via PATCH /users/profile/me (Swagger oficial)
  Future<void> atualizarPerfil(
    String usuarioId,
    Map<String, dynamic> dadosAtualizados, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/users/profile/me");
    final headers = _montarHeaders(token);

    try {
      final response = await http
          .patch(
            url,
            headers: headers,
            body: jsonEncode(dadosAtualizados),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint("Status Code PATCH /users/profile/me: ${response.statusCode}");
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Erro na API: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erro ao atualizar perfil: $e");
      rethrow;
    }
  }

  /// 3. Publica relato via POST /social/voluntarios/experiencias
  Future<void> publicarExperiencia(
    String usuarioId,
    String texto,
    String? imagemUrl, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/social/voluntarios/experiencias");
    final headers = _montarHeaders(token);

    try {
      await http
          .post(
            url,
            headers: headers,
            body: jsonEncode({
              "texto": texto,
              if (imagemUrl != null) "imagemUrl": imagemUrl,
            }),
          )
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint("Erro ao publicar experiência: $e");
    }
  }

  VoluntarioPerfilModel _mesclarDadosApi({
    required String usuarioId,
    required Map<String, dynamic> usuarioData,
    required Map<String, dynamic> dashboardData,
    required List<ExperienciaFeedModel> experienciasApi,
  }) {
    final nomeSessao = SessionService.instance.nomeUsuario;

    final totalEventos = (dashboardData['totalOportunidades'] ??
                dashboardData['eventosConcluidos'] ??
                usuarioData['totalEventos'] as num?)
            ?.toInt() ??
        0;

    final totalHoras = (dashboardData['totalHoras'] ??
                dashboardData['horasVoluntariadas'] ??
                usuarioData['totalHoras'] as num?)
            ?.toInt() ??
        0;

    List<String> extrairLista(dynamic valor) {
      if (valor is List) {
        return valor.map((e) => e.toString()).toList();
      }
      return [];
    }

    final avatarRaw =
        usuarioData['avatar']?.toString() ?? usuarioData['fotoUrl']?.toString();
    final fotoValida = (avatarRaw != null && avatarRaw.startsWith('http'))
        ? avatarRaw
        : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(usuarioData['name'] ?? nomeSessao ?? 'Douglas')}&background=0C6B6B&color=fff";

    return VoluntarioPerfilModel(
      id: usuarioData['id']?.toString() ?? usuarioId,
      nome: usuarioData['name']?.toString() ??
          usuarioData['nome']?.toString() ??
          nomeSessao ??
          "Douglas Barbosa de Oliveira",
      cpf: usuarioData['cpf']?.toString() ?? "",
      nascimento: usuarioData['birthDate']?.toString() ?? "06/02/1991",
      cidade: usuarioData['cidade']?.toString() ?? "Mauá",
      estado: usuarioData['estado']?.toString() ?? "SP",
      cep: usuarioData['cep']?.toString() ?? "09300-000",
      logradouro: usuarioData['logradouro']?.toString() ?? "",
      numero: usuarioData['numero']?.toString() ?? "",
      bairro: usuarioData['bairro']?.toString() ?? "Centro",
      fotoUrl: fotoValida,
      bannerUrl:
          "https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=1200",
      totalEventos: totalEventos,
      totalHoras: totalHoras,
      tempoAtivo: "1a",
      bio: usuarioData['bio']?.toString() ??
          "Voluntário ativo em iniciativas de impacto comunitário e tecnologia no Grande ABC.",
      habilidades: extrairLista(usuarioData['habilidades']).isNotEmpty
          ? extrairLista(usuarioData['habilidades'])
          : ["Desenvolvimento de Software", "Organização", "Educação"],
      disponibilidade: extrairLista(usuarioData['disponibilidade']).isNotEmpty
          ? extrairLista(usuarioData['disponibilidade'])
          : ["Finais de Semana", "Manhãs"],
      escolaridade: "Superior",
      curso: "Desenvolvimento de Software Multiplataforma",
      instagram: usuarioData['instagram']?.toString() ?? "@doug_oliveira",
      linkedin:
          usuarioData['linkedin']?.toString() ?? "linkedin.com/in/douglas",
      whatsapp: usuarioData['phone']?.toString() ?? "(11) 99999-8888",
      experiencias: experienciasApi,
    );
  }

  VoluntarioPerfilModel _obterMockPorId(String id) {
    final nome =
        SessionService.instance.nomeUsuario ?? "Douglas Barbosa de Oliveira";
    return VoluntarioPerfilModel(
      id: id,
      nome: nome,
      cpf: "123.456.789-00",
      nascimento: "06/02/1991",
      cidade: "Mauá",
      estado: "SP",
      cep: "09300-000",
      logradouro: "Av. Barão de Mauá",
      numero: "100",
      bairro: "Centro",
      fotoUrl:
          "https://ui-avatars.com/api/?name=${Uri.encodeComponent(nome)}&background=0C6B6B&color=fff",
      bannerUrl:
          "https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=1200",
      totalEventos: 0,
      totalHoras: 0,
      tempoAtivo: "1a",
      bio:
          "Voluntário ativo em iniciativas de impacto comunitário e tecnologia no Grande ABC.",
      habilidades: const [
        "Desenvolvimento de Software",
        "Organização",
        "Educação"
      ],
      disponibilidade: const ["Finais de Semana", "Manhãs"],
      escolaridade: "Superior",
      curso: "Desenvolvimento de Software Multiplataforma",
      instagram: "@doug_oliveira",
      linkedin: "linkedin.com/in/douglas",
      whatsapp: "(11) 99999-8888",
      experiencias: const [],
    );
  }
}
