import 'dart:math';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/services/data_service.dart';
import 'package:first_project/screens/hospital_screen.dart';
import 'package:flutter/material.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  List<Hospital> allHospitals = [];
  List<Hospital> sortedHospitals = [];
  bool isLoading = true;
  bool locationSet = false;

  // User location defaults (Arab Open University, Egypt)
  double userLat = 30.1195;
  double userLng = 31.6032;
  String locationName = "Arab Open University, Egypt";

  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Predefined locations for quick selection
  final List<Map<String, dynamic>> quickLocations = [
    {'name': 'Arab Open University', 'lat': 30.1195, 'lng': 31.6032},
    {'name': 'Tanta City', 'lat': 30.7865, 'lng': 31.0004},
    {'name': 'Alexandria', 'lat': 31.2001, 'lng': 29.9187},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fetchHospitals();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _fetchHospitals() async {
    final hospitals = await DataService.fetchHospitals();
    if (mounted) {
      setState(() {
        allHospitals = hospitals;
        isLoading = false;
      });
    }
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  void _setLocation(double lat, double lng, String name) {
    setState(() {
      userLat = lat;
      userLng = lng;
      locationName = name;
      locationSet = true;

      // Filter hospitals within 50km radius
      sortedHospitals = allHospitals.where((h) {
        final dist = _calculateDistance(userLat, userLng, h.latitude, h.longitude);
        return dist <= 50.0;
      }).toList();

      sortedHospitals.sort((a, b) {
        final distA = _calculateDistance(userLat, userLng, a.latitude, a.longitude);
        final distB = _calculateDistance(userLat, userLng, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });
    });
  }

  void _showLocationPicker() {
    _latController.text = userLat.toString();
    _lngController.text = userLng.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
        final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final primary = Theme.of(ctx).colorScheme.primary;

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: subColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Set Your Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 6),
                Text("Choose a quick location",
                    style: TextStyle(color: subColor, fontSize: 13)),
                const SizedBox(height: 20),

                // Quick location chips
                Text("Quick Select", style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: quickLocations.map((loc) {
                    return GestureDetector(
                      onTap: () {
                        _setLocation(loc['lat'], loc['lng'], loc['name']);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary.withValues(alpha: 0.1), primary.withValues(alpha: 0.05)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, size: 16, color: primary),
                            const SizedBox(width: 6),
                            Text(loc['name'], style: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = Theme.of(context).colorScheme.primary;
    const emergencyRed = Color(0xFFDC2626);
    const emergencyRedLight = Color(0xFFFEE2E2);
    final emergencyRedBg = isDark ? const Color(0xFF450A0A) : emergencyRedLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10),
                          ],
                        ),
                        child: Icon(Icons.arrow_back, color: textColor, size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text("Emergency",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Emergency banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: emergencyRed.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.emergency, color: Colors.white, size: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Emergency Help",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Set your location to find the nearest hospitals & ambulance numbers",
                                style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Location card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: _showLocationPicker,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: locationSet ? primaryColor.withValues(alpha: 0.3) : subTextColor.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: locationSet
                                ? primaryColor.withValues(alpha: 0.1)
                                : subTextColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            locationSet ? Icons.location_on : Icons.location_searching,
                            color: locationSet ? primaryColor : subTextColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locationSet ? "Your Location" : "Set Your Location",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                locationSet ? locationName : "Tap to select your current location",
                                style: TextStyle(color: subTextColor, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: subTextColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Results section
            if (isLoading)
              const SliverToBoxAdapter(
                child: Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
              )
            else if (!locationSet)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.pin_drop_outlined, size: 64, color: subTextColor.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text("Set your location first",
                          style: TextStyle(color: subTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Text("We'll find the nearest hospitals for you",
                          style: TextStyle(color: subTextColor.withValues(alpha: 0.7), fontSize: 13)),
                    ],
                  ),
                ),
              )
            else if (sortedHospitals.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.local_hospital_outlined, size: 64, color: subTextColor.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text("No hospitals nearby",
                          style: TextStyle(color: subTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Text("We couldn't find any hospitals within 50 km of your location.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: subTextColor.withValues(alpha: 0.7), fontSize: 13)),
                    ],
                  ),
                ),
              )
            else ...[
              // Ambulance numbers header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Ambulance Numbers",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Ambulance number cards
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedHospitals.length,
                    separatorBuilder: (_, i) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final hospital = sortedHospitals[index];
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: emergencyRedBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: emergencyRed.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_hospital, color: emergencyRed, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    hospital.ambulanceNumber.isNotEmpty ? hospital.ambulanceNumber : "123",
                                    style: const TextStyle(
                                      color: emergencyRed,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              hospital.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            if (hospital.phone.isNotEmpty)
                              Text(hospital.phone,
                                  style: TextStyle(color: subTextColor, fontSize: 11)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Nearest hospitals header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Nearest Hospitals",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Hospital list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final hospital = sortedHospitals[index];
                    final dist = _calculateDistance(
                      userLat, userLng, hospital.latitude, hospital.longitude,
                    );

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (_) => HospitalScreen(hospital: hospital)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Hospital image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: hospital.image.startsWith('http')
                                    ? Image.network(
                                        hospital.image,
                                        width: 70, height: 70, fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 70, height: 70,
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Icon(Icons.local_hospital, color: primaryColor),
                                        ),
                                      )
                                    : Container(
                                        width: 70, height: 70,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(Icons.local_hospital, color: primaryColor),
                                      ),
                              ),
                              const SizedBox(width: 14),
                              // Hospital info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hospital.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: primaryColor),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(hospital.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: subTextColor, fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text("${dist.toStringAsFixed(1)} km",
                                              style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.w600)),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.star, size: 12, color: Colors.amber),
                                              const SizedBox(width: 2),
                                              Text(hospital.rating,
                                                  style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        if (hospital.phone.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: emergencyRedBg,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.phone, size: 16, color: emergencyRed),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: sortedHospitals.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ],
        ),
      ),
    );
  }
}
