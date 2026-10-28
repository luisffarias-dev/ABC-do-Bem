// lib/eventos/voluntario/widgets/eventos_calendario_section.dart

import 'package:flutter/material.dart';

class EventosCalendarioSection extends StatelessWidget {
  final DateTime currentMonthDate;
  final String? selectedDate;
  final Set<String> eventDates;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<String?> onSelectDate;

  const EventosCalendarioSection({
    super.key,
    required this.currentMonthDate,
    required this.selectedDate,
    required this.eventDates,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDate,
  });

  static const List<String> _weekdays = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb"
  ];
  static const List<String> _months = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  List<int?> _buildCalendarCells(int year, int month) {
    final firstDayWeekday = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final List<int?> cells = [];

    for (int i = 0; i < firstDayWeekday; i++) {
      cells.add(null);
    }
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(d);
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  String _formatCellDate(int year, int month, int day) {
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return "$year-$m-$d";
  }

  @override
  Widget build(BuildContext context) {
    final year = currentMonthDate.year;
    final month = currentMonthDate.month;
    final cells = _buildCalendarCells(year, month);
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2E4DC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A3B3B), Color(0xFF0C6B6B)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onPrevMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
                Text(
                  "${_months[month - 1]} $year",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  onPressed: onNextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFC2E4DC))),
            ),
            child: Row(
              children: _weekdays.map((w) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      w,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7AAAA0),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, i) {
              final day = cells[i];
              if (day == null) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: const BorderSide(color: Color(0x33C2E4DC)),
                      right: (i % 7 != 6)
                          ? const BorderSide(color: Color(0x33C2E4DC))
                          : BorderSide.none,
                    ),
                  ),
                );
              }

              final dateStr = _formatCellDate(year, month, day);
              final hasEvent = eventDates.contains(dateStr);
              final isSelected = selectedDate == dateStr;
              final isToday = dateStr == todayStr;

              return InkWell(
                onTap: () => onSelectDate(isSelected ? null : dateStr),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0C6B6B)
                        : isToday
                            ? const Color(0xFFD1F5EE)
                            : Colors.transparent,
                    border: Border(
                      bottom: const BorderSide(color: Color(0x33C2E4DC)),
                      right: (i % 7 != 6)
                          ? const BorderSide(color: Color(0x33C2E4DC))
                          : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$day",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? const Color(0xFF0C6B6B)
                                  : const Color(0xFF062222),
                        ),
                      ),
                      if (hasEvent)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xFF9FE8D8)
                                : const Color(0xFF29B0A0),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: const [
                _LegendItem(
                    color: Color(0xFF29B0A0), label: "Evento", isCircle: true),
                SizedBox(width: 14),
                _LegendItem(color: Color(0xFFD1F5EE), label: "Hoje"),
                SizedBox(width: 14),
                _LegendItem(color: Color(0xFF0C6B6B), label: "Selecionado"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isCircle;

  const _LegendItem(
      {required this.color, required this.label, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7AAAA0),
          ),
        ),
      ],
    );
  }
}
