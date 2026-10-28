// lib/services/ong_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../ongs/models/ong_models.dart';

/// Serviço responsável pelo consumo dos endpoints REST de busca de ONGs e recomendações
class OngService {
  final String baseUrl;
  final String? authToken;

  OngService({
    this.baseUrl = "https://api.abc-do-bem.com.br/v1",
    this.authToken,
  });

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (authToken != null) "Authorization": "Bearer $authToken",
      };

  /// 1. GET /ongs?termo={query}&categoria={cat}
  /// Lista todas as ONGs com suporte a filtros
  Future<List<OngModel>> buscarOngs({String? termo, String? categoria}) async {
    final queryParams = {
      if (termo != null && termo.trim().isNotEmpty) 'termo': termo.trim(),
      if (categoria != null && categoria != 'Todas') 'categoria': categoria,
    };

    final url =
        Uri.parse('$baseUrl/ongs').replace(queryParameters: queryParams);

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List dados = jsonDecode(response.body);
        return dados.map((json) => OngModel.fromJson(json)).toList();
      } else {
        throw Exception("Erro ao buscar ONGs: ${response.statusCode}");
      }
    } catch (e) {
      // Fallback local caso o backend esteja offline
      await Future.delayed(const Duration(milliseconds: 250));
      return _obterTodasOngsMock();
    }
  }

  /// 2. GET /voluntarios/{voluntarioId}/ongs-recomendadas
  /// Retorna as ONGs recomendadas com base nas habilidades do usuário
  Future<List<OngRecomendadaModel>> buscarRecomendacoes(
    String voluntarioId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/voluntarios/$voluntarioId/ongs-recomendadas',
    );

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List dados = jsonDecode(response.body);
        return dados.map((json) => OngRecomendadaModel.fromJson(json)).toList();
      } else {
        throw Exception("Erro ao buscar recomendações: ${response.statusCode}");
      }
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _obterRecomendacoesMock();
    }
  }

  // --- MOCKS LOCAIS DE FALLBACK ---

  List<OngRecomendadaModel> _obterRecomendacoesMock() {
    return [
      OngRecomendadaModel(
        id: 1,
        nome: "Exemplo 1 - Mãos que Fazem",
        cidade: "Santo André",
        match: "98% match",
        categoria: "Educação",
        imagem:
            "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
      ),
      OngRecomendadaModel(
        id: 2,
        nome: "Exemplo 2 - Ação Verde ABC",
        cidade: "São Bernardo",
        match: "92% match",
        categoria: "Meio Ambiente",
        imagem:
            "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=200",
      ),
      OngRecomendadaModel(
        id: 3,
        nome: "Exemplo 3 - Saúde para Todos",
        cidade: "São Caetano",
        match: "89% match",
        categoria: "Saúde",
        imagem:
            "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=200",
      ),
    ];
  }

  List<OngModel> _obterTodasOngsMock() {
    return [
      OngModel(
        id: 1,
        nome: "Exemplo 1 - Mãos que Fazem",
        cidade: "Santo André",
        categoria: "Educação",
        voluntarios: 34,
        imagem:
            "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
        posMapa: PosicaoMapa(x: 0.6, y: 0.3),
      ),
      OngModel(
        id: 2,
        nome: "Exemplo 2 - Ação Verde ABC",
        cidade: "São Bernardo do Campo",
        categoria: "Meio Ambiente",
        voluntarios: 52,
        imagem:
            "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=200",
        posMapa: PosicaoMapa(x: 0.45, y: 0.55),
      ),
      OngModel(
        id: 3,
        nome: "Exemplo 3 - Saúde para Todos",
        cidade: "São Caetano do Sul",
        categoria: "Saúde",
        voluntarios: 28,
        imagem:
            "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=200",
        posMapa: PosicaoMapa(x: 0.52, y: 0.22),
      ),
      OngModel(
        id: 4,
        nome: "Exemplo 4 - Arte & Cidadania",
        cidade: "Mauá",
        categoria: "Cultura",
        voluntarios: 21,
        imagem:
            "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=200",
        posMapa: PosicaoMapa(x: 0.65, y: 0.75),
      ),
      OngModel(
        id: 5,
        nome: "Exemplo 5 - Teto Solidário",
        cidade: "Diadema",
        categoria: "Habitação",
        voluntarios: 39,
        imagem:
            "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=200",
        posMapa: PosicaoMapa(x: 0.5, y: 0.8),
      ),
    ];
  }
}
