import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/screens/doctor_profile_screen.dart';
import 'package:flutter/material.dart';

class HospitalDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const HospitalDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25, 
                backgroundImage: doctor.image.startsWith('http') 
                    ? NetworkImage(doctor.image) as ImageProvider
                    : AssetImage('images/WhatsApp Image 2026-03-10 at 2.52.53 AM.jpeg')
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    Text(doctor.specialization, style: TextStyle(color: subTextColor, fontSize: 12)),
                    Row(children: [
                      Icon(Icons.work, size: 14, color: primaryColor),
                      Text(" 10 Years", style: TextStyle(color: textColor)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      Text(" ${doctor.rating.toStringAsFixed(1)}", style: TextStyle(color: textColor)),
                    ])
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor))); },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 47), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: const Text("Appointment Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}