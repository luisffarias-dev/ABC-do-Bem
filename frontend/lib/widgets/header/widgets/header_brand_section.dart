// lib/widgets/header/widgets/header_brand_section.dart

import 'package:flutter/material.dart';

class HeaderBrandSection extends StatelessWidget {
  final bool showBackButton;
  final bool isDesktop;
  final bool isOng;
  final VoidCallback? onVoltar;

  const HeaderBrandSection({
    super.key,
    required this.showBackButton,
    required this.isDesktop,
    required this.isOng,
    this.onVoltar,
  });

  void _executarVoltar(BuildContext context) {
    if (onVoltar != null) {
      onVoltar!();
    } else if (Navigator.canPop(context)) {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // A seta SÓ aparece se:
    // 1. showBackButton for explicitamente 'true'
    // 2. Não for desktop
    // 3. Houver um callback customizado (onVoltar) OU houver histórico real para desempilhar
    final bool deveMostrarSeta = showBackButton &&
        !isDesktop &&
        (onVoltar != null || Navigator.canPop(context));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (deveMostrarSeta) ...[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF0C6B6B),
              size: 24,
            ),
            tooltip: "Voltar",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _executarVoltar(context),
          ),
          const SizedBox(width: 8),
        ],
        if (!isDesktop) ...[
          Image.asset(
            'assets/images/logo_abcdobem.png',
            height: 32,
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F5F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: Color(0xFF0C6B6B),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "ABC do Bem",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF062222),
              letterSpacing: -0.3,
            ),
          ),
          if (isOng) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0C6B6B),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "ONG",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
