import 'package:first_project/components/hospital_action_button.dart';
import 'package:first_project/components/hospital_doctor_card.dart';
import 'package:first_project/services/data_service.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:flutter/material.dart';

class HospitalScreen extends StatefulWidget {
  final Hospital? hospital;

  const HospitalScreen({super.key, this.hospital});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  int selectedTab = 0;
  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  List<DoctorModel> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final docs = await DataService.fetchDoctors();
    if (mounted) {
      setState(() {
        doctors = docs;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child:
                      widget.hospital != null &&
                          widget.hospital!.image.startsWith('http')
                      ? Image.network(
                          widget.hospital!.image,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(color: primaryColor, height: 220),
                        )
                      : Image.asset(
                          "images/WhatsApp Image 2026-03-10 at 12.47.33 AM.jpeg",
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: cardColor,
                      child: Icon(Icons.arrow_back, color: textColor),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.hospital?.rating ?? "4.4 (1k+ review)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospital?.name ?? "Tanta General hospital",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text("Medical Center", style: TextStyle(color: subTextColor)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryColor, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.hospital?.address ?? "8234 Saburbay tanta",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: primaryColor, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        widget.hospital?.distance ?? "15 min / 1.5km",
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HospitalActionButton(
                        icon: Icons.language,
                        text: "Website",
                      ),
                      HospitalActionButton(icon: Icons.call, text: "Call"),
                      HospitalActionButton(
                        icon: Icons.navigation,
                        text: "Direction",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      tabButton(
                        "Specialist",
                        0,
                        primaryColor,
                        cardColor,
                        textColor,
                      ),
                      const SizedBox(width: 10),
                      tabButton("About", 1, primaryColor, cardColor, textColor),
                    ],
                  ),
                  const SizedBox(height: 20),
                  selectedTab == 0
                      ? isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : Column(
                                children: [
                                  for (var doc in doctors)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      child: HospitalDoctorCard(doctor: doc),
                                    ),
                                ],
                              )
                      : aboutSection(textColor, subTextColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabButton(
    String title,
    int index,
    Color primaryColor,
    Color cardColor,
    Color textColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedTab == index ? primaryColor : cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selectedTab == index ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget aboutSection(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dolor sem, laoreet a hendrerit sed, euismod in lectus.",
          style: TextStyle(color: subTextColor),
        ),
        const SizedBox(height: 20),
        Text(
          "Working hours",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        for (var day in days)
          workingRow(day, textColor, subTextColor),
      ],
    );
  }

  Widget workingRow(String day, Color textColor, Color subTextColor) {
    final hours = widget.hospital?.workingHours?[day] ?? 'N/A';
    final isClosed = hours.toLowerCase() == 'closed';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(color: textColor)),
          Text(
            hours,
            style: TextStyle(
              color: isClosed ? Colors.redAccent : subTextColor,
              fontWeight: isClosed ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
