// lib/ongs/criar_evento/widgets/secao_data_vagas.dart

import 'package:flutter/material.dart';

class SecaoDataVagas extends StatelessWidget {
  final DateTime data;
  final TimeOfDay inicio;
  final TimeOfDay termino;
  final TextEditingController vagasCtrl;
  final ValueChanged<DateTime> onDataChanged;
  final ValueChanged<TimeOfDay> onInicioChanged;
  final ValueChanged<TimeOfDay> onTerminoChanged;

  const SecaoDataVagas({
    super.key,
    required this.data,
    required this.inicio,
    required this.termino,
    required this.vagasCtrl,
    required this.onDataChanged,
    required this.onInicioChanged,
    required this.onTerminoChanged,
  });

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
              Icon(Icons.schedule_rounded, size: 18, color: Color(0xFF0C6B6B)),
              SizedBox(width: 6),
              Text(
                "2. Data, Horário e Vagas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _seletorBotao(
                  "Data",
                  "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}",
                  () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: data,
                      firstDate: DateTime.now().subtract(const Duration(days: 60)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) onDataChanged(d);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _seletorBotao(
                  "Início",
                  "${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}",
                  () async {
                    final h = await showTimePicker(
                        context: context, initialTime: inicio);
                    if (h != null) onInicioChanged(h);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _seletorBotao(
                  "Término",
                  "${termino.hour.toString().padLeft(2, '0')}:${termino.minute.toString().padLeft(2, '0')}",
                  () async {
                    final h = await showTimePicker(
                        context: context, initialTime: termino);
                    if (h != null) onTerminoChanged(h);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total de Vagas",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: vagasCtrl,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Informe a quantidade de vagas"
                    : null,
                decoration: InputDecoration(
                  hintText: "15",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seletorBotao(String label, String valor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC2E4DC)),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(valor,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}