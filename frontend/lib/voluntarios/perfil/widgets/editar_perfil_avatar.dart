// lib/voluntarios/perfil/widgets/editar_perfil_avatar.dart

import 'dart:io';
import 'package:flutter/material.dart';

class EditarPerfilAvatar extends StatelessWidget {
  final String fotoAtualUrl;
  final File? novaFotoArquivo;
  final VoidCallback onTrocarFoto;
  final bool isMobile;

  const EditarPerfilAvatar({
    super.key,
    required this.fotoAtualUrl,
    required this.novaFotoArquivo,
    required this.onTrocarFoto,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0C6B6B),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: isMobile ? 48 : 56,
                  backgroundColor: const Color(0xFFE3F5F1),
                  backgroundImage: novaFotoArquivo != null
                      ? FileImage(novaFotoArquivo!) as ImageProvider
                      : NetworkImage(fotoAtualUrl),
                ),
              ),
              InkWell(
                onTap: onTrocarFoto,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C6B6B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: onTrocarFoto,
            child: const Text(
              "Alterar foto",
              style: TextStyle(
                color: Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
