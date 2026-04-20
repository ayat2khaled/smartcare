class DoctorModel {
  final String name;
  final String specialization;
  final String location;
  final double rating;
  final int experience;
  final int patients;
  final int reviews;
  final String image;
  final String about;
  final List<String> availableDays;
  final Map<String, List<String>> schedule;
  final Map<String, int> packagePrices;

  DoctorModel({
    required this.name,
    required this.specialization,
    required this.location,
    required this.rating,
    required this.experience,
    required this.patients,
    required this.reviews,
    required this.image,
    required this.about,
    required this.availableDays,
    required this.schedule,
    required this.packagePrices,
  });


  factory DoctorModel.fromFirestore(Map<String, dynamic> data) {
    return DoctorModel(
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      experience: data['experience'] ?? 0,
      patients: data['patients'] ?? 0,
      reviews: data['reviews'] ?? 0,
      image: data['image'] ?? '',
      about: data['about'] ?? '',
      availableDays: List<String>.from(data['availableDays'] ?? []),
      schedule: (data['schedule'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ) ?? {},
      packagePrices: (data['packagePrices'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {'Messaging': 20, 'Voice Call': 40, 'Video Call': 60, 'In Person': 80},
    );
  }
}