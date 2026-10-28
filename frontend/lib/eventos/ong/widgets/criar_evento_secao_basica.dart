// lib/eventos/ong/widgets/criar_evento_secao_basica.dart

import 'package:flutter/material.dart';
import '../../../../utils/app_validators.dart';

class CriarEventoSecaoBasica extends StatelessWidget {
  final TextEditingController tituloCtrl;
  final TextEditingController imagemUrlCtrl;
  final String categoriaSelecionada;
  final List<String> categoriasDisponiveis;
  final ValueChanged<String?> onCategoriaChanged;

  const CriarEventoSecaoBasica({
    super.key,
    required this.tituloCtrl,
    required this.imagemUrlCtrl,
    required this.categoriaSelecionada,
    required this.categoriasDisponiveis,
    required this.onCategoriaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informações Principais",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: tituloCtrl,
            decoration: _inputDecoration(
              label: "Título da Ação",
              hint: "Ex: Mutirão de Plantio na Horta Comunitária",
              icon: Icons.title_rounded,
            ),
            validator: (v) {
              final obrigatorio = AppValidators.validarObrigatorio(v,
                  mensagem: "Informe o título da ação.");
              if (obrigatorio != null) return obrigatorio;
              if (v!.trim().length < 5)
                return "Informe um título com no mínimo 5 caracteres.";
              return null;
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: categoriaSelecionada,
            decoration: _inputDecoration(
              label: "Categoria da Ação",
              hint: "Selecione uma área de atuação",
              icon: Icons.category_rounded,
            ),
            items: categoriasDisponiveis.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: onCategoriaChanged,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: imagemUrlCtrl,
            decoration: _inputDecoration(
              label: "URL da Imagem de Capa (Banner)",
              hint: "https://exemplo.com/imagem.jpg",
              icon: Icons.image_outlined,
            ),
            validator: (v) => AppValidators.validarObrigatorio(
              v,
              mensagem: "Informe o link de uma imagem ilustrativa.",
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0C6B6B), size: 20),
      filled: true,
      fillColor: const Color(0xFFF0FAF7),
      labelStyle: const TextStyle(color: Color(0xFF3A6868), fontSize: 13),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
      ),
    );
  }
}
