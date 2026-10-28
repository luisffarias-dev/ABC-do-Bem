// lib/voluntarios/perfil/meu_perfil_page.dart

import 'package:flutter/material.dart';
import 'voluntario_perfil_page.dart';

/// Wrapper de conveniência que roteia o usuário logado diretamente
/// para a visualização autônoma/administrativa da página unificada de perfil.
class MeuPerfilPage extends StatelessWidget {
  final String usuarioId;
  final String tipoUsuario;
  final String? token; // <-- Adicionado para suportar autenticação

  const MeuPerfilPage({
    super.key,
    required this.usuarioId,
    this.tipoUsuario = "voluntario",
    this.token, // <-- Recebe no construtor
  });

  @override
  Widget build(BuildContext context) {
    final String idResolvido =
        usuarioId.trim().isNotEmpty ? usuarioId.trim() : "voluntario-1";

    return VoluntarioPerfilPage(
      usuarioId: idResolvido,
      usuarioLogadoId: idResolvido,
      tipoUsuario: tipoUsuario,
      token: token, // <-- Repassa para o VoluntarioPerfilPage
    );
  }
}
