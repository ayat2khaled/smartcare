import 'package:first_project/components/notification_card.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notification", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notifProvider, child) {
              if (notifProvider.newCount == 0) return const SizedBox.shrink();
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                  child: Text("${notifProvider.newCount} New", style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notifProvider, child) {
          final notifications = notifProvider.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: isDark ? const Color(0xFF475569) : Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text("No notifications yet", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text("You'll see your order updates here.", style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey, fontSize: 14)),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
                    TextButton(onPressed: () {}, child: Text("Marks all read", style: TextStyle(color: primaryColor))),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) => NotificationCard(notification: notifications[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
