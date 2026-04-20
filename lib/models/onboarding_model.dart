import 'package:flutter/material.dart';

class Onboarding {
  final String imagePath;
  final String title;
  final String description;
  final int activeDotIndex;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  Onboarding({
    required this.imagePath,
    required this.title,
    required this.description,
    this.activeDotIndex = 0,
    this.onNext,
    this.onSkip,
  });
}