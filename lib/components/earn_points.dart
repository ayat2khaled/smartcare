import 'package:first_project/models/rewards_model.dart';
import 'package:flutter/material.dart';

class EarnPointTile extends StatelessWidget {
  final EarnPoint info;
  const EarnPointTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(info.icon, color: primaryColor),
        const SizedBox(width: 15),
        Text(info.title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
        const Spacer(),
        Text(info.pts, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}