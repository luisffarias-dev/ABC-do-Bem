// lib/eventos/services/event_detail_service.dart

import '../models/event_detail_models.dart';
import 'evento_service.dart';

class EventDetailService {
  final EventoService _eventoService = EventoService();

  // Cache em memória dos detalhes dos eventos para manter sincronismo de estado na sessão
  static final Map<String, EventoDetalheCompletoModel> _detalhesCache = {
    "101": EventoDetalheCompletoModel(
      id: "101",
      ongId: "ong-1",
      ongNome: "Instituto Criança Cidadã",
      ongLogo:
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
      titulo: "Mutirão de Reforço Escolar Comunitário",
      descricao:
          "Venha apoiar nossas crianças do Grande ABC com reforço escolar em matemática básica, língua portuguesa e atividades recreativas de sábado. Uma manhã dedicada ao incentivo e acolhimento pedagógico comunitário.",
      data: "14/Nov",
      horario: "09:00 - 12:30",
      cidade: "Santo André",
      estado: "SP",
      localNome: "Sede Comunitária Bairro Jardim",
      enderecoCompleto:
          "Rua das Figueiras, 450 - Bairro Jardim, Santo André - SP",
      comoChegarDicas:
          "Localizado a cerca de 10 minutos a pé da estação Santo André da Linha 10-Turquesa da CPTM e do Terminal Metropolitano Santo André Leste.",
      imagemUrl:
          "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800",
      vagasTotais: 15,
      vagasRestantes: 2,
      inscritosCount: 13,
      jaInscrito: false,
      statusInscricao: "disponivel",
      tags: ["Educação", "Infância", "Alfabetização", "Recreação"],
      necessidadesOng: [
        "Material escolar (cadernos, lápis de cor, borrachas)",
        "Lanches saudáveis e frutas para o intervalo",
        "Voluntários pedagogos e contadores de histórias",
      ],
      precisoDeOpcoes: [
        "Carona saindo de Santo André (Centro)",
        "Carona saindo de São Bernardo (Rudge Ramos)",
        "Carona saindo de São Caetano",
        "Apoio com transporte de materiais",
      ],
      possoOferecerOpcoes: [
        "Ofereço 2 vagas de carona saindo de Mauá",
        "Ofereço 3 vagas saindo de Santo André (Estação)",
        "Posso levar materiais didáticos extras",
      ],
      participantesConfirmados: const [
        ParticipanteEventoModel(
          id: "vol-2",
          nome: "Mariana Santos",
          cidade: "Santo André",
          fotoUrl:
              "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
        ),
        ParticipanteEventoModel(
          id: "vol-3",
          nome: "Carlos Lima",
          cidade: "São Caetano",
          fotoUrl:
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
        ),
        ParticipanteEventoModel(
          id: "vol-4",
          nome: "Beatriz Souza",
          cidade: "São Bernardo",
          fotoUrl:
              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200",
        ),
      ],
    ),
    "102": EventoDetalheCompletoModel(
      id: "102",
      ongId: "ong-2",
      ongNome: "Ação Verde Billings",
      ongLogo:
          "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=200",
      titulo: "Plantio Urbano e Agroecologia Billings",
      descricao:
          "Ação coletiva de recuperação ambiental na orla da Represa Billings. Faremos o plantio de mudas de árvores nativas da Mata Atlântica e manejo de canteiros agroecológicos.",
      data: "21/Nov",
      horario: "08:30 - 13:00",
      cidade: "São Bernardo",
      estado: "SP",
      localNome: "Parque Ecológico Riacho Grande",
      enderecoCompleto:
          "Estrada do Riacho Grande, km 4 - Riacho Grande, São Bernardo do Campo - SP",
      comoChegarDicas:
          "Acesso pela Rodovia Anchieta (saída Riacho Grande) ou via linhas municipais de São Bernardo partindo do Terminal Ferrazópolis.",
      imagemUrl:
          "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800",
      vagasTotais: 20,
      vagasRestantes: 7,
      inscritosCount: 13,
      jaInscrito: false,
      statusInscricao: "disponivel",
      tags: ["Meio Ambiente", "Sustentabilidade", "Mudas", "Agroecologia"],
      necessidadesOng: [
        "Luvas de jardinagem resistentes",
        "Mudas nativas da Mata Atlântica",
        "Pás, enxadas e regadores",
      ],
      precisoDeOpcoes: [
        "Carona saindo do Terminal Ferrazópolis",
        "Carona saindo de Santo André (Pery Ronchetti)",
      ],
      possoOferecerOpcoes: [
        "Ofereço 3 vagas de carona saindo do Centro de SBC",
        "Posso transportar ferramentas de jardinagem",
      ],
      participantesConfirmados: const [
        ParticipanteEventoModel(
          id: "vol-5",
          nome: "Lucas Pereira",
          cidade: "São Bernardo",
          fotoUrl:
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
        ),
      ],
    ),
  };

  /// Busca os detalhes completos de um evento específico pelo ID
  Future<EventoDetalheCompletoModel> buscarDetalhesEvento(
    String eventoId, {
    String? voluntarioId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Se já existe no cache em memória com estado atualizado
    if (_detalhesCache.containsKey(eventoId)) {
      return _detalhesCache[eventoId]!;
    }

    // Se for um evento criado dinamicamente pela ONG via EventoService
    final eventoBase = await _eventoService.buscarPorId(eventoId);
    if (eventoBase != null) {
      final novoDetalhe = EventoDetalheCompletoModel(
        id: eventoBase.id,
        ongId: eventoBase.ongId,
        ongNome: eventoBase.ongNome,
        ongLogo:
            "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=200",
        titulo: eventoBase.titulo,
        descricao: eventoBase.descricao,
        data: eventoBase.data,
        horario: eventoBase.horario,
        cidade: eventoBase.cidade,
        estado: "SP",
        localNome: eventoBase.endereco ?? "Local a combinar",
        enderecoCompleto: eventoBase.endereco ?? "${eventoBase.cidade} - SP",
        comoChegarDicas:
            "Mais detalhes de trajeto serão combinados diretamente no grupo da ação.",
        imagemUrl: eventoBase.imagemUrl,
        vagasTotais: eventoBase.vagasTotais,
        vagasRestantes: eventoBase.vagasRestantes,
        inscritosCount: eventoBase.vagasTotais - eventoBase.vagasRestantes,
        jaInscrito: eventoBase.isInscrito,
        statusInscricao: eventoBase.isInscrito ? "inscrito" : "disponivel",
        tags: eventoBase.tags,
        necessidadesOng: eventoBase.necessidades.isNotEmpty
            ? eventoBase.necessidades
            : ["Apoio presencial geral na data"],
        precisoDeOpcoes: const [
          "Carona do terminal central",
          "Apoio com trajeto",
        ],
        possoOferecerOpcoes: const [
          "Posso oferecer carona",
        ],
        participantesConfirmados: const [],
      );

      _detalhesCache[eventoId] = novoDetalhe;
      return novoDetalhe;
    }

    // Fallback defensivo caso o ID não seja encontrado
    return _detalhesCache["101"]!;
  }

  /// Submete a solicitação de participação do voluntário no evento e adiciona ofertas/pedidos ao mural
  Future<bool> solicitarInscricaoEvento({
    required String eventoId,
    required String voluntarioId,
    required List<String> precisoDe,
    required List<String> possoOferecer,
    required String observacoes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final atual = _detalhesCache[eventoId];
    if (atual != null && atual.vagasRestantes > 0) {
      final List<String> novosPrecisoDe = List.from(atual.precisoDeOpcoes);
      for (final p in precisoDe) {
        if (!novosPrecisoDe.contains(p)) {
          novosPrecisoDe.add(p);
        }
      }

      final List<String> novosPossoOferecer =
          List.from(atual.possoOferecerOpcoes);
      for (final o in possoOferecer) {
        if (!novosPossoOferecer.contains(o)) {
          novosPossoOferecer.add(o);
        }
      }

      final novosParticipantes = List<ParticipanteEventoModel>.from(
        atual.participantesConfirmados,
      );

      // Adiciona o usuário atual aos confirmados se ainda não estiver
      if (!novosParticipantes.any((p) => p.id == voluntarioId)) {
        novosParticipantes.insert(
          0,
          ParticipanteEventoModel(
            id: voluntarioId,
            nome: "Você (Inscrito)",
            cidade: atual.cidade,
            fotoUrl:
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200",
          ),
        );
      }

      _detalhesCache[eventoId] = EventoDetalheCompletoModel(
        id: atual.id,
        ongId: atual.ongId,
        ongNome: atual.ongNome,
        ongLogo: atual.ongLogo,
        titulo: atual.titulo,
        descricao: atual.descricao,
        data: atual.data,
        horario: atual.horario,
        cidade: atual.cidade,
        estado: atual.estado,
        localNome: atual.localNome,
        enderecoCompleto: atual.enderecoCompleto,
        comoChegarDicas: atual.comoChegarDicas,
        imagemUrl: atual.imagemUrl,
        vagasTotais: atual.vagasTotais,
        vagasRestantes: atual.vagasRestantes - 1,
        inscritosCount: atual.inscritosCount + 1,
        jaInscrito: true,
        statusInscricao: "inscrito",
        tags: atual.tags,
        necessidadesOng: atual.necessidadesOng,
        precisoDeOpcoes: novosPrecisoDe,
        possoOferecerOpcoes: novosPossoOferecer,
        participantesConfirmados: novosParticipantes,
      );

      // Notifica o serviço geral de eventos
      await _eventoService.inscreverVoluntario(eventoId, voluntarioId);
      return true;
    }

    return false;
  }

  /// Cancela a participação prévia de um voluntário e restaura a vaga
  Future<bool> cancelarInscricaoEvento({
    required String eventoId,
    required String voluntarioId,
    required String motivo,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final atual = _detalhesCache[eventoId];
    if (atual != null) {
      final novosParticipantes = atual.participantesConfirmados
          .where((p) => p.id != voluntarioId)
          .toList();

      _detalhesCache[eventoId] = EventoDetalheCompletoModel(
        id: atual.id,
        ongId: atual.ongId,
        ongNome: atual.ongNome,
        ongLogo: atual.ongLogo,
        titulo: atual.titulo,
        descricao: atual.descricao,
        data: atual.data,
        horario: atual.horario,
        cidade: atual.cidade,
        estado: atual.estado,
        localNome: atual.localNome,
        enderecoCompleto: atual.enderecoCompleto,
        comoChegarDicas: atual.comoChegarDicas,
        imagemUrl: atual.imagemUrl,
        vagasTotais: atual.vagasTotais,
        vagasRestantes: (atual.vagasRestantes + 1).clamp(0, atual.vagasTotais),
        inscritosCount: (atual.inscritosCount - 1).clamp(0, atual.vagasTotais),
        jaInscrito: false,
        statusInscricao: "cancelado",
        tags: atual.tags,
        necessidadesOng: atual.necessidadesOng,
        precisoDeOpcoes: atual.precisoDeOpcoes,
        possoOferecerOpcoes: atual.possoOferecerOpcoes,
        participantesConfirmados: novosParticipantes,
      );

      await _eventoService.cancelarInscricao(eventoId, voluntarioId,
          motivo: motivo);
      return true;
    }

    return false;
  }
}
