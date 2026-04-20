import 'package:first_project/components/custom_input_field.dart';
import 'package:first_project/components/date_item.dart';
import 'package:first_project/components/item_slot.dart';
import 'package:first_project/components/queue_status_card.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/screens/select_package_screen.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;
  const BookAppointmentScreen({super.key, required this.doctor});
  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool isReminderOn = false;
  late DateTime selectedDate;
  String selectedTime = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    // Pick the first available date
    bool dateSet = false;
    for (int i = 0; i < 14; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final dayName = _dayNames[date.weekday - 1];
      if (widget.doctor.availableDays.contains(dayName)) {
        selectedDate = date;
        dateSet = true;
        break;
      }
    }
    if (!dateSet) selectedDate = DateTime.now();

    // Pick first available time for that day
    _selectFirstTimeForDate(selectedDate);
  }

  String _getDayName(DateTime date) => _dayNames[date.weekday - 1];

  List<String> _getTimesForDate(DateTime date) {
    final dayName = _getDayName(date);
    return widget.doctor.schedule[dayName] ?? [];
  }

  void _selectFirstTimeForDate(DateTime date) {
    final times = _getTimesForDate(date);
    selectedTime = times.isNotEmpty ? times.first : "";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final availableTimesForDay = _getTimesForDate(selectedDate);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Book Appointment", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 10),
            SizedBox(
              height: 85,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final dayName = _getDayName(date);
                  final dayNumber = date.day.toString();
                  final isSelected = selectedDate.year == date.year && selectedDate.month == date.month && selectedDate.day == date.day;
                  final isDisabled = !widget.doctor.availableDays.contains(dayName);
                  return DateItem(
                    date: dayNumber,
                    day: dayName,
                    isSelected: isSelected && !isDisabled,
                    isDisabled: isDisabled,
                    onTap: () {
                      if (!isDisabled) {
                        setState(() {
                          selectedDate = date;
                          _selectFirstTimeForDate(date);
                        });
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text("Select Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 10),
            availableTimesForDay.isEmpty
                ? Text("No available times for this day", style: TextStyle(color: Colors.grey.shade500))
                : SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableTimesForDay.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final time = availableTimesForDay[index];
                        return TimeSlot(
                          time: time,
                          isSelected: selectedTime == time,
                          onTap: () => setState(() => selectedTime = time),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            CustomInputField(hint: "Full Name", controller: nameController),
            const SizedBox(height: 10),
            CustomInputField(hint: "Phone Number", controller: phoneController, isNumber: true),
            const SizedBox(height: 20),
            Builder(
              builder: (context) {
                const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
                String formattedDate = "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}";
                String displayDateTime = "$formattedDate - ${selectedTime.isEmpty ? 'TBD' : selectedTime}";
                
                int seed = (selectedDate.day * selectedDate.month * selectedDate.year) + selectedTime.hashCode.abs();
                int queueNumber = (seed % 8) + 1;
                int waitTime = (queueNumber * 8) + (seed % 5);

                return QueueStatusCard(
                  dateTime: displayDateTime,
                  queueNumber: queueNumber,
                  waitTime: waitTime,
                  isReminderOn: isReminderOn,
                  onReminderChanged: (value) { setState(() { isReminderOn = value; }); },
                );
              }
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter Name and Phone Number")));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => SelectPackageScreen(
                  doctor: widget.doctor,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime.isEmpty ? 'TBD' : selectedTime,
                  patientName: nameController.text,
                  patientPhone: phoneController.text,
                  remindMe: isReminderOn,
                )));
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}