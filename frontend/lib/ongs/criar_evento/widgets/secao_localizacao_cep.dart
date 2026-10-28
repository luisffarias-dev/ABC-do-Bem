// lib/ongs/criar_evento/widgets/secao_localizacao_cep.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecaoLocalizacaoCep extends StatefulWidget {
  final TextEditingController cepCtrl;
  final TextEditingController logradouroCtrl;
  final TextEditingController numeroCtrl;
  final TextEditingController bairroCtrl;
  final TextEditingController pontoReferenciaCtrl;
  final String cidade;
  final ValueChanged<String> onCidadeChanged;

  const SecaoLocalizacaoCep({
    super.key,
    required this.cepCtrl,
    required this.logradouroCtrl,
    required this.numeroCtrl,
    required this.bairroCtrl,
    required this.pontoReferenciaCtrl,
    required this.cidade,
    required this.onCidadeChanged,
  });

  @override
  State<SecaoLocalizacaoCep> createState() => _SecaoLocalizacaoCepState();
}

class _SecaoLocalizacaoCepState extends State<SecaoLocalizacaoCep> {
  bool _buscando = false;

  Future<void> _buscarCep(String val) async {
    final cep = val.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;
    setState(() => _buscando = true);
    try {
      final res =
          await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        if (data['erro'] != true && mounted) {
          setState(() {
            widget.logradouroCtrl.text = data['logradouro'] ?? '';
            widget.bairroCtrl.text = data['bairro'] ?? '';
            if (data['localidade'] != null && data['localidade'].isNotEmpty) {
              widget.onCidadeChanged(data['localidade']);
            }
          });
        }
      }
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: Color(0xFF0C6B6B),
              ),
              SizedBox(width: 6),
              Text(
                "3. Local do evento",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF062222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // CEP com botão de busca alinhado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _campo(
                  label: "Insira o CEP",
                  ctrl: widget.cepCtrl,
                  hint: "00000-000",
                  keyboardType: TextInputType.number,
                  onChanged: _buscarCep,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 19),
                child: SizedBox(
                  height: 42,
                  width: 42,
                  child: IconButton.filled(
                    onPressed: _buscando
                        ? null
                        : () => _buscarCep(widget.cepCtrl.text),
                    icon: _buscando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6B6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Logradouro (Bloqueado) e Número (Editável)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _campo(
                  label: "Rua / Avenida",
                  ctrl: widget.logradouroCtrl,
                  hint: "",
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _campo(
                  label: "Número",
                  ctrl: widget.numeroCtrl,
                  hint: "",
                  readOnly: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Bairro (Bloqueado) e Cidade (Bloqueada)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _campo(
                  label: "Bairro",
                  ctrl: widget.bairroCtrl,
                  hint: "",
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cidade",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F7F7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC2E4DC)),
                      ),
                      child: Text(
                        widget.cidade.isNotEmpty
                            ? widget.cidade
                            : "Não definida",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: widget.cidade.isNotEmpty
                              ? const Color(0xFF062222)
                              : Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ponto de Referência (Editável)
          _campo(
            label: "Ponto de Referência",
            ctrl: widget.pontoReferenciaCtrl,
            hint: "Insira algum ponto de referência",
            readOnly: false,
            obrigatorio: false,
          ),
        ],
      ),
    );
  }

  Widget _campo({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    bool readOnly = false,
    bool obrigatorio = true,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: obrigatorio
              ? (v) => (v == null || v.trim().isEmpty) ? "Obrigatório" : null
              : null,
          style: TextStyle(
            fontSize: 12,
            color: readOnly ? Colors.black54 : Colors.black87,
            fontWeight: readOnly ? FontWeight.w500 : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            filled: readOnly,
            fillColor: readOnly ? const Color(0xFFF3F7F7) : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
          ),
        ),
      ],
    );
  }
}
