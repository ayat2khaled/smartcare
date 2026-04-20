import 'package:first_project/components/onboarding_card.dart';
import 'package:first_project/models/onboarding_model.dart';
import 'package:first_project/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/onboarding_2_screen.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Onboarding(
      imagePath: 'images/WhatsApp Image 2026-03-05 at 2.47.18 AM.jpeg',
      title: "Find the best doctor\nin your vicinity",
      description:
          "Lorem ipsum dolor sit amet, consectetur elit. Nullam semper lorem orci, a vulputate quam tincidunt id. Aenean sed vehicula tortor.",
      activeDotIndex: 0,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding2()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      },
    );

    return OnboardingCard(data: model);
  }
}
