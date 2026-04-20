import 'package:flutter/material.dart';

class PackageModel {
  final String id; // معرف فريد لكل باقة
  final IconData icon; // الأيقونة (مثلاً Icons.message)
  final String title; // العنوان (مثلاً Message)
  final String subtitle; // الوصف (مثلاً message with doctor)
  final String price; // السعر (مثلاً $30)
  final String duration; // المدة السفلية (مثلاً /30 mins)

  PackageModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
  });
}