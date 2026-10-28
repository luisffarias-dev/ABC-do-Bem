import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LegalAgreementsBox extends StatelessWidget {
  final bool termsAccepted;
  final bool lgpdAccepted;
  final Function(bool?) onTermsChanged;
  final Function(bool?) onLgpdChanged;
  final VoidCallback onShowTerms;
  final VoidCallback onShowLgpd;

  const LegalAgreementsBox({
    super.key,
    required this.termsAccepted,
    required this.lgpdAccepted,
    required this.onTermsChanged,
    required this.onLgpdChanged,
    required this.onShowTerms,
    required this.onShowLgpd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F5F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: termsAccepted,
            onChanged: onTermsChanged,
            title: Row(
              children: [
                const Text(
                  "Li e concordo com os ",
                  style: TextStyle(fontSize: 13, color: Color(0xFF062222)),
                ),
                GestureDetector(
                  onTap: onShowTerms,
                  child: const Text(
                    "Termos de Uso.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            activeColor: const Color(0xFF0C6B6B),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(color: Color(0xFFC2E4DC)),
          CheckboxListTile(
            value: lgpdAccepted,
            onChanged: onLgpdChanged,
            title: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF062222),
                  fontSize: 13,
                  fontFamily: 'Quicksand',
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
                    recognizer: TapGestureRecognizer()..onTap = onShowLgpd,
                  ),
                  const TextSpan(
                    text: ", autorizando o uso dos meus dados na plataforma.",
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
