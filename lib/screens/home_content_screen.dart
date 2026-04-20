import 'package:first_project/components/doctor_main_card.dart';
import 'package:first_project/components/hospital_card.dart';
import 'package:first_project/components/popular_doctor_card.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/screens/doctor_list_screen.dart';
import 'package:first_project/screens/hospital_screen.dart';
import 'package:first_project/screens/hospital_list_screen.dart';
import 'package:first_project/screens/notification_screen.dart';
import 'package:first_project/screens/pharmacy_screen.dart';
import 'package:first_project/screens/records_screen.dart';
import 'package:first_project/screens/rewards_screen.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<DoctorModel> allDoctors = [];
  List<Hospital> allHospitals = [];
  List<DoctorModel> popularDoctors = [];
  List<Hospital> nearbyHospitals = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final docsResponse = await DataService.fetchDoctors();
    final hospsResponse = await DataService.fetchHospitals();

    if (mounted) {
      setState(() {
        allDoctors = docsResponse;
        allHospitals = hospsResponse;
        popularDoctors = docsResponse.take(4).toList();
        
        nearbyHospitals = hospsResponse.take(2).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// --- Header Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                            "images/WhatsApp Image 2026-03-08 at 2.15.02 AM.jpeg"),
                        radius: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello, Mohamed 👋",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: primaryColor),
                            const SizedBox(width: 2),
                            Text("Tanta, Egypt",
                                style: TextStyle(
                                    color: subTextColor, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Consumer<NotificationProvider>(
                  builder: (context, notifProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Icon(Icons.notifications_outlined,
                                color: textColor, size: 22),
                            if (notifProvider.newCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// --- Search Section ---
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                cursorColor: primaryColor,
                style: TextStyle(color: textColor),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search doctors, hospitals...",
                  hintStyle: TextStyle(color: subTextColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (searchQuery.isNotEmpty)
              _buildSearchResults(textColor, subTextColor, primaryColor)
            else ...[

            /// --- Menu Icons Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuItem(Icons.medical_information_rounded, "Doctors",
                    primaryColor, cardColor, textColor, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DoctorListScreen()),
                  );
                }),
                _menuItem(Icons.local_pharmacy_rounded, "Pharmacy",
                    const Color(0xFF10B981), cardColor, textColor, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PharmacyScreen()),
                  );
                }),
                _menuItem(Icons.folder_shared, "Records",
                    const Color(0xFFF59E0B), cardColor, textColor, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MedicalRecordsScreen()),
                  );
                }),
                _menuItem(Icons.card_giftcard_rounded, "Rewards",
                    const Color(0xFF8B5CF6), cardColor, textColor, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RewardsScreen()),
                  );
                }),
              ],
            ),

            const SizedBox(height: 24),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (popularDoctors.length >= 2) ...[
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DoctorMainCard(
                      doctor: popularDoctors[0],
                      date: "12 July 2025 / 09:00 am",
                    ),
                    const SizedBox(width: 15),
                    DoctorMainCard(
                      doctor: popularDoctors[1],
                      date: "15 July 2025 / 02:00 pm",
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            /// --- Popular Doctor Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Popular Doctor",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DoctorListScreen()),
                    );
                  },
                  child: Text("See All",
                      style:
                          TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (popularDoctors.length >= 4) ...[
              Row(
                children: [
                  Expanded(child: DoctorCard(details: popularDoctors[2])),
                  const SizedBox(width: 12),
                  Expanded(child: DoctorCard(details: popularDoctors[3])),
                ],
              ),
            ],

            const SizedBox(height: 28),

            /// --- Nearby Hospital Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nearby Hospital",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HospitalListScreen()),
                    );
                  },
                  child: Text("See All",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (nearbyHospitals.length >= 2) ...[
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalScreen(hospital: nearbyHospitals[0])),
                        );
                      },
                      child: HospitalCard(info: nearbyHospitals[0]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalScreen(hospital: nearbyHospitals[1])),
                        );
                      },
                      child: HospitalCard(info: nearbyHospitals[1]),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            ], // end of else
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(Color textColor, Color subTextColor, Color primaryColor) {
    final filteredDoctors = allDoctors.where((doc) => doc.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    final filteredHospitals = allHospitals.where((hosp) => hosp.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filteredDoctors.isNotEmpty) ...[
          Text("Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 10),
          ...filteredDoctors.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DoctorCard(details: doc),
          )),
          const SizedBox(height: 20),
        ],
        if (filteredHospitals.isNotEmpty) ...[
          Text("Hospitals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 10),
          ...filteredHospitals.map((hosp) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HospitalScreen(hospital: hosp)),
                );
              },
              child: HospitalCard(info: hosp),
            ),
          )),
        ],
        if (filteredDoctors.isEmpty && filteredHospitals.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text("No results found", style: TextStyle(color: subTextColor, fontSize: 16)),
            ),
          )
      ],
    );
  }

  /// Helper widget for menu items
  Widget _menuItem(IconData icon, String title, Color color,
      Color cardColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: textColor)),
        ],
      ),
    );
  }
}