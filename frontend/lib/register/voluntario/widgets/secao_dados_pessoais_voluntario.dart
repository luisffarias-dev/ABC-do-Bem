// lib/register/voluntario/widgets/secao_dados_pessoais_voluntario.dart

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'campo_texto_voluntario.dart';

class SecaoDadosPessoaisVoluntario extends StatefulWidget {
  final TextEditingController nomeCtrl;
  final TextEditingController sobrenomeCtrl;
  final TextEditingController cpfCtrl;
  final TextEditingController dataNascCtrl;
  final TextEditingController telefoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController confirmarEmailCtrl;
  final TextEditingController senhaCtrl;
  final TextEditingController confirmarSenhaCtrl;
  final String? generoSelecionado;

  final FocusNode nomeFocus;
  final FocusNode sobrenomeFocus;
  final FocusNode cpfFocus;
  final FocusNode dataNascFocus;
  final FocusNode telefoneFocus;
  final FocusNode emailFocus;
  final FocusNode confirmarEmailFocus;
  final FocusNode senhaFocus;
  final FocusNode confirmarSenhaFocus;

  final String? erroNome;
  final String? erroSobrenome;
  final String? erroCpf;
  final String? erroDataNasc;
  final String? erroTelefone;
  final String? erroEmail;
  final String? erroConfirmarEmail;
  final String? erroSenha;
  final String? erroConfirmarSenha;

  final MaskTextInputFormatter cpfMask;
  final MaskTextInputFormatter dataNascMask;
  final MaskTextInputFormatter telefoneMask;
  final ValueChanged<String?> onGeneroChanged;
  final bool isMobile;

  const SecaoDadosPessoaisVoluntario({
    super.key,
    required this.nomeCtrl,
    required this.sobrenomeCtrl,
    required this.cpfCtrl,
    required this.dataNascCtrl,
    required this.telefoneCtrl,
    required this.emailCtrl,
    required this.confirmarEmailCtrl,
    required this.senhaCtrl,
    required this.confirmarSenhaCtrl,
    required this.generoSelecionado,
    required this.nomeFocus,
    required this.sobrenomeFocus,
    required this.cpfFocus,
    required this.dataNascFocus,
    required this.telefoneFocus,
    required this.emailFocus,
    required this.confirmarEmailFocus,
    required this.senhaFocus,
    required this.confirmarSenhaFocus,
    required this.erroNome,
    required this.erroSobrenome,
    required this.erroCpf,
    required this.erroDataNasc,
    required this.erroTelefone,
    required this.erroEmail,
    required this.erroConfirmarEmail,
    required this.erroSenha,
    required this.erroConfirmarSenha,
    required this.cpfMask,
    required this.dataNascMask,
    required this.telefoneMask,
    required this.onGeneroChanged,
    required this.isMobile,
  });

  @override
  State<SecaoDadosPessoaisVoluntario> createState() =>
      _SecaoDadosPessoaisVoluntarioState();
}

class _SecaoDadosPessoaisVoluntarioState
    extends State<SecaoDadosPessoaisVoluntario> {
  bool _ocultarSenha = true;
  bool _ocultarConfirmarSenha = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Dados Pessoais & Contato",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 12),

        // 1. Nome e Sobrenome
        if (widget.isMobile) ...[
          CampoTextoVoluntario(
            label: "Nome",
            hint: "Ex: Maria",
            obrigatorio: true,
            controller: widget.nomeCtrl,
            focusNode: widget.nomeFocus,
            errorText: widget.erroNome,
          ),
          const SizedBox(height: 12),
          CampoTextoVoluntario(
            label: "Sobrenome",
            hint: "Ex: Silva",
            obrigatorio: true,
            controller: widget.sobrenomeCtrl,
            focusNode: widget.sobrenomeFocus,
            errorText: widget.erroSobrenome,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Nome",
                  hint: "Ex: Maria",
                  obrigatorio: true,
                  controller: widget.nomeCtrl,
                  focusNode: widget.nomeFocus,
                  errorText: widget.erroNome,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Sobrenome",
                  hint: "Ex: Silva",
                  obrigatorio: true,
                  controller: widget.sobrenomeCtrl,
                  focusNode: widget.sobrenomeFocus,
                  errorText: widget.erroSobrenome,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),

        // 2. CPF e Data de Nascimento
        if (widget.isMobile) ...[
          CampoTextoVoluntario(
            label: "CPF",
            hint: "000.000.000-00",
            obrigatorio: true,
            keyboardType: TextInputType.number,
            controller: widget.cpfCtrl,
            formatters: [widget.cpfMask],
            focusNode: widget.cpfFocus,
            errorText: widget.erroCpf,
          ),
          const SizedBox(height: 12),
          CampoTextoVoluntario(
            label: "Data de Nascimento",
            hint: "DD/MM/AAAA",
            obrigatorio: true,
            keyboardType: TextInputType.number,
            controller: widget.dataNascCtrl,
            formatters: [widget.dataNascMask],
            focusNode: widget.dataNascFocus,
            errorText: widget.erroDataNasc,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTextoVoluntario(
                  label: "CPF",
                  hint: "000.000.000-00",
                  obrigatorio: true,
                  keyboardType: TextInputType.number,
                  controller: widget.cpfCtrl,
                  formatters: [widget.cpfMask],
                  focusNode: widget.cpfFocus,
                  errorText: widget.erroCpf,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Data de Nascimento",
                  hint: "DD/MM/AAAA",
                  obrigatorio: true,
                  keyboardType: TextInputType.number,
                  controller: widget.dataNascCtrl,
                  formatters: [widget.dataNascMask],
                  focusNode: widget.dataNascFocus,
                  errorText: widget.erroDataNasc,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),

        // 3. Gênero e Celular / WhatsApp
        if (widget.isMobile) ...[
          _buildDropdownGenero(),
          const SizedBox(height: 12),
          CampoTextoVoluntario(
            label: "Celular / WhatsApp",
            hint: "(00) 00000-0000",
            obrigatorio: true,
            keyboardType: TextInputType.phone,
            controller: widget.telefoneCtrl,
            formatters: [widget.telefoneMask],
            focusNode: widget.telefoneFocus,
            errorText: widget.erroTelefone,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDropdownGenero()),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Celular / WhatsApp",
                  hint: "(00) 00000-0000",
                  obrigatorio: true,
                  keyboardType: TextInputType.phone,
                  controller: widget.telefoneCtrl,
                  formatters: [widget.telefoneMask],
                  focusNode: widget.telefoneFocus,
                  errorText: widget.erroTelefone,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),

        // 4. E-mail e Confirmação de E-mail
        if (widget.isMobile) ...[
          CampoTextoVoluntario(
            label: "E-mail",
            hint: "exemplo@email.com",
            obrigatorio: true,
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailCtrl,
            focusNode: widget.emailFocus,
            errorText: widget.erroEmail,
          ),
          const SizedBox(height: 12),
          CampoTextoVoluntario(
            label: "Confirmar E-mail",
            hint: "Repita o seu e-mail",
            obrigatorio: true,
            keyboardType: TextInputType.emailAddress,
            controller: widget.confirmarEmailCtrl,
            focusNode: widget.confirmarEmailFocus,
            errorText: widget.erroConfirmarEmail,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTextoVoluntario(
                  label: "E-mail",
                  hint: "exemplo@email.com",
                  obrigatorio: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.emailCtrl,
                  focusNode: widget.emailFocus,
                  errorText: widget.erroEmail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Confirmar E-mail",
                  hint: "Repita o seu e-mail",
                  obrigatorio: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.confirmarEmailCtrl,
                  focusNode: widget.confirmarEmailFocus,
                  errorText: widget.erroConfirmarEmail,
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),

        // 5. Senha e Confirmação de Senha
        if (widget.isMobile) ...[
          CampoTextoVoluntario(
            label: "Senha",
            hint: "No mínimo 8 caracteres",
            obrigatorio: true,
            obscureText: _ocultarSenha,
            controller: widget.senhaCtrl,
            focusNode: widget.senhaFocus,
            errorText: widget.erroSenha,
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color(0xFF0C6B6B),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _ocultarSenha = !_ocultarSenha;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          CampoTextoVoluntario(
            label: "Confirmar Senha",
            hint: "Repita a sua senha",
            obrigatorio: true,
            obscureText: _ocultarConfirmarSenha,
            controller: widget.confirmarSenhaCtrl,
            focusNode: widget.confirmarSenhaFocus,
            errorText: widget.erroConfirmarSenha,
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color(0xFF0C6B6B),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _ocultarConfirmarSenha
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 18,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _ocultarConfirmarSenha = !_ocultarConfirmarSenha;
                });
              },
            ),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Senha",
                  hint: "No mínimo 8 caracteres",
                  obrigatorio: true,
                  obscureText: _ocultarSenha,
                  controller: widget.senhaCtrl,
                  focusNode: widget.senhaFocus,
                  errorText: widget.erroSenha,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: Color(0xFF0C6B6B),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarSenha = !_ocultarSenha;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CampoTextoVoluntario(
                  label: "Confirmar Senha",
                  hint: "Repita a sua senha",
                  obrigatorio: true,
                  obscureText: _ocultarConfirmarSenha,
                  controller: widget.confirmarSenhaCtrl,
                  focusNode: widget.confirmarSenhaFocus,
                  errorText: widget.erroConfirmarSenha,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: Color(0xFF0C6B6B),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarConfirmarSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarConfirmarSenha = !_ocultarConfirmarSenha;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDropdownGenero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: "Gênero",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
            children: [
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC2E4DC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(
                "Selecione o gênero",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              value: widget.generoSelecionado,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0C6B6B)),
              items: const [
                DropdownMenuItem(
                  value: "Feminino",
                  child: Text("Feminino", style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: "Masculino",
                  child: Text("Masculino", style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: "Não-binário",
                  child: Text("Não-binário", style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: "Prefiro não informar",
                  child: Text("Prefiro não informar",
                      style: TextStyle(fontSize: 12)),
                ),
              ],
              onChanged: widget.onGeneroChanged,
            ),
          ),
        ),
      ],
    );
  }
}
