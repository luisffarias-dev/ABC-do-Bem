// lib/register/voluntario/widgets/dialog_sucesso_voluntario.dart

import 'package:flutter/material.dart';
import '../../../voluntarios/home/voluntario_home_page.dart';

class DialogSucessoVoluntario extends StatelessWidget {
  final String mensagem;
  final String voluntarioId;

  const DialogSucessoVoluntario({
    super.key,
    required this.mensagem,
    required this.voluntarioId,
  });

  static void exibir(BuildContext context,
      {required String mensagem, required String voluntarioId}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogSucessoVoluntario(
        mensagem: mensagem,
        voluntarioId: voluntarioId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Bem-vindo ao ABC do Bem! 🎉",
        style: TextStyle(
          color: Color(0xFF0C6B6B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        "$mensagem\nExplore as oportunidades e comece a impactar o Grande ABC!",
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF3A6868),
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a1, a2) =>
                    VoluntarioHomePage(voluntarioId: voluntarioId),
                transitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
          child: const Text(
            "Acessar Plataforma",
            style: TextStyle(
              color: Color(0xFF0C6B6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
