// lib/widgets/sidebar/widgets/sidebar_header.dart

import 'package:flutter/material.dart';

class SidebarHeader extends StatelessWidget {
  final bool isOng;

  const SidebarHeader({
    super.key,
    required this.isOng,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo_abcdobem.png',
                height: 36,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F5F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Color(0xFF0C6B6B),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "ABC do Bem",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Color(0xFF062222),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isOng ? const Color(0xFF0C6B6B) : const Color(0xFFD1F5EE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isOng ? "PAINEL DA INSTITUIÇÃO" : "ÁREA DO VOLUNTÁRIO",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: isOng ? Colors.white : const Color(0xFF0C6B6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
