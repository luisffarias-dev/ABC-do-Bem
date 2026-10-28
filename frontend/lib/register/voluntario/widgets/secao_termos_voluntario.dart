// lib/register/voluntario/widgets/secao_termos_voluntario.dart

import 'package:flutter/material.dart';

class SecaoTermosVoluntario extends StatelessWidget {
  final bool aceiteTermos;
  final bool aceiteLgpd;
  final bool enviando;
  final ValueChanged<bool> onAlternarTermos;
  final ValueChanged<bool> onAlternarLgpd;
  final VoidCallback onVerTermos;
  final bool isMobile;

  const SecaoTermosVoluntario({
    super.key,
    required this.aceiteTermos,
    required this.aceiteLgpd,
    required this.enviando,
    required this.onAlternarTermos,
    required this.onAlternarLgpd,
    required this.onVerTermos,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F5F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: aceiteTermos,
            onChanged:
                enviando ? null : (val) => onAlternarTermos(val ?? false),
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  "Li e concordo com os ",
                  style: TextStyle(fontSize: 12, color: Color(0xFF062222)),
                ),
                GestureDetector(
                  onTap: onVerTermos,
                  child: const Text(
                    "Termos de Uso.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0C6B6B),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  " *",
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            activeColor: const Color(0xFF0C6B6B),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(color: Color(0xFFC2E4DC), height: 1),
          CheckboxListTile(
            value: aceiteLgpd,
            onChanged: enviando ? null : (val) => onAlternarLgpd(val ?? false),
            title: RichText(
              text: const TextSpan(
                text:
                    "Autorizo o tratamento dos meus dados pessoais em conformidade com a LGPD para conexão com ONGs.",
                style: TextStyle(fontSize: 12, color: Color(0xFF062222)),
                children: [
                  TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            activeColor: const Color(0xFF0C6B6B),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
