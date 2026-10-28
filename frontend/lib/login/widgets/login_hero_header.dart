// lib/login/widgets/login_hero_header.dart

import 'package:flutter/material.dart';

class LoginHeroHeader extends StatelessWidget {
  final bool isMobile;

  const LoginHeroHeader({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 36 : 48,
        horizontal: isMobile ? 16 : 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.4, 0.8, 1.0],
          colors: [
            Color(0xFF062222),
            Color(0xFF0C5252),
            Color(0xFF1A8F8F),
            Color(0xFF3DCFB0),
          ],
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_abcdobem.png',
            height: isMobile ? 140 : 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.eco_rounded,
              size: isMobile ? 90 : 130,
              color: const Color(0xFF9FE8D8),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            "Bem-vindo ao ABC do Bem",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "Entre na sua conta",
            style: TextStyle(
              color: const Color(0xFF9FE8D8),
              fontSize: isMobile ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
