// lib/voluntarios/perfil/widgets/perfil_feed_experiencias.dart

import 'package:flutter/material.dart';
import '../../models/voluntario_profile_models.dart';

class PerfilFeedExperiencias extends StatelessWidget {
  final List<ExperienciaFeedModel> experiencias;
  final String fotoUsuario;
  final String nomeUsuario;
  final VoidCallback onPublicarNova;
  final bool isMobile;
  final bool isMeuPerfil;

  const PerfilFeedExperiencias({
    super.key,
    required this.experiencias,
    required this.fotoUsuario,
    required this.nomeUsuario,
    required this.onPublicarNova,
    required this.isMobile,
    this.isMeuPerfil = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMeuPerfil
                  ? "Minhas Experiências no ABC"
                  : "Experiências no ABC",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
            if (isMeuPerfil)
              ElevatedButton.icon(
                onPressed: onPublicarNova,
                icon: const Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "Publicar",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (experiencias.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC2E4DC)),
            ),
            child: Center(
              child: Text(
                isMeuPerfil
                    ? "Nenhuma experiência publicada ainda. Compartilhe suas fotos e relatos!"
                    : "Este voluntário ainda não compartilhou relatos públicos.",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiencias.length,
            itemBuilder: (ctx, idx) {
              final exp = experiencias[idx];
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
                        ClipOval(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Image.network(
                              fotoUsuario,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFD1F5EE),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 18,
                                  color: Color(0xFF0C6B6B),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nomeUsuario,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "${exp.ongNome} • ${exp.dataFormatada}",
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
                      exp.texto,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3A6868),
                        height: 1.3,
                      ),
                    ),
                    if (exp.imagemUrl != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          exp.imagemUrl!,
                          width: double.infinity,
                          height: isMobile ? 180 : 260,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
