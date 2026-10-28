// lib/eventos/voluntario/widgets/eventos_tabs_header.dart

import 'package:flutter/material.dart';

class EventosTabsHeader extends StatelessWidget {
  final int selectedIndex;
  final int totalInscricoesAtivas;
  final ValueChanged<int> onTabChanged;

  const EventosTabsHeader({
    super.key,
    required this.selectedIndex,
    required this.totalInscricoesAtivas,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildItem(label: "Descobrir Eventos", index: 0),
        const SizedBox(width: 24),
        _buildItem(
          label: "Meus Eventos ($totalInscricoesAtivas)",
          index: 1,
        ),
      ],
    );
  }

  Widget _buildItem({required String label, required int index}) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
