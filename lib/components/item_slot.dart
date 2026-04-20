import 'package:flutter/material.dart';

class TimeSlot extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const TimeSlot({super.key, required this.time, required this.isSelected, this.isDisabled = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black87;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
          color: isSelected ? primaryColor : cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryColor : borderColor),
          boxShadow: [
            if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        alignment: Alignment.center,
        child: Text(time, style: TextStyle(color: isSelected ? Colors.white : textColor, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      ),
    );
  }
}