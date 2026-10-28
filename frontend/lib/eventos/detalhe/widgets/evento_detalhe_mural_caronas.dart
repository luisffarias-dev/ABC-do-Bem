// lib/eventos/detalhe/widgets/evento_detalhe_mural_caronas.dart

import 'package:flutter/material.dart';
import '../../models/evento_model.dart';

class EventoDetalheMuralCaronas extends StatefulWidget {
  final EventoModel evento;
  final String usuarioAtualId;
  final bool isDono;

  const EventoDetalheMuralCaronas({
    super.key,
    required this.evento,
    required this.usuarioAtualId,
    required this.isDono,
  });

  @override
  State<EventoDetalheMuralCaronas> createState() =>
      _EventoDetalheMuralCaronasState();
}

class _EventoDetalheMuralCaronasState extends State<EventoDetalheMuralCaronas> {
  final List<Map<String, String>> _caronas = [
    {
      "autor": "Mariana S.",
      "partida": "Saindo da Estação Santo André (Linha 10)",
      "vagas": "2 vagas",
      "horario": "08:15",
    },
    {
      "autor": "Carlos H.",
      "partida": "Saindo do Centro de Mauá",
      "vagas": "3 vagas",
      "horario": "08:00",
    },
  ];

  void _abrirDialogOferecerCarona() {
    final pontoCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Oferecer Carona Solidária",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: pontoCtrl,
          decoration: const InputDecoration(
            labelText: "De onde você vai sair?",
            hintText: "Ex: Catraca da Estação Prefeito Celso Daniel",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (pontoCtrl.text.isNotEmpty) {
                setState(() {
                  _caronas.insert(0, {
                    "autor": "Você",
                    "partida": pontoCtrl.text,
                    "vagas": "Disponível",
                    "horario": "A combinar",
                  });
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C6B6B)),
            child:
                const Text("Publicar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.directions_car_filled_rounded,
                      color: Color(0xFF0C6B6B), size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Mural de Caronas do ABC",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF062222),
                    ),
                  ),
                ],
              ),
              if (!widget.isDono)
                TextButton.icon(
                  onPressed: _abrirDialogOferecerCarona,
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text("Oferecer", style: TextStyle(fontSize: 11)),
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0C6B6B)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Combine transporte solidário com outros voluntários da região:",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ..._caronas.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFD1F5EE),
                      child: Icon(Icons.person,
                          size: 16, color: Color(0xFF0C6B6B)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c["partida"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(
                              "${c["autor"]} • ${c["vagas"]} • ${c["horario"]}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline,
                          size: 16, color: Color(0xFF0C6B6B)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Iniciando chat com ${c['autor']}...")),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
