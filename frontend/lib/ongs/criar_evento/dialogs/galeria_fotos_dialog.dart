// lib/ongs/criar_evento/dialogs/galeria_fotos_dialog.dart

import 'package:flutter/material.dart';

class GaleriaFotosDialog extends StatelessWidget {
  final ValueChanged<String> onSelecionarFoto;

  const GaleriaFotosDialog({super.key, required this.onSelecionarFoto});

  static const List<String> fotos = [
    "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800",
    "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800",
    "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800",
    "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800",
    "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800",
    "https://images.unsplash.com/photo-1526976668912-1a811878dd37?w=800",
  ];

  static Future<void> exibir(
    BuildContext context, {
    required ValueChanged<String> onSelecionar,
  }) {
    return showDialog(
      context: context,
      builder: (_) => GaleriaFotosDialog(onSelecionarFoto: onSelecionar),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Fotos Pré-Salvas",
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF062222),
        ),
      ),
      content: SizedBox(
        width: 460,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: fotos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (_, index) {
            final url = fotos[index];
            return InkWell(
              onTap: () {
                onSelecionarFoto(url);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(url, fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
