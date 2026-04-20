import 'package:first_project/screens/doctor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel details;
  const DoctorCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E293B);
    final subTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: details.image.startsWith('http')
                    ? Image.network(
                        details.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.person, size: 50),
                      )
                    : Image.asset(
                        details.image.isNotEmpty
                            ? details.image
                            : "images/WhatsApp Image 2026-03-08 at 2.50.51 AM.jpeg",
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
              ),
              Positioned(
                bottom: -12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      details.specialization,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            details.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.work, size: 14, color: primaryColor),
              const SizedBox(width: 4),
              Text(
                "10 Years",
                style: TextStyle(color: subTextColor, fontSize: 12),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 2),
              Text(
                details.rating.toStringAsFixed(1),
                style: TextStyle(color: subTextColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorProfileScreen(doctor: details),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                foregroundColor: primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Book Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.calendar_month, size: 16, color: primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
