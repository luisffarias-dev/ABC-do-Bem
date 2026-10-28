// lib/eventos/ong/widgets/criar_evento_secao_logistica.dart

import 'package:flutter/material.dart';
import '../../../../utils/app_validators.dart';

class CriarEventoSecaoLogistica extends StatelessWidget {
  final TextEditingController dataCtrl;
  final TextEditingController horarioCtrl;
  final TextEditingController vagasCtrl;
  final VoidCallback onSelectData;

  const CriarEventoSecaoLogistica({
    super.key,
    required this.dataCtrl,
    required this.horarioCtrl,
    required this.vagasCtrl,
    required this.onSelectData,
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
            "Logística & Capacidade",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: dataCtrl,
                  readOnly: true,
                  onTap: onSelectData,
                  decoration: _inputDecoration(
                    label: "Data do Evento",
                    hint: "DD/MM/AAAA",
                    icon: Icons.calendar_month_rounded,
                  ),
                  validator: (v) => AppValidators.validarObrigatorio(
                    v,
                    mensagem: "Defina a data.",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: horarioCtrl,
                  decoration: _inputDecoration(
                    label: "Horário",
                    hint: "Ex: 09:00 - 13:00",
                    icon: Icons.access_time_rounded,
                  ),
                  validator: (v) => AppValidators.validarObrigatorio(
                    v,
                    mensagem: "Informe o horário.",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: vagasCtrl,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(
              label: "Vagas Totais para Voluntários",
              hint: "Ex: 15",
              icon: Icons.people_alt_rounded,
            ),
            validator: (value) {
              final obrigatorio = AppValidators.validarObrigatorio(value,
                  mensagem: "Informe a quantidade de vagas.");
              if (obrigatorio != null) return obrigatorio;
              final parsed = int.tryParse(value!.trim());
              if (parsed == null || parsed <= 0)
                return "Informe um número válido de vagas.";
              return null;
            },
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
