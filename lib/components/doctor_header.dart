import 'package:first_project/models/doctor_model.dart';
import 'package:flutter/material.dart';

class DoctorHeader extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade100;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor), boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 10)]),
      child: Row(children: [
        CircleAvatar(radius: 40, backgroundImage: NetworkImage(doctor.image)),
        const SizedBox(width: 18),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doctor.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
          Text(doctor.specialization, style: TextStyle(color: subTextColor)),
          const SizedBox(height: 8),
          Row(children: [const Icon(Icons.star, color: Colors.amber, size: 20), Text(" ${doctor.rating}", style: TextStyle(color: subTextColor))]),
          Row(children: [Icon(Icons.location_on, color: primaryColor, size: 20), Text(doctor.location, style: TextStyle(color: subTextColor))]),
        ])),
      ]),
    );
  }
}