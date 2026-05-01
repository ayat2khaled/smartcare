
class Booking {
  final String id;
  final String status;
  final String date;
  final String name;
  final String hospital;
  final String image;
  final String experience;
  final String rating;
  final int appliedPoints;
  final List<String> availableDays;
  final Map<String, List<String>> schedule;

  Booking({
    required this.id,
    this.status = "Upcoming",
    required this.date,
    required this.name,
    required this.hospital,
    required this.image,
    required this.experience,
    required this.rating,
    this.appliedPoints = 0,
    this.availableDays = const [],
    this.schedule = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'date': date,
    'name': name,
    'hospital': hospital,
    'image': image,
    'experience': experience,
    'rating': rating,
    'appliedPoints': appliedPoints,
    'availableDays': availableDays,
    'schedule': schedule.map((key, value) => MapEntry(key, value)),
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    status: json['status'] as String? ?? "Upcoming",
    date: json['date'] as String,
    name: json['name'] as String,
    hospital: json['hospital'] as String,
    image: json['image'] as String,
    experience: json['experience'] as String,
    rating: json['rating'] as String,
    appliedPoints: json['appliedPoints'] as int? ?? 0,
    availableDays: (json['availableDays'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
    schedule: (json['schedule'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, (value as List<dynamic>).map((e) => e as String).toList())) ?? {},
  );
}