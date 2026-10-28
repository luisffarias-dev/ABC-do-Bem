// lib/mensagens/widgets/chat_lista_conversas.dart

import 'package:flutter/material.dart';
import '../../mensagens/models/chat_models.dart';
import 'chat_conversa_item.dart';

class ChatListaConversas extends StatelessWidget {
  final List<ChatConversation> conversas;
  final ChatConversation? conversaSelecionada;
  final String tipoUsuario;
  final bool isMobile;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<ChatConversation> onSelecionarConversa;
  final VoidCallback onRecarregar;

  const ChatListaConversas({
    super.key,
    required this.conversas,
    required this.conversaSelecionada,
    required this.tipoUsuario,
    required this.isMobile,
    required this.onBuscaChanged,
    required this.onSelecionarConversa,
    required this.onRecarregar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFC2E4DC))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mensagens",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062222),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: Color(0xFF0C6B6B),
                      ),
                      tooltip: "Atualizar conversas",
                      onPressed: onRecarregar,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: onBuscaChanged,
                  decoration: InputDecoration(
                    hintText: tipoUsuario == 'ong'
                        ? "Buscar voluntário..."
                        : "Buscar instituição...",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF0C6B6B),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0FAF7),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0C6B6B)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: conversas.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhuma conversa encontrada",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: conversas.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFF0FAF7)),
                    itemBuilder: (context, index) {
                      final chat = conversas[index];
                      final isSelected =
                          !isMobile && conversaSelecionada?.id == chat.id;

                      return ChatConversaItem(
                        conversa: chat,
                        isSelected: isSelected,
                        onTap: () => onSelecionarConversa(chat),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
