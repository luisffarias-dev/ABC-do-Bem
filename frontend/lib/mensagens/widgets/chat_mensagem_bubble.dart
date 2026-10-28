// lib/mensagens/widgets/chat_mensagem_bubble.dart

import 'package:flutter/material.dart';
import '../../mensagens/models/chat_models.dart';

class ChatMensagemBubble extends StatelessWidget {
  final ChatMessage mensagem;
  final bool ehMinha;
  final bool isMobile;

  const ChatMensagemBubble({
    super.key,
    required this.mensagem,
    required this.ehMinha,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ehMinha ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * (isMobile ? 0.78 : 0.45),
        ),
        decoration: BoxDecoration(
          color: ehMinha ? const Color(0xFF0C6B6B) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(ehMinha ? 14 : 2),
            bottomRight: Radius.circular(ehMinha ? 2 : 14),
          ),
          border: Border.all(
            color: ehMinha ? Colors.transparent : const Color(0xFFC2E4DC),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              ehMinha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              mensagem.texto,
              style: TextStyle(
                color: ehMinha ? Colors.white : const Color(0xFF062222),
                fontSize: 13,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mensagem.horarioFormatado,
              style: TextStyle(
                color: ehMinha ? Colors.white70 : Colors.grey,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
