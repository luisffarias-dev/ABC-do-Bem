// lib/services/ong_search_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ong_search_models.dart';

class OngSearchService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  Future<List<VoluntarioCandidatoBuscaModel>> buscarBancoVoluntarios(
      String ongId) async {
    final url = Uri.parse("$baseUrl/ongs/$ongId/banco-voluntarios");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(response.bodyBytes));
        return list
            .map((e) => VoluntarioCandidatoBuscaModel.fromJson(e))
            .toList();
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));
    return [
      VoluntarioCandidatoBuscaModel(
        id: "vol-1",
        nome: "Ana Carolina Santos",
        fotoUrl:
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
        cidade: "Santo André",
        totalHorasDoadas: 48,
        eventosConcluidos: 14,
        percentualMatch: 98,
        habilidades: ["Alfabetização", "Recreação Infantil", "Artesanato"],
        disponibilidade: ["Sábados de manhã", "Finais de semana"],
      ),
      VoluntarioCandidatoBuscaModel(
        id: "vol-2",
        nome: "Carlos Eduardo Lima",
        fotoUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
        cidade: "São Bernardo",
        totalHorasDoadas: 92,
        eventosConcluidos: 28,
        percentualMatch: 94,
        habilidades: ["Robótica Lúdica", "Fotografia", "Logística"],
        disponibilidade: ["Sábados o dia todo"],
      ),
      VoluntarioCandidatoBuscaModel(
        id: "vol-3",
        nome: "Beatriz Ribeiro",
        fotoUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
        cidade: "Santo André",
        totalHorasDoadas: 34,
        eventosConcluidos: 9,
        percentualMatch: 91,
        habilidades: ["Contação de Histórias", "Música", "Psicologia"],
        disponibilidade: ["Domingos à tarde"],
      ),
      VoluntarioCandidatoBuscaModel(
        id: "vol-4",
        nome: "Gabriel Souza",
        fotoUrl:
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
        cidade: "São Caetano",
        totalHorasDoadas: 20,
        eventosConcluidos: 6,
        percentualMatch: 85,
        habilidades: ["Primeiros Socorros", "Educação Física", "Cozinha"],
        disponibilidade: ["Finais de semana"],
      ),
      VoluntarioCandidatoBuscaModel(
        id: "vol-5",
        nome: "Mariana Oliveira",
        fotoUrl:
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200",
        cidade: "Mauá",
        totalHorasDoadas: 16,
        eventosConcluidos: 4,
        percentualMatch: 78,
        habilidades: ["Gestão de Redes", "Organização", "Pintura"],
        disponibilidade: ["Sábados à tarde"],
      ),
    ];
  }

  Future<List<OngParceiraBuscaModel>> buscarRedeOngs(String ongId) async {
    final url = Uri.parse("$baseUrl/ongs?ignorarId=$ongId");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        final List list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((e) => OngParceiraBuscaModel.fromJson(e)).toList();
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));
    return [
      OngParceiraBuscaModel(
        id: "ong-2",
        nome: "Ação Verde ABC",
        categoria: "Meio Ambiente & Sustentabilidade",
        cidade: "São Bernardo",
        logoUrl:
            "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
        totalEventos: 42,
        voluntariosAtivos: 68,
        necessidades: ["Mudas nativas", "Ferramentas de jardinagem"],
      ),
      OngParceiraBuscaModel(
        id: "ong-3",
        nome: "Mãos que Alimentam",
        categoria: "Apoio Social & Alimentos",
        cidade: "São Caetano",
        logoUrl:
            "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
        totalEventos: 84,
        voluntariosAtivos: 110,
        necessidades: ["Arroz, feijão e óleo", "Embalagens térmicas"],
      ),
      OngParceiraBuscaModel(
        id: "ong-4",
        nome: "Anjos de Quatro Patas ABC",
        categoria: "Proteção Animal",
        cidade: "Santo André",
        logoUrl:
            "https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=400",
        totalEventos: 31,
        voluntariosAtivos: 45,
        necessidades: ["Ração para cães e gatos", "Medicamentos veterinários"],
      ),
    ];
  }

  Future<bool> enviarConviteAcao({
    required String ongId,
    required String voluntarioId,
    required String eventoId,
    String? mensagem,
  }) async {
    final url = Uri.parse("$baseUrl/ongs/$ongId/convites");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "voluntarioId": voluntarioId,
          "eventoId": eventoId,
          "mensagem": mensagem,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) return true;
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
