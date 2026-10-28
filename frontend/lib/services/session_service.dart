// lib/services/session_service.dart

class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  String? token;
  String? usuarioId;
  String? nomeUsuario;

  bool get estaAutenticado => token != null && token!.isNotEmpty;

  void salvarSessao({
    required String novoToken,
    required String novoUsuarioId,
    required String novoNome,
  }) {
    token = novoToken;
    usuarioId = novoUsuarioId;
    nomeUsuario = novoNome;
  }

  void limpar() {
    token = null;
    usuarioId = null;
    nomeUsuario = null;
  }

  // Alias para manter compatibilidade com as telas
  void limparSessao() => limpar();
}
