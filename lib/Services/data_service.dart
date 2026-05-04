import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/models/product_model.dart';

/// Service to fetch health data & provide symptom checking
class DataService {

  /// Fetch doctors directly from our custom local dataset
  static Future<List<DoctorModel>> fetchDoctors() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/doctors.json',
      );
      final data = json.decode(response);
      final doctorsList = data['doctors'] as List;

      return doctorsList.map((doc) {
        return DoctorModel(
          name: doc['name'] ?? '',
          specialization: doc['specialization'] ?? '',
          location: doc['location'] ?? '',
          rating: (doc['rating'] as num?)?.toDouble() ?? 0.0,
          experience: doc['experience'] ?? 0,
          patients: doc['patients'] ?? 0,
          reviews: doc['reviews'] ?? 0,
          image: doc['image'] ?? '',
          about: doc['about'] ?? '',
          availableDays:
              (doc['availableDays'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          schedule:
              (doc['schedule'] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(
                  key,
                  (value as List<dynamic>).map((e) => e.toString()).toList(),
                ),
              ) ??
              {},
          packagePrices:
              (doc['packagePrices'] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(key, (value as num).toInt()),
              ) ??
              {
                'Messaging': 20,
                'Voice Call': 40,
                'Video Call': 60,
                'In Person': 80,
              },
        );
      }).toList();
    } catch (_) {}
    return [];
  }

  /// Fetch hospitals from local JSON asset
  static Future<List<Hospital>> fetchHospitals() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/hospitals.json',
      );
      final data = json.decode(jsonString);
      final hospitalsList = data['hospitals'] as List;

      return hospitalsList.map((h) {
        final double distKm = (h['distance_km'] as num?)?.toDouble() ?? 0.0;
        final double rating = (h['rating'] as num?)?.toDouble() ?? 0.0;
        final Map<String, dynamic>? workingHours = h['working_hours'] != null
            ? Map<String, dynamic>.from(h['working_hours'])
            : null;

        return Hospital(
          name: h['name'] ?? '',
          image: h['image'] ?? '',
          address: h['address'] ?? '',
          rating: '$rating',
          distance: '$distKm km',
          workingHours: workingHours,
          phone: h['phone'] ?? '',
          ambulanceNumber: h['ambulance_number'] ?? '',
          latitude: (h['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (h['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ Error loading hospitals: $e");
    }
    return [];
  }

  /// Fetch nearby hospitals specifically for the non-emergency sections
  static Future<List<Hospital>> fetchNearbyHospitals() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/popular_hospitals.json',
      );
      final data = json.decode(jsonString);
      final hospitalsList = data['hospitals'] as List;

      return hospitalsList.map((h) {
        final double distKm = (h['distance_km'] as num).toDouble();
        final double rating = (h['rating'] as num).toDouble();
        final Map<String, dynamic>? workingHours = h['working_hours'] != null
            ? Map<String, dynamic>.from(h['working_hours'])
            : null;

        return Hospital(
          name: h['name'] ?? '',
          image: h['image'] ?? '',
          address: h['address'] ?? '',
          rating: '$rating',
          distance: '$distKm km',
          workingHours: workingHours,
          phone: h['phone'] ?? '',
          ambulanceNumber: h['ambulance_number'] ?? '',
          latitude: (h['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (h['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
}
    return [];
  }

  static Future<List<Product>> fetchPharmacyProducts() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final data = json.decode(response);
      final productsList = data['products'] as List;

      return productsList.map((prod) {
        return Product(
          name: prod['name'] ?? 'Product',
          category: prod['category'] ?? 'Category',
          image: prod['image'] ?? '',
          price: (prod['price'] as num).toDouble(),
          rating: (prod['rating'] as num).toDouble(),
          reviews: (prod['reviews'] as num).toInt(),
        );
      }).toList();
    } catch (e) {
  debugPrint(e.toString());
}
    return [];
  }
}
