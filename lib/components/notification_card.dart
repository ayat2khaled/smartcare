import 'package:first_project/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final subtileBg = isDark ? const Color(0xFF334155) : Colors.grey.shade100;
    final subtileText = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade300;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 25, backgroundImage: AssetImage(notification.userImage)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor))),
                      Text(notification.time, style: TextStyle(color: subTextColor, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (notification.attachment != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf, color: primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(notification.attachment!, style: TextStyle(color: primaryColor, fontSize: 12)),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: subtileBg, borderRadius: BorderRadius.circular(8)),
                      child: Text(notification.subtitle, style: TextStyle(color: subtileText, fontSize: 13)),
                    ),
                  Align(alignment: Alignment.centerRight, child: Icon(Icons.more_horiz, color: subTextColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}