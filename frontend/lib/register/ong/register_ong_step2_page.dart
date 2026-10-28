// lib/register/ong/register_ong_step2_page.dart

import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import 'register_ong_step3_page.dart';
import 'widgets/register_step_header.dart';
import 'widgets/secao_identidade_visual_ong.dart';
import 'widgets/secao_atuacao_publico_ong.dart';
import 'widgets/secao_descricao_ong.dart';

class RegisterOngStep2Page extends StatefulWidget {
  final Map<String, dynamic> dadosOng;

  const RegisterOngStep2Page({super.key, required this.dadosOng});

  @override
  State<RegisterOngStep2Page> createState() => _RegisterOngStep2PageState();
}

class _RegisterOngStep2PageState extends State<RegisterOngStep2Page> {
  final TextEditingController _descricaoController = TextEditingController();
  int _tamanhoDescricao = 0;
  bool _logoAdicionado = false;

  String? _causaPrincipalSelecionada;
  final Set<String> _oferecimentosSelecionados = {};
  final Set<String> _publicoSelecionado = {};

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
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

  void _aoProsseguir() {
    if (_causaPrincipalSelecionada == null) {
      _mostrarErro("Por favor, selecione a Causa Principal da ONG (*).");
      return;
    }
    if (_oferecimentosSelecionados.isEmpty) {
      _mostrarErro("Selecione pelo menos um serviço que a ONG oferece (*).");
      return;
    }
    if (_publicoSelecionado.isEmpty) {
      _mostrarErro(
          "Selecione pelo menos um público atendido pela organização (*).");
      return;
    }
    if (_descricaoController.text.trim().length < 200) {
      _mostrarErro(
        "A descrição da ONG está muito curta (*). Escreva no mínimo 200 caracteres.",
      );
      return;
    }

    final dadosOngStep2 = {
      ...widget.dadosOng,
      "logo_adicionado": _logoAdicionado,
      "causa_principal": _causaPrincipalSelecionada,
      "servicos_oferecidos": _oferecimentosSelecionados.toList(),
      "publico_atendido": _publicoSelecionado.toList(),
      "descricao": _descricaoController.text.trim(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterOngStep3Page(
          dadosCompletos: dadosOngStep2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RegisterStepHeader(
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
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Banner informativo
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F5F1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC2E4DC)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: Color(0xFF0C6B6B),
                            ),
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

                      // 1. Identidade Visual
                      SecaoIdentidadeVisualOng(
                        logoAdicionado: _logoAdicionado,
                        onAlternarLogo: () {
                          setState(() => _logoAdicionado = !_logoAdicionado);
                        },
                      ),
                      const SizedBox(height: 24),

                      // 2. Causa, Serviços e Público
                      SecaoAtuacaoPublicoOng(
                        causaSelecionada: _causaPrincipalSelecionada,
                        servicosSelecionados: _oferecimentosSelecionados,
                        publicosSelecionados: _publicoSelecionado,
                        onCausaChanged: (novo) {
                          setState(() {
                            _causaPrincipalSelecionada = novo;
                            _oferecimentosSelecionados.clear();
                            _publicoSelecionado.clear();
                          });
                        },
                        onAlternarServico: (servico, val) {
                          setState(() {
                            if (val) {
                              _oferecimentosSelecionados.add(servico);
                            } else {
                              _oferecimentosSelecionados.remove(servico);
                            }
                          });
                        },
                        onAlternarPublico: (publico, val) {
                          setState(() {
                            if (val) {
                              _publicoSelecionado.add(publico);
                            } else {
                              _publicoSelecionado.remove(publico);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // 3. Descrição
                      SecaoDescricaoOng(
                        descricaoCtrl: _descricaoController,
                        tamanhoDescricao: _tamanhoDescricao,
                        onTamanhoChanged: (t) =>
                            setState(() => _tamanhoDescricao = t),
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
