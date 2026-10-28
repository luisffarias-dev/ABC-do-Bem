// lib/register/ong/widgets/dialog_sucesso_ong.dart

import 'package:flutter/material.dart';

class DialogSucessoOng extends StatelessWidget {
  final String emailCadastrado;

  const DialogSucessoOng({super.key, required this.emailCadastrado});

  static Future<void> exibir(BuildContext context, String email) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogSucessoOng(emailCadastrado: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(28),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mark_email_read_rounded,
            color: Color(0xFF0C6B6B),
            size: 56,
          ),
          const SizedBox(height: 16),
          const Text(
            "Quase lá!",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF062222),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF3A6868),
              ),
              children: [
                const TextSpan(
                    text: "Enviamos um e-mail de confirmação para\n"),
                TextSpan(
                  text: emailCadastrado,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
                const TextSpan(
                  text:
                      ".\n\nPor favor, clique no link enviado para ativar a conta da sua ONG e começar a acessar a plataforma!",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Entendi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
