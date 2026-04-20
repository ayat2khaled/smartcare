import 'package:flutter/material.dart';

class DateItem extends StatelessWidget {
  final String date;
  final String day;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const DateItem({super.key, required this.date, required this.day, required this.isSelected, this.isDisabled = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          width: 65, height: 85,
          alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : borderColor),
          boxShadow: [
            if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(color: isSelected ? Colors.white.withValues(alpha: 0.9) : subTextColor, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(color: isSelected ? Colors.white : textColor, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      ),
    );
  }
}