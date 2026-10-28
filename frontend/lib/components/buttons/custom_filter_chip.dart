import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFFD1F5EE),
      checkmarkColor: const Color(0xFF0C6B6B),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF0C6B6B) : const Color(0xFF062222),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? const Color(0xFF0C6B6B) : const Color(0xFFC2E4DC),
          width: 1,
        ),
      ),
      onSelected: onSelected,
    );
  }
}
