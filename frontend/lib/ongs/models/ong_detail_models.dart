// lib/models/ong_detail_models.dart

class OngPostagemModel {
  final String id;
  final String titulo;
  final String texto;
  final String dataFormatada;
  final String? imagemUrl;
  final int curtidas;

  OngPostagemModel({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.dataFormatada,
    this.imagemUrl,
    this.curtidas = 0,
  });

  factory OngPostagemModel.fromJson(Map<String, dynamic> json) {
    return OngPostagemModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? '',
      texto: json['texto'] ?? '',
      dataFormatada: json['data'] ?? 'Recente',
      imagemUrl: json['imagemUrl'],
      curtidas: json['curtidas'] ?? 0,
    );
  }
}

class OngOportunidadeModel {
  final String id;
  final String titulo;
  final String data;
  final String horario;
  final int vagasRestantes;
  final String imagemUrl;

  OngOportunidadeModel({
    required this.id,
    required this.titulo,
    required this.data,
    required this.horario,
    required this.vagasRestantes,
    required this.imagemUrl,
  });

  factory OngOportunidadeModel.fromJson(Map<String, dynamic> json) {
    return OngOportunidadeModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? '',
      data: json['data'] ?? '',
      horario: json['horario'] ?? '',
      vagasRestantes: json['vagasRestantes'] ?? 0,
      imagemUrl: json['imagemUrl'] ??
          'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400',
    );
  }
}

class OngDetalheModel {
  final String id;
  final String nome;
  final String categoria;
  final String cidade;
  final String estado;
  final String enderecoCompleto;
  final String logoUrl;
  final String bannerUrl;
  final String sobre;
  final int voluntariosAtivos;
  final int eventosRealizados;
  final int anosAtuacao;
  final int totalSeguidores;
  final bool isSeguindo;
  final List<String> necessidadesUrgentes;
  final String? instagram;
  final String? facebook;
  final String? linkedin;
  final String? whatsapp;
  final String? telefone;
  final List<OngOportunidadeModel> oportunidadesAbertas;
  final List<OngPostagemModel> publicacoes;

  OngDetalheModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.estado,
    required this.enderecoCompleto,
    required this.logoUrl,
    required this.bannerUrl,
    required this.sobre,
    required this.voluntariosAtivos,
    required this.eventosRealizados,
    required this.anosAtuacao,
    required this.totalSeguidores,
    required this.isSeguindo,
    required this.necessidadesUrgentes,
    this.instagram,
    this.facebook,
    this.linkedin,
    this.whatsapp,
    this.telefone,
    required this.oportunidadesAbertas,
    required this.publicacoes,
  });

  factory OngDetalheModel.fromJson(Map<String, dynamic> json) {
    var rawOp = json['oportunidades'] as List? ?? [];
    var rawPosts = json['publicacoes'] as List? ?? [];

    return OngDetalheModel(
      id: json['id']?.toString() ?? '1',
      nome: json['nome'] ?? 'Instituto Criança Cidadã',
      categoria: json['categoria'] ?? 'Educação',
      cidade: json['cidade'] ?? 'Santo André',
      estado: json['estado'] ?? 'SP',
      enderecoCompleto: json['enderecoCompleto'] ??
          'Rua das Figueiras, 450 - Bairro Jardim, Santo André - SP',
      logoUrl: json['logoUrl'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      bannerUrl: json['bannerUrl'] ??
          'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=1200',
      sobre: json['sobre'] ??
          'O Instituto Criança Cidadã atua desde 2018 no Grande ABC promovendo educação complementar, acolhimento e alfabetização para mais de 300 crianças em vulnerabilidade social.',
      voluntariosAtivos: json['voluntariosAtivos'] ?? 48,
      eventosRealizados: json['eventosRealizados'] ?? 86,
      anosAtuacao: json['anosAtuacao'] ?? 6,
      totalSeguidores: json['totalSeguidores'] ?? 312,
      isSeguindo: json['isSeguindo'] ?? false,
      necessidadesUrgentes: List<String>.from(json['necessidadesUrgentes'] ??
          [
            "Material escolar",
            "Leite em pó e alimentos não perecíveis",
            "Voluntários pedagogos e recreadores",
          ]),
      instagram: json['instagram'] ?? '@criancacidada.abc',
      facebook: json['facebook'] ?? 'fb.com/criancacidada',
      linkedin: json['linkedin'],
      whatsapp: json['whatsapp'] ?? '(11) 97123-4567',
      telefone: json['telefone'] ?? '(11) 4433-2211',
      oportunidadesAbertas:
          rawOp.map((o) => OngOportunidadeModel.fromJson(o)).toList(),
      publicacoes: rawPosts.map((p) => OngPostagemModel.fromJson(p)).toList(),
    );
  }
}
