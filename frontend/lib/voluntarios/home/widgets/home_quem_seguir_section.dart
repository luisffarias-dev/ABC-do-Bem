// lib/voluntarios/home/widgets/home_quem_seguir_section.dart

import 'package:flutter/material.dart';

class HomeQuemSeguirSection extends StatelessWidget {
  final List<Map<String, dynamic>> perfis;
  final Function(Map<String, dynamic>) onPerfilTap;
  final Function(int) onToggleSeguir;
  final VoidCallback onVerOngs;

  const HomeQuemSeguirSection({
    super.key,
    required this.perfis,
    required this.onPerfilTap,
    required this.onToggleSeguir,
    required this.onVerOngs,
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
              "Quem Seguir no ABC",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            TextButton(
              onPressed: onVerOngs,
              child: const Text(
                "Ver ONGs",
                style: TextStyle(
                  color: Color(0xFF0C6B6B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: perfis.length,
            itemBuilder: (context, index) {
              final item = perfis[index];
              final bool seguindo = item["seguindo"] as bool;

              return InkWell(
                onTap: () => onPerfilTap(item),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 145,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFC2E4DC)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                NetworkImage(item["foto"] as String),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: item["tipo"] == "ONG"
                                  ? const Color(0xFF0C6B6B)
                                  : const Color(0xFF1A528F),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item["tipo"] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["nome"] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062222),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item["subtitulo"] as String,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 26,
                        child: ElevatedButton(
                          onPressed: () => onToggleSeguir(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: seguindo
                                ? Colors.grey.shade200
                                : const Color(0xFF0C6B6B),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            seguindo ? "Seguindo" : "Seguir",
                            style: TextStyle(
                              color: seguindo
                                  ? Colors.grey.shade700
                                  : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
