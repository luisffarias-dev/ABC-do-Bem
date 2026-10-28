// lib/voluntarios/perfil/widgets/modal_compartilhar_social.dart

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class ModalCompartilharSocial {
  static void exibir(BuildContext context,
      {required String texto, required String origem}) {
    showDialog(
      context: context,
      builder: (shareCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(22),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFFD1F5EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF0C6B6B),
                size: 38,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Experiência Publicada!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Que tal divulgar seu impacto e inspirar amigos nas suas redes sociais?",
              style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FlutterSocialButton(
                  mini: true,
                  buttonType: ButtonType.instagram,
                  onTap: () => Navigator.pop(shareCtx),
                ),
                FlutterSocialButton(
                  mini: true,
                  buttonType: ButtonType.facebook,
                  onTap: () => Navigator.pop(shareCtx),
                ),
                FlutterSocialButton(
                  mini: true,
                  buttonType: ButtonType.linkedin,
                  onTap: () => Navigator.pop(shareCtx),
                ),
                FlutterSocialButton(
                  mini: true,
                  buttonType: ButtonType.whatsapp,
                  onTap: () => Navigator.pop(shareCtx),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(shareCtx),
              child: const Text(
                "Agora não, obrigado",
                style: TextStyle(
                    color: Color(0xFF7AAAA0), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
