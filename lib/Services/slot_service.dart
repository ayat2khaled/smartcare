import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service to manage booked appointment slots in Firestore.
/// Slots are shared across all users so that once a doctor's
/// time slot is taken, no other user can book it.
class SlotService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'booked_slots';

  /// Generates a unique, deterministic document ID for a slot.
  static String _slotId(String doctorName, String dateKey, String time) {
    final sanitized = '${doctorName}_${dateKey}_$time'
        .replaceAll(' ', '_')
        .replaceAll('/', '-')
        .replaceAll(':', '-');
    return sanitized;
  }

  /// Converts a DateTime to a consistent date string key (yyyy-MM-dd).
  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Books a slot in Firestore for the given doctor, date, and time.
  static Future<void> bookSlot({
    required String doctorName,
    required DateTime date,
    required String time,
    required String userEmail,
  }) async {
    final dk = dateKey(date);
    final id = _slotId(doctorName, dk, time);
    try {
      await _firestore.collection(_collection).doc(id).set({
        'doctorName': doctorName,
        'date': dk,
        'time': time,
        'userEmail': userEmail,
        'bookedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ Error booking slot: $e');
    }
  }

  /// Releases a slot in Firestore (e.g. when a booking is cancelled).
  static Future<void> releaseSlot({
    required String doctorName,
    required String dateStr,
    required String time,
  }) async {
    // dateStr comes as "May 7, 2026 - 10:00 AM" from booking.date
    // We need to parse it back into a date key
    final dk = _parseDateFromBookingStr(dateStr);
    if (dk == null) {
      debugPrint('⚠️ Could not parse date from: $dateStr');
      return;
    }
    final id = _slotId(doctorName, dk, time);
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      debugPrint('❌ Error releasing slot: $e');
    }
  }

  /// Fetches all booked time strings for a given doctor on a given date.
  static Future<List<String>> getBookedTimes({
    required String doctorName,
    required DateTime date,
  }) async {
    final dk = dateKey(date);
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('doctorName', isEqualTo: doctorName)
          .where('date', isEqualTo: dk)
          .get();
      return snapshot.docs.map((doc) => doc['time'] as String).toList();
    } catch (e) {
      debugPrint('❌ Error fetching booked slots: $e');
      return [];
    }
  }

  /// Parses the booking date string "May 7, 2026 - 10:00 AM" into "2026-05-07"
  static String? _parseDateFromBookingStr(String dateStr) {
    const months = {
      'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
      'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
      'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
    };
    try {
      // Format: "May 7, 2026 - 10:00 AM"
      final datePart = dateStr.split(' - ').first.trim();
      final parts = datePart.split(' ');
      final month = months[parts[0]];
      final day = parts[1].replaceAll(',', '').padLeft(2, '0');
      final year = parts[2];
      if (month == null) return null;
      return '$year-$month-$day';
    } catch (_) {
      return null;
    }
  }

  /// Extracts the time part from a booking date string.
  /// "May 7, 2026 - 10:00 AM" → "10:00 AM"
  static String? extractTimeFromBookingStr(String dateStr) {
    try {
      final parts = dateStr.split(' - ');
      if (parts.length >= 2) return parts[1].trim();
      return null;
    } catch (_) {
      return null;
    }
  }
  /// Releases a slot using a DateTime directly (used during reschedule).
  static Future<void> releaseSlotByDate({
    required String doctorName,
    required DateTime date,
    required String time,
  }) async {
    final dk = dateKey(date);
    final id = _slotId(doctorName, dk, time);
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      debugPrint('❌ Error releasing slot by date: $e');
    }
  }
}
