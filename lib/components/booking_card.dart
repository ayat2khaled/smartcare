import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String date;
  final String name;
  final String hospital;
  final String image;
  final String experience;
  final String rating;
  final String leftButton;
  final String rightButton;
  final bool showSwitch;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;
  final VoidCallback? onLeftButtonPressed;
  final VoidCallback? onRightButtonPressed;

  const BookingCard({
    super.key,
    required this.date,
    required this.name,
    required this.hospital,
    required this.image,
    required this.experience,
    required this.rating,
    required this.leftButton,
    required this.rightButton,
    required this.showSwitch,
    required this.switchValue,
    required this.onSwitchChanged,
    this.onLeftButtonPressed,
    this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final leftBtnColor = isDark ? const Color(0xFF334155) : Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📅 Date
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          /// 👤 Doctor Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
  width: 80,
  height: 80,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      image,
      fit: BoxFit.cover,
    ),
  ),
),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      hospital,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.work, size: 14, color: primaryColor),
                            Text(" $experience",
                                style: TextStyle(color: textColor)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.orange),
                            Text(" $rating",
                                style: TextStyle(color: textColor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔘 Buttons
          Row(
            children: [
              if (leftButton.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: leftButton == "Cancel"
                          ? onLeftButtonPressed
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: leftBtnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        leftButton,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),

              if (leftButton.isNotEmpty) const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: rightButton == "Edit" ? onRightButtonPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      rightButton,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}