// lib/ongs/painel_geral/widgets/painel_header.dart

import 'package:flutter/material.dart';

class PainelHeader extends StatelessWidget {
  final bool isMobile;

  const PainelHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final badgeAdmin = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0C6B6B),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: Colors.white,
            size: isMobile ? 12 : 14,
          ),
          const SizedBox(width: 4),
          Text(
            isMobile ? "Admin" : "Administrador",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 10 : 11,
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Painel Geral da ONG",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
              ),
              badgeAdmin,
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Centro operacional, metas e gestão de voluntariado",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Painel Geral da ONG",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Centro operacional, metas e gestão de voluntariado no Grande ABC",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        badgeAdmin,
      ],
    );
  }
}
