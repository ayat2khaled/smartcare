import 'package:flutter/material.dart';

class HospitalActionButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const HospitalActionButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.blue.shade50;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

    return Column(
      children: [
        CircleAvatar(radius: 25, backgroundColor: bgColor, child: Icon(icon, color: primaryColor)),
        const SizedBox(height: 5),
        Text(text, style: TextStyle(color: textColor)),
      ],
    );
  }
}