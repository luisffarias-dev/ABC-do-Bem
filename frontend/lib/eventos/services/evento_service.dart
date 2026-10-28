// lib/eventos/services/evento_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/session_service.dart';
import '../models/evento_model.dart';

class EventoService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  String? _obterToken(String? tokenParametro) {
    if (tokenParametro != null && tokenParametro.trim().isNotEmpty) {
      return tokenParametro.trim();
    }
    return SessionService.instance.token;
  }

  /// Lista oportunidades disponíveis no feed (GET /opportunities)
  Future<List<EventoModel>> listarEventos({
    String? cidade,
    String? categoria,
    String? busca,
    String? token,
  }) async {
    final queryParams = <String, String>{};
    if (cidade != null && cidade.isNotEmpty && cidade != "Todas") {
      queryParams["cidade"] = cidade;
    }
    if (categoria != null && categoria.isNotEmpty && categoria != "Todos") {
      queryParams["categoria"] = categoria;
    }

    final uri = Uri.parse("$baseUrl/opportunities").replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final tokenFinal = _obterToken(token);
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== BUSCANDO OPORTUNIDADES NA API ===");
    debugPrint("URL: $uri");

    try {
      final res = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 12));
      debugPrint("Status Code Oportunidades: ${res.statusCode}");
      debugPrint("Body Oportunidades: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(utf8.decode(res.bodyBytes));
        final List<EventoModel> eventos = [];

        for (final item in lista) {
          if (item is Map<String, dynamic>) {
            eventos.add(_mapearJsonParaEvento(item));
          }
        }

        // Filtro local opcional para termo de busca digitado
        if (busca != null && busca.trim().isNotEmpty) {
          final termo = busca.trim().toLowerCase();
          return eventos.where((ev) {
            return ev.titulo.toLowerCase().contains(termo) ||
                ev.descricao.toLowerCase().contains(termo) ||
                ev.ongNome.toLowerCase().contains(termo);
          }).toList();
        }

        return eventos;
      }
    } catch (e) {
      debugPrint("Erro ao buscar oportunidades na API: $e");
    }

    return [];
  }

  /// Lista as inscrições do voluntário logado (GET /users/dashboard/me)
  Future<List<InscricaoEventoModel>> listarMinhasInscricoes(
    String voluntarioId, {
    String? token,
  }) async {
    final tokenFinal = _obterToken(token);
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    final url = Uri.parse("$baseUrl/users/dashboard/me");
    debugPrint("=== BUSCANDO MINHAS INSCRIÇÕES NO DASHBOARD ===");
    debugPrint("URL: $url");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 12));
      debugPrint("Status Code Dashboard: ${res.statusCode}");
      debugPrint("Body Dashboard: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 200) {
        final dynamic dados = jsonDecode(utf8.decode(res.bodyBytes));
        final List<dynamic> listaInscricoes =
            dados['inscricoes'] ?? dados['applications'] ?? [];

        return listaInscricoes.map((item) {
          final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
          final Map<String, dynamic>? opp =
              itemMap['opportunity'] ?? itemMap['vaga'];
          EventoModel? ev;
          if (opp != null) {
            ev = _mapearJsonParaEvento(opp);
          }

          return InscricaoEventoModel(
            id: itemMap['id']?.toString() ?? '',
            eventoId: itemMap['opportunityId']?.toString() ?? ev?.id ?? '',
            voluntarioId: itemMap['userId']?.toString() ?? voluntarioId,
            status: itemMap['status']?.toString() ?? 'Aprovado',
            autorizouContato: true,
            criadoEm:
                DateTime.tryParse(itemMap['createdAt']?.toString() ?? '') ??
                    DateTime.now(),
            evento: ev,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Erro ao buscar inscrições na API: $e");
    }

    return [];
  }

  /// Busca os detalhes completos de uma oportunidade por ID (GET /opportunities/{id})
  Future<EventoModel?> buscarPorId(
    String id, {
    String? voluntarioId,
    String? token,
  }) async {
    final tokenFinal = _obterToken(token);
    final url = Uri.parse("$baseUrl/opportunities/$id");
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== BUSCANDO DETALHES DA OPORTUNIDADE POR ID ===");
    debugPrint("URL: $url");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 12));
      debugPrint("Status Code Oportunidade $id: ${res.statusCode}");
      debugPrint("Body Oportunidade $id: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 200) {
        final item = jsonDecode(utf8.decode(res.bodyBytes));
        return _mapearJsonParaEvento(item as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Erro ao buscar oportunidade por ID: $e");
    }

    return null;
  }

  /// Lista vagas publicadas por uma ONG específica (GET /opportunities/ong/{ongId})
  Future<List<EventoModel>> listarEventosPorOng(String ongId,
      {String? token}) async {
    final tokenFinal = _obterToken(token);
    final url = Uri.parse("$baseUrl/opportunities/ong/$ongId");
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== BUSCANDO OPORTUNIDADES DA ONG: $ongId ===");
    debugPrint("URL: $url");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(utf8.decode(res.bodyBytes));
        return lista
            .whereType<Map<String, dynamic>>()
            .map((item) => _mapearJsonParaEvento(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Erro ao buscar vagas da ONG na API: $e");
    }

    return [];
  }

  /// Inscreve o voluntário logado em uma vaga (POST /opportunities/{id}/apply)
  Future<bool> inscreverVoluntario(
    String eventoId,
    String voluntarioId, {
    String? token,
  }) async {
    final tokenFinal = _obterToken(token);
    final url = Uri.parse("$baseUrl/opportunities/$eventoId/apply");
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== INSCREVENDO NA OPORTUNIDADE (APPLY) ===");
    debugPrint("URL: $url");

    try {
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"voluntarioId": voluntarioId}),
      );

      debugPrint("Status Code Apply: ${res.statusCode}");
      debugPrint("Body Apply: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint("Erro ao se inscrever na oportunidade: $e");
    }

    return false;
  }

  /// Cancelamento / Desinscrição
  Future<bool> cancelarInscricao(
    String eventoId,
    String voluntarioId, {
    String? token,
    String? motivo,
  }) async {
    final tokenFinal = _obterToken(token);
    final url = Uri.parse("$baseUrl/opportunities/$eventoId/apply");
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== CANCELANDO INSCRIÇÃO ===");
    debugPrint("URL: $url");

    try {
      final res = await http.delete(
        url,
        headers: headers,
        body: jsonEncode({"motivo": motivo}),
      );

      debugPrint("Status Code Cancelar: ${res.statusCode}");
      debugPrint("Body Cancelar: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      }
    } catch (e) {
      debugPrint("Erro ao cancelar inscrição na API: $e");
    }

    return false;
  }

  /// Criação de nova vaga pela ONG (POST /opportunities)
  Future<EventoModel?> criarEvento(CriarEventoDTO dto, {String? token}) async {
    final tokenFinal = _obterToken(token);
    final url = Uri.parse("$baseUrl/opportunities");
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    final payload = jsonEncode({
      "title": dto.titulo,
      "description": dto.descricao,
      "banner": dto.imagemUrl,
      "eventDate": dto.dataHoraInicio.toIso8601String(),
      "durationHours": 4,
      "totalVacancies": dto.vagasTotais,
      "categories": dto.tags,
      "cidade": dto.cidade,
      "logradouro": dto.endereco,
      "latitude": dto.latitude,
      "longitude": dto.longitude,
    });

    debugPrint("=== CRIANDO VAGA NA API ===");
    debugPrint("URL: $url");
    debugPrint("Payload: $payload");

    try {
      final res = await http.post(url, headers: headers, body: payload);
      debugPrint("Status Code Criar Vaga: ${res.statusCode}");
      debugPrint("Body Criar Vaga: ${utf8.decode(res.bodyBytes)}");

      if (res.statusCode == 201 || res.statusCode == 200) {
        final dados = jsonDecode(utf8.decode(res.bodyBytes));
        return _mapearJsonParaEvento(dados as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Erro ao criar vaga na API: $e");
    }

    return null;
  }

  Future<List<EventoModel>> buscarEventos({
    String? ongId,
    String? busca,
    String? cidade,
    String? categoria,
    String? token,
  }) async {
    if (ongId != null && ongId.isNotEmpty) {
      return listarEventosPorOng(ongId, token: token);
    }
    return listarEventos(
      cidade: cidade,
      categoria: categoria,
      busca: busca,
      token: token,
    );
  }

  // --- MAPPER AUXILIAR SWAGGER -> EVENTOMODEL ---

  EventoModel _mapearJsonParaEvento(Map<String, dynamic> item) {
    final String id = item['id']?.toString() ?? '';
    final String titulo =
        item['title'] ?? item['titulo'] ?? 'Oportunidade Voluntária';
    final String ongNome =
        item['ong']?['name'] ?? item['ongNome'] ?? 'ONG Parceira';
    final String ongId =
        item['ongId']?.toString() ?? item['ong']?['id']?.toString() ?? '';

    String dataExibicao = "";
    DateTime? dtInicio;
    if (item['eventDate'] != null) {
      try {
        dtInicio = DateTime.parse(item['eventDate'].toString()).toLocal();
        dataExibicao =
            "${dtInicio.day.toString().padLeft(2, '0')}/${dtInicio.month.toString().padLeft(2, '0')}";
      } catch (_) {
        dataExibicao = item['eventDate'].toString();
      }
    }

    final int vagasTotais =
        (item['totalVacancies'] ?? item['vagasTotais'] as num?)?.toInt() ?? 0;
    final int inscritos =
        (item['_count']?['applications'] ?? item['inscritos'] as num?)
                ?.toInt() ??
            0;
    final int vagasRestantes = (vagasTotais - inscritos).clamp(0, 999);

    final List<dynamic> categorias = item['categories'] is List
        ? item['categories']
        : (item['tags'] is List ? item['tags'] : []);

    final String categoriaPrincipal = categorias.isNotEmpty
        ? categorias.first.toString()
        : (item['categoria']?.toString() ?? 'Social');

    final String? banner = item['banner']?.toString() ??
        item['imageUrl']?.toString() ??
        item['imagemUrl']?.toString();
    final String foto = (banner != null && banner.trim().isNotEmpty)
        ? banner
        : "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=600";

    final enderecoPartes = [item['logradouro'], item['numero'], item['bairro']]
        .where((p) => p != null && p.toString().isNotEmpty);
    final String enderecoFormatado = enderecoPartes.isNotEmpty
        ? enderecoPartes.join(', ')
        : (item['endereco']?.toString() ?? 'Endereço a confirmar');

    return EventoModel(
      id: id,
      ongId: ongId,
      ongNome: ongNome,
      titulo: titulo,
      categoria: categoriaPrincipal,
      descricao: item['description'] ??
          item['descricao'] ??
          'Sem descrição detalhada.',
      cidade: item['cidade']?.toString() ?? 'Grande ABC',
      endereco: enderecoFormatado,
      latitude: (item['latitude'] as num?)?.toDouble() ?? -23.668,
      longitude: (item['longitude'] as num?)?.toDouble() ?? -46.461,
      data: dataExibicao,
      horario: "${item['durationHours'] ?? 4}h de duração",
      dataHoraInicio: dtInicio ?? DateTime.now(),
      imagemUrl: foto,
      tags: categorias.map((c) => c.toString()).toList(),
      vagasTotais: vagasTotais,
      vagasRestantes: vagasRestantes,
      criadoEm: DateTime.tryParse(item['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isInscrito: item['isApplied'] == true || item['isInscrito'] == true,
      statusInscricao: item['statusInscricao']?.toString(),
    );
  }
}
