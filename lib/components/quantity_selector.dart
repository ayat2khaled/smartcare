import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF253350) : Colors.blue.shade50;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        IconButton(onPressed: onDecrement, icon: Icon(Icons.remove_circle, color: primaryColor)),
        Text("$quantity", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        IconButton(onPressed: onIncrement, icon: Icon(Icons.add_circle, color: primaryColor)),
      ]),
    );
  }
}