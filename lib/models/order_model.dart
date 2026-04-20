import 'package:flutter/material.dart';

class OrderModel {
  final String orderId;
  final int itemsCount;
  final String price;
  String status;
  Color statusColor;
  Color statusTextColor;
  final String? date;

  OrderModel({
    required this.orderId,
    required this.itemsCount,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    this.date,
  });
}