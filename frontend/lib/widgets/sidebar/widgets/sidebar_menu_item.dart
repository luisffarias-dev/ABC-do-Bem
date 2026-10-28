// lib/widgets/sidebar/widgets/sidebar_menu_item.dart

import 'package:flutter/material.dart';

class SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selecionado;
  final VoidCallback onTap;
  final Color? corTexto;

  const SidebarMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selecionado,
    required this.onTap,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    final corAtiva = corTexto ??
        (selecionado ? const Color(0xFF0C6B6B) : const Color(0xFF3A6868));
    final corFundo = selecionado ? const Color(0xFFE3F5F1) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: corFundo,
            borderRadius: BorderRadius.circular(12),
            border:
                selecionado ? Border.all(color: const Color(0xFFC2E4DC)) : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: corAtiva),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: selecionado ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                    color: corAtiva,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (selecionado)
                Container(
                  width: 5,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C6B6B),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
