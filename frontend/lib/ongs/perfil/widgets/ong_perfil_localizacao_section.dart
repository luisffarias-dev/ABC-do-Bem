// lib/ongs/perfil/widgets/ong_perfil_localizacao_section.dart

import 'package:flutter/material.dart';

class OngPerfilLocalizacaoSection extends StatelessWidget {
  final String enderecoCompleto;
  final String cidade;
  final bool isMobile;

  const OngPerfilLocalizacaoSection({
    super.key,
    required this.enderecoCompleto,
    required this.cidade,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sede e Localização",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: Color(0xFF0C6B6B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  enderecoCompleto,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF062222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: isMobile ? 140 : 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFC7EBE3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF9FE8D8)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map_rounded,
                    size: 36,
                    color: Color(0xFF0C5252),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Ponto de Atendimento em $cidade",
                    style: const TextStyle(
                      color: Color(0xFF062222),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
