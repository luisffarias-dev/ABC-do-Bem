// lib/mensagens/widgets/chat_janela.dart

import 'package:flutter/material.dart';
import '../../mensagens/models/chat_models.dart';
import 'chat_mensagem_bubble.dart';
import 'chat_input_area.dart';

class ChatJanela extends StatelessWidget {
  final ChatConversation conversa;
  final List<ChatMessage> mensagens;
  final bool carregandoMensagens;
  final String usuarioId;
  final bool isMobile;
  final ScrollController scrollController;
  final TextEditingController mensagemController;
  final VoidCallback onVoltarMobile;
  final VoidCallback onEnviarMensagem;

  const ChatJanela({
    super.key,
    required this.conversa,
    required this.mensagens,
    required this.carregandoMensagens,
    required this.usuarioId,
    required this.isMobile,
    required this.scrollController,
    required this.mensagemController,
    required this.onVoltarMobile,
    required this.onEnviarMensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Barra superior da conversa
          Container(
            padding: EdgeInsets.only(
              top: isMobile ? MediaQuery.of(context).padding.top + 8 : 12,
              bottom: 12,
              left: isMobile ? 8 : 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFC2E4DC))),
            ),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0C6B6B),
                    ),
                    onPressed: onVoltarMobile,
                  ),
                CircleAvatar(
                  backgroundImage: NetworkImage(conversa.interlocutorFoto),
                  radius: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversa.interlocutorNome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF062222),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        conversa.online
                            ? "Online agora"
                            : conversa.interlocutorSubtitulo,
                        style: TextStyle(
                          fontSize: 11,
                          color: conversa.online
                              ? const Color(0xFF29B0A0)
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Histórico de mensagens
          Expanded(
            child: Container(
              color: const Color(0xFFF0FAF7).withValues(alpha: 0.6),
              child: carregandoMensagens
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0C6B6B),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: mensagens.length,
                      itemBuilder: (context, index) {
                        final msg = mensagens[index];
                        final ehMinha = msg.remetenteId == usuarioId;
                        return ChatMensagemBubble(
                          mensagem: msg,
                          ehMinha: ehMinha,
                          isMobile: isMobile,
                        );
                      },
                    ),
            ),
          ),

          // Campo de digitação
          ChatInputArea(
            controller: mensagemController,
            onEnviar: onEnviarMensagem,
          ),
        ],
      ),
    );
  }
}
