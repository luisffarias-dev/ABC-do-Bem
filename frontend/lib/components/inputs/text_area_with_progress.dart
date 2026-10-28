import 'package:flutter/material.dart';

class TextAreaWithProgress extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLength;
  final int minLength;

  const TextAreaWithProgress({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLength = 600,
    this.minLength = 200,
  });

  @override
  State<TextAreaWithProgress> createState() => _TextAreaWithProgressState();
}

class _TextAreaWithProgressState extends State<TextAreaWithProgress> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.controller.text.length;
    widget.controller.addListener(_updateLength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateLength);
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      _currentLength = widget.controller.text.length;
    });
  }

  String get _statusText {
    if (_currentLength == 0) return "";
    if (_currentLength < widget.minLength)
      return "Muito curto (mín. ${widget.minLength})";
    if (_currentLength < (widget.maxLength * 0.6)) return "Razoável";
    if (_currentLength < (widget.maxLength * 0.9)) return "Bom!";
    return "Excelente!";
  }

  Color get _statusColor {
    if (_currentLength < widget.minLength) return Colors.redAccent;
    if (_currentLength < (widget.maxLength * 0.6)) return Colors.orange;
    if (_currentLength < (widget.maxLength * 0.9)) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062222),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          maxLines: 5,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.grey),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC2E4DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0C6B6B), width: 2),
            ),
          ),
        ),
        if (_currentLength > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _currentLength / widget.maxLength,
                  backgroundColor: Colors.grey.shade300,
                  color: _statusColor,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$_currentLength / ${widget.maxLength}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
