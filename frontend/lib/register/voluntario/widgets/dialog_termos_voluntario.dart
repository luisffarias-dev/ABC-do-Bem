// lib/register/voluntario/widgets/dialog_termos_voluntario.dart

import 'package:flutter/material.dart';

class DialogTermosVoluntario extends StatelessWidget {
  const DialogTermosVoluntario({super.key});

  static void exibir(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const DialogTermosVoluntario(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Termos e Condições - ABC do Bem",
        style: TextStyle(
          color: Color(0xFF0C6B6B),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: const SingleChildScrollView(
        child: Text(
          "1. Natureza do Serviço\n"
          "O ABC do Bem é uma plataforma facilitadora que conecta voluntários a Organizações Não Governamentais (ONGs). O cadastro e a atuação não geram qualquer vínculo empregatício, trabalhista ou previdenciário com a plataforma ou com as instituições.\n\n"
          "2. Idade Mínima e Autorização\n"
          "O cadastro na plataforma é permitido para pessoas a partir de 12 anos de idade. No entanto, voluntários menores de 18 anos precisarão obrigatoriamente da autorização e consentimento expresso de um dos pais ou responsável legal para confirmar presença e participar das ações e eventos divulgados.\n\n"
          "3. Conduta e Ambiente Seguro\n"
          "O ABC do Bem preza por um ambiente acolhedor. Não será tolerada nenhuma forma de discriminação, assédio, preconceito ou comportamento inadequado. Violações a esta regra resultarão no banimento imediato da plataforma.\n\n"
          "4. Privacidade e LGPD\n"
          "Em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018), seus dados pessoais serão armazenados com segurança e utilizados exclusivamente para conectá-lo às ONGs. Você pode solicitar a exclusão da sua conta a qualquer momento.\n\n"
          "5. Responsabilidades e Direitos de Imagem\n"
          "A plataforma atua apenas como intermediadora. O alinhamento de expectativas, regras de segurança e eventuais autorizações de uso de imagem devem ser acordados diretamente entre o voluntário (ou seus responsáveis) e a ONG organizadora.\n\n"
          "6. Veracidade das Informações\n"
          "O usuário declara que todas as informações prestadas são verdadeiras, sob pena de exclusão da plataforma.",
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF062222),
            height: 1.45,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Fechar",
            style: TextStyle(
              color: Color(0xFF0C6B6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
