// lib/ongs/perfil/widgets/ong_perfil_oportunidades_section.dart

import 'package:flutter/material.dart';
import '../../models/ong_detail_models.dart';

class OngPerfilOportunidadesSection extends StatelessWidget {
  final List<OngOportunidadeModel> oportunidades;
  final Function(OngOportunidadeModel) onVerEvento;
  final bool isMobile;

  const OngPerfilOportunidadesSection({
    super.key,
    required this.oportunidades,
    required this.onVerEvento,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Oportunidades e Eventos Abertos",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            Text(
              "${oportunidades.length} ativas",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7AAAA0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (oportunidades.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: const Center(
              child: Text(
                "Nenhum evento com vagas abertas no momento. Fique atento a novas publicações!",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: oportunidades.length,
            itemBuilder: (ctx, idx) {
              final op = oportunidades[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        op.imagemUrl,
                        width: isMobile ? 55 : 70,
                        height: isMobile ? 55 : 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            op.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF062222),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "📅 ${op.data} • ⏱️ ${op.horario}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${op.vagasRestantes} vagas restantes",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0C6B6B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onVerEvento(op),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C6B6B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Ver",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
