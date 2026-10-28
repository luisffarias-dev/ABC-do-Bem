// lib/login/widgets/login_demo_box.dart

import 'package:flutter/material.dart';

class LoginDemoBox extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onEntrarVoluntarioDemo;
  final VoidCallback onEntrarOngDemo;

  const LoginDemoBox({
    super.key,
    required this.isMobile,
    required this.onEntrarVoluntarioDemo,
    required this.onEntrarOngDemo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2E4DC),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACESSO RÁPIDO (DEMO)",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDemoButton(
                  icone: "🙋",
                  texto: "Entrar como Voluntário",
                  corFundo: const Color(0xFFD1F5EE),
                  corTexto: const Color(0xFF0C6B6B),
                  onTap: onEntrarVoluntarioDemo,
                ),
                const SizedBox(height: 10),
                _buildDemoButton(
                  icone: "🏢",
                  texto: "Entrar como ONG",
                  corFundo: const Color(0xFF0C6B6B),
                  corTexto: Colors.white,
                  onTap: onEntrarOngDemo,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildDemoButton(
                    icone: "🙋",
                    texto: "Entrar como\nVoluntário",
                    corFundo: const Color(0xFFD1F5EE),
                    corTexto: const Color(0xFF0C6B6B),
                    onTap: onEntrarVoluntarioDemo,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDemoButton(
                    icone: "🏢",
                    texto: "Entrar como\nONG",
                    corFundo: const Color(0xFF0C6B6B),
                    corTexto: Colors.white,
                    onTap: onEntrarOngDemo,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDemoButton({
    required String icone,
    required String texto,
    required Color corFundo,
    required Color corTexto,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Text(icone, style: const TextStyle(fontSize: 14)),
      label: Text(
        texto,
        style: TextStyle(
          color: corTexto,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: corFundo,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}
