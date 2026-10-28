// lib/models/ong_models.dart

/// Coordenadas relativas para plotagem no mapa interativo
class PosicaoMapa {
  final double x;
  final double y;

  PosicaoMapa({required this.x, required this.y});

  factory PosicaoMapa.fromJson(Map<String, dynamic> json) {
    return PosicaoMapa(
      x: (json['x'] as num?)?.toDouble() ?? 0.5,
      y: (json['y'] as num?)?.toDouble() ?? 0.5,
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}

/// Representação de uma ONG na vitrine de busca e mapa
class OngModel {
  final int id;
  final String nome;
  final String cidade;
  final String categoria;
  final int voluntarios;
  final String imagem;
  final PosicaoMapa posMapa;
  final String? descricao;
  final String? endereco;

  OngModel({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.categoria,
    required this.voluntarios,
    required this.imagem,
    required this.posMapa,
    this.descricao,
    this.endereco,
  });

  factory OngModel.fromJson(Map<String, dynamic> json) {
    return OngModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome'] ?? '',
      cidade: json['cidade'] ?? '',
      categoria: json['categoria'] ?? 'Geral',
      voluntarios: json['voluntarios'] ?? 0,
      imagem: json['imagem'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      posMapa: json['posMapa'] != null
          ? PosicaoMapa.fromJson(Map<String, dynamic>.from(json['posMapa']))
          : PosicaoMapa(x: 0.5, y: 0.5),
      descricao: json['descricao'],
      endereco: json['endereco'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
      'categoria': categoria,
      'voluntarios': voluntarios,
      'imagem': imagem,
      'posMapa': posMapa.toJson(),
      'descricao': descricao,
      'endereco': endereco,
    };
  }
}

/// Representação de uma recomendação personalizada (Match baseado em perfil)
class OngRecomendadaModel {
  final String nome;
  final String cidade;
  final String match;
  final String categoria;
  final String imagem;
  final int? id;

  OngRecomendadaModel({
    required this.nome,
    required this.cidade,
    required this.match,
    required this.categoria,
    required this.imagem,
    this.id,
  });

  factory OngRecomendadaModel.fromJson(Map<String, dynamic> json) {
    return OngRecomendadaModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      nome: json['nome'] ?? '',
      cidade: json['cidade'] ?? '',
      match: json['match'] ?? '90% match',
      categoria: json['categoria'] ?? 'Geral',
      imagem: json['imagem'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
      'match': match,
      'categoria': categoria,
      'imagem': imagem,
    };
  }
}
