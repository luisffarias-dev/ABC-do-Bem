// lib/eventos/models/evento_model.dart

/// Modelo representativo de cada voluntário confirmado no evento
class EventoParticipanteModel {
  final String id;
  final String nome;
  final String? fotoUrl;

  const EventoParticipanteModel({
    required this.id,
    required this.nome,
    this.fotoUrl,
  });

  factory EventoParticipanteModel.fromJson(Map<String, dynamic> json) {
    return EventoParticipanteModel(
      id: json['id']?.toString() ?? json['voluntarioId']?.toString() ?? '',
      nome: json['nome'] ?? json['name'] ?? 'Voluntário',
      fotoUrl: json['fotoUrl'] ?? json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'fotoUrl': fotoUrl,
      };
}

class EventoModel {
  final String id;
  final String ongId;
  final String ongNome;
  final String titulo;
  final String descricao;
  final String categoria;
  final String cidade;
  final String? endereco;
  final double? latitude;
  final double? longitude;
  final String data;
  final String horario;
  final DateTime dataHoraInicio;
  final int vagasTotais;
  final int vagasRestantes;
  final String imagemUrl;
  final List<String> tags;
  final List<String> requisitos;
  final List<String> necessidades;
  final bool emiteCertificado;
  final bool isInscrito;
  final String? statusInscricao;
  final String? inscricaoId;
  final DateTime criadoEm;
  final List<EventoParticipanteModel> participantesConfirmados;

  const EventoModel({
    required this.id,
    required this.ongId,
    this.ongNome = 'Instituição Parceira',
    required this.titulo,
    this.descricao = '',
    this.categoria = 'Geral',
    this.cidade = 'Grande ABC',
    this.endereco,
    this.latitude,
    this.longitude,
    required this.data,
    required this.horario,
    required this.dataHoraInicio,
    required this.vagasTotais,
    required this.vagasRestantes,
    required this.imagemUrl,
    this.tags = const [],
    this.requisitos = const [],
    this.necessidades = const [],
    this.emiteCertificado = true,
    this.isInscrito = false,
    this.statusInscricao,
    this.inscricaoId,
    required this.criadoEm,
    this.participantesConfirmados = const [],
  });

  double get progressoOcupacao {
    if (vagasTotais <= 0) return 0.0;
    final ocupadas = vagasTotais - vagasRestantes;
    final r = ocupadas / vagasTotais;
    return r.clamp(0.0, 1.0);
  }

  bool get isEsgotado => vagasRestantes <= 0;
  bool get isQuaseEsgotado => vagasRestantes > 0 && vagasRestantes <= 3;

  EventoModel copyWith({
    String? id,
    String? ongId,
    String? ongNome,
    String? titulo,
    String? descricao,
    String? categoria,
    String? cidade,
    String? endereco,
    double? latitude,
    double? longitude,
    String? data,
    String? horario,
    DateTime? dataHoraInicio,
    int? vagasTotais,
    int? vagasRestantes,
    String? imagemUrl,
    List<String>? tags,
    List<String>? requisitos,
    List<String>? necessidades,
    bool? emiteCertificado,
    bool? isInscrito,
    String? statusInscricao,
    String? inscricaoId,
    DateTime? criadoEm,
    List<EventoParticipanteModel>? participantesConfirmados,
  }) {
    return EventoModel(
      id: id ?? this.id,
      ongId: ongId ?? this.ongId,
      ongNome: ongNome ?? this.ongNome,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      cidade: cidade ?? this.cidade,
      endereco: endereco ?? this.endereco,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      data: data ?? this.data,
      horario: horario ?? this.horario,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      vagasTotais: vagasTotais ?? this.vagasTotais,
      vagasRestantes: vagasRestantes ?? this.vagasRestantes,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      tags: tags ?? this.tags,
      requisitos: requisitos ?? this.requisitos,
      necessidades: necessidades ?? this.necessidades,
      emiteCertificado: emiteCertificado ?? this.emiteCertificado,
      isInscrito: isInscrito ?? this.isInscrito,
      statusInscricao: statusInscricao ?? this.statusInscricao,
      inscricaoId: inscricaoId ?? this.inscricaoId,
      criadoEm: criadoEm ?? this.criadoEm,
      participantesConfirmados:
          participantesConfirmados ?? this.participantesConfirmados,
    );
  }

  factory EventoModel.fromJson(Map<String, dynamic> json,
      {String? voluntarioId}) {
    bool inscrito = false;
    String? status;
    String? inscricaoId;

    if (voluntarioId != null && json['inscricoes'] is List) {
      final match = (json['inscricoes'] as List).firstWhere(
        (i) => i['voluntarioId'] == voluntarioId && i['status'] != 'CANCELADA',
        orElse: () => null,
      );
      if (match != null) {
        inscrito = true;
        status = match['status']?.toString() ?? "Aprovado";
        inscricaoId = match['id']?.toString();
      }
    } else {
      inscrito = json['isInscrito'] as bool? ?? false;
      status = json['statusInscricao']?.toString();
      inscricaoId = json['inscricaoId']?.toString();
    }

    // Extração segura de participantes com fallbacks
    final rawParticipantes = json['participantesConfirmados'] ??
        json['participantes'] ??
        (json['inscricoes'] is List ? json['inscricoes'] : []);

    List<EventoParticipanteModel> listaParticipantes = [];
    if (rawParticipantes is List) {
      listaParticipantes = rawParticipantes.map((p) {
        if (p is Map<String, dynamic>) {
          return EventoParticipanteModel.fromJson(
            p['voluntario'] is Map<String, dynamic>
                ? p['voluntario'] as Map<String, dynamic>
                : p,
          );
        }
        return EventoParticipanteModel(
          id: p.toString(),
          nome: "Voluntário $p",
          fotoUrl: null,
        );
      }).toList();
    }

    return EventoModel(
      id: json['id']?.toString() ?? '',
      ongId: json['ongId']?.toString() ?? json['ong']?['id']?.toString() ?? '',
      ongNome: json['ongNome']?.toString() ??
          json['ong']?['nome']?.toString() ??
          'Instituição Parceira',
      titulo: json['titulo']?.toString() ?? 'Ação Solidária',
      descricao: json['descricao']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? 'Assistência Social',
      cidade: json['cidade']?.toString() ?? 'Grande ABC',
      endereco: json['endereco']?.toString(),
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      data: json['data']?.toString() ?? '',
      horario: json['horario']?.toString() ?? '',
      dataHoraInicio: json['dataHoraInicio'] != null
          ? DateTime.tryParse(json['dataHoraInicio'].toString()) ??
              DateTime.now()
          : DateTime.now(),
      vagasTotais: (json['vagasTotais'] as num?)?.toInt() ?? 10,
      vagasRestantes: (json['vagasRestantes'] as num?)?.toInt() ?? 0,
      imagemUrl: json['imagemUrl']?.toString() ??
          'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      requisitos:
          (json['requisitos'] as List?)?.map((r) => r.toString()).toList() ??
              [],
      necessidades:
          (json['necessidades'] as List?)?.map((n) => n.toString()).toList() ??
              [],
      emiteCertificado: json['emiteCertificado'] as bool? ?? true,
      isInscrito: inscrito,
      statusInscricao: status,
      inscricaoId: inscricaoId,
      criadoEm: json['criadoEm'] != null
          ? DateTime.tryParse(json['criadoEm'].toString()) ?? DateTime.now()
          : DateTime.now(),
      participantesConfirmados: listaParticipantes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ongId': ongId,
      'ongNome': ongNome,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'cidade': cidade,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'data': data,
      'horario': horario,
      'dataHoraInicio': dataHoraInicio.toIso8601String(),
      'vagasTotais': vagasTotais,
      'vagasRestantes': vagasRestantes,
      'imagemUrl': imagemUrl,
      'tags': tags,
      'requisitos': requisitos,
      'necessidades': necessidades,
      'emiteCertificado': emiteCertificado,
      'isInscrito': isInscrito,
      'statusInscricao': statusInscricao,
      'inscricaoId': inscricaoId,
      'criadoEm': criadoEm.toIso8601String(),
      'participantesConfirmados':
          participantesConfirmados.map((p) => p.toJson()).toList(),
    };
  }
}

/// Modelo de Inscrição com suporte a todas as propriedades de chamada, histórico e contato
class InscricaoEventoModel {
  final String id;
  final String eventoId;
  final String voluntarioId;
  final String status;
  final DateTime dataInscricao;
  final DateTime? criadoEm;
  final EventoModel? evento;
  final int horasComputadas;
  final int horasValidadas;
  final bool autorizouContato;

  const InscricaoEventoModel({
    required this.id,
    required this.eventoId,
    required this.voluntarioId,
    this.status = "CONFIRMADA",
    DateTime? dataInscricao,
    DateTime? criadoEm,
    this.evento,
    this.horasComputadas = 0,
    this.horasValidadas = 0,
    this.autorizouContato = true,
  })  : dataInscricao = dataInscricao ?? criadoEm ?? const _DataPadrao(),
        criadoEm = criadoEm ?? dataInscricao;

  factory InscricaoEventoModel.fromJson(Map<String, dynamic> json) {
    final data = json['dataInscricao'] != null
        ? DateTime.tryParse(json['dataInscricao'].toString())
        : (json['criadoEm'] != null
            ? DateTime.tryParse(json['criadoEm'].toString())
            : null);

    return InscricaoEventoModel(
      id: json['id']?.toString() ?? '',
      eventoId: json['eventoId']?.toString() ?? '',
      voluntarioId: json['voluntarioId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'CONFIRMADA',
      dataInscricao: data ?? DateTime.now(),
      criadoEm: data ?? DateTime.now(),
      evento:
          json['evento'] != null ? EventoModel.fromJson(json['evento']) : null,
      horasComputadas: (json['horasComputadas'] as num?)?.toInt() ?? 0,
      horasValidadas: (json['horasValidadas'] as num?)?.toInt() ??
          (json['horasComputadas'] as num?)?.toInt() ??
          0,
      autorizouContato: json['autorizouContato'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventoId': eventoId,
      'voluntarioId': voluntarioId,
      'status': status,
      'dataInscricao': dataInscricao.toIso8601String(),
      'criadoEm':
          criadoEm?.toIso8601String() ?? dataInscricao.toIso8601String(),
      'evento': evento?.toJson(),
      'horasComputadas': horasComputadas,
      'horasValidadas': horasValidadas,
      'autorizouContato': autorizouContato,
    };
  }
}

class _DataPadrao implements DateTime {
  const _DataPadrao();
  @override
  dynamic noSuchMethod(Invocation invocation) => DateTime.now();
}

/// DTO flexível para criação de ações
class CriarEventoDTO {
  final String ongId;
  final String ongNome;
  final String titulo;
  final String categoria;
  final String descricao;
  final String cidade;
  final String endereco;
  final double? latitude;
  final double? longitude;
  final String data;
  final String horario;
  final String? horarioInicio;
  final String? horarioTermino;
  final DateTime dataHoraInicio;
  final String imagemUrl;
  final List<String> tags;
  final int vagasTotais;
  final List<String> requisitos;
  final List<String> necessidades;
  final bool emiteCertificado;

  const CriarEventoDTO({
    required this.ongId,
    this.ongNome = '',
    required this.titulo,
    this.categoria = 'Assistência Social',
    this.descricao = '',
    required this.cidade,
    this.endereco = '',
    this.latitude,
    this.longitude,
    this.data = '',
    this.horario = '',
    this.horarioInicio,
    this.horarioTermino,
    required this.dataHoraInicio,
    this.imagemUrl = '',
    this.tags = const [],
    required this.vagasTotais,
    this.requisitos = const [],
    this.necessidades = const [],
    this.emiteCertificado = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'ongId': ongId,
      'ongNome': ongNome,
      'titulo': titulo,
      'categoria': categoria,
      'descricao': descricao,
      'cidade': cidade,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'data': data,
      'horario': horario.isNotEmpty
          ? horario
          : "${horarioInicio ?? ''} - ${horarioTermino ?? ''}".trim(),
      'dataHoraInicio': dataHoraInicio.toIso8601String(),
      'imagemUrl': imagemUrl,
      'tags': tags,
      'vagasTotais': vagasTotais,
      'requisitos': requisitos,
      'necessidades': necessidades,
      'emiteCertificado': emiteCertificado,
    };
  }
}
