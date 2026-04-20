import 'package:flutter/material.dart';

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.title,
    required this.icon,
    this.iconColor = Colors.blue, // اللون الافتراضي أزرق زي الصورة
    required this.onTap,
  });
}