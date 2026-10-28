// lib/models/ong_cadastro_models.dart

/// DTO consolidado com as informações de todas as etapas de cadastro da ONG
class OngCadastroDTO {
  final Map<String, dynamic> dadosCompletosEtapasAnteriores;
  final List<String> habilidadesBuscadas;
  final List<String> doacoesAceitas;
  final String formatoVoluntariado;
  final String emailLogin;
  final String senhaLogin;
  final bool termosAceitos;
  final bool lgpdAceita;

  OngCadastroDTO({
    required this.dadosCompletosEtapasAnteriores,
    required this.habilidadesBuscadas,
    required this.doacoesAceitas,
    required this.formatoVoluntariado,
    required this.emailLogin,
    required this.senhaLogin,
    required this.termosAceitos,
    required this.lgpdAceita,
  });

  Map<String, dynamic> toJson() {
    return {
      ...dadosCompletosEtapasAnteriores,
      'habilidades_buscadas': habilidadesBuscadas,
      'doacoes_aceitas': doacoesAceitas,
      'formato_voluntariado': formatoVoluntariado,
      'email_login': emailLogin.trim().toLowerCase(),
      'senha_login': senhaLogin,
      'termos_aceitos': termosAceitos,
      'lgpd_aceita': lgpdAceita,
    };
  }
}

/// Resposta de confirmação retornada pelo endpoint da API
class RespostaCadastroOngModel {
  final String ongId;
  final String email;
  final String mensagem;

  RespostaCadastroOngModel({
    required this.ongId,
    required this.email,
    required this.mensagem,
  });

  factory RespostaCadastroOngModel.fromJson(Map<String, dynamic> json) {
    return RespostaCadastroOngModel(
      ongId: json['ongId']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      mensagem: json['mensagem'] ?? 'Cadastro realizado com sucesso!',
    );
  }
}
