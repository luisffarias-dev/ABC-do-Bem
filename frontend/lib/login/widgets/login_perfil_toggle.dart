// lib/login/widgets/login_perfil_toggle.dart

import 'package:flutter/material.dart';

class LoginPerfilToggle extends StatelessWidget {
  final bool isVolunteer;
  final ValueChanged<bool> onToggle;

  const LoginPerfilToggle({
    super.key,
    required this.isVolunteer,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F5F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildToggleOption(
            title: "🙋 Voluntário",
            isSelected: isVolunteer,
            onTap: () => onToggle(true),
          ),
          _buildToggleOption(
            title: "🏢 ONG",
            isSelected: !isVolunteer,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF0C6B6B)
                  : const Color(0xFF3A6868),
            ),
          ),
        ),
      ),
    );
  }
}
