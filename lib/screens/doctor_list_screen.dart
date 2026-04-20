import 'package:first_project/components/doctor_card.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/services/data_service.dart';
import 'package:flutter/material.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  String selectedCategory = "All";
  String searchQuery = "";

  List<DoctorModel> allDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final doctors = await DataService.fetchDoctors();
    if (mounted) {
      setState(() {
        allDoctors = doctors;
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

    // Filter doctors
    List<DoctorModel> filteredDoctors = allDoctors;
    if (selectedCategory != "All") {
      filteredDoctors = filteredDoctors
          .where((doc) =>
              doc.specialization.toLowerCase() ==
              selectedCategory.toLowerCase())
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      filteredDoctors = filteredDoctors
          .where((doc) =>
              doc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.specialization
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
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
          "Doctors",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    hintText: "Search doctors...",
                    hintStyle: TextStyle(color: subTextColor),
                    prefixIcon: Icon(Icons.search, color: subTextColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              if (searchQuery.isEmpty) ...[
                const SizedBox(height: 20),

                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      "All",
                      "Cardio",
                      "Dentist",
                      "Surgeon",
                      "Radiologist",
                    ].map((cat) {
                      bool isPrimary = cat == selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isPrimary ? primaryColor : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isPrimary
                                  ? primaryColor
                                  : isDark
                                      ? const Color(0xFF334155)
                                      : Colors.grey.shade200,
                            ),
                            boxShadow: isPrimary
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isPrimary ? Colors.white : subTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Results count
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${filteredDoctors.length} doctors found",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Doctors List
              Expanded(
                child: isLoading 
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 60, color: subTextColor),
                            const SizedBox(height: 12),
                            Text(
                              "No doctors found",
                              style: TextStyle(
                                  color: subTextColor, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          var doctor = filteredDoctors[index];
                          return DoctorCard(
                            doctor: doctor,
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
