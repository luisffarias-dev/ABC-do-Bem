// lib/register/ong/widgets/secao_identidade_visual_ong.dart

import 'package:flutter/material.dart';

class SecaoIdentidadeVisualOng extends StatelessWidget {
  final bool logoAdicionado;
  final VoidCallback onAlternarLogo;

  const SecaoIdentidadeVisualOng({
    super.key,
    required this.logoAdicionado,
    required this.onAlternarLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Identidade Visual",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            SizedBox(width: 4),
            Text(
              "(opcional)",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onAlternarLogo,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: logoAdicionado ? const Color(0xFFE3F5F1) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: logoAdicionado
                    ? const Color(0xFF0C6B6B)
                    : const Color(0xFFC2E4DC),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  logoAdicionado
                      ? Icons.check_circle_rounded
                      : Icons.cloud_upload_outlined,
                  color: const Color(0xFF0C6B6B),
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text(
                  logoAdicionado
                      ? "Logo adicionado com sucesso!"
                      : "Toque para enviar o Logo ou Foto da ONG",
                  style: TextStyle(
                    fontSize: 12,
                    color: logoAdicionado
                        ? const Color(0xFF0C6B6B)
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
