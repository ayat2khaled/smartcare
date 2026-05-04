import 'package:flutter/material.dart';

class PackageModel {
  final String id; 
  final IconData icon; 
  final String title; 
  final String subtitle; 
  final String price; 
  final String duration; 

  PackageModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
  });
}