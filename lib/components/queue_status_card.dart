import 'package:flutter/material.dart';

class QueueStatusCard extends StatelessWidget {
  final String dateTime;
  final int queueNumber;
  final int waitTime;
  final bool isReminderOn;
  final ValueChanged<bool> onReminderChanged;

  const QueueStatusCard({super.key, required this.dateTime, required this.queueNumber, required this.waitTime, required this.isReminderOn, required this.onReminderChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black87;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateTime, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
              Row(
                children: [
                  Text("Remind me", style: TextStyle(color: subTextColor, fontSize: 12)),
                  Switch(value: isReminderOn, onChanged: onReminderChanged, activeThumbColor: primaryColor),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          Row(children: [
            Icon(Icons.person, color: primaryColor, size: 22),
            const SizedBox(width: 10),
            RichText(text: TextSpan(style: TextStyle(color: textColor, fontSize: 15), children: [
              const TextSpan(text: "You are currently number "),
              TextSpan(text: "$queueNumber", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              const TextSpan(text: " in the queue"),
            ])),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Icon(Icons.access_time_filled, color: primaryColor, size: 22),
            const SizedBox(width: 10),
            RichText(text: TextSpan(style: TextStyle(color: textColor, fontSize: 15), children: [
              const TextSpan(text: "Estimated wait time: "),
              TextSpan(text: "$waitTime minutes", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            ])),
          ]),
        ],
      ),
    );
  }
}