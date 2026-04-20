import 'package:first_project/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final Onboarding data;
  const OnboardingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey[800];
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(data.imagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          Positioned(
            top: 50, right: 20,
            child: TextButton(onPressed: data.onSkip ?? () {}, child: Text("Skip", style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold))),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    Text(data.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 10),
                    Text(data.description, textAlign: TextAlign.center, style: TextStyle(color: subTextColor, fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => Row(children: [
                        Icon(Icons.circle, size: index == data.activeDotIndex ? 10 : 8, color: index == data.activeDotIndex ? primaryColor : (isDark ? const Color(0xFF94A3B8) : Colors.grey)),
                        const SizedBox(width: 5),
                      ])),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                        onPressed: data.onNext ?? () {},
                        child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}