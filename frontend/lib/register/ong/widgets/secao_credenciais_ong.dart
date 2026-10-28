// lib/register/ong/widgets/secao_credenciais_ong.dart

import 'package:flutter/material.dart';
import 'campo_texto_ong.dart';

class SecaoCredenciaisOng extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController senhaCtrl;
  final TextEditingController confirmarSenhaCtrl;
  final FocusNode emailFocus;
  final String? erroEmail;
  final bool obscureSenha;
  final bool obscureConfirmarSenha;
  final VoidCallback onToggleObscureSenha;
  final VoidCallback onToggleObscureConfirmarSenha;

  final bool temMinimo;
  final bool temMaiuscula;
  final bool temMinuscula;
  final bool temEspecial;
  final bool senhasIguais;
  final ValueChanged<String> onSenhaChanged;
  final ValueChanged<String> onConfirmarSenhaChanged;

  const SecaoCredenciaisOng({
    super.key,
    required this.emailCtrl,
    required this.senhaCtrl,
    required this.confirmarSenhaCtrl,
    required this.emailFocus,
    required this.erroEmail,
    required this.obscureSenha,
    required this.obscureConfirmarSenha,
    required this.onToggleObscureSenha,
    required this.onToggleObscureConfirmarSenha,
    required this.temMinimo,
    required this.temMaiuscula,
    required this.temMinuscula,
    required this.temEspecial,
    required this.senhasIguais,
    required this.onSenhaChanged,
    required this.onConfirmarSenhaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: Color(0xFFC2E4DC)),
        const SizedBox(height: 16),
        const Text(
          "Criar Conta de Acesso",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Este será o login para a ONG acessar a plataforma.",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 14),

        // E-mail Institucional
        CampoTextoOng(
          label: "E-mail Institucional",
          hint: "ong@email.com",
          obrigatorio: true,
          keyboardType: TextInputType.emailAddress,
          controller: emailCtrl,
          focusNode: emailFocus,
          errorText: erroEmail,
        ),
        const SizedBox(height: 14),

        // Senha
        _buildPasswordField(
          label: "Senha",
          hint: "Crie uma senha forte",
          controller: senhaCtrl,
          obscure: obscureSenha,
          onToggle: onToggleObscureSenha,
          onChanged: onSenhaChanged,
        ),
        const SizedBox(height: 8),

        // Checklist de Senha
        _buildItemChecklist("Mínimo de 8 caracteres", temMinimo),
        _buildItemChecklist("Pelo menos 1 letra maiúscula", temMaiuscula),
        _buildItemChecklist("Pelo menos 1 letra minúscula", temMinuscula),
        _buildItemChecklist(
            "Pelo menos 1 caractere especial (@, #, !, etc)", temEspecial),
        const SizedBox(height: 14),

        // Confirmar Senha
        _buildPasswordField(
          label: "Confirmar Senha",
          hint: "Digite a senha novamente",
          controller: confirmarSenhaCtrl,
          obscure: obscureConfirmarSenha,
          onToggle: onToggleObscureConfirmarSenha,
          onChanged: onConfirmarSenhaChanged,
        ),
        const SizedBox(height: 8),
        _buildItemChecklist("As senhas coincidem", senhasIguais),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF3A6868),
                size: 18,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemChecklist(String texto, bool atendido) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(
            atendido
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: atendido ? const Color(0xFF0C6B6B) : Colors.grey.shade400,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              color: atendido ? const Color(0xFF0C6B6B) : Colors.grey.shade600,
              fontWeight: atendido ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
