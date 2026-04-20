import 'package:first_project/components/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/order_provider.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("My Orders", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true, backgroundColor: bgColor, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderData, child) {
          final orders = orderData.orders;
          if (orders.isEmpty) {
            return Center(child: Text("You have no past orders.", style: TextStyle(color: textColor, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) => OrderCardItem(order: orders[index]),
          );
        },
      ),
    );
  }
}
