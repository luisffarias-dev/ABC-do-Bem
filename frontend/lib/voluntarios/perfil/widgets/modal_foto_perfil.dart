// lib/voluntarios/perfil/widgets/modal_foto_perfil.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalFotoPerfil {
  static void exibir(
    BuildContext context, {
    required ImagePicker picker,
    dynamic onImagemArquivo, // Mantido opcional por compatibilidade
    required ValueChanged<String> onImagemUrl,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Alterar Foto de Perfil",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF062222),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOpcao(
                    icon: Icons.photo_library_rounded,
                    label: "Galeria",
                    onTap: () async {
                      Navigator.pop(ctx);
                      try {
                        final XFile? img = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 800,
                          maxHeight: 800,
                          imageQuality: 85,
                        );

                        if (img != null) {
                          // Leitura de bytes segura e compatível com Web, Desktop e Mobile
                          final bytes = await img.readAsBytes();
                          final base64String = base64Encode(bytes);
                          final dataUrl =
                              "data:image/jpeg;base64,$base64String";
                          onImagemUrl(dataUrl);
                        }
                      } catch (e) {
                        debugPrint("Erro ao selecionar imagem da galeria: $e");
                      }
                    },
                  ),
                  _buildOpcao(
                    icon: Icons.camera_alt_rounded,
                    label: "Câmera",
                    onTap: () async {
                      Navigator.pop(ctx);
                      try {
                        final XFile? foto = await picker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 800,
                          maxHeight: 800,
                          imageQuality: 85,
                        );

                        if (foto != null) {
                          final bytes = await foto.readAsBytes();
                          final base64String = base64Encode(bytes);
                          final dataUrl =
                              "data:image/jpeg;base64,$base64String";
                          onImagemUrl(dataUrl);
                        }
                      } catch (e) {
                        debugPrint("Erro ao capturar foto pela câmera: $e");
                      }
                    },
                  ),
                  _buildOpcao(
                    icon: Icons.link_rounded,
                    label: "URL / Link",
                    onTap: () {
                      Navigator.pop(ctx);
                      _abrirDialogUrl(context, onImagemUrl);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOpcao({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0C6B6B), size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062222),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _abrirDialogUrl(
    BuildContext context,
    ValueChanged<String> onImagemUrl,
  ) {
    final TextEditingController urlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Inserir Link da Foto",
          style: TextStyle(
            color: Color(0xFF062222),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(
            hintText: "https://...",
            filled: true,
            fillColor: Color(0xFFF0FAF7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlCtrl.text.trim();
              if (url.isNotEmpty) onImagemUrl(url);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C6B6B),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
