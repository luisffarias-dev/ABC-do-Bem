import 'package:flutter/material.dart';

class RegistrationHeader extends StatelessWidget {
  final String overlineText; // "CADASTRO" ou "CADASTRO ONG"
  final String title; // "Sou Voluntário" ou "Instituição"
  final String subtitle;
  final int currentStep; // 1, 2 ou 3
  final List<String>
  stepLabels; // Ex: ["Dados Gerais", "Detalhes", "Finalizar"]

  const RegistrationHeader({
    super.key,
    required this.overlineText,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF062222), Color(0xFF0C5252), Color(0xFF1A8F8F)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF9FE8D8),
                    size: 20,
                  ),
                  label: const Text(
                    "Voltar",
                    style: TextStyle(
                      color: Color(0xFF9FE8D8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 24),
                Text(
                  overlineText,
                  style: const TextStyle(
                    color: Color(0xFF9FE8D8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9FE8D8),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),

                // Indicador de Passos Inteligente
                Row(
                  children: [
                    _buildStepItem(
                      currentStep > 1 ? "✓" : "1",
                      stepLabels[0],
                      currentStep >= 1,
                      isCompleted: currentStep > 1,
                    ),
                    _buildStepDivider(currentStep > 1),
                    _buildStepItem(
                      currentStep > 2 ? "✓" : "2",
                      stepLabels[1],
                      currentStep >= 2,
                      isCompleted: currentStep > 2,
                    ),
                    _buildStepDivider(currentStep > 2),
                    _buildStepItem(
                      "3",
                      stepLabels[2],
                      currentStep >= 3,
                      isCompleted: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(
    String number,
    String label,
    bool isActive, {
    bool isCompleted = false,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive || isCompleted
                    ? const Color(0xFF062222)
                    : Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withOpacity(0.7),
            fontWeight: isActive || isCompleted
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isPassed) {
    return Expanded(
      child: Container(
        height: 2,
        color: isPassed ? Colors.white : Colors.white.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
    );
  }
}
