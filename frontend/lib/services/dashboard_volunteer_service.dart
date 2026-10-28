// lib/services/dashboard_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dashboard_volunteer_models.dart';
import '../eventos/models/evento_model.dart';
import '../ongs/models/ong_models.dart';

/// Serviço que fornece os dados agregados da página inicial do voluntário
class DashboardService {
  final String baseUrl;
  final String? authToken;

  DashboardService({
    this.baseUrl = "https://api.abc-do-bem.com.br/v1",
    this.authToken,
  });

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (authToken != null) "Authorization": "Bearer $authToken",
      };

  /// GET /voluntarios/{voluntarioId}/dashboard
  /// Retorna as métricas, o próximo evento inscrito e a ONG mais próxima
  Future<VoluntarioDashboardModel> buscarDashboard(String voluntarioId) async {
    final url = Uri.parse('$baseUrl/voluntarios/$voluntarioId/dashboard');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        return VoluntarioDashboardModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Erro ao obter dados da Home: ${response.statusCode}");
      }
    } catch (e) {
      // Fallback local com os dados mockados enquanto a API estiver offline
      await Future.delayed(const Duration(milliseconds: 300));
      return _obterDashboardMock(voluntarioId);
    }
  }

  VoluntarioDashboardModel _obterDashboardMock(String voluntarioId) {
    return VoluntarioDashboardModel(
      voluntarioId: voluntarioId,
      nome: "Ana Carolina",
      fotoUrl:
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400",
      cidade: "Santo André",
      metricas: MetricasImpactoModel(
        totalCidades: 3,
        ongsAjudadas: 5,
        horasDoadas: "48h",
        rankingEstrelas: 4.8,
      ),
      proximoEvento: EventoModel(
        id: "1",
        ongId: "ong-1",
        ongNome: "Mãos que Fazem",
        titulo: "Mutirão de Reforço Escolar",
        descricao:
            "Aulas de apoio em matemática e português para crianças do ensino fundamental.",
        cidade: "Santo André",
        data: "2026-09-12",
        horario: "08:00 - 12:00",
        dataHoraInicio: DateTime(2026, 9, 12, 8, 0),
        imagemUrl:
            "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600",
        tags: ["Educação", "Crianças"],
        vagasTotais: 15,
        vagasRestantes: 7,
        criadoEm: DateTime.now(),
        statusInscricao: "Aprovado",
      ),
      ongProxima: OngModel(
        id: 1,
        nome: "Mãos que Fazem",
        cidade: "Santo André",
        categoria: "Educação",
        voluntarios: 34,
        imagem:
            "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
        posMapa: PosicaoMapa(x: 0.6, y: 0.3),
        endereco: "1,2 km de distância",
      ),
    );
  }
}
