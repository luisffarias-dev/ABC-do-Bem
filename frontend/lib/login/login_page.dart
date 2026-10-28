// lib/login/login_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../widgets/landing_page_sections.dart';
import '../voluntarios/home/voluntario_home_page.dart';
import '../ongs/home/ong_home_page.dart';

import 'services/login_service.dart';
import 'models/login_dto.dart';
import '../services/session_service.dart';
import 'widgets/login_hero_header.dart';
import 'widgets/login_perfil_toggle.dart';
import 'widgets/login_form.dart';
import 'widgets/login_demo_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService _loginService = LoginService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool isVolunteer = true;
  bool obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _mostrarAlerta(String mensagem, {bool erro = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, textAlign: TextAlign.center),
        backgroundColor: erro ? Colors.redAccent : const Color(0xFF0C6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Extrai o ID ('sub') do payload do token JWT retornado pelo backend
  String? _extrairIdDoJwt(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      final partes = token.split('.');
      if (partes.length != 3) return null;

      // Normaliza o base64 para decodificação
      String payloadB64 = partes[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payloadB64.length % 4 != 0) {
        payloadB64 += '=';
      }

      final payloadString = utf8.decode(base64Url.decode(payloadB64));
      final Map<String, dynamic> payloadMap = jsonDecode(payloadString);

      return payloadMap['sub']?.toString() ?? payloadMap['id']?.toString();
    } catch (_) {
      return null;
    }
  }

  void _navegarParaHome({
    required bool comoVoluntario,
    required String id,
    String? nome,
    String? token,
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => comoVoluntario
            ? VoluntarioHomePage(
                voluntarioId: id,
                nomeUsuario: nome,
                token: token,
              )
            : OngHomePage(ongId: id),
        transitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarAlerta("Por favor, preencha o e-mail e a senha.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dto = LoginDto(
        email: email,
        password: senha,
      );

      final resposta = await _loginService.autenticar(dto);

      if (!mounted) return;
      setState(() => _isLoading = false);

      // 1. Extrai o ID do 'sub' do JWT; se não encontrar, usa resposta.usuarioId
      final String? idJwt = _extrairIdDoJwt(resposta.accessToken);
      final String idAutenticado = idJwt ??
          resposta.usuarioId ??
          (isVolunteer ? 'bc7cab2e-1351-4384-b2f4-3a1343e75058' : 'ong-1');

      debugPrint("Nome recebido no login: ${resposta.name}");
      debugPrint("Token recebido no login: ${resposta.accessToken}");
      debugPrint("ID autenticado resolvido: $idAutenticado");

      // 2. Salva os dados na sessão global com o UUID real do banco
      SessionService.instance.salvarSessao(
        novoToken: resposta.accessToken,
        novoUsuarioId: idAutenticado,
        novoNome: resposta.name,
      );

      // 3. Roteia para a home correspondente
      _navegarParaHome(
        comoVoluntario: isVolunteer,
        id: idAutenticado,
        nome: resposta.name,
        token: resposta.accessToken,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _mostrarAlerta(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0FAF7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              LoginHeroHeader(isMobile: isMobile),
              SizedBox(height: isMobile ? 28 : 48),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginPerfilToggle(
                          isVolunteer: isVolunteer,
                          onToggle: (val) => setState(() => isVolunteer = val),
                        ),
                        const SizedBox(height: 24),
                        LoginForm(
                          emailController: _emailController,
                          senhaController: _senhaController,
                          isVolunteer: isVolunteer,
                          obscurePassword: obscurePassword,
                          isLoading: _isLoading,
                          onToggleObscure: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                          onSubmit: _fazerLogin,
                          onEsqueciSenha: () {},
                        ),
                        const SizedBox(height: 36),
                        LoginDemoBox(
                          isMobile: isMobile,
                          onEntrarVoluntarioDemo: () => _navegarParaHome(
                            comoVoluntario: true,
                            id: "voluntario-1",
                          ),
                          onEntrarOngDemo: () => _navegarParaHome(
                            comoVoluntario: false,
                            id: "ong-1",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 48 : 80),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
