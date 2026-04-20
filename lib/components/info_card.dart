import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const InfoCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade100;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor), boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
        ]),
      ),
    );
  }
}