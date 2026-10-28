// lib/models/dashboard_models.dart

import '../../../eventos/models/evento_model.dart';
import '../ongs/models/ong_models.dart';

/// Métricas de impacto acumuladas pelo voluntário
class MetricasImpactoModel {
  final int totalCidades;
  final int ongsAjudadas;
  final String horasDoadas;
  final double rankingEstrelas;

  MetricasImpactoModel({
    required this.totalCidades,
    required this.ongsAjudadas,
    required this.horasDoadas,
    required this.rankingEstrelas,
  });

  factory MetricasImpactoModel.fromJson(Map<String, dynamic> json) {
    return MetricasImpactoModel(
      totalCidades: json['totalCidades'] ?? 0,
      ongsAjudadas: json['ongsAjudadas'] ?? 0,
      horasDoadas: json['horasDoadas'] ?? '0h',
      rankingEstrelas: (json['rankingEstrelas'] as num?)?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalCidades': totalCidades,
        'ongsAjudadas': ongsAjudadas,
        'horasDoadas': horasDoadas,
        'rankingEstrelas': rankingEstrelas,
      };
}

/// Dados completos para renderizar a Home do Voluntário em uma única chamada de API
class VoluntarioDashboardModel {
  final String voluntarioId;
  final String nome;
  final String fotoUrl;
  final String cidade;
  final MetricasImpactoModel metricas;
  final EventoModel? proximoEvento;
  final OngModel? ongProxima;

  VoluntarioDashboardModel({
    required this.voluntarioId,
    required this.nome,
    required this.fotoUrl,
    required this.cidade,
    required this.metricas,
    this.proximoEvento,
    this.ongProxima,
  });

  factory VoluntarioDashboardModel.fromJson(Map<String, dynamic> json) {
    return VoluntarioDashboardModel(
      voluntarioId: json['voluntarioId']?.toString() ?? '',
      nome: json['nome'] ?? 'Voluntário',
      fotoUrl: json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      cidade: json['cidade'] ?? 'Grande ABC',
      metricas: MetricasImpactoModel.fromJson(
        json['metricas'] != null
            ? Map<String, dynamic>.from(json['metricas'])
            : {},
      ),
      proximoEvento: json['proximoEvento'] != null
          ? EventoModel.fromJson(
              Map<String, dynamic>.from(json['proximoEvento']),
            )
          : null,
      ongProxima: json['ongProxima'] != null
          ? OngModel.fromJson(Map<String, dynamic>.from(json['ongProxima']))
          : null,
    );
  }
}
