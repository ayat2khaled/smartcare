class Doctor {
  final String name;
  final String specialty;
  final String image;

  Doctor({
    required this.name,
    required this.specialty,
    required this.image,
  });
}

class Hospital {
  final String name;
  final String image;
  final String address;
  final String rating;
  final String distance;
  final Map<String, dynamic>? workingHours;
  final String phone;
  final String ambulanceNumber;
  final double latitude;
  final double longitude;

  Hospital({
    required this.name,
    required this.image,
    required this.address,
    required this.rating,
    required this.distance,
    this.workingHours,
    this.phone = '',
    this.ambulanceNumber = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
  });
}