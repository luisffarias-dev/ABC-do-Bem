import 'package:flutter/material.dart';

class RegistrationHeader extends StatelessWidget {
  final String overlineText; // ex: "CADASTRO" ou "CADASTRO ONG"
  final String title; // ex: "Sou Voluntário" ou "Instituição"
  final String subtitle;
  final int currentStep;
  final List<String>
  stepLabels; // ex: ["Dados pessoais", "Habilidades", "Disponibilidade"]

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
            constraints: const BoxConstraints(maxWidth: 600),
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
                Row(
                  children: [
                    _buildStepItem("1", stepLabels[0], currentStep >= 1),
                    _buildStepDivider(),
                    _buildStepItem("2", stepLabels[1], currentStep >= 2),
                    _buildStepDivider(),
                    _buildStepItem("3", stepLabels[2], currentStep >= 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive
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
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.white.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
    );
  }
}
