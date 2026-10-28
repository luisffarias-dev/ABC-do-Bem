// lib/eventos/voluntario/widgets/eventos_vitrine_header.dart

import 'package:flutter/material.dart';

class EventosVitrineHeader extends StatelessWidget {
  final String viewMode; // "list", "map" ou "calendar"
  final ValueChanged<String> onViewModeChanged;
  final bool isMobile;

  const EventosVitrineHeader({
    super.key,
    required this.viewMode,
    required this.onViewModeChanged,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      "Eventos no Grande ABC",
      style: TextStyle(
        fontSize: isMobile ? 18 : 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF062222),
      ),
    );

    final toggleWidget = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFD1F5EE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment:
            isMobile ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
        children: [
          _buildOption("Lista", "list", Icons.view_list_rounded),
          _buildOption("Mapa", "map", Icons.map_outlined),
          _buildOption("Calendário", "calendar", Icons.calendar_today_rounded),
        ],
      ),
    );

    // Se for mobile, empilha o título e o seletor para evitar overflow horizontal
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleWidget,
          const SizedBox(height: 12),
          toggleWidget,
        ],
      );
    }

    // Se for tablet/desktop, mantém lado a lado
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleWidget),
        const SizedBox(width: 12),
        toggleWidget,
      ],
    );
  }

  Widget _buildOption(String label, String mode, IconData icone) {
    final isSelected = viewMode == mode;
    return GestureDetector(
      onTap: () => onViewModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: 13,
              color: isSelected
                  ? const Color(0xFF0C6B6B)
                  : const Color(0xFF3A6868),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF0C6B6B)
                    : const Color(0xFF3A6868),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
