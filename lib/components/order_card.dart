import 'package:first_project/models/notification_model.dart';
import 'package:first_project/models/order_model.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/providers/order_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderCardItem extends StatelessWidget {
  final OrderModel order;
  const OrderCardItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final imgBg = isDark ? const Color(0xFF334155) : Colors.grey.shade100;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Order #${order.orderId}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${order.itemsCount} items",
                  style: TextStyle(color: subTextColor),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      order.date ?? "\$${order.price}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: order.date != null ? subTextColor : textColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: order.statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: order.statusTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if (order.status == "Pending") ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Cancel Order"),
                            content: Text(
                              "Are you sure you want to cancel order #${order.orderId}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("No"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<RewardsProvider>(
                                    context,
                                    listen: false,
                                  ).deductPoints(20);
                                  Provider.of<OrderProvider>(
                                    context,
                                    listen: false,
                                  ).cancelOrder(order.orderId);
                                  Provider.of<NotificationProvider>(
                                    context,
                                    listen: false,
                                  ).addNotification(
                                    NotificationModel(
                                      title: "Order Cancelled ❌",
                                      subtitle:
                                          "Your order #${order.orderId} (${order.itemsCount} items) has been cancelled.",
                                      userImage: "assets/user1.jpg",
                                      time: "Just now",
                                    ),
                                  );

                                  showTopSnackBar(ctx, "Order Cancelled ❌");

                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE53935),
                                ),
                                child: const Text(
                                  "Yes, Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text(
                        "Cancel Order",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        side: const BorderSide(color: Color(0xFFE53935)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: imgBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/vitamin_c.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.medication, color: subTextColor, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
