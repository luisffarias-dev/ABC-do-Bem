// lib/register/voluntario/register_step3_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../models/voluntario_cadastro_dto.dart';
import '../../services/auth_service.dart';
import 'widgets/register_voluntario_step_header.dart';
import 'widgets/secao_disponibilidade_voluntario.dart';
import 'widgets/secao_resumo_perfil_voluntario.dart';
import 'widgets/secao_termos_voluntario.dart';
import 'widgets/dialog_termos_voluntario.dart';
import 'widgets/dialog_sucesso_voluntario.dart';

class RegisterStep3Page extends StatefulWidget {
  final Map<String, String> dadosBasicos;
  final List<String> habilidadesSelecionadas;

  const RegisterStep3Page({
    super.key,
    required this.dadosBasicos,
    required this.habilidadesSelecionadas,
  });

  @override
  State<RegisterStep3Page> createState() => _RegisterStep3PageState();
}

class _RegisterStep3PageState extends State<RegisterStep3Page> {
  final AuthService _authService = AuthService();
  final Set<String> _disponibilidadeSelecionada = {};
  bool _aceiteTermos = false;
  bool _aceiteLgpd = false;
  bool _enviando = false;

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _concluirCadastro() async {
    if (_disponibilidadeSelecionada.isEmpty) {
      _mostrarErro(
        "Por favor, selecione ao menos uma opção de disponibilidade (*).",
      );
      return;
    }

    setState(() => _enviando = true);

    final dto = VoluntarioCadastroDTO.deEtapas(
      dadosBasicos: Map<String, String>.from(widget.dadosBasicos),
      habilidades: widget.habilidadesSelecionadas,
      disponibilidade: _disponibilidadeSelecionada.toList(),
      termosAceitos: _aceiteTermos,
      lgpdAceita: _aceiteLgpd,
    );

    try {
      final resposta = await _authService.cadastrarVoluntario(dto);
      if (!mounted) return;
      setState(() => _enviando = false);
      DialogSucessoVoluntario.exibir(
        context,
        mensagem: resposta.mensagem,
        voluntarioId: resposta.voluntarioId,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _enviando = false);
      _mostrarErro("Falha ao salvar seu perfil. Tente novamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RegisterVoluntarioStepHeader(
              stepAtual: 3,
              isMobile: isMobile,
              onVoltar: _enviando ? () {} : () => Navigator.pop(context),
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
                      // 1. Disponibilidade
                      SecaoDisponibilidadeVoluntario(
                        disponibilidadeSelecionada: _disponibilidadeSelecionada,
                        enviando: _enviando,
                        onAlternarDisponibilidade: (opcao, val) {
                          setState(() {
                            val
                                ? _disponibilidadeSelecionada.add(opcao)
                                : _disponibilidadeSelecionada.remove(opcao);
                          });
                        },
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 20),

                      // 2. Resumo do Perfil (Com E-mail, Celular e Endereço)
                      SecaoResumoPerfilVoluntario(
                        dadosBasicos: widget.dadosBasicos,
                        habilidadesSelecionadas: widget.habilidadesSelecionadas,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 20),

                      // 3. Termos e LGPD
                      SecaoTermosVoluntario(
                        aceiteTermos: _aceiteTermos,
                        aceiteLgpd: _aceiteLgpd,
                        enviando: _enviando,
                        onAlternarTermos: (val) =>
                            setState(() => _aceiteTermos = val),
                        onAlternarLgpd: (val) =>
                            setState(() => _aceiteLgpd = val),
                        onVerTermos: () =>
                            DialogTermosVoluntario.exibir(context),
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 32),

                      // Botões Voltar / Criar Perfil
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _enviando
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
                                  (_aceiteTermos && _aceiteLgpd && !_enviando)
                                      ? _concluirCadastro
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C6B6B),
                                disabledBackgroundColor: Colors.grey.shade300,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: _enviando
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Criar Perfil ✓",
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
