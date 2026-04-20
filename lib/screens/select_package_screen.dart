import 'package:first_project/components/package_card.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/screens/review_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/models/package_model.dart';

class SelectPackageScreen extends StatefulWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final String selectedTime;
  final String patientName;
  final String patientPhone;
  final bool remindMe;

  const SelectPackageScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.patientName,
    required this.patientPhone,
    required this.remindMe,
  });
  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  String selectedPackageId = "message";
  String selectedPaymentMethod = "Cash";
  late final List<PackageModel> availablePackages;

  @override
  void initState() {
    super.initState();
    availablePackages = [
      PackageModel(id: "message", icon: Icons.message, title: "Message", subtitle: "message with doctor", price: "\$${widget.doctor.packagePrices['Messaging'] ?? 20}", duration: "10 mins"),
      PackageModel(id: "voice", icon: Icons.call, title: "Voice Call", subtitle: "voice call with doctor", price: "\$${widget.doctor.packagePrices['Voice Call'] ?? 30}", duration: "15 mins"),
      PackageModel(id: "video", icon: Icons.video_camera_front, title: "Video Call", subtitle: "video call with doctor", price: "\$${widget.doctor.packagePrices['Video Call'] ?? 40}", duration: "20 mins"),
      PackageModel(id: "in_person", icon: Icons.person, title: "In Person", subtitle: "in person visit with doctor", price: "\$${widget.doctor.packagePrices['In Person'] ?? 50}", duration: "30 mins"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor, elevation: 0,
        title: Text("Select Package", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Packages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            Column(
              children: availablePackages.map((package) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PackageCard(icon: package.icon, title: package.title, subtitle: package.subtitle, price: package.price, duration: package.duration, isSelected: selectedPackageId == package.id, onTap: () { setState(() { selectedPackageId = package.id; }); }),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPaymentMethod = "Visa"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedPaymentMethod == "Visa" ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selectedPaymentMethod == "Visa" ? primaryColor : Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: Text("Visa", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedPaymentMethod == "Visa" ? Colors.white : textColor,
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPaymentMethod = "Cash"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedPaymentMethod == "Cash" ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selectedPaymentMethod == "Cash" ? primaryColor : Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: Text("Cash", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedPaymentMethod == "Cash" ? Colors.white : textColor,
                      )),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            final selectedPackage = availablePackages.firstWhere((p) => p.id == selectedPackageId);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewSummaryScreen(
              doctor: widget.doctor,
              selectedDate: widget.selectedDate,
              selectedTime: widget.selectedTime,
              patientName: widget.patientName,
              patientPhone: widget.patientPhone,
              selectedPackage: selectedPackage,
              paymentMethod: selectedPaymentMethod,
              remindMe: widget.remindMe,
            )));
          },
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 2),
          child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}