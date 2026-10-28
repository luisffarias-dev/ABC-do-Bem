// lib/ongs/gestao_eventos/widgets/formulario_evento_completo.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/app_data.dart';

class FormularioEventoCompleto extends StatefulWidget {
  final TextEditingController nomeCtrl;
  final TextEditingController descCtrl;
  final TextEditingController vagasCtrl;
  final TextEditingController bannerUrlCtrl;
  final TextEditingController cepCtrl;
  final TextEditingController logradouroCtrl;
  final TextEditingController numeroCtrl;
  final TextEditingController bairroCtrl;
  final String categoriaSelecionada;
  final String formatoSelecionado;
  final String cidadeSelecionada;
  final DateTime dataEvento;
  final TimeOfDay horarioInicio;
  final TimeOfDay horarioTermino;
  final Set<String> requisitosSelecionados;
  final Set<String> necessidadesSelecionadas;
  final ValueChanged<String> onCategoriaChanged;
  final ValueChanged<String> onFormatoChanged;
  final ValueChanged<String> onCidadeChanged;
  final ValueChanged<DateTime> onDataChanged;
  final ValueChanged<TimeOfDay> onHorarioInicioChanged;
  final ValueChanged<TimeOfDay> onHorarioTerminoChanged;

  const FormularioEventoCompleto({
    super.key,
    required this.nomeCtrl,
    required this.descCtrl,
    required this.vagasCtrl,
    required this.bannerUrlCtrl,
    required this.cepCtrl,
    required this.logradouroCtrl,
    required this.numeroCtrl,
    required this.bairroCtrl,
    required this.categoriaSelecionada,
    required this.formatoSelecionado,
    required this.cidadeSelecionada,
    required this.dataEvento,
    required this.horarioInicio,
    required this.horarioTermino,
    required this.requisitosSelecionados,
    required this.necessidadesSelecionadas,
    required this.onCategoriaChanged,
    required this.onFormatoChanged,
    required this.onCidadeChanged,
    required this.onDataChanged,
    required this.onHorarioInicioChanged,
    required this.onHorarioTerminoChanged,
  });

  @override
  State<FormularioEventoCompleto> createState() =>
      _FormularioEventoCompletoState();
}

class _FormularioEventoCompletoState extends State<FormularioEventoCompleto> {
  bool _buscandoCep = false;

  final List<String> _cidadesAbc = [
    "Santo André",
    "São Bernardo do Campo",
    "São Caetano do Sul",
    "Diadema",
    "Mauá",
    "Ribeirão Pires",
    "Rio Grande da Serra",
  ];

  final List<String> _fotosPreSalvas = [
    "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800",
    "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800",
    "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800",
    "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800",
    "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800",
    "https://images.unsplash.com/photo-1526976668912-1a811878dd37?w=800",
  ];

  static String _limpar(String t) => t
      .replaceAll(
          RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}]', unicode: true), '')
      .trim();

  bool get _isRemoto => widget.formatoSelecionado == "Apenas Remoto (Online)";

  Future<void> _buscarCep(String val) async {
    final cep = val.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;
    setState(() => _buscandoCep = true);
    try {
      final res =
          await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        if (data['erro'] != true) {
          setState(() {
            widget.logradouroCtrl.text = data['logradouro'] ?? '';
            widget.bairroCtrl.text = data['bairro'] ?? '';
            if (_cidadesAbc.contains(data['localidade'])) {
              widget.onCidadeChanged(data['localidade']);
            }
          });
        }
      }
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
  }

  void _abrirGaleriaPreSalva() {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Fotos Pré-Salvas",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 460,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: _fotosPreSalvas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (_, index) {
              final url = _fotosPreSalvas[index];
              return InkWell(
                onTap: () {
                  setState(() => widget.bannerUrlCtrl.text = url);
                  Navigator.pop(dlgCtx);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url, fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = AppData.habilidadesPorCausa.keys
        .map((k) => _limpar(k))
        .toSet()
        .toList();
    final categoriaAtual =
        categorias.contains(_limpar(widget.categoriaSelecionada))
            ? _limpar(widget.categoriaSelecionada)
            : categorias.first;

    final chaveOriginalAppData = AppData.habilidadesPorCausa.keys.firstWhere(
      (k) => _limpar(k) == categoriaAtual,
      orElse: () => AppData.habilidadesPorCausa.keys.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Dados Básicos
        _card("1. Informações Básicas", Icons.edit_note_rounded, [
          _campo("Nome do Evento", widget.nomeCtrl, "Ex: Mutirão de Apoio"),
          const SizedBox(height: 10),
          _dropdown("Causa Oficial", categorias, categoriaAtual,
              (v) => widget.onCategoriaChanged(v!)),
          const SizedBox(height: 10),
          _dropdown("Formato", AppData.formatosVoluntariado,
              widget.formatoSelecionado, (v) => widget.onFormatoChanged(v!)),
          const SizedBox(height: 10),
          _campo("Descrição", widget.descCtrl, "Detalhes da ação...",
              maxLines: 3),
        ]),
        const SizedBox(height: 14),

        // 2. Data, Horários e Vagas
        _card("2. Data, Horário e Vagas", Icons.schedule_rounded, [
          Row(
            children: [
              Expanded(
                child: _seletorBotao(
                  "Data",
                  "${widget.dataEvento.day}/${widget.dataEvento.month}/${widget.dataEvento.year}",
                  () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: widget.dataEvento,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) widget.onDataChanged(d);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _seletorBotao(
                  "Início",
                  "${widget.horarioInicio.hour}:${widget.horarioInicio.minute.toString().padLeft(2, '0')}",
                  () async {
                    final h = await showTimePicker(
                        context: context, initialTime: widget.horarioInicio);
                    if (h != null) widget.onHorarioInicioChanged(h);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _seletorBotao(
                  "Término",
                  "${widget.horarioTermino.hour}:${widget.horarioTermino.minute.toString().padLeft(2, '0')}",
                  () async {
                    final h = await showTimePicker(
                        context: context, initialTime: widget.horarioTermino);
                    if (h != null) widget.onHorarioTerminoChanged(h);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _campo("Total de Vagas", widget.vagasCtrl, "15",
              keyboardType: TextInputType.number),
        ]),
        const SizedBox(height: 14),

        // 3. Localização
        if (!_isRemoto) ...[
          _card("3. Localização (Via CEP)", Icons.location_on_rounded, [
            Row(
              children: [
                Expanded(
                  child: _campo("CEP", widget.cepCtrl, "09000-000",
                      keyboardType: TextInputType.number,
                      onChanged: _buscarCep),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _buscandoCep
                      ? null
                      : () => _buscarCep(widget.cepCtrl.text),
                  icon: _buscandoCep
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search),
                  style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child:
                        _campo("Logradouro", widget.logradouroCtrl, "Rua...")),
                const SizedBox(width: 8),
                Expanded(child: _campo("Nº", widget.numeroCtrl, "123")),
              ],
            ),
            const SizedBox(height: 8),
            _dropdown("Cidade", _cidadesAbc, widget.cidadeSelecionada,
                (v) => widget.onCidadeChanged(v!)),
          ]),
          const SizedBox(height: 14),
        ],

        // 4. Habilidades Requeridas
        _card("4. Habilidades da Causa (AppData)", Icons.psychology_rounded, [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (AppData.habilidadesPorCausa[chaveOriginalAppData] ?? [])
                .map((hab) {
              final sel = widget.requisitosSelecionados.contains(hab);
              return FilterChip(
                label: Text(_limpar(hab),
                    style: TextStyle(
                        fontSize: 11,
                        color: sel ? Colors.white : Colors.black87)),
                selected: sel,
                selectedColor: const Color(0xFF0C6B6B),
                checkmarkColor: Colors.white,
                onSelected: (val) => setState(() => val
                    ? widget.requisitosSelecionados.add(hab)
                    : widget.requisitosSelecionados.remove(hab)),
              );
            }).toList(),
          ),
        ]),
        const SizedBox(height: 14),

        // 5. Suprimentos / Doações
        _card("5. Necessidades e Doações (AppData)",
            Icons.volunteer_activism_rounded, [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (AppData.doacoesPorCausa[chaveOriginalAppData] ?? [])
                .map((item) {
              final sel = widget.necessidadesSelecionadas.contains(item);
              return FilterChip(
                label: Text(_limpar(item),
                    style: TextStyle(
                        fontSize: 11,
                        color: sel ? Colors.white : Colors.black87)),
                selected: sel,
                selectedColor: const Color(0xFFD46B08),
                checkmarkColor: Colors.white,
                onSelected: (val) => setState(() => val
                    ? widget.necessidadesSelecionadas.add(item)
                    : widget.necessidadesSelecionadas.remove(item)),
              );
            }).toList(),
          ),
        ]),
        const SizedBox(height: 14),

        // 6. Foto de Capa
        _card("6. Foto de Capa", Icons.image_rounded, [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.bannerUrlCtrl.text.trim(),
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                color: const Color(0xFFC7EBE3),
                child: const Center(
                    child: Text("Nenhuma imagem selecionada",
                        style: TextStyle(color: Colors.grey, fontSize: 12))),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Seletor de arquivos acionado."),
                          backgroundColor: Color(0xFF0C6B6B)),
                    );
                  },
                  icon: const Icon(Icons.file_upload_outlined,
                      size: 16, color: Color(0xFF0C6B6B)),
                  label: const Text("Fazer Upload",
                      style: TextStyle(
                          color: Color(0xFF0C6B6B),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _abrirGaleriaPreSalva,
                  icon: const Icon(Icons.photo_library_outlined,
                      size: 16, color: Color(0xFF0C6B6B)),
                  label: const Text("Fotos Salvas",
                      style: TextStyle(
                          color: Color(0xFF0C6B6B),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _card(String titulo, IconData icone, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 16, color: const Color(0xFF0C6B6B)),
              const SizedBox(width: 6),
              Text(titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _campo(String label, TextEditingController c, String hint,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      void Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: c,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? "Campo obrigatório" : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFC2E4DC))),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, List<String> itens, String valor,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC2E4DC))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: valor,
              items: itens
                  .map((i) => DropdownMenuItem(
                      value: i,
                      child: Text(_limpar(i),
                          style: const TextStyle(fontSize: 12))))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _seletorBotao(String label, String valor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC2E4DC))),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(valor,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
