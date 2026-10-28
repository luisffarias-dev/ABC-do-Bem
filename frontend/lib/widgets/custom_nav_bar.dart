// lib/widgets/custom_nav_bar.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class CustomNavBar extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegisterVolunteer;

  const CustomNavBar({
    super.key,
    required this.onLogin,
    required this.onRegisterVolunteer,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: isMobile ? 64 : 70,
          padding:
              EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            border: const Border(bottom: BorderSide(color: Color(0xFFC2E4DC))),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Lado Esquerdo: Botão Drawer (no mobile) + Logo e Título
                  Row(
                    children: [
                      if (isMobile)
                        Builder(
                          builder: (innerContext) => IconButton(
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Color(0xFF0C6B6B),
                              size: 26,
                            ),
                            tooltip: "Abrir menu",
                            onPressed: () =>
                                Scaffold.of(innerContext).openDrawer(),
                          ),
                        ),
                      Image.asset(
                        'assets/images/logo_abcdobem.png',
                        width: isMobile ? 30 : 36,
                        height: isMobile ? 30 : 36,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.eco_rounded,
                          size: isMobile ? 28 : 34,
                          color: const Color(0xFF0C6B6B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "ABC do Bem",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF062222),
                          fontSize: isMobile ? 16 : 18,
                        ),
                      ),
                    ],
                  ),

                  // Lado Direito: Ações de Login e Cadastro
                  Row(
                    children: [
                      TextButton(
                        onPressed: onLogin,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0C6B6B),
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 16),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Entrar"),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0C6B6B), Color(0xFF29B0A0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: onRegisterVolunteer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            child: const Text("Cadastrar-se"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
