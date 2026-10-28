// lib/register/voluntario/register_step2_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../utils/app_data.dart';
import 'register_step3_page.dart';
import 'widgets/register_voluntario_step_header.dart';
import 'widgets/secao_habilidades_voluntario.dart';

class RegisterStep2Page extends StatefulWidget {
  final Map<String, String> dadosBasicos;

  const RegisterStep2Page({
    super.key,
    required this.dadosBasicos,
  });

  @override
  State<RegisterStep2Page> createState() => _RegisterStep2PageState();
}

class _RegisterStep2PageState extends State<RegisterStep2Page> {
  final Set<String> _habilidadesSelecionadas = {};

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _aoProsseguir() {
    if (_habilidadesSelecionadas.length < AppData.minHabilidades) {
      _mostrarErro(
        "Por favor, selecione ao menos ${AppData.minHabilidades} características para continuar.",
      );
      return;
    }

    if (_habilidadesSelecionadas.length > AppData.maxHabilidades) {
      _mostrarErro(
        "Por favor, reduza para no máximo ${AppData.maxHabilidades} características antes de prosseguir.",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterStep3Page(
          dadosBasicos: Map<String, String>.from(widget.dadosBasicos),
          habilidadesSelecionadas: _habilidadesSelecionadas.toList(),
        ),
      ),
    );
  }

  void _alternarHabilidade(String habilidade, bool selecionada) {
    if (selecionada) {
      if (_habilidadesSelecionadas.length >= AppData.maxHabilidades) {
        _mostrarErro(
          "Você atingiu o limite de ${AppData.maxHabilidades} características para manter a precisão do seu perfil.",
        );
        return;
      }
      setState(() => _habilidadesSelecionadas.add(habilidade));
    } else {
      setState(() => _habilidadesSelecionadas.remove(habilidade));
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
              stepAtual: 2,
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
                      // Subcomponente de Habilidades
                      SecaoHabilidadesVoluntario(
                        habilidadesSelecionadas: _habilidadesSelecionadas,
                        onAlternarHabilidade: _alternarHabilidade,
                      ),
                      const SizedBox(height: 32),

                      // Botões Voltar / Continuar
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
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
                              onPressed: _aoProsseguir,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C6B6B),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
