// lib/models/ong_search_models.dart

class VoluntarioCandidatoBuscaModel {
  final String id;
  final String nome;
  final String fotoUrl;
  final String cidade;
  final int totalHorasDoadas;
  final int eventosConcluidos;
  final int percentualMatch;
  final List<String> habilidades;
  final List<String> disponibilidade;
  final bool jaConvidado;

  VoluntarioCandidatoBuscaModel({
    required this.id,
    required this.nome,
    required this.fotoUrl,
    required this.cidade,
    required this.totalHorasDoadas,
    required this.eventosConcluidos,
    required this.percentualMatch,
    required this.habilidades,
    required this.disponibilidade,
    this.jaConvidado = false,
  });

  factory VoluntarioCandidatoBuscaModel.fromJson(Map<String, dynamic> json) {
    return VoluntarioCandidatoBuscaModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      fotoUrl: json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      cidade: json['cidade'] ?? 'Santo André',
      totalHorasDoadas: json['totalHorasDoadas'] ?? 0,
      eventosConcluidos: json['eventosConcluidos'] ?? 0,
      percentualMatch: json['percentualMatch'] ?? 80,
      habilidades: List<String>.from(json['habilidades'] ?? []),
      disponibilidade: List<String>.from(json['disponibilidade'] ?? []),
      jaConvidado: json['jaConvidado'] ?? false,
    );
  }
}

class OngParceiraBuscaModel {
  final String id;
  final String nome;
  final String categoria;
  final String cidade;
  final String logoUrl;
  final int totalEventos;
  final int voluntariosAtivos;
  final List<String> necessidades;

  OngParceiraBuscaModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.logoUrl,
    required this.totalEventos,
    required this.voluntariosAtivos,
    required this.necessidades,
  });

  factory OngParceiraBuscaModel.fromJson(Map<String, dynamic> json) {
    return OngParceiraBuscaModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? 'Assistência Social',
      cidade: json['cidade'] ?? 'Santo André',
      logoUrl: json['logoUrl'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      totalEventos: json['totalEventos'] ?? 0,
      voluntariosAtivos: json['voluntariosAtivos'] ?? 0,
      necessidades: List<String>.from(json['necessidades'] ?? []),
    );
  }
}
