// lib/ongs/home/widgets/ong_candidaturas_section.dart

import 'package:flutter/material.dart';
import '../../../ongs/models/ong_dashboard_models.dart';

class OngCandidaturasSection extends StatelessWidget {
  final List<CandidatoVoluntarioModel> candidaturas;
  final Function(CandidatoVoluntarioModel, bool) onResponder;
  final Function(String) onVerPerfil;

  const OngCandidaturasSection({
    super.key,
    required this.candidaturas,
    required this.onResponder,
    required this.onVerPerfil,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.pending_actions_rounded,
                  color: Color(0xFF0C6B6B),
                  size: 20,
                ),
                SizedBox(width: 6),
                Text(
                  "Aprovações de Voluntários",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF062222),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: candidaturas.isNotEmpty
                    ? const Color(0xFFD1F5EE)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${candidaturas.length} pendentes",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: candidaturas.isNotEmpty
                      ? const Color(0xFF0C6B6B)
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (candidaturas.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: const Center(
              child: Text(
                "Nenhuma candidatura pendente no momento! Tudo em dia. ✨",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: candidaturas.length,
            itemBuilder: (context, index) {
              final c = candidaturas[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => onVerPerfil(c.voluntarioId),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(c.fotoUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      c.nome,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF062222),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    c.dataSolicitacao,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Vaga para: ${c.eventoNome}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0C6B6B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: c.habilidades
                                    .map((hab) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE3F5F1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            hab,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF0C6B6B),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              if (c.caronaOuSuporte != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.directions_car_rounded,
                                      size: 13,
                                      color: Color(0xFFD46B08),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        c.caronaOuSuporte!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFD46B08),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => onVerPerfil(c.voluntarioId),
                          child: const Text(
                            "Ver Perfil",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => onResponder(c, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            "Recusar",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => onResponder(c, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C6B6B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            "Aprovar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
