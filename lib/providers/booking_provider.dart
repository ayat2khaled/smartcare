import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:first_project/models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingProvider with ChangeNotifier {
  static const String _bookingsPrefix = 'user_bookings_';
  final List<Booking> _bookings = [];
  String _userEmail = '';

  List<Booking> get bookings => [..._bookings];

  /// Load bookings for a specific user
  Future<void> loadForUser(String email) async {
    _userEmail = email.toLowerCase();
    _bookings.clear();
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('$_bookingsPrefix$_userEmail') ?? [];
    for (final json in bookingsJson) {
      _bookings.add(Booking.fromJson(jsonDecode(json)));
    }
    notifyListeners();
  }

  /// Clear in-memory data on logout
  void clearUserData() {
    _bookings.clear();
    _userEmail = '';
    notifyListeners();
  }

  void addBooking(Booking newBooking) {
    _bookings.insert(0, newBooking); // Add to top
    _save();
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
      _save();
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
      _save();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    if (_userEmail.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = _bookings.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList('$_bookingsPrefix$_userEmail', bookingsJson);
  }
}
