// lib/register/ong/widgets/secao_endereco_ong.dart

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'campo_texto_ong.dart';

class SecaoEnderecoOng extends StatelessWidget {
  final TextEditingController cepCtrl;
  final TextEditingController ruaCtrl;
  final TextEditingController numeroCtrl;
  final TextEditingController bairroCtrl;
  final TextEditingController cidadeCtrl;
  final TextEditingController estadoCtrl;

  final FocusNode cepFocus;
  final FocusNode ruaFocus;
  final FocusNode numeroFocus;
  final FocusNode bairroFocus;
  final FocusNode cidadeFocus;
  final FocusNode estadoFocus;

  final String? erroCep;
  final String? erroRua;
  final String? erroNumero;
  final String? erroBairro;
  final String? erroCidade;
  final String? erroEstado;

  final bool isLoadingCep;
  final ValueChanged<String> onCepChanged;
  final MaskTextInputFormatter cepMask;
  final bool isMobile;

  const SecaoEnderecoOng({
    super.key,
    required this.cepCtrl,
    required this.ruaCtrl,
    required this.numeroCtrl,
    required this.bairroCtrl,
    required this.cidadeCtrl,
    required this.estadoCtrl,
    required this.cepFocus,
    required this.ruaFocus,
    required this.numeroFocus,
    required this.bairroFocus,
    required this.cidadeFocus,
    required this.estadoFocus,
    required this.erroCep,
    required this.erroRua,
    required this.erroNumero,
    required this.erroBairro,
    required this.erroCidade,
    required this.erroEstado,
    required this.isLoadingCep,
    required this.onCepChanged,
    required this.cepMask,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Endereço Físico",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CampoTextoOng(
                label: "CEP",
                hint: "00000-000",
                obrigatorio: true,
                keyboardType: TextInputType.number,
                controller: cepCtrl,
                formatters: [cepMask],
                focusNode: cepFocus,
                errorText: erroCep,
                onChanged: onCepChanged,
              ),
            ),
            if (isLoadingCep)
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 12),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0C6B6B),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Rua / Logradouro",
            hint: "Preenchido via CEP",
            obrigatorio: true,
            controller: ruaCtrl,
            focusNode: ruaFocus,
            errorText: erroRua,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "Número",
            hint: "Ex: 123",
            obrigatorio: true,
            controller: numeroCtrl,
            focusNode: numeroFocus,
            errorText: erroNumero,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: CampoTextoOng(
                  label: "Rua / Logradouro",
                  hint: "Preenchido via CEP",
                  obrigatorio: true,
                  controller: ruaCtrl,
                  focusNode: ruaFocus,
                  errorText: erroRua,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: CampoTextoOng(
                  label: "Número",
                  hint: "Ex: 123",
                  obrigatorio: true,
                  controller: numeroCtrl,
                  focusNode: numeroFocus,
                  errorText: erroNumero,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        CampoTextoOng(
          label: "Bairro",
          hint: "Preenchido via CEP",
          obrigatorio: true,
          controller: bairroCtrl,
          focusNode: bairroFocus,
          errorText: erroBairro,
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Cidade",
            hint: "Preenchido via CEP",
            obrigatorio: true,
            controller: cidadeCtrl,
            focusNode: cidadeFocus,
            errorText: erroCidade,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "Estado",
            hint: "UF",
            obrigatorio: true,
            controller: estadoCtrl,
            focusNode: estadoFocus,
            errorText: erroEstado,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: CampoTextoOng(
                  label: "Cidade",
                  hint: "Preenchido via CEP",
                  obrigatorio: true,
                  controller: cidadeCtrl,
                  focusNode: cidadeFocus,
                  errorText: erroCidade,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: CampoTextoOng(
                  label: "Estado",
                  hint: "UF",
                  obrigatorio: true,
                  controller: estadoCtrl,
                  focusNode: estadoFocus,
                  errorText: erroEstado,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
