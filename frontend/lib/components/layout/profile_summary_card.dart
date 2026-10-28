import 'package:flutter/material.dart';

class ProfileSummaryCard extends StatelessWidget {
  final String name;
  final String location;
  final List<String> skills;
  final String skillsTitle; // "Habilidades" ou "O que oferecemos"

  const ProfileSummaryCard({
    super.key,
    required this.name,
    required this.location,
    required this.skills,
    this.skillsTitle = "Habilidades",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumo do perfil",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: const TextStyle(fontSize: 14, color: Color(0xFF3A6868)),
          ),
          const SizedBox(height: 16),
          if (skills.isEmpty)
            const Text(
              "Nenhum item selecionado.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F5F1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC2E4DC)),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Color(0xFF0C6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
