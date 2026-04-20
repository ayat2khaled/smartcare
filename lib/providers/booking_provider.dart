import 'package:flutter/material.dart';
import 'package:first_project/models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => [..._bookings];

  void addBooking(Booking newBooking) {
    _bookings.insert(0, newBooking); // Add to top
    notifyListeners();
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index >= 0) {
      final old = _bookings[index];
      // Create updated booking with Cancelled status
      _bookings[index] = Booking(
        id: old.id,
        status: "Cancelled",
        date: old.date,
        name: old.name,
        hospital: old.hospital,
        image: old.image,
        experience: old.experience,
        rating: old.rating,
        appliedPoints: old.appliedPoints,
        availableDays: old.availableDays,
        schedule: old.schedule,
      );
      notifyListeners();
    }
  }

  void rescheduleBooking(String id, String newDate) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index >= 0) {
      final old = _bookings[index];
      _bookings[index] = Booking(
        id: old.id,
        status: old.status,
        date: newDate,
        name: old.name,
        hospital: old.hospital,
        image: old.image,
        experience: old.experience,
        rating: old.rating,
        appliedPoints: old.appliedPoints,
        availableDays: old.availableDays,
        schedule: old.schedule,
      );
      notifyListeners();
    }
  }
}
