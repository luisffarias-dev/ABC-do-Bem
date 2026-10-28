// lib/ongs/perfil/widgets/ong_perfil_feed_section.dart

import 'package:flutter/material.dart';
import '../../models/ong_detail_models.dart';

class OngPerfilFeedSection extends StatelessWidget {
  final List<OngPostagemModel> publicacoes;
  final String ongNome;
  final String logoUrl;
  final bool isMobile;

  const OngPerfilFeedSection({
    super.key,
    required this.publicacoes,
    required this.ongNome,
    required this.logoUrl,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Ações e Relatos Recentes",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (publicacoes.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: const Center(
              child: Text(
                "Nenhuma publicação cadastrada por enquanto.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: publicacoes.length,
            itemBuilder: (ctx, idx) {
              final post = publicacoes[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC2E4DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(logoUrl),
                          radius: 16,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ongNome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              post.dataFormatada,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF062222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.texto,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3A6868),
                        height: 1.35,
                      ),
                    ),
                    if (post.imagemUrl != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          post.imagemUrl!,
                          width: double.infinity,
                          height: isMobile ? 180 : 260,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
