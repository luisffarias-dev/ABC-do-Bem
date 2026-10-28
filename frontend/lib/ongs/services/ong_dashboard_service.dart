// lib/services/ong_dashboard_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ong_dashboard_models.dart';

class OngDashboardService {
  final String baseUrl = "https://abc-do-bem.onrender.com";

  Future<OngDashboardModel> buscarDashboardOng(String ongId) async {
    final url = Uri.parse("$baseUrl/ongs/$ongId/dashboard");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        return OngDashboardModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (_) {}

    // Mock funcional offline completo
    await Future.delayed(const Duration(milliseconds: 350));
    return OngDashboardModel(
      id: ongId,
      nome: "Instituto Criança Cidadã",
      categoria: "Educação & Infância",
      cidade: "Santo André",
      logoUrl:
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400",
      totalVoluntariosEngajados: 54,
      vagasAbertas: 11,
      horasGeradas: 340,
      candidaturasPendentesCount: 3,
      necessidadesAtuais: [
        "Cadernos, borrachas e lápis de cor",
        "Leite em pó e biscoitos para lanche comunitário",
        "Voluntários para apoio pedagógico aos sábados",
      ],
      candidaturasPendentes: [
        CandidatoVoluntarioModel(
          solicitacaoId: "sol-1",
          voluntarioId: "vol-1",
          nome: "Lucas Ferreira",
          fotoUrl:
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
          eventoNome: "Mutirão de Reforço Escolar Comunitário",
          cidade: "São Caetano",
          dataSolicitacao: "Há 25 min",
          habilidades: ["Educação", "Matemática", "Paciência"],
          caronaOuSuporte: "Oferece carona saindo de São Caetano",
        ),
        CandidatoVoluntarioModel(
          solicitacaoId: "sol-2",
          voluntarioId: "vol-2",
          nome: "Mariana Santos",
          fotoUrl:
              "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
          eventoNome: "Oficina de Robótica e Pintura",
          cidade: "Santo André",
          dataSolicitacao: "Há 2 horas",
          habilidades: ["Artes", "Recreação", "Primeiros Socorros"],
          caronaOuSuporte: null,
        ),
        CandidatoVoluntarioModel(
          solicitacaoId: "sol-3",
          voluntarioId: "vol-3",
          nome: "Beatriz Lima",
          fotoUrl:
              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
          eventoNome: "Mutirão de Reforço Escolar Comunitário",
          cidade: "Mauá",
          dataSolicitacao: "Ontem",
          habilidades: ["Contação de Histórias", "Alfabetização"],
          caronaOuSuporte: "Precisa de carona a partir da estação",
        ),
      ],
      eventosAtivos: [
        EventoGerenciadoModel(
          id: "ev-1",
          titulo: "Mutirão de Reforço Escolar Comunitário",
          dataFormatada: "Sábado, 19/Set",
          horario: "09:00 às 12:30",
          inscritosCount: 16,
          vagasTotais: 20,
          imagemUrl:
              "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600",
          status: "ativo",
        ),
        EventoGerenciadoModel(
          id: "ev-2",
          titulo: "Oficina de Robótica e Artes Lúdicas",
          dataFormatada: "Sábado, 26/Set",
          horario: "14:00 às 17:30",
          inscritosCount: 8,
          vagasTotais: 15,
          imagemUrl:
              "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=600",
          status: "ativo",
        ),
      ],
    );
  }

  Future<bool> responderCandidatura(String solicitacaoId, bool aprovado) async {
    final url = Uri.parse("$baseUrl/solicitacoes/$solicitacaoId/responder");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": aprovado ? "aprovado" : "recusado"}),
      );
      if (response.statusCode == 200) return true;
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<bool> atualizarNecessidades(
      String ongId, List<String> necessidades) async {
    final url = Uri.parse("$baseUrl/ongs/$ongId/necessidades");
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"necessidades": necessidades}),
      );
      if (response.statusCode == 200) return true;
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
