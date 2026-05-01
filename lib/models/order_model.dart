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

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'itemsCount': itemsCount,
    'price': price,
    'status': status,
    'statusColor': statusColor.toARGB32(),
    'statusTextColor': statusTextColor.toARGB32(),
    'date': date,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json['orderId'] as String,
    itemsCount: json['itemsCount'] as int,
    price: json['price'] as String,
    status: json['status'] as String,
    statusColor: Color(json['statusColor'] as int),
    statusTextColor: Color(json['statusTextColor'] as int),
    date: json['date'] as String?,
  );
}