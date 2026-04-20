import 'package:first_project/components/booking_card.dart';
import 'package:first_project/models/booking_model.dart';
import 'package:first_project/models/notification_model.dart';
import 'package:first_project/providers/booking_provider.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Dynamic list fetched via provider

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "My Booking",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.search, color: textColor),
            ),
          ],
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: subTextColor,
            indicatorColor: primaryColor,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            tabs: const [
              Tab(text: "Upcoming"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            final allBookings = provider.bookings;
            final upcoming = allBookings
                .where((b) => b.status == "Upcoming")
                .toList();
            //final completed = allBookings.where((b) => b.status == "Completed").toList();
            final cancelled = allBookings
                .where((b) => b.status == "Cancelled")
                .toList();

            return TabBarView(
              children: [
                _bookingList(upcoming, "Cancel", "Edit", true, false),
                _bookingList(cancelled, "", "Add Review", false, true),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bookingList(
    List<Booking> list,
    String leftButton,
    String rightButton,
    bool showSwitch,
    bool hideLeft,
  ) {
    if (list.isEmpty) {
      return const Center(
        child: Text("No bookings found.", style: TextStyle(fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        return BookingCard(
          date: booking.date,
          name: booking.name,
          hospital: booking.hospital,
          image: booking.image,
          experience: booking.experience,
          rating: booking.rating,
          leftButton: leftButton,
          rightButton: rightButton,
          showSwitch: showSwitch,
          switchValue: true,
          onSwitchChanged: (v) {},
          onLeftButtonPressed: () {
            if (leftButton == "Cancel") {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Cancel Booking"),
                  content: Text(
                    "Are you sure you want to cancel this booking? This will deduct 50 rewards from your balance${booking.appliedPoints > 0 ? ', and restore your ${booking.appliedPoints} applied points' : ''}.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("No"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final rewards = Provider.of<RewardsProvider>(
                          context,
                          listen: false,
                        );
                        rewards.deductPoints(50);
                        if (booking.appliedPoints > 0) {
                          rewards.addPoints(booking.appliedPoints);
                        }
                        Provider.of<BookingProvider>(
                          context,
                          listen: false,
                        ).cancelBooking(booking.id);
                        Provider.of<NotificationProvider>(
                          context,
                          listen: false,
                        ).addNotification(
                          NotificationModel(
                            title: "Booking Cancelled ❌",
                            subtitle:
                                "Your appointment with ${booking.name} on ${booking.date} has been cancelled.",
                            userImage: booking.image,
                            time: "Just now",
                          ),
                        );

                        showTopSnackBar(ctx, "Booking Cancelled ❌");

                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                      ),
                      child: const Text(
                        "Yes, Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          onRightButtonPressed: () {
            if (rightButton == "Edit") {
              _showRescheduleDialog(context, booking);
            }
          },
        );
      },
    );
  }

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _getDayName(DateTime date) => _dayNames[date.weekday - 1];

  void _showRescheduleDialog(BuildContext context, Booking booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.grey.shade100;

    // Find the first available date
    DateTime? initialDate;
    for (int i = 0; i < 14; i++) {
      final date = DateTime.now().add(Duration(days: i));
      if (booking.availableDays.contains(_getDayName(date))) {
        initialDate = date;
        break;
      }
    }
    initialDate ??= DateTime.now();

    DateTime selectedDate = initialDate;
    String selectedTime = "";
    final times = booking.schedule[_getDayName(selectedDate)] ?? [];
    if (times.isNotEmpty) selectedTime = times.first;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final availableTimes =
                booking.schedule[_getDayName(selectedDate)] ?? [];

            return AlertDialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Reschedule Appointment",
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 75,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        separatorBuilder: (_, i) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(
                            Duration(days: index),
                          );
                          final dayName = _getDayName(date);
                          final isDisabled = !booking.availableDays.contains(
                            dayName,
                          );
                          final isSelected =
                              selectedDate.year == date.year &&
                              selectedDate.month == date.month &&
                              selectedDate.day == date.day;

                          return GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () {
                                    setDialogState(() {
                                      selectedDate = date;
                                      final newTimes =
                                          booking.schedule[dayName] ?? [];
                                      selectedTime = newTimes.isNotEmpty
                                          ? newTimes.first
                                          : "";
                                    });
                                  },
                            child: Container(
                              width: 55,
                              decoration: BoxDecoration(
                                color: isDisabled
                                    ? (isDark
                                          ? const Color(0xFF1E293B)
                                          : Colors.grey.shade200)
                                    : isSelected
                                    ? primaryColor
                                    : cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected && !isDisabled
                                    ? Border.all(color: primaryColor, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDisabled
                                          ? Colors.grey
                                          : isSelected
                                          ? Colors.white
                                          : textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${date.day}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDisabled
                                          ? Colors.grey
                                          : isSelected
                                          ? Colors.white
                                          : textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Select Time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    availableTimes.isEmpty
                        ? Text(
                            "No available times",
                            style: TextStyle(color: Colors.grey.shade500),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: availableTimes.map((time) {
                              final isSelected = selectedTime == time;
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    selectedTime = time;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSelected
                                        ? Border.all(
                                            color: primaryColor,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: selectedTime.isEmpty
                      ? null
                      : () {
                          final months = [
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
                          final dateStr =
                              "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}";
                          Provider.of<BookingProvider>(
                            context,
                            listen: false,
                          ).rescheduleBooking(
                            booking.id,
                            "$dateStr - $selectedTime",
                          );

                          showTopSnackBar(
                            ctx,
                            "Rescheduled to $dateStr at $selectedTime",
                          );

                          Navigator.pop(ctx);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
