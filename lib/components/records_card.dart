import 'package:first_project/models/records_model.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final MedicalRecord record;
  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;
    final shadowColor = isDark ? Colors.black26 : const Color(0xFFF5F5F5);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor), boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Icon(record.icon, color: primaryColor, size: 30),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(record.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 4),
            Text(record.subtitle, style: TextStyle(fontSize: 14, color: subTextColor)),
          ])),
          Icon(Icons.arrow_forward_ios, color: subTextColor, size: 16),
        ],
      ),
    );
  }
}