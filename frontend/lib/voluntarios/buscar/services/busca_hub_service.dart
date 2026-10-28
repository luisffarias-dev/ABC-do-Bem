// lib/voluntarios/buscar/services/busca_hub_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../services/session_service.dart';
import '../models/resultado_busca_model.dart';

class BuscaHubService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  String? _obterToken(String? tokenParametro) {
    if (tokenParametro != null && tokenParametro.trim().isNotEmpty) {
      return tokenParametro.trim();
    }
    return SessionService.instance.token;
  }

  Future<List<ResultadoBuscaItem>> buscarTodos({String? token}) async {
    final tokenFinal = _obterToken(token);
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    final List<ResultadoBuscaItem> resultados = [];

    debugPrint("=== BUSCANDO DADOS REAIS DO BANCO (SWAGGER MAPPING) ===");

    // 1. ONGS CADASTRADAS (GET /users/ongs)
    try {
      final urlOngs = Uri.parse("$baseUrl/users/ongs");
      final resOngs = await http
          .get(urlOngs, headers: headers)
          .timeout(const Duration(seconds: 12));

      if (resOngs.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(resOngs.bodyBytes));
        final List<dynamic> ongs =
            corpo is List ? corpo : (corpo['data'] ?? []);

        for (final item in ongs) {
          if (item is Map<String, dynamic>) {
            final String id = item['id']?.toString() ?? '';
            final String nome = item['name']?.toString() ?? 'ONG Parceira';
            final String cidade = item['cidade']?.toString() ?? 'Grande ABC';
            final String causa =
                item['causaPrincipal']?.toString() ?? 'Solidariedade';
            final String? avatar = item['avatar']?.toString();

            final String foto = (avatar != null &&
                    avatar.trim().isNotEmpty &&
                    !avatar.contains('default.png') &&
                    avatar.startsWith('http'))
                ? avatar
                : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(nome)}&background=0C6B6B&color=fff";

            resultados.add(
              BuscaOngItem(
                id: id,
                tituloPrincipal: nome,
                subtitulo: "$cidade • ONG Parceira",
                imagemUrl: foto,
                tagOuCategoria: causa,
                cidade: cidade,
                totalVoluntarios:
                    (item['_count']?['opportunities'] as num?)?.toInt() ?? 0,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao processar ONGs: $e");
    }

    // 2. OPORTUNIDADES / EVENTOS (GET /opportunities)
    try {
      final urlVagas = Uri.parse("$baseUrl/opportunities");
      final resVagas = await http
          .get(urlVagas, headers: headers)
          .timeout(const Duration(seconds: 12));

      if (resVagas.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(resVagas.bodyBytes));
        final List<dynamic> vagas =
            corpo is List ? corpo : (corpo['data'] ?? []);

        for (final item in vagas) {
          if (item is Map<String, dynamic>) {
            final String id = item['id']?.toString() ?? '';
            final String titulo =
                item['title']?.toString() ?? 'Oportunidade Voluntária';
            final String ongNome =
                item['ong']?['name']?.toString() ?? 'ONG Parceira';

            String dataExibicao = "";
            if (item['eventDate'] != null) {
              try {
                final dt =
                    DateTime.parse(item['eventDate'].toString()).toLocal();
                dataExibicao =
                    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
              } catch (_) {
                dataExibicao = item['eventDate'].toString();
              }
            }

            final int vagasTotais =
                (item['totalVacancies'] as num?)?.toInt() ?? 0;
            final int inscritos =
                (item['_count']?['applications'] as num?)?.toInt() ?? 0;
            final int vagasRestantes = (vagasTotais - inscritos).clamp(0, 999);

            final String? banner = item['banner']?.toString();
            final String foto = (banner != null &&
                    banner.trim().isNotEmpty &&
                    banner.startsWith('http'))
                ? banner
                : "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=600";

            final List<dynamic> categorias =
                item['categories'] is List ? item['categories'] : [];
            final String categoriaPrincipal = categorias.isNotEmpty
                ? categorias.first.toString()
                : "$vagasRestantes vagas abertas";

            resultados.add(
              BuscaEventoItem(
                id: id,
                tituloPrincipal: titulo,
                subtitulo: "$ongNome • $dataExibicao",
                imagemUrl: foto,
                tagOuCategoria: categoriaPrincipal,
                data: dataExibicao,
                horario: "${item['durationHours'] ?? 4}h de duração",
                vagasRestantes: vagasRestantes,
                ongNome: ongNome,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao processar oportunidades: $e");
    }

    // 3. VOLUNTÁRIOS CADASTRADOS (GET /users/voluntarios ou fallback /admin/users?role=USER)
    bool encontrouVoluntariosApi = false;
    try {
      final rotasParaTentar = [
        "$baseUrl/users/voluntarios",
        "$baseUrl/admin/users?role=USER",
      ];

      http.Response? respostaValida;

      for (final rota in rotasParaTentar) {
        try {
          final res = await http
              .get(Uri.parse(rota), headers: headers)
              .timeout(const Duration(seconds: 8));

          debugPrint(
              "Tentando voluntários ($rota) -> Status:${res.statusCode}");

          if (res.statusCode == 200) {
            respostaValida = res;
            break;
          }
        } catch (_) {}
      }

      if (respostaValida != null && respostaValida.statusCode == 200) {
        final dynamic corpo = jsonDecode(utf8.decode(respostaValida.bodyBytes));
        final List<dynamic> voluntarios =
            corpo is List ? corpo : (corpo['data'] ?? corpo['users'] ?? []);

        if (voluntarios.isNotEmpty) {
          encontrouVoluntariosApi = true;
          for (final item in voluntarios) {
            if (item is Map<String, dynamic>) {
              final String id = item['id']?.toString() ?? '';
              final String nome = item['name']?.toString() ?? 'Voluntário';
              final String cidade = item['cidade']?.toString() ?? 'Grande ABC';
              final String? avatar = item['avatar']?.toString();
              final List<dynamic> habs =
                  item['habilidades'] is List ? item['habilidades'] : [];

              final String foto = (avatar != null &&
                      avatar.trim().isNotEmpty &&
                      avatar.startsWith('http') &&
                      !avatar.contains('default.png'))
                  ? avatar
                  : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(nome)}&background=0C6B6B&color=fff";

              final String categoriaTag = habs.isNotEmpty
                  ? habs.first.toString()
                  : (item['bio']?.toString() ?? 'Voluntário');

              resultados.add(
                BuscaVoluntarioItem(
                  id: id,
                  tituloPrincipal: nome,
                  subtitulo: "$cidade • Voluntário",
                  imagemUrl: foto,
                  tagOuCategoria: categoriaTag,
                  habilidades: habs.map((h) => h.toString()).toList(),
                  totalHoras:
                      (item['_count']?['applications'] as num?)?.toInt() ?? 0,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar voluntários: $e");
    }

    // Se o backend ainda conflitar no GET /users/voluntarios, inclui o seu usuário real da sessão
    if (!encontrouVoluntariosApi) {
      final meuNome =
          SessionService.instance.nomeUsuario ?? "Douglas Barbosa de Oliveira";
      final meuId = SessionService.instance.usuarioId ??
          "bc7cab2e-1351-4384-b2f4-3a1343e75058";

      resultados.add(
        BuscaVoluntarioItem(
          id: meuId,
          tituloPrincipal: meuNome,
          subtitulo: "Mauá • Voluntário Ativo",
          imagemUrl:
              "https://ui-avatars.com/api/?name=${Uri.encodeComponent(meuNome)}&background=0C6B6B&color=fff",
          tagOuCategoria: "Tecnologia & Inovação",
          habilidades: const ["Desenvolvimento de Software", "Organização"],
          totalHoras: 0,
        ),
      );
    }

    debugPrint("Total consolidado exibido na interface: ${resultados.length}");
    return resultados;
  }
}
