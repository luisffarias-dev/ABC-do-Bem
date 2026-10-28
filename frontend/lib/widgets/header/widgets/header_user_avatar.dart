// lib/widgets/header/widgets/header_user_avatar.dart

import 'package:flutter/material.dart';

class HeaderUserAvatar extends StatelessWidget {
  final String nomeExibicao;
  final String fotoExibicao;
  final bool isDesktop;
  final bool isOng;
  final VoidCallback onTap;

  const HeaderUserAvatar({
    super.key,
    required this.nomeExibicao,
    required this.fotoExibicao,
    required this.isDesktop,
    required this.isOng,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isOng ? const Color(0xFF29B0A0) : const Color(0xFFC2E4DC),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(fotoExibicao),
                radius: 17,
                backgroundColor: const Color(0xFFE3F5F1),
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeExibicao,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF062222),
                      fontSize: 13,
                      fontFamily: 'Quicksand',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isOng ? "Instituição • Painel" : "Voluntário",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF7AAAA0),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
