// lib/voluntarios/perfil/widgets/perfil_header_banner.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/voluntario_profile_models.dart';
import '../editar_perfil_page.dart';

class PerfilHeaderBanner extends StatelessWidget {
  final VoluntarioPerfilModel perfil;
  final File? novaFotoPerfilArquivo;
  final VoidCallback onAlterarFoto;
  final VoidCallback onPerfilAtualizado;
  final bool isMobile;
  final bool isMeuPerfil;
  final VoidCallback? onConectarOuConvidar;
  final String? token;

  const PerfilHeaderBanner({
    super.key,
    required this.perfil,
    this.novaFotoPerfilArquivo,
    required this.onAlterarFoto,
    required this.onPerfilAtualizado,
    required this.isMobile,
    this.isMeuPerfil = true,
    this.onConectarOuConvidar,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isMobile ? 110 : 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF062222),
                  Color(0xFF0C5252),
                  Color(0xFF1A8F8F),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, isMobile ? -40 : -55),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: isMobile ? 75 : 95,
                            height: isMobile ? 75 : 95,
                            child: novaFotoPerfilArquivo != null
                                ? Image.file(
                                    novaFotoPerfilArquivo!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    perfil.fotoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFFD1F5EE),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        size: 40,
                                        color: Color(0xFF0C6B6B),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      if (isMeuPerfil)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: InkWell(
                            onTap: onAlterarFoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0C6B6B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        perfil.nome,
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF062222),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 13,
                            color: Color(0xFF7AAAA0),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              "${perfil.cidade} - ${perfil.estado}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7AAAA0),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isMeuPerfil)
                  ElevatedButton(
                    onPressed: () async {
                      final alterado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarPerfilPage(
                            usuarioId: perfil.id,
                            token: token,
                          ),
                        ),
                      );
                      if (alterado == true) onPerfilAtualizado();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Editar",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: onConectarOuConvidar ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Mensagem enviada para ${perfil.nome}!"),
                              backgroundColor: const Color(0xFF0C6B6B),
                            ),
                          );
                        },
                    icon: const Icon(Icons.send_rounded,
                        size: 14, color: Colors.white),
                    label: const Text(
                      "Conectar",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
