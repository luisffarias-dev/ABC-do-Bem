// lib/register/voluntario/register_step1_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../utils/responsive.dart';
import '../../utils/app_validators.dart';
import 'register_step2_page.dart';
import 'widgets/register_voluntario_step_header.dart';
import 'widgets/secao_dados_pessoais_voluntario.dart';
import 'widgets/secao_endereco_voluntario.dart';

class RegisterStep1Page extends StatefulWidget {
  const RegisterStep1Page({super.key});

  @override
  State<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  // Controladores
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmarEmailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  // FocusNodes
  final _nomeFocus = FocusNode();
  final _sobrenomeFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _dataNascFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _confirmarEmailFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _ruaFocus = FocusNode();
  final _numeroFocus = FocusNode();
  final _bairroFocus = FocusNode();
  final _cidadeFocus = FocusNode();
  final _estadoFocus = FocusNode();

  // Estados
  String? _generoSelecionado;
  bool _isLoadingCep = false;

  // Erros
  String? _erroNome;
  String? _erroSobrenome;
  String? _erroCpf;
  String? _erroDataNasc;
  String? _erroTelefone;
  String? _erroEmail;
  String? _erroConfirmarEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;
  String? _erroCep;
  String? _erroRua;
  String? _erroNumero;
  String? _erroBairro;
  String? _erroCidade;
  String? _erroEstado;

  // Máscaras
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _dataNascMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _configurarOuvintes();
  }

  void _configurarOuvintes() {
    _nomeFocus.addListener(() {
      if (!_nomeFocus.hasFocus) {
        setState(() => _erroNome = AppValidators.validarObrigatorio(
              _nomeController.text,
              mensagem: "Nome obrigatório",
            ));
      }
    });

    _sobrenomeFocus.addListener(() {
      if (!_sobrenomeFocus.hasFocus) {
        setState(() => _erroSobrenome = AppValidators.validarObrigatorio(
              _sobrenomeController.text,
              mensagem: "Sobrenome obrigatório",
            ));
      }
    });

    _cpfFocus.addListener(() {
      if (!_cpfFocus.hasFocus) {
        setState(
            () => _erroCpf = AppValidators.validarCpf(_cpfController.text));
      }
    });

    _dataNascFocus.addListener(() {
      if (!_dataNascFocus.hasFocus) {
        setState(() => _erroDataNasc =
            AppValidators.validarDataNascimento(_dataNascController.text));
      }
    });

    _telefoneFocus.addListener(() {
      if (!_telefoneFocus.hasFocus) {
        setState(() => _erroTelefone =
            AppValidators.validarWhatsapp(_telefoneController.text));
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        setState(() =>
            _erroEmail = AppValidators.validarEmail(_emailController.text));
      }
    });

    _confirmarEmailFocus.addListener(() {
      if (!_confirmarEmailFocus.hasFocus) {
        setState(
            () => _erroConfirmarEmail = AppValidators.validarConfirmacaoEmail(
                  _emailController.text,
                  _confirmarEmailController.text,
                ));
      }
    });

    _senhaFocus.addListener(() {
      if (!_senhaFocus.hasFocus) {
        setState(() => _erroSenha = _validarSenha(_senhaController.text));
      }
    });

    _confirmarSenhaFocus.addListener(() {
      if (!_confirmarSenhaFocus.hasFocus) {
        setState(() => _erroConfirmarSenha = _validarConfirmacaoSenha(
              _senhaController.text,
              _confirmarSenhaController.text,
            ));
      }
    });

    _cepFocus.addListener(() {
      if (!_cepFocus.hasFocus) {
        setState(
            () => _erroCep = AppValidators.validarCep(_cepController.text));
      }
    });
  }

  String? _validarSenha(String valor) {
    if (valor.trim().isEmpty) return "Senha obrigatória";
    if (valor.length < 8) return "A senha deve ter no mínimo 8 caracteres";
    return null;
  }

  String? _validarConfirmacaoSenha(String senha, String confirmacao) {
    if (confirmacao.trim().isEmpty) return "Confirmação de senha obrigatória";
    if (senha != confirmacao) return "As senhas não coincidem";
    return null;
  }

  Future<void> _buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return;

    setState(() => _isLoadingCep = true);
    try {
      final res =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'));
      if (res.statusCode == 200) {
        final dados = json.decode(res.body);
        if (dados['erro'] == true) {
          _mostrarSnackBar("CEP não encontrado.");
          return;
        }
        setState(() {
          _ruaController.text = dados['logradouro'] ?? '';
          _bairroController.text = dados['bairro'] ?? '';
          _cidadeController.text = dados['localidade'] ?? '';
          _estadoController.text = dados['uf'] ?? '';
          _erroRua = null;
          _erroBairro = null;
          _erroCidade = null;
          _erroEstado = null;
        });
      }
    } catch (_) {
      _mostrarSnackBar("Erro ao consultar CEP.");
    } finally {
      if (mounted) setState(() => _isLoadingCep = false);
    }
  }

  void _mostrarSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _aoProsseguir() {
    final erroNome = AppValidators.validarObrigatorio(_nomeController.text,
        mensagem: "Nome obrigatório");
    final erroSobrenome = AppValidators.validarObrigatorio(
        _sobrenomeController.text,
        mensagem: "Sobrenome obrigatório");
    final erroCpf = AppValidators.validarCpf(_cpfController.text);
    final erroDataNasc =
        AppValidators.validarDataNascimento(_dataNascController.text);
    final erroTelefone =
        AppValidators.validarWhatsapp(_telefoneController.text);
    final erroEmail = AppValidators.validarEmail(_emailController.text);
    final erroConfirmarEmail = AppValidators.validarConfirmacaoEmail(
      _emailController.text,
      _confirmarEmailController.text,
    );
    final erroSenha = _validarSenha(_senhaController.text);
    final erroConfirmarSenha = _validarConfirmacaoSenha(
      _senhaController.text,
      _confirmarSenhaController.text,
    );
    final erroCep = AppValidators.validarCep(_cepController.text);
    final erroRua = AppValidators.validarObrigatorio(_ruaController.text,
        mensagem: "Rua obrigatória");
    final erroNumero = AppValidators.validarObrigatorio(_numeroController.text,
        mensagem: "Número obrigatório");
    final erroBairro = AppValidators.validarObrigatorio(_bairroController.text,
        mensagem: "Bairro obrigatório");
    final erroCidade = AppValidators.validarObrigatorio(_cidadeController.text,
        mensagem: "Cidade obrigatória");
    final erroEstado = AppValidators.validarObrigatorio(_estadoController.text,
        mensagem: "Estado obrigatório");

    setState(() {
      _erroNome = erroNome;
      _erroSobrenome = erroSobrenome;
      _erroCpf = erroCpf;
      _erroDataNasc = erroDataNasc;
      _erroTelefone = erroTelefone;
      _erroEmail = erroEmail;
      _erroConfirmarEmail = erroConfirmarEmail;
      _erroSenha = erroSenha;
      _erroConfirmarSenha = erroConfirmarSenha;
      _erroCep = erroCep;
      _erroRua = erroRua;
      _erroNumero = erroNumero;
      _erroBairro = erroBairro;
      _erroCidade = erroCidade;
      _erroEstado = erroEstado;
    });

    final temErros = [
      erroNome,
      erroSobrenome,
      erroCpf,
      erroDataNasc,
      erroTelefone,
      erroEmail,
      erroConfirmarEmail,
      erroSenha,
      erroConfirmarSenha,
      erroCep,
      erroRua,
      erroNumero,
      erroBairro,
      erroCidade,
      erroEstado,
    ].any((e) => e != null);

    if (temErros || _generoSelecionado == null) {
      _mostrarSnackBar("Preencha todos os campos corretamente.");
      return;
    }

    final dadosBasicos = {
      "nome": _nomeController.text.trim(),
      "sobrenome": _sobrenomeController.text.trim(),
      "cpf": _cpfController.text.trim(),
      "data_nascimento": _dataNascController.text.trim(),
      "genero": _generoSelecionado!,
      "telefone": _telefoneController.text.trim(),
      "email": _emailController.text.trim().toLowerCase(),
      "senha": _senhaController.text,
      "cep": _cepController.text.trim(),
      "rua": _ruaController.text.trim(),
      "numero": _numeroController.text.trim(),
      "bairro": _bairroController.text.trim(),
      "cidade": _cidadeController.text.trim(),
      "estado": _estadoController.text.trim(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterStep2Page(dadosBasicos: dadosBasicos),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    _dataNascController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _confirmarEmailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();

    _nomeFocus.dispose();
    _sobrenomeFocus.dispose();
    _cpfFocus.dispose();
    _dataNascFocus.dispose();
    _telefoneFocus.dispose();
    _emailFocus.dispose();
    _confirmarEmailFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    _cepFocus.dispose();
    _ruaFocus.dispose();
    _numeroFocus.dispose();
    _bairroFocus.dispose();
    _cidadeFocus.dispose();
    _estadoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RegisterVoluntarioStepHeader(
              stepAtual: 1,
              isMobile: isMobile,
              onVoltar: () => Navigator.pop(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 24 : 36,
                horizontal: isMobile ? 16 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F5F1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC2E4DC)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16, color: Color(0xFF0C6B6B)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Os campos marcados com asterisco (*) são obrigatórios.",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0C6B6B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Dados Pessoais & Contato
                      SecaoDadosPessoaisVoluntario(
                        nomeCtrl: _nomeController,
                        sobrenomeCtrl: _sobrenomeController,
                        cpfCtrl: _cpfController,
                        dataNascCtrl: _dataNascController,
                        telefoneCtrl: _telefoneController,
                        emailCtrl: _emailController,
                        confirmarEmailCtrl: _confirmarEmailController,
                        senhaCtrl: _senhaController,
                        confirmarSenhaCtrl: _confirmarSenhaController,
                        generoSelecionado: _generoSelecionado,
                        nomeFocus: _nomeFocus,
                        sobrenomeFocus: _sobrenomeFocus,
                        cpfFocus: _cpfFocus,
                        dataNascFocus: _dataNascFocus,
                        telefoneFocus: _telefoneFocus,
                        emailFocus: _emailFocus,
                        confirmarEmailFocus: _confirmarEmailFocus,
                        senhaFocus: _senhaFocus,
                        confirmarSenhaFocus: _confirmarSenhaFocus,
                        erroNome: _erroNome,
                        erroSobrenome: _erroSobrenome,
                        erroCpf: _erroCpf,
                        erroDataNasc: _erroDataNasc,
                        erroTelefone: _erroTelefone,
                        erroEmail: _erroEmail,
                        erroConfirmarEmail: _erroConfirmarEmail,
                        erroSenha: _erroSenha,
                        erroConfirmarSenha: _erroConfirmarSenha,
                        cpfMask: _cpfMask,
                        dataNascMask: _dataNascMask,
                        telefoneMask: _telefoneMask,
                        onGeneroChanged: (g) =>
                            setState(() => _generoSelecionado = g),
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 24),

                      // 2. Endereço
                      SecaoEnderecoVoluntario(
                        cepCtrl: _cepController,
                        ruaCtrl: _ruaController,
                        numeroCtrl: _numeroController,
                        bairroCtrl: _bairroController,
                        cidadeCtrl: _cidadeController,
                        estadoCtrl: _estadoController,
                        cepFocus: _cepFocus,
                        ruaFocus: _ruaFocus,
                        numeroFocus: _numeroFocus,
                        bairroFocus: _bairroFocus,
                        cidadeFocus: _cidadeFocus,
                        estadoFocus: _estadoFocus,
                        erroCep: _erroCep,
                        erroRua: _erroRua,
                        erroNumero: _erroNumero,
                        erroBairro: _erroBairro,
                        erroCidade: _erroCidade,
                        erroEstado: _erroEstado,
                        isLoadingCep: _isLoadingCep,
                        onCepChanged: (v) {
                          if (v.length >= 9) _buscarCep(v);
                        },
                        cepMask: _cepMask,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 32),

                      // Botão Avançar
                      ElevatedButton(
                        onPressed: _aoProsseguir,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C6B6B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Continuar →",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
