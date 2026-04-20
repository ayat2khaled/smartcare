import 'package:first_project/components/doctor_info_title.dart';
import 'package:first_project/components/review_datails.dart';
import 'package:first_project/screens/booking_success_screen.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/models/package_model.dart';

import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/rewards_provider.dart';

class ReviewSummaryScreen extends StatefulWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final String selectedTime;
  final String patientName;
  final String patientPhone;
  final PackageModel selectedPackage;
  final String paymentMethod;
  final bool remindMe;

  const ReviewSummaryScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.patientName,
    required this.patientPhone,
    required this.selectedPackage,
    required this.paymentMethod,
    required this.remindMe,
  });

  @override
  State<ReviewSummaryScreen> createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  final TextEditingController _pointsController = TextEditingController();
  double _discountAmount = 0.0;
  bool _isDiscountApplied = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String formattedDate = "${months[widget.selectedDate.month - 1]} ${widget.selectedDate.day}, ${widget.selectedDate.year}";
    
    // Parse price to calculate totals
    double packagePrice = double.tryParse(widget.selectedPackage.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    
    // Apply discount, total can't be below 0
    double total = packagePrice - _discountAmount;
    if (total < 0) total = 0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Review Summary", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true, backgroundColor: bgColor, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorInfoTile(doctor: widget.doctor),
            const SizedBox(height: 20),
            const Divider(),
            ReviewDetailRow(title: "Date & Hour", value: "$formattedDate / ${widget.selectedTime}"),
            ReviewDetailRow(title: "Package", value: widget.selectedPackage.title),
            ReviewDetailRow(title: "Duration", value: widget.selectedPackage.duration),
            ReviewDetailRow(title: "Patient Name", value: widget.patientName),
            ReviewDetailRow(title: "Phone number", value: widget.patientPhone),
            ReviewDetailRow(title: "Payment", value: widget.paymentMethod),
            const Divider(),
            ReviewDetailRow(title: "Total", value: "\$${packagePrice.toStringAsFixed(2)}"),
            
            const SizedBox(height: 10),
            Text("Earned Points", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: textColor),
                    enabled: !_isDiscountApplied,
                    decoration: InputDecoration(
                      hintText: "Enter points...",
                      hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_isDiscountApplied) {
                      // Remove applied points
                      setState(() {
                        _discountAmount = 0.0;
                        _isDiscountApplied = false;
                        _pointsController.clear();
                      });
                      showTopSnackBar(context, "Cleared applied points.");
                    } else {
                      // Apply points
                      final points = int.tryParse(_pointsController.text) ?? 0;
                      if (points <= 0) return;
                      
                      final availablePoints = Provider.of<RewardsProvider>(context, listen: false).points;
                      if (points > availablePoints) {
                        showTopSnackBar(context, "Error: You only have $availablePoints points available!");
                        return;
                      }
                      
                      setState(() {
                        _discountAmount = points * 0.02; // Matches cart logic (2 cents per point)
                        _isDiscountApplied = true;
                      });
                      showTopSnackBar(context, "Applied $points points!");
                      FocusScope.of(context).unfocus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDiscountApplied ? Colors.red : primaryColor,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_isDiscountApplied ? "Remove" : "Apply", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_isDiscountApplied && _discountAmount > 0)
              ReviewDetailRow(title: "Discount", value: "- \$${_discountAmount.toStringAsFixed(2)}"),
            
            const Divider(),
            ReviewDetailRow(title: "Total", value: "\$${total.toStringAsFixed(2)}", isTotal: true),
            const SizedBox(height: 20),
           //_buildPaymentCard(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(context, total),
    );
  }

  

  Widget _buildPayButton(BuildContext context, double total) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () { 
          Navigator.push(context, MaterialPageRoute(builder: (_) => BookingSuccessScreen(
            doctor: widget.doctor,
            date: widget.selectedDate,
            time: widget.selectedTime,
            patientName: widget.patientName,
            patientPhone: widget.patientPhone,
            packageTitle: widget.selectedPackage.title,
            packageDuration: widget.selectedPackage.duration,
            paymentMethod: widget.paymentMethod,
            subtotal: double.parse(widget.selectedPackage.price.replaceAll(RegExp(r'[^0-9.]'), '')),
            discount: _discountAmount,
            total: total,
            appliedPoints: _isDiscountApplied ? (int.tryParse(_pointsController.text) ?? 0) : 0,
            remindMe: widget.remindMe,
          ))); 
        },
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}