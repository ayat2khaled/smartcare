import 'package:flutter/material.dart';

class ReviewDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const ReviewDetailRow({super.key, required this.title, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? const Color(0xFF94A3B8) : Colors.grey[700];
    final valueColor = isDark ? const Color(0xFFE2E8F0) : (isTotal ? Colors.black : Colors.black87);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: labelColor, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}