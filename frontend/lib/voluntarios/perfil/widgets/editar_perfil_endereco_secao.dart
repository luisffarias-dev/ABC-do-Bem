// lib/voluntarios/perfil/widgets/editar_perfil_endereco_secao.dart

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPerfilEnderecoSecao extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController ruaController;
  final TextEditingController numeroController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;
  final MaskTextInputFormatter cepMask;
  final bool isLoadingCep;
  final ValueChanged<String> onCepChanged;
  final bool isMobile;

  const EditarPerfilEnderecoSecao({
    super.key,
    required this.cepController,
    required this.ruaController,
    required this.numeroController,
    required this.bairroController,
    required this.cidadeController,
    required this.estadoController,
    required this.cepMask,
    required this.isLoadingCep,
    required this.onCepChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Endereço Residencial",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildInput(
                "CEP",
                cepController,
                keyboardType: TextInputType.number,
                formatters: [cepMask],
                onChanged: onCepChanged,
              ),
            ),
            if (isLoadingCep)
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0C6B6B),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (isMobile) ...[
          _buildInput("Rua / Logradouro", ruaController),
          const SizedBox(height: 14),
          _buildInput("Número", numeroController),
        ] else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildInput("Rua / Logradouro", ruaController),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 1,
                child: _buildInput("Número", numeroController),
              ),
            ],
          ),
        const SizedBox(height: 14),
        _buildInput("Bairro", bairroController),
        const SizedBox(height: 14),
        if (isMobile) ...[
          _buildInput("Cidade", cidadeController),
          const SizedBox(height: 14),
          _buildInput("Estado (UF)", estadoController),
        ] else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildInput("Cidade", cidadeController),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 1,
                child: _buildInput("Estado (UF)", estadoController),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    List<dynamic>? formatters,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: formatters?.cast(),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
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
              borderSide:
                  const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
