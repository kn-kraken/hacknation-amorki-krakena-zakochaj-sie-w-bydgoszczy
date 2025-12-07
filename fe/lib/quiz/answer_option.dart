import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingIcon;

    if (hasAnswered) {
      if (isCorrect) {
        leadingIcon = const Icon(
          Icons.check_circle,
          color: Color(0xFF2E5C2E),
          size: 20,
        );
      } else if (isSelected && !isCorrect) {
        leadingIcon = const Icon(
          Icons.cancel,
          color: Color(0xFF8B0000),
          size: 20,
        );
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFdbdad8),
          border: Border.all(
            color: const Color(0xFF6B1D27),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              '$letter.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B1D27),
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(width: 12),
            if (leadingIcon != null) ...[
              leadingIcon,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B1D27),
                  fontFamily: 'Serif',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}