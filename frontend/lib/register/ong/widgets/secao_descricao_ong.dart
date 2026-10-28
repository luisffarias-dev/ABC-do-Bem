// lib/register/ong/widgets/secao_descricao_ong.dart

import 'package:flutter/material.dart';

class SecaoDescricaoOng extends StatelessWidget {
  final TextEditingController descricaoCtrl;
  final int tamanhoDescricao;
  final ValueChanged<int> onTamanhoChanged;

  const SecaoDescricaoOng({
    super.key,
    required this.descricaoCtrl,
    required this.tamanhoDescricao,
    required this.onTamanhoChanged,
  });

  String get _statusDescricao {
    if (tamanhoDescricao == 0) return "";
    if (tamanhoDescricao < 200) return "Muito curto (mín. 200)";
    if (tamanhoDescricao < 400) return "Razoável";
    if (tamanhoDescricao < 550) return "Bom!";
    return "Excelente!";
  }

  Color get _corStatusDescricao {
    if (tamanhoDescricao < 200) return Colors.redAccent;
    if (tamanhoDescricao < 400) return Colors.orange;
    if (tamanhoDescricao < 550) return Colors.teal;
    return const Color(0xFF0C6B6B);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: "Descrição da ONG",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062222),
            ),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: descricaoCtrl,
          maxLines: 4,
          maxLength: 600,
          onChanged: (val) => onTamanhoChanged(val.length),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          decoration: InputDecoration(
            hintText:
                "Conte a história, a missão e os projetos da organização (Mín. 200 caracteres)...",
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF0C6B6B), width: 1.5),
            ),
          ),
        ),
        if (tamanhoDescricao > 0) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (tamanhoDescricao / 600).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFC2E4DC),
              color: _corStatusDescricao,
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _statusDescricao,
                style: TextStyle(
                  color: _corStatusDescricao,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$tamanhoDescricao / 600",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
