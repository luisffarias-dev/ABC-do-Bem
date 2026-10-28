// lib/ongs/gestao_eventos/editar_evento_page.dart

import 'package:flutter/material.dart';
import '../../../eventos/models/evento_model.dart';
import '../../../utils/responsive.dart';
import '../../../utils/app_data.dart';
import '../../widgets/header/app_header.dart';
import '../../widgets/sidebar/app_sidebar.dart';
import '../../widgets/bottom_nav/app_bottom_nav.dart';
import '../widgets/formulario_evento_campos.dart';

class EditarEventoPage extends StatefulWidget {
  final EventoModel evento;

  const EditarEventoPage({super.key, required this.evento});

  @override
  State<EditarEventoPage> createState() => _EditarEventoPageState();
}

class _EditarEventoPageState extends State<EditarEventoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _vagasCtrl;
  late TextEditingController _bannerUrlCtrl;
  late TextEditingController _cepCtrl;
  late TextEditingController _logradouroCtrl;
  late TextEditingController _numeroCtrl;
  late TextEditingController _bairroCtrl;

  late String _categoriaSelecionada;
  late String _formatoSelecionado;
  late String _cidadeSelecionada;
  late DateTime _dataEvento;
  late TimeOfDay _horarioInicio;
  late TimeOfDay _horarioTermino;
  late Set<String> _requisitosSelecionados;
  late Set<String> _necessidadesSelecionadas;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final ev = widget.evento;

    _nomeCtrl = TextEditingController(text: ev.titulo);
    _descCtrl = TextEditingController(text: ev.descricao);
    _vagasCtrl = TextEditingController(text: ev.vagasTotais.toString());
    _bannerUrlCtrl = TextEditingController(text: ev.imagemUrl);
    _cepCtrl = TextEditingController();
    _logradouroCtrl = TextEditingController(text: ev.endereco);
    _numeroCtrl = TextEditingController();
    _bairroCtrl = TextEditingController();

    _categoriaSelecionada = ev.categoria;
    _formatoSelecionado = ev.cidade.toLowerCase() == "remoto"
        ? "Apenas Remoto (Online)"
        : AppData.formatosVoluntariado.first;
    _cidadeSelecionada =
        ev.cidade.toLowerCase() == "remoto" ? "Santo André" : ev.cidade;

    _dataEvento = ev.dataHoraInicio;
    _horarioInicio = TimeOfDay(
        hour: ev.dataHoraInicio.hour, minute: ev.dataHoraInicio.minute);
    _horarioTermino = TimeOfDay(
        hour: (ev.dataHoraInicio.hour + 4) % 24,
        minute: ev.dataHoraInicio.minute);

    _requisitosSelecionados = Set<String>.from(ev.requisitos);
    _necessidadesSelecionadas = Set<String>.from(ev.necessidades);
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descCtrl.dispose();
    _vagasCtrl.dispose();
    _bannerUrlCtrl.dispose();
    _cepCtrl.dispose();
    _logradouroCtrl.dispose();
    _numeroCtrl.dispose();
    _bairroCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    // Simulação da chamada PUT/PATCH de atualização na API
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ação atualizada com sucesso!"),
        backgroundColor: Color(0xFF0C6B6B),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF7),
      bottomNavigationBar: isMobile
          ? AppBottomNav(
              currentIndex: 4,
              usuarioId: widget.evento.ongId,
              tipoUsuario: "ong",
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            AppSidebar(
              currentIndex: 5,
              usuarioId: widget.evento.ongId,
              tipoUsuario: "ong",
            ),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  usuarioId: widget.evento.ongId,
                  tipoUsuario: "ong",
                  showBackButton: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 14 : 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Editar Ação",
                                style: TextStyle(
                                  fontSize: isMobile ? 22 : 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF062222),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Formulário Completo Idêntico ao de Criação
                              FormularioEventoCompleto(
                                nomeCtrl: _nomeCtrl,
                                descCtrl: _descCtrl,
                                vagasCtrl: _vagasCtrl,
                                bannerUrlCtrl: _bannerUrlCtrl,
                                cepCtrl: _cepCtrl,
                                logradouroCtrl: _logradouroCtrl,
                                numeroCtrl: _numeroCtrl,
                                bairroCtrl: _bairroCtrl,
                                categoriaSelecionada: _categoriaSelecionada,
                                formatoSelecionado: _formatoSelecionado,
                                cidadeSelecionada: _cidadeSelecionada,
                                dataEvento: _dataEvento,
                                horarioInicio: _horarioInicio,
                                horarioTermino: _horarioTermino,
                                requisitosSelecionados: _requisitosSelecionados,
                                necessidadesSelecionadas:
                                    _necessidadesSelecionadas,
                                onCategoriaChanged: (v) =>
                                    setState(() => _categoriaSelecionada = v),
                                onFormatoChanged: (v) =>
                                    setState(() => _formatoSelecionado = v),
                                onCidadeChanged: (v) =>
                                    setState(() => _cidadeSelecionada = v),
                                onDataChanged: (d) =>
                                    setState(() => _dataEvento = d),
                                onHorarioInicioChanged: (h) =>
                                    setState(() => _horarioInicio = h),
                                onHorarioTerminoChanged: (h) =>
                                    setState(() => _horarioTermino = h),
                              ),
                              const SizedBox(height: 24),

                              // Botão Final de Salvar
                              ElevatedButton(
                                onPressed: _salvando ? null : _salvarAlteracoes,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0C6B6B),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _salvando
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : const Text(
                                        "Salvar Alterações da Ação",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
