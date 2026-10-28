// lib/voluntarios/buscar/widgets/busca_resultado_card.dart

import 'package:flutter/material.dart';
import '../models/resultado_busca_model.dart';

class BuscaResultadoCard extends StatelessWidget {
  final ResultadoBuscaItem item;
  final VoidCallback onTap;

  const BuscaResultadoCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color tagBgColor;
    Color tagTextColor;
    IconData badgeIcon;

    switch (item.tipo) {
      case TipoResultadoBusca.ong:
        tagBgColor = const Color(0xFFD1F5EE);
        tagTextColor = const Color(0xFF0C6B6B);
        badgeIcon = Icons.domain_rounded;
        break;
      case TipoResultadoBusca.evento:
        tagBgColor = const Color(0xFFFFF7E6);
        tagTextColor = const Color(0xFFD46B08);
        badgeIcon = Icons.event_rounded;
        break;
      case TipoResultadoBusca.voluntario:
        tagBgColor = const Color(0xFFE3EDF5);
        tagTextColor = const Color(0xFF1A528F);
        badgeIcon = Icons.person_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imagemUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: const Color(0xFFE3F5F1),
                    child: Icon(badgeIcon, color: const Color(0xFF0C6B6B)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.tituloPrincipal,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF062222),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(badgeIcon, size: 10, color: tagTextColor),
                              const SizedBox(width: 3),
                              Text(
                                item.tagOuCategoria,
                                style: TextStyle(
                                  color: tagTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitulo,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
