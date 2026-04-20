import 'package:first_project/models/notification_model.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/providers/order_provider.dart';
import 'package:first_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/cart_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String address;
  final String paymentMethod;
  final int itemsCount;
  final double subtotal;
  final double discount;
  final double total;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.address,
    required this.paymentMethod,
    required this.itemsCount,
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E2843);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 120, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                "Order Completed!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Your order #$orderId has been placed successfully.",
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Invoice details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Divider(height: 25),
                    _invoiceRow(
                      "Payment",
                      paymentMethod,
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Items",
                      "$itemsCount item(s)",
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Address",
                      address.replaceAll('\n', ', '),
                      textColor,
                      subTextColor,
                    ),
                    const Divider(height: 25),
                    _invoiceRow(
                      "Subtotal",
                      "\$${subtotal.toStringAsFixed(2)}",
                      textColor,
                      subTextColor,
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 8),
                      _invoiceRow(
                        "Discount",
                        "-\$${discount.toStringAsFixed(2)}",
                        textColor,
                        subTextColor,
                      ),
                    ],
                    const SizedBox(height: 8),
                    _invoiceRow("Shipping", "\$10.00", textColor, subTextColor),
                    const Divider(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  try {
                    final rewards = Provider.of<RewardsProvider>(context, listen: false);
                    final cart = Provider.of<CartProvider>(context, listen: false);

                    // 1. Deduct points used for discount
                    if (cart.appliedPoints > 0) {
                      rewards.deductPoints(cart.appliedPoints);
                    }

                    // 2. Add 50 reward points for completing an order
                    rewards.addPoints(20);

                    // 3. Clear cart
                    cart.clear();

                    // 2. Add Notification (which also shows a snackbar)
                    final notifProvider = Provider.of<NotificationProvider>(
                      context,
                      listen: false,
                    );
                    notifProvider.addNotification(
                      NotificationModel(
                        title: "Order Placed Successfully! 🛒",
                        subtitle:
                            "Your order #$orderId ($itemsCount items, \$${total.toStringAsFixed(2)}) has been placed.",
                        userImage: "assets/user1.jpg",
                        time: "Just now",
                      ),
                    );

                    // 3. Start delivery timer
                    Provider.of<OrderProvider>(
                      context,
                      listen: false,
                    ).startDeliveryTimer(orderId, notifProvider);

                    // 4. Navigate back to Home and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                      (route) => false,
                    );
                  } catch (e) {
                    debugPrint("Error completing order: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceRow(
    String label,
    String value,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
