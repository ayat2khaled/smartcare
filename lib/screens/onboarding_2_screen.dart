import 'package:smartcare/models/onboarding_model.dart';
import 'package:smartcare/screens/onboarding_3_screen.dart';
import 'package:smartcare/components/onboarding_card.dart';
import 'package:smartcare/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Onboarding(
      imagePath: 'images/WhatsApp Image 2026-03-05 at 3.51.43 AM.jpeg',
      title: "Find the best doctor\nin your vicinity",
      description:
          "Lorem ipsum dolor sit amet, consectetur elit. Nullam semper lorem orci, a vulputate quam tincidunt id. Aenean sed vehicula tortor.",
      activeDotIndex: 1,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding3()),
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
