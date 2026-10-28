// lib/register/ong/widgets/secao_termos_lgpd_ong.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../legal_popups.dart';

class SecaoTermosLgpdOng extends StatelessWidget {
  final bool aceitouTermos;
  final bool aceitouLgpd;
  final ValueChanged<bool> onAlternarTermos;
  final ValueChanged<bool> onAlternarLgpd;

  const SecaoTermosLgpdOng({
    super.key,
    required this.aceitouTermos,
    required this.aceitouLgpd,
    required this.onAlternarTermos,
    required this.onAlternarLgpd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        children: [
          // Termos de Uso
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: aceitouTermos,
                  activeColor: const Color(0xFF0C6B6B),
                  onChanged: (val) => onAlternarTermos(val ?? false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF062222),
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: "Declaro que li e concordo com os "),
                      TextSpan(
                        text: "Termos e Condições de Uso",
                        style: const TextStyle(
                          color: Color(0xFF0C6B6B),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => LegalPopups.mostrarTermosOng(context),
                      ),
                      const TextSpan(text: " da plataforma ABC do Bem. *"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // LGPD
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: aceitouLgpd,
                  activeColor: const Color(0xFF0C6B6B),
                  onChanged: (val) => onAlternarLgpd(val ?? false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF062222),
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: "Concordo com a "),
                      TextSpan(
                        text: "Política de Privacidade (LGPD)",
                        style: const TextStyle(
                          color: Color(0xFF0C6B6B),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => LegalPopups.mostrarLGPD(context),
                      ),
                      const TextSpan(
                        text:
                            ", autorizando a exibição pública do perfil da ONG para fins de engajamento social. *",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
