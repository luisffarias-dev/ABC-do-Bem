// lib/services/ong_detail_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/session_service.dart';
import '../ongs/models/ong_detail_models.dart';

class OngDetailService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  String? _obterToken(String? tokenParametro) {
    if (tokenParametro != null && tokenParametro.trim().isNotEmpty) {
      return tokenParametro.trim();
    }
    return SessionService.instance.token;
  }

  /// Busca dados consolidados da ONG:
  /// 1. Perfil Público: GET /users/{id}
  /// 2. Vagas publicadas: GET /opportunities/ong/{ongId}
  /// 3. Mural de Notícias: GET /social/ongs/{ongId}/postagens
  Future<OngDetalheModel> buscarDetalhesOng(
    String ongId, {
    String voluntarioId = "voluntario-1",
    String? token,
  }) async {
    final tokenFinal = _obterToken(token);
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    debugPrint("=== BUSCANDO DETALHES REAIS DA ONG ===");
    debugPrint("ONG ID: $ongId");

    Map<String, dynamic>? dadosOng;
    final List<OngOportunidadeModel> oportunidades = [];
    final List<OngPostagemModel> postagens = [];

    // 1. Perfil Institucional (GET /users/{id})
    try {
      final urlPerfil = Uri.parse("$baseUrl/users/$ongId");
      debugPrint("URL Perfil ONG: $urlPerfil");
      final resPerfil = await http
          .get(urlPerfil, headers: headers)
          .timeout(const Duration(seconds: 10));
      debugPrint("Status Code Perfil ONG: ${resPerfil.statusCode}");
      debugPrint("Body Perfil ONG: ${utf8.decode(resPerfil.bodyBytes)}");

      if (resPerfil.statusCode == 200) {
        dadosOng = jsonDecode(utf8.decode(resPerfil.bodyBytes))
            as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Erro ao buscar perfil da ONG: $e");
    }

    // 2. Vagas da ONG (GET /opportunities/ong/{ongId})
    try {
      final urlVagas = Uri.parse("$baseUrl/opportunities/ong/$ongId");
      debugPrint("URL Vagas ONG: $urlVagas");
      final resVagas = await http
          .get(urlVagas, headers: headers)
          .timeout(const Duration(seconds: 10));
      debugPrint("Status Code Vagas ONG: ${resVagas.statusCode}");

      if (resVagas.statusCode == 200) {
        final List<dynamic> listaVagas =
            jsonDecode(utf8.decode(resVagas.bodyBytes));
        for (final item in listaVagas) {
          if (item is Map<String, dynamic>) {
            final String id = item['id']?.toString() ?? '';
            final String titulo =
                item['title']?.toString() ?? 'Ação Voluntária';
            final int total = (item['totalVacancies'] as num?)?.toInt() ?? 0;
            final int inscritos =
                (item['_count']?['applications'] as num?)?.toInt() ?? 0;
            final int vagasRestantes = (total - inscritos).clamp(0, 999);

            String dataFormatada = "";
            if (item['eventDate'] != null) {
              try {
                final dt =
                    DateTime.parse(item['eventDate'].toString()).toLocal();
                dataFormatada =
                    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
              } catch (_) {
                dataFormatada = item['eventDate'].toString();
              }
            }

            final String? banner = item['banner']?.toString();
            final String foto = (banner != null && banner.isNotEmpty)
                ? banner
                : "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600";

            oportunidades.add(
              OngOportunidadeModel(
                id: id,
                titulo: titulo,
                data: dataFormatada.isNotEmpty ? dataFormatada : "Em breve",
                horario: "${item['durationHours'] ?? 4}h de duração",
                vagasRestantes: vagasRestantes,
                imagemUrl: foto,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar oportunidades da ONG: $e");
    }

    // 3. Postagens do Mural (GET /social/ongs/{ongId}/postagens)
    try {
      final urlPosts = Uri.parse("$baseUrl/social/ongs/$ongId/postagens");
      debugPrint("URL Postagens ONG: $urlPosts");
      final resPosts = await http
          .get(urlPosts, headers: headers)
          .timeout(const Duration(seconds: 10));
      debugPrint("Status Code Postagens ONG: ${resPosts.statusCode}");

      if (resPosts.statusCode == 200) {
        final List<dynamic> listaPosts =
            jsonDecode(utf8.decode(resPosts.bodyBytes));
        for (final p in listaPosts) {
          if (p is Map<String, dynamic>) {
            postagens.add(
              OngPostagemModel(
                id: p['id']?.toString() ?? '',
                titulo: p['titulo']?.toString() ??
                    p['title']?.toString() ??
                    'Novidade no Projeto',
                texto: p['conteudo']?.toString() ??
                    p['text']?.toString() ??
                    p['descricao']?.toString() ??
                    '',
                dataFormatada: "Recente",
                imagemUrl: p['imagemUrl']?.toString(),
                curtidas: (p['curtidas'] ?? p['likes'] as num?)?.toInt() ?? 0,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar mural da ONG: $e");
    }

    if (dadosOng != null) {
      final String nome =
          dadosOng['name'] ?? dadosOng['razaoSocial'] ?? 'ONG Parceira';
      final String? avatar = dadosOng['avatar']?.toString();
      final String logo = (avatar != null &&
              avatar.isNotEmpty &&
              !avatar.contains('default.png'))
          ? avatar
          : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(nome)}&background=0C6B6B&color=fff";

      final enderecoFormatado = [
        dadosOng['logradouro'],
        dadosOng['numero'],
        dadosOng['bairro'],
        dadosOng['cidade'],
        dadosOng['estado'],
      ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');

      return OngDetalheModel(
        id: ongId,
        nome: nome,
        categoria: dadosOng['causaPrincipal']?.toString() ?? 'Solidariedade',
        cidade: dadosOng['cidade']?.toString() ?? 'Grande ABC',
        estado: dadosOng['estado']?.toString() ?? 'SP',
        enderecoCompleto: enderecoFormatado.isNotEmpty
            ? enderecoFormatado
            : "Grande ABC - São Paulo",
        logoUrl: logo,
        bannerUrl: dadosOng['banner']?.toString() ??
            "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1200",
        sobre: dadosOng['descricao']?.toString() ??
            dadosOng['bio']?.toString() ??
            "Instituição dedicada ao suporte comunitário e transformação social no Grande ABC.",
        voluntariosAtivos:
            (dadosOng['_count']?['opportunities'] as num?)?.toInt() ?? 0,
        eventosRealizados: oportunidades.length,
        anosAtuacao: 2,
        totalSeguidores:
            (dadosOng['_count']?['seguidores'] as num?)?.toInt() ?? 12,
        isSeguindo: dadosOng['isFollowing'] == true,
        necessidadesUrgentes: const [
          "Voluntários presenciais para apoio às ações",
          "Alimentos não perecíveis",
          "Material escolar e apoio pedagógico",
        ],
        instagram: dadosOng['instagram']?.toString(),
        facebook: dadosOng['facebook']?.toString(),
        linkedin: dadosOng['linkedin']?.toString(),
        whatsapp: dadosOng['whatsapp']?.toString(),
        telefone: dadosOng['telefone']?.toString(),
        oportunidadesAbertas: oportunidades,
        publicacoes: postagens,
      );
    }

    // Fallback de demonstração
    return _mockFallback(ongId, oportunidades, postagens);
  }

  /// Alternar Seguir ONG:
  /// POST /social/ongs/{ongId}/seguir (seguir)
  /// DELETE /social/ongs/{ongId}/seguir (deixar de seguir)
  Future<bool> alternarSeguirOng(
    String ongId,
    String voluntarioId,
    bool seguindoAtual, {
    String? token,
  }) async {
    final tokenFinal = _obterToken(token);
    final headers = <String, String>{
      "Accept": "application/json",
      if (tokenFinal != null && tokenFinal.isNotEmpty)
        "Authorization": "Bearer $tokenFinal",
    };

    final url = Uri.parse("$baseUrl/social/ongs/$ongId/seguir");
    debugPrint(
        "=== ALTERNANDO SEGUIR ONG: $url (Ação atual: $seguindoAtual) ===");

    try {
      final res = seguindoAtual
          ? await http
              .delete(url, headers: headers)
              .timeout(const Duration(seconds: 8))
          : await http
              .post(url, headers: headers)
              .timeout(const Duration(seconds: 8));

      debugPrint("Status Code Seguir/Deixar de Seguir: ${res.statusCode}");
      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 204) {
        return !seguindoAtual;
      }
    } catch (e) {
      debugPrint("Erro ao alternar seguir ONG na API: $e");
    }

    return !seguindoAtual;
  }

  OngDetalheModel _mockFallback(
    String ongId,
    List<OngOportunidadeModel> oportunidades,
    List<OngPostagemModel> postagens,
  ) {
    return OngDetalheModel(
      id: ongId,
      nome: "Instituto ABC do Bem",
      categoria: "Educação & Cidadania",
      cidade: "Mauá",
      estado: "SP",
      enderecoCompleto: "Av. Barão de Mauá - Centro, Mauá - SP",
      logoUrl:
          "https://ui-avatars.com/api/?name=ABC+Bem&background=0D8ABC&color=fff",
      bannerUrl:
          "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1200",
      sobre:
          "Somos uma instituição dedicada a levar educação e reforço escolar para crianças em situação de vulnerabilidade.",
      voluntariosAtivos: 24,
      eventosRealizados: 12,
      anosAtuacao: 3,
      totalSeguidores: 140,
      isSeguindo: false,
      necessidadesUrgentes: const [
        "Cadernos, lápis de cor e mochilas",
        "Alimentos não perecíveis para lanches comunitários",
      ],
      oportunidadesAbertas: oportunidades,
      publicacoes: postagens,
    );
  }
}
