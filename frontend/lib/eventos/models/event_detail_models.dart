// lib/eventos/models/event_detail_models.dart

class ParticipanteEventoModel {
  final String id;
  final String nome;
  final String cidade;
  final String fotoUrl;

  const ParticipanteEventoModel({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.fotoUrl,
  });

  factory ParticipanteEventoModel.fromJson(Map<String, dynamic> json) {
    return ParticipanteEventoModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? 'Voluntário',
      cidade: json['cidade']?.toString() ?? 'ABC',
      fotoUrl: json['fotoUrl']?.toString() ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cidade': cidade,
      'fotoUrl': fotoUrl,
    };
  }

  ParticipanteEventoModel copyWith({
    String? id,
    String? nome,
    String? cidade,
    String? fotoUrl,
  }) {
    return ParticipanteEventoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cidade: cidade ?? this.cidade,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }
}

class EventoDetalheCompletoModel {
  final String id;
  final String ongId;
  final String ongNome;
  final String ongLogo;
  final String titulo;
  final String descricao;
  final String data;
  final String horario;
  final String cidade;
  final String estado;
  final String localNome;
  final String enderecoCompleto;
  final String comoChegarDicas;
  final String imagemUrl;
  final int vagasTotais;
  final int vagasRestantes;
  final int inscritosCount;
  final bool jaInscrito;
  final String
      statusInscricao; // "disponivel", "aguardando_aprovacao", "inscrito", "cancelado"
  final List<String> tags;
  final List<String> necessidadesOng;
  final List<String> precisoDeOpcoes;
  final List<String> possoOferecerOpcoes;
  final List<ParticipanteEventoModel> participantesConfirmados;

  const EventoDetalheCompletoModel({
    required this.id,
    required this.ongId,
    required this.ongNome,
    required this.ongLogo,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.cidade,
    required this.estado,
    required this.localNome,
    required this.enderecoCompleto,
    required this.comoChegarDicas,
    required this.imagemUrl,
    required this.vagasTotais,
    required this.vagasRestantes,
    required this.inscritosCount,
    required this.jaInscrito,
    required this.statusInscricao,
    required this.tags,
    required this.necessidadesOng,
    required this.precisoDeOpcoes,
    required this.possoOferecerOpcoes,
    required this.participantesConfirmados,
  });

  factory EventoDetalheCompletoModel.fromJson(Map<String, dynamic> json) {
    return EventoDetalheCompletoModel(
      id: json['id']?.toString() ?? '',
      ongId: json['ongId']?.toString() ?? '',
      ongNome: json['ongNome']?.toString() ?? 'Instituição',
      ongLogo: json['ongLogo']?.toString() ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200',
      titulo: json['titulo']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      data: json['data']?.toString() ?? '',
      horario: json['horario']?.toString() ?? '',
      cidade: json['cidade']?.toString() ?? 'Grande ABC',
      estado: json['estado']?.toString() ?? 'SP',
      localNome: json['localNome']?.toString() ?? 'Local a definir',
      enderecoCompleto: json['enderecoCompleto']?.toString() ?? '',
      comoChegarDicas: json['comoChegarDicas']?.toString() ?? '',
      imagemUrl: json['imagemUrl']?.toString() ??
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
      vagasTotais: json['vagasTotais'] is int
          ? json['vagasTotais']
          : int.tryParse(json['vagasTotais']?.toString() ?? '0') ?? 0,
      vagasRestantes: json['vagasRestantes'] is int
          ? json['vagasRestantes']
          : int.tryParse(json['vagasRestantes']?.toString() ?? '0') ?? 0,
      inscritosCount: json['inscritosCount'] is int
          ? json['inscritosCount']
          : int.tryParse(json['inscritosCount']?.toString() ?? '0') ?? 0,
      jaInscrito: json['jaInscrito'] as bool? ?? false,
      statusInscricao: json['statusInscricao']?.toString() ?? 'disponivel',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : const [],
      necessidadesOng: json['necessidadesOng'] != null
          ? List<String>.from(json['necessidadesOng'] as List)
          : const [],
      precisoDeOpcoes: json['precisoDeOpcoes'] != null
          ? List<String>.from(json['precisoDeOpcoes'] as List)
          : const [],
      possoOferecerOpcoes: json['possoOferecerOpcoes'] != null
          ? List<String>.from(json['possoOferecerOpcoes'] as List)
          : const [],
      participantesConfirmados: json['participantesConfirmados'] != null
          ? (json['participantesConfirmados'] as List)
              .map((p) =>
                  ParticipanteEventoModel.fromJson(p as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ongId': ongId,
      'ongNome': ongNome,
      'ongLogo': ongLogo,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
      'horario': horario,
      'cidade': cidade,
      'estado': estado,
      'localNome': localNome,
      'enderecoCompleto': enderecoCompleto,
      'comoChegarDicas': comoChegarDicas,
      'imagemUrl': imagemUrl,
      'vagasTotais': vagasTotais,
      'vagasRestantes': vagasRestantes,
      'inscritosCount': inscritosCount,
      'jaInscrito': jaInscrito,
      'statusInscricao': statusInscricao,
      'tags': tags,
      'necessidadesOng': necessidadesOng,
      'precisoDeOpcoes': precisoDeOpcoes,
      'possoOferecerOpcoes': possoOferecerOpcoes,
      'participantesConfirmados':
          participantesConfirmados.map((p) => p.toJson()).toList(),
    };
  }

  EventoDetalheCompletoModel copyWith({
    String? id,
    String? ongId,
    String? ongNome,
    String? ongLogo,
    String? titulo,
    String? descricao,
    String? data,
    String? horario,
    String? cidade,
    String? estado,
    String? localNome,
    String? enderecoCompleto,
    String? comoChegarDicas,
    String? imagemUrl,
    int? vagasTotais,
    int? vagasRestantes,
    int? inscritosCount,
    bool? jaInscrito,
    String? statusInscricao,
    List<String>? tags,
    List<String>? necessidadesOng,
    List<String>? precisoDeOpcoes,
    List<String>? possoOferecerOpcoes,
    List<ParticipanteEventoModel>? participantesConfirmados,
  }) {
    return EventoDetalheCompletoModel(
      id: id ?? this.id,
      ongId: ongId ?? this.ongId,
      ongNome: ongNome ?? this.ongNome,
      ongLogo: ongLogo ?? this.ongLogo,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      horario: horario ?? this.horario,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      localNome: localNome ?? this.localNome,
      enderecoCompleto: enderecoCompleto ?? this.enderecoCompleto,
      comoChegarDicas: comoChegarDicas ?? this.comoChegarDicas,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      vagasTotais: vagasTotais ?? this.vagasTotais,
      vagasRestantes: vagasRestantes ?? this.vagasRestantes,
      inscritosCount: inscritosCount ?? this.inscritosCount,
      jaInscrito: jaInscrito ?? this.jaInscrito,
      statusInscricao: statusInscricao ?? this.statusInscricao,
      tags: tags ?? this.tags,
      necessidadesOng: necessidadesOng ?? this.necessidadesOng,
      precisoDeOpcoes: precisoDeOpcoes ?? this.precisoDeOpcoes,
      possoOferecerOpcoes: possoOferecerOpcoes ?? this.possoOferecerOpcoes,
      participantesConfirmados:
          participantesConfirmados ?? this.participantesConfirmados,
    );
  }

  // Getters visuais práticos
  bool get isEsgotado => vagasRestantes <= 0;
  bool get isQuaseEsgotado => vagasRestantes <= 3 && !isEsgotado;
  double get progressoOcupacao =>
      vagasTotais > 0 ? (vagasTotais - vagasRestantes) / vagasTotais : 0.0;
}
