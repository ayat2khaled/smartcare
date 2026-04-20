import 'package:flutter/material.dart';
import 'package:first_project/models/order_model.dart';
import 'package:first_project/models/notification_model.dart';
import 'package:first_project/providers/notification_provider.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1 && _orders[index].status == "Pending") {
      _orders[index].status = "Cancelled";
      _orders[index].statusColor = const Color(0xFFFFEBEE);
      _orders[index].statusTextColor = const Color(0xFFE53935);
      notifyListeners();
    }
  }

  void deliverOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1 && _orders[index].status == "Pending") {
      _orders[index].status = "Delivered";
      _orders[index].statusColor = const Color(0xFFE8F5E9);
      _orders[index].statusTextColor = const Color(0xFF43A047);
      notifyListeners();
    }
  }

  void startDeliveryTimer(
    String orderId,
    NotificationProvider notificationProvider,
  ) {
    Future.delayed(const Duration(seconds: 15), () {
      final index = _orders.indexWhere((o) => o.orderId == orderId);
      if (index != -1 && _orders[index].status == "Pending") {
        _orders[index].status = "Delivered";
        _orders[index].statusColor = const Color(0xFFE8F5E9);
        _orders[index].statusTextColor = const Color(0xFF43A047);
        notifyListeners();

        notificationProvider.addNotification(
          NotificationModel(
            title: "Order Delivered! 🎉",
            subtitle: "Your order #$orderId has been delivered successfully.",
            userImage: "assets/user1.jpg",
            time: "Just now",
          ),
        );
      }
    });
  }
}
