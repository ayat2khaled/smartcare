import 'package:first_project/models/cart_item_model.dart';
import 'package:flutter/material.dart';

class PriceSummary extends StatelessWidget {
  final PartPrice info;
  const PriceSummary({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = info.isTotal ? (isDark ? const Color(0xFFE2E8F0) : Colors.black) : (isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700);
    final valueColor = info.isTotal ? (isDark ? const Color(0xFFE2E8F0) : Colors.black) : (isDark ? const Color(0xFFCBD5E1) : Colors.black87);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(info.label, style: TextStyle(fontWeight: info.isTotal ? FontWeight.bold : FontWeight.normal, fontSize: info.isTotal ? 16 : 14, color: labelColor)),
          Text(info.value, style: TextStyle(fontWeight: info.isTotal ? FontWeight.bold : FontWeight.normal, fontSize: info.isTotal ? 16 : 14, color: valueColor)),
        ],
      ),
    );
  }
}