// lib/voluntarios/buscar/models/resultado_busca_model.dart

enum TipoResultadoBusca {
  ong,
  voluntario,
  evento,
}

abstract class ResultadoBuscaItem {
  final String id;
  final String tituloPrincipal;
  final String subtitulo;
  final String imagemUrl;
  final String tagOuCategoria;
  final TipoResultadoBusca tipo;

  const ResultadoBuscaItem({
    required this.id,
    required this.tituloPrincipal,
    required this.subtitulo,
    required this.imagemUrl,
    required this.tagOuCategoria,
    required this.tipo,
  });
}

class BuscaOngItem extends ResultadoBuscaItem {
  final String cidade;
  final int totalVoluntarios;

  const BuscaOngItem({
    required super.id,
    required super.tituloPrincipal,
    required super.subtitulo,
    required super.imagemUrl,
    required super.tagOuCategoria,
    required this.cidade,
    required this.totalVoluntarios,
  }) : super(tipo: TipoResultadoBusca.ong);

  factory BuscaOngItem.fromJson(Map<String, dynamic> json) {
    return BuscaOngItem(
      id: json['id']?.toString() ?? '',
      tituloPrincipal: json['nome'] ?? '',
      subtitulo:
          "${json['cidade'] ?? 'ABC'} • ${json['totalVoluntarios'] ?? 0} vol.",
      imagemUrl: json['logoUrl'] ??
          json['imagem'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      tagOuCategoria: json['categoria'] ?? 'Causa Social',
      cidade: json['cidade'] ?? '',
      totalVoluntarios: json['totalVoluntarios'] ?? 0,
    );
  }
}

class BuscaVoluntarioItem extends ResultadoBuscaItem {
  final List<String> habilidades;
  final int totalHoras;

  const BuscaVoluntarioItem({
    required super.id,
    required super.tituloPrincipal,
    required super.subtitulo,
    required super.imagemUrl,
    required super.tagOuCategoria,
    required this.habilidades,
    required this.totalHoras,
  }) : super(tipo: TipoResultadoBusca.voluntario);

  factory BuscaVoluntarioItem.fromJson(Map<String, dynamic> json) {
    final habs = List<String>.from(json['habilidades'] ?? []);
    final horas = json['totalHoras'] ?? 0;
    return BuscaVoluntarioItem(
      id: json['id']?.toString() ?? '',
      tituloPrincipal: json['nome'] ?? 'Voluntário',
      subtitulo: json['cidade'] != null
          ? "${json['cidade']} • $horas horas doadas"
          : "$horas horas doadas",
      imagemUrl: json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      tagOuCategoria: habs.isNotEmpty ? habs.first : "Voluntário Ativo",
      habilidades: habs,
      totalHoras: horas,
    );
  }
}

class BuscaEventoItem extends ResultadoBuscaItem {
  final String data;
  final String horario;
  final int vagasRestantes;
  final String ongNome;

  const BuscaEventoItem({
    required super.id,
    required super.tituloPrincipal,
    required super.subtitulo,
    required super.imagemUrl,
    required super.tagOuCategoria,
    required this.data,
    required this.horario,
    required this.vagasRestantes,
    required this.ongNome,
  }) : super(tipo: TipoResultadoBusca.evento);

  factory BuscaEventoItem.fromJson(Map<String, dynamic> json) {
    final vagas = json['vagasRestantes'] ?? 0;
    return BuscaEventoItem(
      id: json['id']?.toString() ?? '',
      tituloPrincipal: json['titulo'] ?? '',
      subtitulo:
          "${json['ongNome'] ?? 'Instituição'} • ${json['data'] ?? ''} às ${json['horario'] ?? ''}",
      imagemUrl: json['imagemUrl'] ??
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
      tagOuCategoria: "$vagas vagas abertas",
      data: json['data'] ?? '',
      horario: json['horario'] ?? '',
      vagasRestantes: vagas,
      ongNome: json['ongNome'] ?? '',
    );
  }
}
