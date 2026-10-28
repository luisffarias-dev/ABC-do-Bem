// lib/voluntarios/home/widgets/home_feed_comunidade_section.dart

import 'package:flutter/material.dart';

class HomeFeedComunidadeSection extends StatelessWidget {
  final List<Map<String, dynamic>> postagens;
  final Function(Map<String, dynamic>) onAutorTap;
  final bool isMobile;

  const HomeFeedComunidadeSection({
    super.key,
    required this.postagens,
    required this.onAutorTap,
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
              "Postagens da Comunidade",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            Text(
              "${postagens.length} novas",
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF7AAAA0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: postagens.length,
          itemBuilder: (context, index) {
            final post = postagens[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC2E4DC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => onAutorTap(post),
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage(post["fotoAutor"] as String),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      post["autor"] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF062222),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F5F1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      post["tipoAutor"] as String,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0C6B6B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                post["tempo"] as String,
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post["texto"] as String,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF3A6868), height: 1.3),
                  ),
                  if (post["imagemPost"] != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        post["imagemPost"] as String,
                        width: double.infinity,
                        height: isMobile ? 160 : 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.favorite_rounded,
                          size: 15, color: Colors.red.shade400),
                      const SizedBox(width: 4),
                      Text(
                        "${post["curtidas"]}",
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.mode_comment_outlined,
                          size: 15, color: Color(0xFF7AAAA0)),
                      const SizedBox(width: 4),
                      Text(
                        "${post["comentarios"]}",
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
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
