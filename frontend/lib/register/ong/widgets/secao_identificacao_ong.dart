// lib/register/ong/widgets/secao_identificacao_ong.dart

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'campo_texto_ong.dart';

class SecaoIdentificacaoOng extends StatelessWidget {
  final TextEditingController razaoSocialCtrl;
  final TextEditingController nomeFantasiaCtrl;
  final TextEditingController cnpjCtrl;
  final TextEditingController anoFundacaoCtrl;
  final TextEditingController siteCtrl;

  final FocusNode razaoSocialFocus;
  final FocusNode nomeFantasiaFocus;
  final FocusNode cnpjFocus;
  final FocusNode anoFocus;
  final FocusNode siteFocus;

  final String? erroRazaoSocial;
  final String? erroNomeFantasia;
  final String? erroCnpj;
  final String? erroAno;
  final String? erroSite;

  final MaskTextInputFormatter cnpjMask;
  final bool isMobile;

  const SecaoIdentificacaoOng({
    super.key,
    required this.razaoSocialCtrl,
    required this.nomeFantasiaCtrl,
    required this.cnpjCtrl,
    required this.anoFundacaoCtrl,
    required this.siteCtrl,
    required this.razaoSocialFocus,
    required this.nomeFantasiaFocus,
    required this.cnpjFocus,
    required this.anoFocus,
    required this.siteFocus,
    required this.erroRazaoSocial,
    required this.erroNomeFantasia,
    required this.erroCnpj,
    required this.erroAno,
    required this.erroSite,
    required this.cnpjMask,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Identificação da ONG",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),
        CampoTextoOng(
          label: "Razão Social (Nome Completo)",
          hint: "Ex: Associação ABC do Bem",
          obrigatorio: true,
          controller: razaoSocialCtrl,
          focusNode: razaoSocialFocus,
          errorText: erroRazaoSocial,
        ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Nome Fantasia",
            hint: "Ex: ABC do Bem",
            obrigatorio: true,
            controller: nomeFantasiaCtrl,
            focusNode: nomeFantasiaFocus,
            errorText: erroNomeFantasia,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "CNPJ",
            hint: "00.000.000/0000-00",
            obrigatorio: true,
            keyboardType: TextInputType.number,
            controller: cnpjCtrl,
            formatters: [cnpjMask],
            focusNode: cnpjFocus,
            errorText: erroCnpj,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CampoTextoOng(
                  label: "Nome Fantasia",
                  hint: "Ex: ABC do Bem",
                  obrigatorio: true,
                  controller: nomeFantasiaCtrl,
                  focusNode: nomeFantasiaFocus,
                  errorText: erroNomeFantasia,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: CampoTextoOng(
                  label: "CNPJ",
                  hint: "00.000.000/0000-00",
                  obrigatorio: true,
                  keyboardType: TextInputType.number,
                  controller: cnpjCtrl,
                  formatters: [cnpjMask],
                  focusNode: cnpjFocus,
                  errorText: erroCnpj,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        if (isMobile) ...[
          CampoTextoOng(
            label: "Ano de Fundação",
            hint: "Ex: 2015",
            obrigatorio: true,
            keyboardType: TextInputType.number,
            controller: anoFundacaoCtrl,
            maxLength: 4,
            focusNode: anoFocus,
            errorText: erroAno,
          ),
          const SizedBox(height: 12),
          CampoTextoOng(
            label: "Site",
            hint: "www.suaong.org.br",
            obrigatorio: false,
            keyboardType: TextInputType.url,
            controller: siteCtrl,
            focusNode: siteFocus,
            errorText: erroSite,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: CampoTextoOng(
                  label: "Ano de Fundação",
                  hint: "Ex: 2015",
                  obrigatorio: true,
                  keyboardType: TextInputType.number,
                  controller: anoFundacaoCtrl,
                  maxLength: 4,
                  focusNode: anoFocus,
                  errorText: erroAno,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: CampoTextoOng(
                  label: "Site",
                  hint: "www.suaong.org.br",
                  obrigatorio: false,
                  keyboardType: TextInputType.url,
                  controller: siteCtrl,
                  focusNode: siteFocus,
                  errorText: erroSite,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
