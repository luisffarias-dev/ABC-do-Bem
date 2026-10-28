// lib/eventos/voluntario/widgets/eventos_tags_selector.dart

import 'package:flutter/material.dart';

class EventosTagsSelector extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const EventosTagsSelector({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          final isSelected = selectedTag == tag;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tag),
              selected: isSelected,
              selectedColor: const Color(0xFF0C6B6B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF0C6B6B),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              backgroundColor: const Color(0xFFD1F5EE),
              onSelected: (_) => onTagSelected(tag),
            ),
          );
        }).toList(),
      ),
    );
  }
}
