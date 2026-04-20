import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/models/product_model.dart';

/// Model for a disease entry
class DiseaseInfo {
  final String name;
  final String description;
  final List<String> symptoms;
  final String prevention;

  const DiseaseInfo({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.prevention,
  });
}

/// Service to fetch live health data & provide symptom matching
class DataService {


  /// Local disease-symptom knowledge base for chatbot
  static const List<DiseaseInfo> diseaseKnowledgeBase = [
    DiseaseInfo(
      name: 'Common Cold',
      description: 'A viral infection of the upper respiratory tract.',
      symptoms: [
        'runny nose',
        'sneezing',
        'sore throat',
        'mild cough',
        'congestion',
        'mild fever',
      ],
      prevention:
          'Wash hands frequently, avoid close contact with sick people.',
    ),
    DiseaseInfo(
      name: 'Influenza (Flu)',
      description:
          'A contagious respiratory illness caused by influenza viruses.',
      symptoms: [
        'high fever',
        'chills',
        'severe body aches',
        'headache',
        'fatigue',
        'dry cough',
        'sore throat',
      ],
      prevention: 'Annual flu vaccine, good hygiene practices.',
    ),
    DiseaseInfo(
      name: 'COVID-19',
      description:
          'A respiratory illness caused by the SARS-CoV-2 coronavirus.',
      symptoms: [
        'fever',
        'dry cough',
        'fatigue',
        'loss of taste',
        'loss of smell',
        'shortness of breath',
        'chest pain',
      ],
      prevention: 'Vaccination, masking, social distancing, hand hygiene.',
    ),
    DiseaseInfo(
      name: 'Migraine',
      description: 'A neurological condition causing intense headaches.',
      symptoms: [
        'severe headache',
        'nausea',
        'vomiting',
        'light sensitivity',
        'sound sensitivity',
        'visual disturbances',
      ],
      prevention: 'Avoid triggers, maintain regular sleep, stay hydrated.',
    ),
    DiseaseInfo(
      name: 'Hypertension (High Blood Pressure)',
      description: 'A condition where blood pressure is consistently high.',
      symptoms: [
        'headache',
        'dizziness',
        'blurred vision',
        'chest pain',
        'shortness of breath',
        'nosebleed',
      ],
      prevention: 'Healthy diet, regular exercise, reduce salt intake.',
    ),
    DiseaseInfo(
      name: 'Diabetes',
      description: 'A metabolic disease causing high blood sugar levels.',
      symptoms: [
        'frequent urination',
        'excessive thirst',
        'unexplained weight loss',
        'blurred vision',
        'fatigue',
        'slow healing wounds',
      ],
      prevention: 'Healthy diet, regular exercise, maintain healthy weight.',
    ),
    DiseaseInfo(
      name: 'Gastroenteritis (Stomach Flu)',
      description: 'Inflammation of the stomach and intestines.',
      symptoms: [
        'diarrhea',
        'vomiting',
        'stomach cramps',
        'nausea',
        'fever',
        'muscle aches',
      ],
      prevention: 'Good hygiene, safe food handling, clean water.',
    ),
    DiseaseInfo(
      name: 'Anemia',
      description: 'A condition where you lack enough healthy red blood cells.',
      symptoms: [
        'fatigue',
        'weakness',
        'pale skin',
        'shortness of breath',
        'dizziness',
        'cold hands and feet',
        'chest pain',
      ],
      prevention: 'Iron-rich diet, vitamin supplements if needed.',
    ),
    DiseaseInfo(
      name: 'Asthma',
      description: 'A condition causing airway inflammation and narrowing.',
      symptoms: [
        'shortness of breath',
        'wheezing',
        'chest tightness',
        'coughing at night',
        'difficulty breathing',
      ],
      prevention: 'Avoid triggers, use prescribed inhalers, regular checkups.',
    ),
    DiseaseInfo(
      name: 'Urinary Tract Infection (UTI)',
      description: 'An infection in any part of the urinary system.',
      symptoms: [
        'burning urination',
        'frequent urination',
        'cloudy urine',
        'pelvic pain',
        'strong urine smell',
        'fever',
      ],
      prevention: 'Stay hydrated, urinate after intercourse, good hygiene.',
    ),
    DiseaseInfo(
      name: 'Pneumonia',
      description:
          'An infection that inflames the air sacs in one or both lungs.',
      symptoms: [
        'cough',
        'fever',
        'chills',
        'shortness of breath',
        'chest pain',
        'fatigue',
        'nausea',
      ],
      prevention: 'Vaccination, good hygiene, healthy lifestyle.',
    ),
    DiseaseInfo(
      name: 'Bronchitis',
      description: 'Inflammation of the lining of the bronchial tubes.',
      symptoms: [
        'persistent cough',
        'mucus production',
        'fatigue',
        'shortness of breath',
        'chest discomfort',
        'mild fever',
      ],
      prevention: 'Avoid smoking, wear masks in polluted areas.',
    ),
    DiseaseInfo(
      name: 'Allergic Rhinitis',
      description: 'Inflammation of the nasal passages due to allergens.',
      symptoms: [
        'sneezing',
        'runny nose',
        'itchy eyes',
        'congestion',
        'watery eyes',
        'itching',
      ],
      prevention: 'Avoid allergens, use air purifiers, take antihistamines.',
    ),
    DiseaseInfo(
      name: 'Malaria',
      description: 'A mosquito-borne disease caused by Plasmodium parasites.',
      symptoms: [
        'high fever',
        'chills',
        'sweating',
        'headache',
        'nausea',
        'vomiting',
        'muscle pain',
      ],
      prevention: 'Use mosquito nets, repellents, antimalarial medication.',
    ),
    DiseaseInfo(
      name: 'Tonsillitis',
      description: 'Inflammation of the tonsils, usually from infection.',
      symptoms: [
        'sore throat',
        'difficulty swallowing',
        'fever',
        'swollen tonsils',
        'headache',
        'neck pain',
      ],
      prevention: 'Good hygiene, avoid sharing utensils.',
    ),
  ];

  /// Match symptoms to possible diseases
  static List<Map<String, dynamic>> matchSymptoms(List<String> userSymptoms) {
    List<Map<String, dynamic>> results = [];

    for (var disease in diseaseKnowledgeBase) {
      int matchCount = 0;
      List<String> matchedSymptoms = [];

      for (var symptom in userSymptoms) {
        for (var dSymptom in disease.symptoms) {
          if (dSymptom.toLowerCase().contains(symptom.toLowerCase()) ||
              symptom.toLowerCase().contains(dSymptom.toLowerCase())) {
            matchCount++;
            if (!matchedSymptoms.contains(dSymptom)) {
              matchedSymptoms.add(dSymptom);
            }
            break;
          }
        }
      }

      if (matchCount > 0) {
        double confidence = (matchCount / disease.symptoms.length * 100).clamp(
          0,
          100,
        );
        results.add({
          'disease': disease,
          'matchCount': matchCount,
          'confidence': confidence,
          'matchedSymptoms': matchedSymptoms,
        });
      }
    }

    results.sort(
      (a, b) => (b['matchCount'] as int).compareTo(a['matchCount'] as int),
    );
    return results.take(3).toList();
  }

  /// Fetch doctors directly from our custom local dataset
  static Future<List<DoctorModel>> fetchDoctors() async {
    try {
      final String response = await rootBundle.loadString('assets/data/doctors.json');
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
          availableDays: (doc['availableDays'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          schedule: (doc['schedule'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as List<dynamic>).map((e) => e.toString()).toList()),
          ) ?? {},
          packagePrices: (doc['packagePrices'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ) ?? {'Messaging': 20, 'Voice Call': 40, 'Video Call': 60, 'In Person': 80},
        );
      }).toList();
    } catch (_) {}
    return [];
  }

  /// Fetch hospitals from local JSON asset
  static Future<List<Hospital>> fetchHospitals() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/hospitals.json');
      final data = json.decode(jsonString);
      final hospitalsList = data['hospitals'] as List;

      return hospitalsList.map((h) {
        final double distKm = (h['distance_km'] as num).toDouble();
        final double rating = (h['rating'] as num).toDouble();
        final Map<String, dynamic>? workingHours =
            h['working_hours'] != null
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
    } catch (_) {}
    return [];
  }

  static Future<List<Product>> fetchPharmacyProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
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
    } catch (_) {}
    return [];
  }
}
