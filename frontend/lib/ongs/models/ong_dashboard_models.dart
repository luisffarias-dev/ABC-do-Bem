// lib/models/ong_dashboard_models.dart

class CandidatoVoluntarioModel {
  final String solicitacaoId;
  final String voluntarioId;
  final String nome;
  final String fotoUrl;
  final String eventoNome;
  final String cidade;
  final String dataSolicitacao;
  final List<String> habilidades;
  final String? caronaOuSuporte;

  CandidatoVoluntarioModel({
    required this.solicitacaoId,
    required this.voluntarioId,
    required this.nome,
    required this.fotoUrl,
    required this.eventoNome,
    required this.cidade,
    required this.dataSolicitacao,
    required this.habilidades,
    this.caronaOuSuporte,
  });

  factory CandidatoVoluntarioModel.fromJson(Map<String, dynamic> json) {
    return CandidatoVoluntarioModel(
      solicitacaoId: json['solicitacaoId']?.toString() ?? '',
      voluntarioId: json['voluntarioId']?.toString() ?? '',
      nome: json['nome'] ?? 'Voluntário',
      fotoUrl: json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      eventoNome: json['eventoNome'] ?? 'Evento Comunitário',
      cidade: json['cidade'] ?? 'Santo André',
      dataSolicitacao: json['dataSolicitacao'] ?? 'Hoje',
      habilidades:
          List<String>.from(json['habilidades'] ?? ["Educação", "Empatia"]),
      caronaOuSuporte: json['caronaOuSuporte'],
    );
  }
}

class EventoGerenciadoModel {
  final String id;
  final String titulo;
  final String dataFormatada;
  final String horario;
  final int inscritosCount;
  final int vagasTotais;
  final String imagemUrl;
  final String status; // "ativo", "lotado", "concluido"

  EventoGerenciadoModel({
    required this.id,
    required this.titulo,
    required this.dataFormatada,
    required this.horario,
    required this.inscritosCount,
    required this.vagasTotais,
    required this.imagemUrl,
    required this.status,
  });

  factory EventoGerenciadoModel.fromJson(Map<String, dynamic> json) {
    return EventoGerenciadoModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? '',
      dataFormatada: json['data'] ?? '',
      horario: json['horario'] ?? '',
      inscritosCount: json['inscritosCount'] ?? 0,
      vagasTotais: json['vagasTotais'] ?? 0,
      imagemUrl: json['imagemUrl'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600',
      status: json['status'] ?? 'ativo',
    );
  }
}

class OngDashboardModel {
  final String id;
  final String nome;
  final String categoria;
  final String cidade;
  final String logoUrl;
  final int totalVoluntariosEngajados;
  final int vagasAbertas;
  final int horasGeradas;
  final int candidaturasPendentesCount;
  final List<String> necessidadesAtuais;
  final List<CandidatoVoluntarioModel> candidaturasPendentes;
  final List<EventoGerenciadoModel> eventosAtivos;

  OngDashboardModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.logoUrl,
    required this.totalVoluntariosEngajados,
    required this.vagasAbertas,
    required this.horasGeradas,
    required this.candidaturasPendentesCount,
    required this.necessidadesAtuais,
    required this.candidaturasPendentes,
    required this.eventosAtivos,
  });

  factory OngDashboardModel.fromJson(Map<String, dynamic> json) {
    var rawCands = json['candidaturasPendentes'] as List? ?? [];
    var rawEventos = json['eventosAtivos'] as List? ?? [];

    return OngDashboardModel(
      id: json['id']?.toString() ?? 'ong-1',
      nome: json['nome'] ?? 'Instituto Criança Cidadã',
      categoria: json['categoria'] ?? 'Educação & Infância',
      cidade: json['cidade'] ?? 'Santo André',
      logoUrl: json['logoUrl'] ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      totalVoluntariosEngajados: json['totalVoluntarios'] ?? 54,
      vagasAbertas: json['vagasAbertas'] ?? 11,
      horasGeradas: json['horasGeradas'] ?? 340,
      candidaturasPendentesCount: json['candidaturasPendentesCount'] ?? 3,
      necessidadesAtuais: List<String>.from(json['necessidadesAtuais'] ??
          [
            "Material Escolar (Cadernos e Lápis)",
            "Leite e Alimentos para o lanche",
            "Voluntários para recreação de sábado",
          ]),
      candidaturasPendentes:
          rawCands.map((c) => CandidatoVoluntarioModel.fromJson(c)).toList(),
      eventosAtivos:
          rawEventos.map((e) => EventoGerenciadoModel.fromJson(e)).toList(),
    );
  }
}
