import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartcare/models/order_model.dart';
import 'package:smartcare/models/notification_model.dart';
import 'package:smartcare/providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  static const String _ordersPrefix = 'user_orders_';
  final List<OrderModel> _orders = [];
  String _userEmail = '';

  List<OrderModel> get orders => [..._orders];

  /// Load orders for a specific user
  Future<void> loadForUser(String email) async {
    _userEmail = email.toLowerCase();
    _orders.clear();
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList('$_ordersPrefix$_userEmail') ?? [];
    for (final json in ordersJson) {
      _orders.add(OrderModel.fromJson(jsonDecode(json)));
    }
    notifyListeners();
  }

  /// Clear in-memory data on logout
  void clearUserData() {
    _orders.clear();
    _userEmail = '';
    notifyListeners();
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    _save();
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1 && _orders[index].status == "Pending") {
      _orders[index].status = "Cancelled";
      _orders[index].statusColor = const Color(0xFFFFEBEE);
      _orders[index].statusTextColor = const Color(0xFFE53935);
      _save();
      notifyListeners();
    }
  }

  void deliverOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1 && _orders[index].status == "Pending") {
      _orders[index].status = "Delivered";
      _orders[index].statusColor = const Color(0xFFE8F5E9);
      _orders[index].statusTextColor = const Color(0xFF43A047);
      _save();
      notifyListeners();
    }
  }

  void startDeliveryTimer(
    String orderId,
    NotificationProvider notificationProvider,
  ) {
    Future.delayed(const Duration(seconds: 60), () {
      final index = _orders.indexWhere((o) => o.orderId == orderId);
      if (index != -1 && _orders[index].status == "Pending") {
        _orders[index].status = "Delivered";
        _orders[index].statusColor = const Color(0xFFE8F5E9);
        _orders[index].statusTextColor = const Color(0xFF43A047);
        _save();
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

  Future<void> _save() async {
    if (_userEmail.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = _orders.map((o) => jsonEncode(o.toJson())).toList();
    await prefs.setStringList('$_ordersPrefix$_userEmail', ordersJson);
  }
}
