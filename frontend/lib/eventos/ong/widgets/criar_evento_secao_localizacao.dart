// lib/eventos/ong/widgets/criar_evento_secao_localizacao.dart

import 'package:flutter/material.dart';
import '../../../../utils/app_validators.dart';

class CriarEventoSecaoLocalizacao extends StatelessWidget {
  final TextEditingController localNomeCtrl;
  final TextEditingController enderecoCtrl;
  final TextEditingController comoChegarCtrl;
  final String cidadeSelecionada;
  final List<String> cidadesABC;
  final ValueChanged<String?> onCidadeChanged;

  const CriarEventoSecaoLocalizacao({
    super.key,
    required this.localNomeCtrl,
    required this.enderecoCtrl,
    required this.comoChegarCtrl,
    required this.cidadeSelecionada,
    required this.cidadesABC,
    required this.onCidadeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Localização & Trajeto no Grande ABC",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: cidadeSelecionada,
            decoration: _inputDecoration(
              label: "Município",
              hint: "Selecione a cidade",
              icon: Icons.location_city_rounded,
            ),
            items: cidadesABC.map((cid) {
              return DropdownMenuItem(value: cid, child: Text(cid));
            }).toList(),
            onChanged: onCidadeChanged,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: localNomeCtrl,
            decoration: _inputDecoration(
              label: "Nome do Local / Ponto de Encontro",
              hint: "Ex: Sede Comunitária ou Praça Central",
              icon: Icons.place_rounded,
            ),
            validator: (v) => AppValidators.validarObrigatorio(
              v,
              mensagem: "Informe o nome do local de realização.",
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: enderecoCtrl,
            decoration: _inputDecoration(
              label: "Endereço Completo",
              hint: "Ex: Rua das Figueiras, 450 - Bairro Jardim",
              icon: Icons.map_rounded,
            ),
            validator: (v) => AppValidators.validarObrigatorio(
              v,
              mensagem: "Informe o endereço completo para navegação.",
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: comoChegarCtrl,
            maxLines: 2,
            decoration: _inputDecoration(
              label: "Dicas de Como Chegar (Transporte / Referência)",
              hint:
                  "Ex: A 10 min a pé da estação da CPTM ou linhas de ônibus municipais.",
              icon: Icons.directions_transit_rounded,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0C6B6B), size: 20),
      filled: true,
      fillColor: const Color(0xFFF0FAF7),
      labelStyle: const TextStyle(color: Color(0xFF3A6868), fontSize: 13),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
      ),
    );
  }
}
