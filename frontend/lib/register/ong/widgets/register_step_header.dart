// lib/register/ong/widgets/register_step_header.dart

import 'package:flutter/material.dart';

class RegisterStepHeader extends StatelessWidget {
  final int stepAtual; // 1, 2 ou 3
  final bool isMobile;
  final VoidCallback onVoltar;

  const RegisterStepHeader({
    super.key,
    required this.stepAtual,
    required this.isMobile,
    required this.onVoltar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 36,
        horizontal: isMobile ? 16 : 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF062222),
            Color(0xFF0C5252),
            Color(0xFF1A8F8F),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: onVoltar,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF9FE8D8),
                    size: 18,
                  ),
                  label: const Text(
                    "Voltar",
                    style: TextStyle(
                      color: Color(0xFF9FE8D8),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                const Text(
                  "CADASTRO ONG",
                  style: TextStyle(
                    color: Color(0xFF9FE8D8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Instituição",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Cadastre sua ONG e encontre voluntários incríveis",
                  style: TextStyle(
                    color: Color(0xFF9FE8D8),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 28),
                Row(
                  children: [
                    _buildStepItem("1", "Dados Gerais", 1),
                    _buildStepDivider(),
                    _buildStepItem("2", "Detalhes", 2),
                    _buildStepDivider(),
                    _buildStepItem("3", "Finalizar", 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String label, int stepIndex) {
    final bool isActive = stepAtual == stepIndex;
    final bool isCompleted = stepAtual > stepIndex;

    return Column(
      children: [
        Container(
          width: isMobile ? 34 : 40,
          height: isMobile ? 34 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Color(0xFF0C6B6B))
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF062222)
                          : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: isMobile ? 10 : 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.white.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      ),
    );
  }
}
