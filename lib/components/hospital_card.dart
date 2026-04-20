import 'package:first_project/models/home_screen_model.dart';
import 'package:flutter/material.dart';

class HospitalCard extends StatelessWidget {
  final Hospital info;
  const HospitalCard({super.key, required this.info});

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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: info.image.startsWith('http')
                ? Image.network(
                    info.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.local_hospital, size: 50),
                  )
                : Image.asset(
                    info.image.isNotEmpty
                        ? info.image
                        : "images/placeholder.jpg",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            info.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Divider(
            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: primaryColor, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  info.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: subTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  info.rating,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: subTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: primaryColor, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  info.distance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: subTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
