import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;
  final String duration;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.isSelected, required this.icon, required this.title, required this.subtitle, required this.price, required this.duration, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final borderColor = isSelected ? primaryColor : (isDark ? const Color(0xFF334155) : Colors.grey.shade100);
    final iconBg = isDark ? const Color(0xFF253350) : const Color(0xFFF1F6FE);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: borderColor, width: 2) : Border.all(color: borderColor),
          boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, color: primaryColor, size: 28)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 14, color: subTextColor)),
            ])),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              Text(duration, style: TextStyle(fontSize: 13, color: subTextColor)),
            ])),
            const SizedBox(width: 12),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_off, color: primaryColor, size: 28),
          ],
        ),
      ),
    );
  }
}