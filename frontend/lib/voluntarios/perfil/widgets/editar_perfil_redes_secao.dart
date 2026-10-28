// lib/voluntarios/perfil/widgets/editar_perfil_redes_secao.dart

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPerfilRedesSecao extends StatelessWidget {
  final TextEditingController instagramController;
  final TextEditingController facebookController;
  final TextEditingController linkedinController;
  final TextEditingController whatsappController;
  final MaskTextInputFormatter telefoneMask;
  final bool isMobile;

  const EditarPerfilRedesSecao({
    super.key,
    required this.instagramController,
    required this.facebookController,
    required this.linkedinController,
    required this.whatsappController,
    required this.telefoneMask,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Redes Sociais e Contato",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          _buildIconField(
            "Instagram (@usuario)",
            instagramController,
            FontAwesomeIcons.instagram,
          ),
          const SizedBox(height: 12),
          _buildIconField(
            "Facebook",
            facebookController,
            FontAwesomeIcons.facebook,
          ),
          const SizedBox(height: 12),
          _buildIconField(
            "LinkedIn",
            linkedinController,
            FontAwesomeIcons.linkedin,
          ),
          const SizedBox(height: 12),
          _buildIconField(
            "WhatsApp / Telefone",
            whatsappController,
            FontAwesomeIcons.whatsapp,
            keyboardType: TextInputType.phone,
            formatters: [telefoneMask],
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildIconField(
                  "Instagram (@usuario)",
                  instagramController,
                  FontAwesomeIcons.instagram,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildIconField(
                  "Facebook",
                  facebookController,
                  FontAwesomeIcons.facebook,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildIconField(
                  "LinkedIn",
                  linkedinController,
                  FontAwesomeIcons.linkedin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildIconField(
                  "WhatsApp / Telefone",
                  whatsappController,
                  FontAwesomeIcons.whatsapp,
                  keyboardType: TextInputType.phone,
                  formatters: [telefoneMask],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildIconField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    List<dynamic>? formatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters?.cast(),
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FaIcon(icon, color: const Color(0xFF0C6B6B), size: 18),
        ),
        filled: true,
        fillColor: const Color(0xFFF0FAF7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
        ),
      ),
    );
  }
}
