import 'package:first_project/components/earn_points.dart';
import 'package:first_project/components/rewards_card.dart';
import 'package:first_project/models/rewards_model.dart';

import 'package:flutter/material.dart';



class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

    List<EarnPoint> earnPointsData = [
      EarnPoint(icon: Icons.calendar_month, title: "Book Appointment", pts: "+50 pts"),
      EarnPoint(icon: Icons.medical_services_outlined, title: "Buy Medicine", pts: "+20 pts"),
      EarnPoint(icon: Icons.directions_walk, title: "Daily Steps Goal", pts: "+10 pts"),
      EarnPoint(icon: Icons.star_outline_rounded, title: "Rate Doctor", pts: "+15 pts"),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Rewards", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true, backgroundColor: bgColor, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainRewardsCard(),
      
            const SizedBox(height: 30),
            Text("How to Earn Points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: earnPointsData.length,
              itemBuilder: (context, index) => EarnPointTile(info: earnPointsData[index]),
            ),
          ],
        ),
      ),
    );
  }
}