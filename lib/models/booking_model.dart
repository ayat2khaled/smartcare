
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
}