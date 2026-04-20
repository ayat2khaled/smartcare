import 'package:first_project/models/doctor_model.dart';
import 'package:flutter/material.dart';

class DoctorInfoTile extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorInfoTile({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(doctor.image)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctor.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
              Text(doctor.specialization, style: TextStyle(color: subTextColor, fontSize: 16)),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.location_on, color: primaryColor, size: 18),
                const SizedBox(width: 5),
                Expanded(child: Text(doctor.location, style: TextStyle(color: subTextColor))),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}