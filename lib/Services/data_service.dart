import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:first_project/models/doctor_model.dart';
import 'package:first_project/models/home_screen_model.dart';
import 'package:first_project/models/product_model.dart';

/// Model for a health area category used in symptom checking
class HealthCategory {
  final String name;
  final String emoji;
  final String area;
  final List<String> symptoms;
  final List<String> redFlagSymptoms;
  final String mildDescription;
  final String moderateDescription;
  final String severeDescription;
  final String specialist;
  final List<String> selfCareTips;

  const HealthCategory({
    required this.name,
    required this.emoji,
    required this.area,
    required this.symptoms,
    required this.redFlagSymptoms,
    required this.mildDescription,
    required this.moderateDescription,
    required this.severeDescription,
    required this.specialist,
    required this.selfCareTips,
  });
}

/// Result of a preliminary symptom check — NOT a diagnosis
class SymptomAnalysis {
  final String categoryName;
  final String emoji;
  final String description;
  final String severity;
  final double matchScore;
  final List<String> matchedSymptoms;
  final String recommendation;
  final String specialist;
  final List<String> selfCareTips;
  final bool shouldSeeDoctor;

  const SymptomAnalysis({
    required this.categoryName,
    required this.emoji,
    required this.description,
    required this.severity,
    required this.matchScore,
    required this.matchedSymptoms,
    required this.recommendation,
    required this.specialist,
    required this.selfCareTips,
    required this.shouldSeeDoctor,
  });
}

/// Service to fetch health data & provide symptom checking
class DataService {
  /// Health categories knowledge base for symptom checking
  static const List<HealthCategory> healthCategories = [
    HealthCategory(
      name: 'Respiratory',
      emoji: '🫁',
      area: 'respiratory system',
      symptoms: [
        'cough', 'sore throat', 'runny nose', 'sneezing', 'congestion',
        'shortness of breath', 'wheezing', 'chest tightness',
        'difficulty breathing', 'mucus', 'dry cough',
      ],
      redFlagSymptoms: [
        'shortness of breath', 'difficulty breathing',
        'chest tightness', 'wheezing',
      ],
      mildDescription:
          'The symptoms may indicate a mild respiratory issue such as a common cold or seasonal irritation.',
      moderateDescription:
          'The symptoms may indicate a respiratory condition such as bronchitis or an upper respiratory infection.',
      severeDescription:
          'The symptoms suggest a potentially serious respiratory condition that needs prompt evaluation.',
      specialist: 'Pulmonologist or Internist',
      selfCareTips: [
        'Rest and stay well hydrated',
        'Use a humidifier to ease breathing',
        'Drink warm fluids like tea with honey',
        'Gargle with warm salt water for sore throat',
      ],
    ),
    HealthCategory(
      name: 'Gastrointestinal',
      emoji: '🤢',
      area: 'digestive system',
      symptoms: [
        'nausea', 'vomiting', 'diarrhea', 'stomach pain', 'abdominal pain',
        'bloating', 'loss of appetite', 'cramps', 'stomach cramps',
        'indigestion', 'heartburn',
      ],
      redFlagSymptoms: [
        'severe abdominal pain', 'persistent vomiting',
      ],
      mildDescription:
          'The symptoms may indicate a mild digestive upset such as indigestion or a stomach bug.',
      moderateDescription:
          'The symptoms may indicate a gastrointestinal condition such as gastroenteritis or gastritis.',
      severeDescription:
          'The symptoms suggest a digestive condition that requires medical attention.',
      specialist: 'Gastroenterologist or Internist',
      selfCareTips: [
        'Stay hydrated with small, frequent sips of water',
        'Follow the BRAT diet (bananas, rice, applesauce, toast)',
        'Avoid spicy, fatty, or heavy foods',
        'Rest and avoid strenuous activity',
      ],
    ),
    HealthCategory(
      name: 'Neurological',
      emoji: '🧠',
      area: 'nervous system',
      symptoms: [
        'headache', 'dizziness', 'blurred vision', 'light sensitivity',
        'sound sensitivity', 'numbness', 'tingling', 'confusion',
        'difficulty concentrating', 'visual disturbances',
      ],
      redFlagSymptoms: [
        'confusion', 'numbness', 'sudden severe headache',
        'visual disturbances',
      ],
      mildDescription:
          'The symptoms may indicate a tension headache or mild neurological strain, possibly from stress or lack of sleep.',
      moderateDescription:
          'The symptoms may indicate a neurological condition such as a migraine or vestibular issue.',
      severeDescription:
          'The symptoms suggest a neurological concern that should be evaluated promptly by a specialist.',
      specialist: 'Neurologist',
      selfCareTips: [
        'Rest in a quiet, dark room',
        'Apply a cold compress to your forehead',
        'Stay hydrated and avoid screen time',
        'Practice relaxation techniques',
      ],
    ),
    HealthCategory(
      name: 'Cardiovascular',
      emoji: '❤️',
      area: 'cardiovascular system',
      symptoms: [
        'chest pain', 'palpitations', 'shortness of breath', 'dizziness',
        'fatigue', 'swelling', 'irregular heartbeat', 'rapid heartbeat',
      ],
      redFlagSymptoms: [
        'chest pain', 'palpitations', 'irregular heartbeat',
        'rapid heartbeat',
      ],
      mildDescription:
          'The symptoms could be related to stress, caffeine, or mild cardiovascular strain.',
      moderateDescription:
          'The symptoms may indicate a cardiovascular concern such as elevated blood pressure or arrhythmia.',
      severeDescription:
          'The symptoms suggest a cardiovascular issue that requires prompt medical evaluation.',
      specialist: 'Cardiologist',
      selfCareTips: [
        'Rest and avoid physical exertion',
        'Reduce caffeine and salt intake',
        'Practice deep breathing exercises',
        'Monitor your blood pressure if possible',
      ],
    ),
    HealthCategory(
      name: 'Musculoskeletal',
      emoji: '🦴',
      area: 'muscles and joints',
      symptoms: [
        'joint pain', 'muscle pain', 'back pain', 'neck pain', 'stiffness',
        'swelling', 'weakness', 'body aches', 'muscle cramps',
      ],
      redFlagSymptoms: ['sudden weakness', 'severe back pain'],
      mildDescription:
          'The symptoms may indicate muscle strain, minor joint irritation, or general body fatigue.',
      moderateDescription:
          'The symptoms may indicate a musculoskeletal condition such as arthritis or a sprain that may benefit from evaluation.',
      severeDescription:
          'The symptoms suggest a musculoskeletal issue that needs medical attention.',
      specialist: 'Orthopedist or Rheumatologist',
      selfCareTips: [
        'Apply ice or heat to affected areas',
        'Rest and avoid overexertion',
        'Gentle stretching exercises',
        'Over-the-counter pain relief if appropriate',
      ],
    ),
    HealthCategory(
      name: 'Urinary',
      emoji: '💧',
      area: 'urinary system',
      symptoms: [
        'burning urination', 'frequent urination', 'cloudy urine',
        'pelvic pain', 'strong urine smell', 'burning sensation',
        'lower back pain',
      ],
      redFlagSymptoms: ['severe pain', 'high fever'],
      mildDescription:
          'The symptoms may indicate mild urinary irritation, possibly from dehydration.',
      moderateDescription:
          'The symptoms may indicate a urinary tract issue such as a UTI that may need treatment.',
      severeDescription:
          'The symptoms suggest a urinary condition that should be evaluated by a specialist.',
      specialist: 'Urologist or Internist',
      selfCareTips: [
        'Drink plenty of water',
        'Avoid caffeine and alcohol',
        'Maintain proper hygiene',
        'Do not delay urination',
      ],
    ),
    HealthCategory(
      name: 'Allergic / Immunological',
      emoji: '🤧',
      area: 'immune system',
      symptoms: [
        'sneezing', 'itchy eyes', 'watery eyes', 'rash', 'itching',
        'hives', 'congestion', 'runny nose', 'skin redness', 'swelling',
      ],
      redFlagSymptoms: ['difficulty breathing', 'severe swelling'],
      mildDescription:
          'The symptoms may indicate a mild allergic reaction such as seasonal allergies or mild skin sensitivity.',
      moderateDescription:
          'The symptoms may indicate a notable allergic or immune response that may benefit from antihistamine treatment.',
      severeDescription:
          'The symptoms suggest a significant allergic reaction. Seek medical attention promptly.',
      specialist: 'Allergist or Dermatologist',
      selfCareTips: [
        'Avoid known allergens',
        'Use over-the-counter antihistamines if appropriate',
        'Apply cool compresses to itchy areas',
        'Keep windows closed during high pollen seasons',
      ],
    ),
    HealthCategory(
      name: 'General Infection',
      emoji: '🤒',
      area: 'general health',
      symptoms: [
        'fever', 'chills', 'fatigue', 'body aches', 'sweating',
        'weakness', 'loss of appetite', 'tired', 'exhaustion',
      ],
      redFlagSymptoms: ['high fever', 'severe fatigue', 'confusion'],
      mildDescription:
          'The symptoms may indicate a mild viral infection or general fatigue from overexertion.',
      moderateDescription:
          'The symptoms may indicate an ongoing infection such as the flu or a viral illness.',
      severeDescription:
          'The symptoms suggest a significant infection that needs medical evaluation.',
      specialist: 'Internist (General Practitioner)',
      selfCareTips: [
        'Rest and get adequate sleep',
        'Stay well hydrated',
        'Monitor your temperature regularly',
        'Eat light, nutritious meals',
      ],
    ),
    HealthCategory(
      name: 'Ear, Nose & Throat',
      emoji: '👂',
      area: 'ear, nose, and throat',
      symptoms: [
        'sore throat', 'difficulty swallowing', 'ear pain', 'hoarseness',
        'swollen tonsils', 'neck pain', 'nasal congestion', 'post-nasal drip',
      ],
      redFlagSymptoms: ['difficulty breathing', 'unable to swallow'],
      mildDescription:
          'The symptoms may indicate a mild throat or sinus irritation.',
      moderateDescription:
          'The symptoms may indicate an ENT condition such as tonsillitis or sinusitis.',
      severeDescription:
          'The symptoms suggest an ENT issue that should be seen by a specialist.',
      specialist: 'ENT Specialist',
      selfCareTips: [
        'Gargle with warm salt water',
        'Stay hydrated with warm fluids',
        'Use throat lozenges for comfort',
        'Avoid irritants like smoke',
      ],
    ),
    HealthCategory(
      name: 'Metabolic / Endocrine',
      emoji: '⚖️',
      area: 'metabolic system',
      symptoms: [
        'excessive thirst', 'frequent urination', 'weight loss',
        'blurred vision', 'fatigue', 'slow healing wounds',
        'increased hunger',
      ],
      redFlagSymptoms: [
        'excessive thirst', 'frequent urination', 'unexplained weight loss',
      ],
      mildDescription:
          'The symptoms could be related to lifestyle factors like diet or hydration levels.',
      moderateDescription:
          'The symptoms may indicate a metabolic concern such as blood sugar imbalance that should be checked.',
      severeDescription:
          'The symptoms suggest a metabolic or endocrine condition that requires medical evaluation.',
      specialist: 'Endocrinologist or Internist',
      selfCareTips: [
        'Maintain a balanced diet',
        'Stay properly hydrated',
        'Monitor any changes in symptoms',
        'Keep a regular eating schedule',
      ],
    ),
  ];

  /// Analyze user symptoms and return preliminary assessments
  static List<SymptomAnalysis> analyzeSymptoms(List<String> userSymptoms) {
    final List<SymptomAnalysis> analyses = [];
    final normalizedInput =
        userSymptoms.map((s) => s.toLowerCase().trim()).toList();

    for (var category in healthCategories) {
      int matchCount = 0;
      final List<String> matched = [];
      bool hasRedFlag = false;

      for (var userSym in normalizedInput) {
        for (var catSym in category.symptoms) {
          if (catSym.toLowerCase().contains(userSym) ||
              userSym.contains(catSym.toLowerCase())) {
            matchCount++;
            if (!matched.contains(catSym)) matched.add(catSym);
            // Check red flags
            for (var rf in category.redFlagSymptoms) {
              if (rf.toLowerCase().contains(userSym) ||
                  userSym.contains(rf.toLowerCase())) {
                hasRedFlag = true;
              }
            }
            break;
          }
        }
      }

      if (matchCount == 0) continue;

      final double score = matchCount / category.symptoms.length;
      String severity;
      String description;
      bool shouldSeeDoctor;
      String recommendation;

      if (hasRedFlag || score > 0.5) {
        severity = 'Seek Medical Attention';
        description = category.severeDescription;
        shouldSeeDoctor = true;
        recommendation =
            'It is recommended to consult a ${category.specialist} as soon as possible.';
      } else if (score > 0.25) {
        severity = 'Moderate';
        description = category.moderateDescription;
        shouldSeeDoctor = true;
        recommendation =
            'It is recommended to consult a ${category.specialist} if the symptoms persist.';
      } else {
        severity = 'Mild';
        description = category.mildDescription;
        shouldSeeDoctor = false;
        recommendation =
            'This appears mild. Try self-care measures, but see a doctor if symptoms persist beyond a few days.';
      }

      analyses.add(SymptomAnalysis(
        categoryName: category.name,
        emoji: category.emoji,
        description: description,
        severity: severity,
        matchScore: score * 100,
        matchedSymptoms: matched,
        recommendation: recommendation,
        specialist: category.specialist,
        selfCareTips: category.selfCareTips,
        shouldSeeDoctor: shouldSeeDoctor,
      ));
    }

    analyses.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return analyses.take(2).toList();
  }

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
    } catch (_) {}
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
    } catch (_) {}
    return [];
  }
}
