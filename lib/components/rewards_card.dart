import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/screens/home_screen.dart';
//import 'package:first_project/screens/records_screen.dart';
//import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainRewardsCard extends StatelessWidget {
  const MainRewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final dividerColor = isDark ? const Color(0xFF334155) : Colors.grey.shade300;
    final progressBg = isDark ? const Color(0xFF334155) : Colors.grey.shade200;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final rewards = Provider.of<RewardsProvider>(context);
    final pts = rewards.points;
    final formatted = _formatNumber(pts);
    // Progress toward 5000 points, capped at 1.0
    final progress = (pts / 5000).clamp(0.0, 1.0);

    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 10)]),
      child: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(width: 140, height: 140, child: CircularProgressIndicator(value: progress, strokeWidth: 10, backgroundColor: progressBg, color: primaryColor, strokeCap: StrokeCap.round)),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(formatted, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
              Text("points", style: TextStyle(color: subTextColor, fontSize: 14)),
            ]),
          ]),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _statColumn(formatted, "points", textColor, subTextColor),
            Container(width: 1, height: 40, color: dividerColor),
            _statColumn("0", "عرض السجل", textColor, subTextColor),
          ]),
          const SizedBox(height: 25),
          ElevatedButton(
  onPressed: () {
  

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
  child: const Text(
    "Redeem Points Now",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k'.replaceAll('.', ',');
    }
    return n.toString();
  }

  Widget _statColumn(String val, String label, Color textColor, Color subTextColor) {
    return Column(children: [
      Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
      Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
    ]);
  }
}