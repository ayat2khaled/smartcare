import 'package:first_project/components/profile_title.dart';
import 'package:first_project/models/profile_model.dart';
import 'package:first_project/screens/booking_screen.dart';
import 'package:first_project/screens/my_orders_screen.dart';
import 'package:first_project/providers/booking_provider.dart';
import 'package:first_project/providers/order_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
          title: "My Profile", icon: Icons.person_outline, onTap: () {}),
      ProfileMenuItem(
        title: "My Booking",
        icon: Icons.bookmark_added_outlined,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookingScreen()));
        },
      ),
      ProfileMenuItem(
        title: "My Orders",
        icon: Icons.shopping_bag_outlined,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyOrdersScreen()));
        },
      ),
      ProfileMenuItem(
          title: "Settings", icon: Icons.settings_outlined, onTap: () {}),
      ProfileMenuItem(
          title: "Help Center", icon: Icons.info_outline, onTap: () {}),
      ProfileMenuItem(
          title: "Privacy Policy", icon: Icons.lock_outline, onTap: () {}),
      ProfileMenuItem(
        title: "Log Out",
        icon: Icons.logout,
        iconColor: Colors.red,
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1E293B) : const Color(0xFFF5F7FA),
        elevation: 0,
        title: Text("Profile",
            style:
                TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          "images/WhatsApp Image 2026-03-08 at 2.50.51 AM.jpeg"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text("Mr. Mohamed",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 2),
            Text("m.user@smartcare.com",
                style: TextStyle(fontSize: 13, color: subTextColor)),
            const SizedBox(height: 24),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statChip('${context.watch<BookingProvider>().bookings.length}', 'Appointments', cardColor, textColor,
                      subTextColor, primaryColor),
                  _statChip('${context.watch<OrderProvider>().orders.length}', 'Orders', cardColor, textColor,
                      subTextColor, const Color(0xFF10B981)),
                  _statChip('${context.watch<RewardsProvider>().points}', 'Points', cardColor, textColor,
                      subTextColor, const Color(0xFFF59E0B)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Dark mode toggle card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: const Color(0xFF6366F1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isDark ? "Light Mode" : "Dark Mode",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: textColor),
                      ),
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeThumbColor: primaryColor,
                      activeTrackColor: primaryColor.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return ProfileTile(item: menuItems[index]);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String value, String label, Color cardColor,
      Color textColor, Color subTextColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 11, color: subTextColor)),
        ],
      ),
    );
  }
}
