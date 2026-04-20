import 'package:first_project/screens/home_screen.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/models/booking_model.dart';
import 'package:first_project/models/notification_model.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/providers/booking_provider.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingSuccessScreen extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime date;
  final String time;
  final String patientName;
  final String patientPhone;
  final String packageTitle;
  final String packageDuration;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double total;
  final int appliedPoints;
  final bool remindMe;

  const BookingSuccessScreen({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
    required this.patientName,
    required this.patientPhone,
    required this.packageTitle,
    required this.packageDuration,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.appliedPoints,
    required this.remindMe,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E2843);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String formattedDate =
        "${months[date.month - 1]} ${date.day}, ${date.year}";

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 120, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                "Booking Completed!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Your appointment with ${doctor.name} is successfully confirmed.",
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Invoice details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Divider(height: 25),
                    _invoiceRow(
                      "Doctor",
                      "${doctor.name} (${doctor.specialization})",
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Patient",
                      patientName,
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Phone number",
                      patientPhone,
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Date & Time",
                      "$formattedDate / $time",
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Package",
                      packageTitle,
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Duration",
                      packageDuration,
                      textColor,
                      subTextColor,
                    ),
                    const SizedBox(height: 10),
                    _invoiceRow(
                      "Payment",
                      paymentMethod,
                      textColor,
                      subTextColor,
                    ),
                    const Divider(height: 25),
                    _invoiceRow(
                      "Subtotal",
                      "\$${subtotal.toStringAsFixed(2)}",
                      textColor,
                      subTextColor,
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 8),
                      _invoiceRow(
                        "Discount",
                        "-\$${discount.toStringAsFixed(2)}",
                        textColor,
                        subTextColor,
                      ),
                    ],
                    const Divider(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  final rewards = Provider.of<RewardsProvider>(
                    context,
                    listen: false,
                  );
                  if (appliedPoints > 0) {
                    rewards.deductPoints(appliedPoints);
                  }
                  rewards.addPoints(50);

                  // Always record the booking first
                  final bookingProvider = Provider.of<BookingProvider>(
                    context,
                    listen: false,
                  );
                  bookingProvider.addBooking(
                    Booking(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: "$formattedDate - $time",
                      name: doctor.name,
                      hospital: doctor.specialization,
                      image: doctor.image,
                      experience: "${doctor.experience} Years",
                      rating: doctor.rating.toString(),
                      appliedPoints: appliedPoints,
                      availableDays: doctor.availableDays,
                      schedule: doctor.schedule,
                    ),
                  );

                  // Send reminder notification if enabled
                  if (remindMe) {
                    try {
                      final notifProvider = Provider.of<NotificationProvider>(
                        context,
                        listen: false,
                      );
                      notifProvider.addNotification(
                        NotificationModel(
                          title:
                              "Your appointment with ${doctor.name} is successfully confirmed.",
                          subtitle: "Date: $formattedDate at $time",
                          userImage: doctor.image,
                          time: "Just now",
                        ),
                      );
                      showTopSnackBar(
                        context,
                        "Your appointment with ${doctor.name} is successfully confirmed.",
                      );
                    } catch (e) {
                      debugPrint("Error sending reminder notification: $e");
                    }
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceRow(
    String label,
    String value,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
