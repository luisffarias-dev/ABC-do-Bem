// lib/register/ong/widgets/secao_contato_redes_ong.dart

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'campo_texto_ong.dart';

class SecaoContatoRedesOng extends StatelessWidget {
  final TextEditingController telefoneCtrl;
  final TextEditingController whatsappCtrl;
  final TextEditingController instagramCtrl;
  final TextEditingController facebookCtrl;
  final TextEditingController tiktokCtrl;

  final FocusNode telefoneFocus;
  final FocusNode whatsappFocus;

  final String? erroTelefone;
  final String? erroWhatsapp;

  final bool mesmoNumeroWhatsapp;
  final ValueChanged<bool> onAlternarMesmoNumero;

  final MaskTextInputFormatter telefoneMask;
  final MaskTextInputFormatter whatsappMask;
  final bool isMobile;

  const SecaoContatoRedesOng({
    super.key,
    required this.telefoneCtrl,
    required this.whatsappCtrl,
    required this.instagramCtrl,
    required this.facebookCtrl,
    required this.tiktokCtrl,
    required this.telefoneFocus,
    required this.whatsappFocus,
    required this.erroTelefone,
    required this.erroWhatsapp,
    required this.mesmoNumeroWhatsapp,
    required this.onAlternarMesmoNumero,
    required this.telefoneMask,
    required this.whatsappMask,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Contato e Redes Sociais",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Telefone Fixo",
            hint: "(00) 0000-0000",
            obrigatorio: true,
            keyboardType: TextInputType.phone,
            controller: telefoneCtrl,
            formatters: [telefoneMask],
            focusNode: telefoneFocus,
            errorText: erroTelefone,
          ),
          const SizedBox(height: 12),
          _buildBlocoWhatsapp(),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTextoOng(
                  label: "Telefone Fixo",
                  hint: "(00) 0000-0000",
                  obrigatorio: true,
                  keyboardType: TextInputType.phone,
                  controller: telefoneCtrl,
                  formatters: [telefoneMask],
                  focusNode: telefoneFocus,
                  errorText: erroTelefone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildBlocoWhatsapp()),
            ],
          ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Instagram",
            hint: "@suaong",
            obrigatorio: false,
            controller: instagramCtrl,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "Facebook",
            hint: "Link ou @",
            obrigatorio: false,
            controller: facebookCtrl,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "TikTok",
            hint: "@suaong",
            obrigatorio: false,
            controller: tiktokCtrl,
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: CampoTextoOng(
                  label: "Instagram",
                  hint: "@suaong",
                  obrigatorio: false,
                  controller: instagramCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoOng(
                  label: "Facebook",
                  hint: "Link ou @",
                  obrigatorio: false,
                  controller: facebookCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoOng(
                  label: "TikTok",
                  hint: "@suaong",
                  obrigatorio: false,
                  controller: tiktokCtrl,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBlocoWhatsapp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoTextoOng(
          label: "WhatsApp",
          hint: "(00) 00000-0000",
          obrigatorio: true,
          keyboardType: TextInputType.phone,
          controller: whatsappCtrl,
          formatters: [whatsappMask],
          focusNode: whatsappFocus,
          errorText: erroWhatsapp,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: mesmoNumeroWhatsapp,
                activeColor: const Color(0xFF0C6B6B),
                onChanged: (val) => onAlternarMesmoNumero(val ?? false),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              "Mesmo número do fixo",
              style: TextStyle(fontSize: 11, color: Color(0xFF3A6868)),
            ),
          ],
        ),
      ],
    );
  }
}
