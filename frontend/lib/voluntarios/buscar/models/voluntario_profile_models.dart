// lib/voluntarios/models/voluntario_profile_models.dart

class ExperienciaFeedModel {
  final String id;
  final String ongNome;
  final String dataFormatada;
  final String texto;
  final String? imagemUrl;
  final int curtidas;

  const ExperienciaFeedModel({
    required this.id,
    required this.ongNome,
    required this.dataFormatada,
    required this.texto,
    this.imagemUrl,
    this.curtidas = 0,
  });

  factory ExperienciaFeedModel.fromJson(Map<String, dynamic> json) {
    return ExperienciaFeedModel(
      id: json['id']?.toString() ?? '',
      ongNome: json['ongNome'] ?? 'Instituição Parceira',
      dataFormatada: json['data'] ?? json['dataFormatada'] ?? 'Recente',
      texto: json['texto'] ?? '',
      imagemUrl: json['imagemUrl'],
      curtidas: (json['curtidas'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ongNome': ongNome,
        'dataFormatada': dataFormatada,
        'texto': texto,
        'imagemUrl': imagemUrl,
        'curtidas': curtidas,
      };

  ExperienciaFeedModel copyWith({
    String? id,
    String? ongNome,
    String? dataFormatada,
    String? texto,
    String? imagemUrl,
    int? curtidas,
  }) {
    return ExperienciaFeedModel(
      id: id ?? this.id,
      ongNome: ongNome ?? this.ongNome,
      dataFormatada: dataFormatada ?? this.dataFormatada,
      texto: texto ?? this.texto,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      curtidas: curtidas ?? this.curtidas,
    );
  }
}

class VoluntarioPerfilModel {
  final String id;
  final String nome;
  final String cpf;
  final String nascimento;
  final String cidade;
  final String estado;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String fotoUrl;
  final String bannerUrl;
  final int totalEventos;
  final int totalHoras;
  final String tempoAtivo;
  final String bio;
  final List<String> habilidades;
  final List<String> disponibilidade;
  final String escolaridade;
  final String curso;
  final String? instagram;
  final String? facebook;
  final String? linkedin;
  final String? whatsapp;
  final List<ExperienciaFeedModel> experiencias;

  const VoluntarioPerfilModel({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.nascimento,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.fotoUrl,
    required this.bannerUrl,
    required this.totalEventos,
    required this.totalHoras,
    required this.tempoAtivo,
    required this.bio,
    required this.habilidades,
    required this.disponibilidade,
    required this.escolaridade,
    required this.curso,
    this.instagram,
    this.facebook,
    this.linkedin,
    this.whatsapp,
    required this.experiencias,
  });

  VoluntarioPerfilModel copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? nascimento,
    String? cidade,
    String? estado,
    String? cep,
    String? logradouro,
    String? numero,
    String? bairro,
    String? fotoUrl,
    String? bannerUrl,
    int? totalEventos,
    int? totalHoras,
    String? tempoAtivo,
    String? bio,
    List<String>? habilidades,
    List<String>? disponibilidade,
    String? escolaridade,
    String? curso,
    String? instagram,
    String? facebook,
    String? linkedin,
    String? whatsapp,
    List<ExperienciaFeedModel>? experiencias,
  }) {
    return VoluntarioPerfilModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      nascimento: nascimento ?? this.nascimento,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      totalEventos: totalEventos ?? this.totalEventos,
      totalHoras: totalHoras ?? this.totalHoras,
      tempoAtivo: tempoAtivo ?? this.tempoAtivo,
      bio: bio ?? this.bio,
      habilidades: habilidades ?? this.habilidades,
      disponibilidade: disponibilidade ?? this.disponibilidade,
      escolaridade: escolaridade ?? this.escolaridade,
      curso: curso ?? this.curso,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      linkedin: linkedin ?? this.linkedin,
      whatsapp: whatsapp ?? this.whatsapp,
      experiencias: experiencias ?? this.experiencias,
    );
  }

  factory VoluntarioPerfilModel.fromJson(Map<String, dynamic> json) {
    final rawExp = json['experiencias'] as List? ?? [];
    return VoluntarioPerfilModel(
      id: json['id']?.toString() ?? 'voluntario-1',
      nome: json['nome'] ?? json['name'] ?? 'Ana Carolina Silva',
      cpf: json['cpf'] ?? '123.456.789-00',
      nascimento: json['nascimento'] ?? '15/05/1995',
      cidade: json['cidade'] ?? 'Santo André',
      estado: json['estado'] ?? 'SP',
      cep: json['cep'] ?? '09390-000',
      logradouro: json['logradouro'] ?? 'Rua das Flores',
      numero: json['numero'] ?? '123',
      bairro: json['bairro'] ?? 'Vila Assis Brasil',
      fotoUrl: json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      bannerUrl: json['bannerUrl'] ??
          'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=1200',
      totalEventos: (json['totalEventos'] as num?)?.toInt() ?? 23,
      totalHoras: (json['totalHoras'] as num?)?.toInt() ?? 187,
      tempoAtivo: json['tempoAtivo'] ?? '6a',
      bio: json['bio'] ??
          'Professora apaixonada por educação inclusiva e impacto social. Voluntária há 4 anos no ABC.',
      habilidades:
          (json['habilidades'] as List?)?.map((h) => h.toString()).toList() ??
              ["Design Gráfico", "Educação", "Fotografia"],
      disponibilidade: (json['disponibilidade'] as List?)
              ?.map((d) => d.toString())
              .toList() ??
          ["Manhãs", "Tardes", "Noites", "Fins de semana"],
      escolaridade: json['escolaridade'] ?? 'Superior',
      curso: json['curso'] ?? 'Pedagogia / Licenciatura',
      instagram: json['instagram'] ?? '@anacarolina',
      facebook: json['facebook'],
      linkedin: json['linkedin'] ?? 'linkedin.com/in/anacarolina',
      whatsapp: json['whatsapp'] ?? '(11) 98765-4321',
      experiencias: rawExp
          .map((e) => ExperienciaFeedModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cpf': cpf,
        'nascimento': nascimento,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'fotoUrl': fotoUrl,
        'bannerUrl': bannerUrl,
        'totalEventos': totalEventos,
        'totalHoras': totalHoras,
        'tempoAtivo': tempoAtivo,
        'bio': bio,
        'habilidades': habilidades,
        'disponibilidade': disponibilidade,
        'escolaridade': escolaridade,
        'curso': curso,
        'instagram': instagram,
        'facebook': facebook,
        'linkedin': linkedin,
        'whatsapp': whatsapp,
        'experiencias': experiencias.map((e) => e.toJson()).toList(),
      };
}
