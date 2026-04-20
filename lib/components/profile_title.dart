import 'package:first_project/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final ProfileMenuItem item;

  const ProfileTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final dividerColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: item.iconColor == Colors.red ? Colors.red : textColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 14, color: isDark ? const Color(0xFF64748B) : Colors.grey),
            onTap: item.onTap,
          ),
          Divider(height: 1, indent: 65, endIndent: 20, color: dividerColor),
        ],
      ),
    );
  }
}