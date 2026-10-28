// lib/models/voluntario_cadastro_dto.dart

/// DTO consolidado com todas as informações das 3 etapas de cadastro do voluntário
class VoluntarioCadastroDTO {
  // Etapa 1: Dados pessoais, endereço e acesso
  final String name;
  final String tipoDocumento;
  final String cpf;
  final String nascimento;
  final String genero;
  final String email;
  final String password;
  final String telefone;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String bio;

  // Etapa 2: Habilidades
  final List<String> habilidades;

  // Etapa 3: Disponibilidade e Aceites Legais
  final List<String> disponibilidade;
  final bool aceiteTermos;
  final bool aceiteLgpd;

  VoluntarioCadastroDTO({
    required this.name,
    required this.tipoDocumento,
    required this.cpf,
    required this.nascimento,
    required this.genero,
    required this.email,
    required this.password,
    required this.telefone,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.bio,
    required this.habilidades,
    required this.disponibilidade,
    required this.aceiteTermos,
    required this.aceiteLgpd,
  });

  /// Factory: centraliza o mapeamento dos dados passados pelas etapas
  factory VoluntarioCadastroDTO.deEtapas({
    required Map<String, String> dadosBasicos,
    required List<String> habilidades,
    required List<String> disponibilidade,
    required bool termosAceitos,
    required bool lgpdAceita,
  }) {
    // Unifica nome e sobrenome se vierem separados
    final nome = (dadosBasicos['nome'] ?? '').trim();
    final sobrenome = (dadosBasicos['sobrenome'] ?? '').trim();
    final nomeCompleto = sobrenome.isNotEmpty ? "$nome $sobrenome" : nome;

    return VoluntarioCadastroDTO(
      name: nomeCompleto,
      tipoDocumento: dadosBasicos['tipo_documento'] ?? 'CPF',
      // Aceita 'cpf' ou 'documento'
      cpf: (dadosBasicos['cpf'] ?? dadosBasicos['documento'] ?? '').trim(),
      // Aceita 'data_nascimento' ou 'nascimento'
      nascimento:
          (dadosBasicos['data_nascimento'] ?? dadosBasicos['nascimento'] ?? '')
              .trim(),
      genero: (dadosBasicos['genero'] ?? '').trim(),
      email: (dadosBasicos['email'] ?? '').trim().toLowerCase(),
      // Aceita 'password' ou 'senha'
      password: dadosBasicos['password'] ?? dadosBasicos['senha'] ?? '',
      telefone: (dadosBasicos['telefone'] ?? '').trim(),
      cep: (dadosBasicos['cep'] ?? '').trim(),
      logradouro:
          (dadosBasicos['rua'] ?? dadosBasicos['logradouro'] ?? '').trim(),
      numero: (dadosBasicos['numero'] ?? '').trim(),
      bairro: (dadosBasicos['bairro'] ?? '').trim(),
      cidade: (dadosBasicos['cidade'] ?? '').trim(),
      estado: (dadosBasicos['estado'] ?? 'SP').trim(),
      bio: (dadosBasicos['bio'] ?? '').trim(),
      habilidades: habilidades,
      disponibilidade: disponibilidade,
      aceiteTermos: termosAceitos,
      aceiteLgpd: lgpdAceita,
    );
  }

  /// Converte para o payload exato exigido pelo backend
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "tipoDocumento": tipoDocumento,
      "cpf": cpf,
      "nascimento": nascimento,
      "email": email,
      "password": password,
      "telefone": telefone,
      "cep": cep,
      "logradouro": logradouro,
      "numero": numero,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
      "bio": bio,
      "habilidades": habilidades,
      "disponibilidade": disponibilidade,
      "aceiteTermos": aceiteTermos,
      "aceiteLgpd": aceiteLgpd,
    };
  }
}

/// Resposta retornada pelo endpoint /auth/userRegister
class RespostaCadastroVoluntario {
  final String voluntarioId;
  final String? tokenJWT;
  final String mensagem;

  RespostaCadastroVoluntario({
    required this.voluntarioId,
    this.tokenJWT,
    required this.mensagem,
  });

  factory RespostaCadastroVoluntario.fromJson(Map<String, dynamic> json) {
    return RespostaCadastroVoluntario(
      voluntarioId: json['id']?.toString() ??
          json['userId']?.toString() ??
          json['voluntarioId']?.toString() ??
          'voluntario-1',
      tokenJWT: json['token'] ?? json['accessToken'] ?? json['jwt'],
      mensagem: json['message'] ??
          json['mensagem'] ??
          'Cadastro concluído com sucesso!',
    );
  }
}
