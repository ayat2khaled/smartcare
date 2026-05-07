import 'package:first_project/components/custom_input_field.dart';
import 'package:first_project/components/date_item.dart';
import 'package:first_project/components/time_slot.dart';
import 'package:first_project/components/queue_status_card.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/screens/select_package_screen.dart';
import 'package:first_project/services/slot_service.dart';
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

  String? _nameError;
  String? _phoneError;
  bool _hasTriedSubmit = false;

  /// Set of time strings that are already booked for the selected date.
  Set<String> _bookedTimes = {};
  bool _isLoadingSlots = false;

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

    // Load booked slots then pick first available time
    _loadBookedSlotsAndSelectTime(selectedDate);
  }

  String _getDayName(DateTime date) => _dayNames[date.weekday - 1];

  List<String> _getTimesForDate(DateTime date) {
    final dayName = _getDayName(date);
    return widget.doctor.schedule[dayName] ?? [];
  }

  /// Loads booked slots from Firestore and auto-selects the first available time.
  Future<void> _loadBookedSlotsAndSelectTime(DateTime date) async {
    setState(() => _isLoadingSlots = true);

    final booked = await SlotService.getBookedTimes(
      doctorName: widget.doctor.name,
      date: date,
    );

    if (!mounted) return;

    final times = _getTimesForDate(date);
    // Pick the first time that is NOT booked
    String firstAvailable = "";
    for (final t in times) {
      if (!booked.contains(t)) {
        firstAvailable = t;
        break;
      }
    }

    setState(() {
      _bookedTimes = booked.toSet();
      selectedTime = firstAvailable;
      _isLoadingSlots = false;
    });
  }

  // ── Validation helpers ──────────────────────────────────────────────

  String? _validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter your full name';
    if (trimmed.length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z\s\u0600-\u06FF]+$').hasMatch(trimmed)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(trimmed)) {
      return 'Enter a valid 11-digit number starting with 01';
    }
    return null;
  }

  void _onNameChanged(String value) {
    if (_hasTriedSubmit) setState(() => _nameError = _validateName(value));
  }

  void _onPhoneChanged(String value) {
    if (_hasTriedSubmit) setState(() => _phoneError = _validatePhone(value));
  }

  bool _validateAll() {
    _hasTriedSubmit = true;
    final nameErr = _validateName(nameController.text);
    final phoneErr = _validatePhone(phoneController.text);
    setState(() {
      _nameError = nameErr;
      _phoneError = phoneErr;
    });
    return nameErr == null && phoneErr == null;
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
                        });
                        _loadBookedSlotsAndSelectTime(date);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text("Select Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 10),
            _isLoadingSlots
                ? const SizedBox(
                    height: 50,
                    child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
                  )
                : availableTimesForDay.isEmpty
                    ? Text("No available times for this day", style: TextStyle(color: Colors.grey.shade500))
                    : SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: availableTimesForDay.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final time = availableTimesForDay[index];
                            final isBooked = _bookedTimes.contains(time);
                            return TimeSlot(
                              time: isBooked ? "$time ❌" : time,
                              isSelected: selectedTime == time && !isBooked,
                              isDisabled: isBooked,
                              onTap: () {
                                if (!isBooked) {
                                  setState(() => selectedTime = time);
                                }
                              },
                            );
                          },
                        ),
                      ),
            const SizedBox(height: 20),
            CustomInputField(
              hint: "Full Name",
              controller: nameController,
              errorText: _nameError,
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 10),
            CustomInputField(
              hint: "Phone Number (01XXXXXXXXX)",
              controller: phoneController,
              isNumber: true,
              errorText: _phoneError,
              onChanged: _onPhoneChanged,
            ),
            const SizedBox(height: 20),
            Builder(
              builder: (context) {
                const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
                String formattedDate = "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}";
                String displayDateTime = "$formattedDate - ${selectedTime.isEmpty ? 'TBD' : selectedTime}";
                //seed = (10 * 1 * 2026) + hash("10:00 AM")
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
                if (!_validateAll()) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => SelectPackageScreen(
                  doctor: widget.doctor,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime.isEmpty ? 'TBD' : selectedTime,
                  patientName: nameController.text.trim(),
                  patientPhone: phoneController.text.trim(),
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