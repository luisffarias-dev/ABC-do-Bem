// lib/models/user_session_model.dart

class UserSessionModel {
  final String id;
  final String nome;
  final String fotoUrl;
  final String tipoUsuario; // 'voluntario' ou 'ong'
  final String? tokenJWT;

  UserSessionModel({
    required this.id,
    required this.nome,
    required this.fotoUrl,
    required this.tipoUsuario,
    this.tokenJWT,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? 'Usuário',
      fotoUrl:
          json['fotoUrl'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      tipoUsuario: json['tipoUsuario'] ?? 'voluntario',
      tokenJWT: json['tokenJWT'],
    );
  }
}
