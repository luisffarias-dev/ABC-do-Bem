// lib/notificacoes/widgets/notificacao_tabs.dart

import 'package:flutter/material.dart';

class NotificacaoTabs extends StatelessWidget {
  final int tabIndex;
  final int totalNaoLidas;
  final int totalLidas;
  final ValueChanged<int> onTabChanged;

  const NotificacaoTabs({
    super.key,
    required this.tabIndex,
    required this.totalNaoLidas,
    required this.totalLidas,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFC2E4DC),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(label: "Novas ($totalNaoLidas)", index: 0),
          const SizedBox(width: 24),
          _buildTabItem(label: "Lidas ($totalLidas)", index: 1),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String label, required int index}) {
    final isSelected = tabIndex == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF0C6B6B) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color:
                isSelected ? const Color(0xFF0C6B6B) : const Color(0xFF7AAAA0),
          ),
        ),
      ),
    );
  }
}
