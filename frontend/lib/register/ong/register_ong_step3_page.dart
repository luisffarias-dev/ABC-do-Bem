// lib/register/ong/register_ong_step3_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../ongs/models/ong_cadastro_dto.dart';
import '../../services/ong_auth_service.dart';
import 'widgets/register_step_header.dart';
import 'widgets/secao_necessidades_ong.dart';
import 'widgets/secao_credenciais_ong.dart';
import 'widgets/secao_termos_lgpd_ong.dart';
import 'widgets/dialog_sucesso_ong.dart';

class RegisterOngStep3Page extends StatefulWidget {
  final Map<String, dynamic> dadosCompletos;

  const RegisterOngStep3Page({super.key, required this.dadosCompletos});

  @override
  State<RegisterOngStep3Page> createState() => _RegisterOngStep3PageState();
}

class _RegisterOngStep3PageState extends State<RegisterOngStep3Page> {
  final OngAuthService _ongAuthService = OngAuthService();

  // Controladores de conta
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _emailFocus = FocusNode();

  String? _erroEmail;
  bool _obscureSenha = true;
  final bool _obscureConfirmarSenha = true;

  // Validações da Senha Forte
  bool _temMinimo = false;
  bool _temMaiuscula = false;
  bool _temMinuscula = false;
  bool _temEspecial = false;
  bool _senhasIguais = false;

  // Consentimentos Legais
  bool _aceitouTermos = false;
  bool _aceitouLgpd = false;
  bool _isCarregando = false;

  // Seleções do Step
  String? _formatoVoluntariado;
  final Set<String> _habilidadesSelecionadas = {};
  final Set<String> _doacoesSelecionadas = {};

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        setState(() {
          _erroEmail = emailRegex.hasMatch(_emailController.text.trim())
              ? null
              : "E-mail inválido.";
        });
      }
    });
  }

  void _atualizarValidacoesSenha(String senha, String confirmacao) {
    setState(() {
      _temMinimo = senha.length >= 8;
      _temMaiuscula = senha.contains(RegExp(r'[A-Z]'));
      _temMinuscula = senha.contains(RegExp(r'[a-z]'));
      _temEspecial = senha.contains(RegExp(r'[\W_]'));
      _senhasIguais = senha.isNotEmpty && (senha == confirmacao);
    });
  }

  void _mostrarAlerta(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline_rounded,
                color: Color(0xFF0C6B6B), size: 40),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF062222)),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFF0C6B6B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processarFinalizacao() async {
    if (_erroEmail != null) {
      _mostrarAlerta("Verifique o campo de E-mail antes de finalizar.");
      return;
    }
    if (_habilidadesSelecionadas.isEmpty) {
      _mostrarAlerta("Selecione pelo menos uma habilidade buscada (*).");
      return;
    }
    if (_formatoVoluntariado == null) {
      _mostrarAlerta(
          "Por favor, selecione o formato de voluntariado aceito (*).");
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _mostrarAlerta("O E-mail institucional é obrigatório (*).");
      return;
    }
    if (!_temMinimo || !_temMaiuscula || !_temMinuscula || !_temEspecial) {
      _mostrarAlerta("A senha não atende aos requisitos de segurança.");
      return;
    }
    if (!_senhasIguais) {
      _mostrarAlerta("A confirmação da senha não coincide.");
      return;
    }
    if (!_aceitouTermos || !_aceitouLgpd) {
      _mostrarAlerta(
          "É obrigatório aceitar os Termos e a Política de Privacidade (*).");
      return;
    }

    setState(() => _isCarregando = true);

    final dto = OngCadastroDTO(
      dadosCompletosEtapasAnteriores: widget.dadosCompletos,
      habilidadesBuscadas: _habilidadesSelecionadas.toList(),
      doacoesAceitas: _doacoesSelecionadas.toList(),
      formatoVoluntariado: _formatoVoluntariado!,
      emailLogin: _emailController.text.trim(),
      senhaLogin: _senhaController.text,
      termosAceitos: _aceitouTermos,
      lgpdAceita: _aceitouLgpd,
    );

    try {
      final resposta = await _ongAuthService.cadastrarOng(dto);
      if (!mounted) return;
      setState(() => _isCarregando = false);
      DialogSucessoOng.exibir(context, resposta.email);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isCarregando = false);
      _mostrarAlerta("Falha ao realizar cadastro. Tente novamente.");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final String causa =
        widget.dadosCompletos['causa_principal'] ?? "Assistência social";

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RegisterStepHeader(
              stepAtual: 3,
              isMobile: isMobile,
              onVoltar: _isCarregando ? () {} : () => Navigator.pop(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 24 : 36,
                horizontal: isMobile ? 16 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Necessidades (Habilidades, Formato, Doações)
                      SecaoNecessidadesOng(
                        causaPrincipal: causa,
                        formatoVoluntariado: _formatoVoluntariado,
                        habilidadesSelecionadas: _habilidadesSelecionadas,
                        doacoesSelecionadas: _doacoesSelecionadas,
                        onFormatoChanged: (f) =>
                            setState(() => _formatoVoluntariado = f),
                        onAlternarHabilidade: (hab, val) {
                          setState(() {
                            val
                                ? _habilidadesSelecionadas.add(hab)
                                : _habilidadesSelecionadas.remove(hab);
                          });
                        },
                        onAlternarDoacao: (item, val) {
                          setState(() {
                            val
                                ? _doacoesSelecionadas.add(item)
                                : _doacoesSelecionadas.remove(item);
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // 2. Credenciais de Acesso (Email e Senha Forte)
                      SecaoCredenciaisOng(
                        emailCtrl: _emailController,
                        senhaCtrl: _senhaController,
                        confirmarSenhaCtrl: _confirmarSenhaController,
                        emailFocus: _emailFocus,
                        erroEmail: _erroEmail,
                        obscureSenha: _obscureSenha,
                        obscureConfirmarSenha: _obscureConfirmarSenha,
                        onToggleObscureSenha: () =>
                            setState(() => _obscureSenha = !_obscureSenha),
                        onToggleObscureConfirmarSenha: () =>
                            setState(() => _obscureSenha = !_obscureSenha),
                        temMinimo: _temMinimo,
                        temMaiuscula: _temMaiuscula,
                        temMinuscula: _temMinuscula,
                        temEspecial: _temEspecial,
                        senhasIguais: _senhasIguais,
                        onSenhaChanged: (s) => _atualizarValidacoesSenha(
                            s, _confirmarSenhaController.text),
                        onConfirmarSenhaChanged: (c) =>
                            _atualizarValidacoesSenha(_senhaController.text, c),
                      ),
                      const SizedBox(height: 24),

                      // 3. Termos e LGPD
                      SecaoTermosLgpdOng(
                        aceitouTermos: _aceitouTermos,
                        aceitouLgpd: _aceitouLgpd,
                        onAlternarTermos: (v) =>
                            setState(() => _aceitouTermos = v),
                        onAlternarLgpd: (v) => setState(() => _aceitouLgpd = v),
                      ),
                      const SizedBox(height: 32),

                      // Botões Voltar / Finalizar
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isCarregando
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(
                                  color: Color(0xFF0C6B6B),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "← Voltar",
                                style: TextStyle(
                                  color: Color(0xFF0C6B6B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed:
                                  _isCarregando ? null : _processarFinalizacao,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C6B6B),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: _isCarregando
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Finalizar Cadastro ✓",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
