import 'package:first_project/components/hospital_card.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/services/data_service.dart';
import 'package:first_project/screens/hospital_screen.dart';
import 'package:flutter/material.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String searchQuery = "";
  List<Hospital> allHospitals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final hosp = await DataService.fetchHospitals();
    if (mounted) {
      setState(() {
        allHospitals = hosp;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = Theme.of(context).colorScheme.primary;

    List<Hospital> filteredHospitals = allHospitals;
    if (searchQuery.isNotEmpty) {
      filteredHospitals = filteredHospitals
          .where((hosp) =>
              hosp.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              hosp.address.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Hospitals",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
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
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search hospitals...",
                    hintStyle: TextStyle(color: subTextColor),
                    prefixIcon: Icon(Icons.search, color: subTextColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Results count
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${filteredHospitals.length} hospitals found",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Hospitals List
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : filteredHospitals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 60, color: subTextColor),
                                const SizedBox(height: 12),
                                Text(
                                  "No hospitals found",
                                  style: TextStyle(
                                      color: subTextColor, fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 250,
                            ),
                            itemCount: filteredHospitals.length,
                            itemBuilder: (context, index) {
                              var hospital = filteredHospitals[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HospitalScreen(
                                            hospital: hospital)),
                                  );
                                },
                                child: HospitalCard(info: hospital),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
