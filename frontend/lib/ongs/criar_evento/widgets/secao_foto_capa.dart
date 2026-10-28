// lib/ongs/criar_evento/widgets/secao_foto_capa.dart

import 'package:flutter/material.dart';
import '../dialogs/galeria_fotos_dialog.dart';

class SecaoFotoCapa extends StatelessWidget {
  final TextEditingController bannerUrlCtrl;
  final VoidCallback onFotoAlterada;

  const SecaoFotoCapa({
    super.key,
    required this.bannerUrlCtrl,
    required this.onFotoAlterada,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.image_rounded, size: 18, color: Color(0xFF0C6B6B)),
              SizedBox(width: 6),
              Text(
                "6. Foto de Capa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              bannerUrlCtrl.text.trim(),
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                color: const Color(0xFFC7EBE3),
                child: const Center(
                  child: Text(
                    "Nenhuma imagem selecionada",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Seletor de arquivos acionado."),
                        backgroundColor: Color(0xFF0C6B6B),
                      ),
                    );
                  },
                  icon: const Icon(Icons.file_upload_outlined,
                      size: 16, color: Color(0xFF0C6B6B)),
                  label: const Text(
                    "Fazer Upload",
                    style: TextStyle(
                      color: Color(0xFF0C6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF0C6B6B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    GaleriaFotosDialog.exibir(
                      context,
                      onSelecionar: (url) {
                        bannerUrlCtrl.text = url;
                        onFotoAlterada();
                      },
                    );
                  },
                  icon: const Icon(Icons.photo_library_outlined,
                      size: 16, color: Color(0xFF0C6B6B)),
                  label: const Text(
                    "Fotos Salvas",
                    style: TextStyle(
                      color: Color(0xFF0C6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF0C6B6B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
