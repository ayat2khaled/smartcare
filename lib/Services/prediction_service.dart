import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionResult {
  final List<DiseasePrediction> predictions;
  final List<String> symptomsFound;

  PredictionResult({
    required this.predictions,
    required this.symptomsFound,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictions: (json['predictions'] as List<dynamic>)
          .map((p) => DiseasePrediction.fromJson(p))
          .toList(),
      symptomsFound: List<String>.from(json['symptoms_found'] ?? []),
    );
  }
}

class DiseasePrediction {
  final String disease;
  final double probability;

  DiseasePrediction({required this.disease, required this.probability});

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) {
    return DiseasePrediction(
      disease: json['disease'] ?? '',
      probability: (json['probability'] as num).toDouble(),
    );
  }
}

class PredictionService {
  static const String _baseUrl = "http://10.0.2.2:5000"; // Android emulator -> localhost

  /// Sends the user's symptoms, gender, and age to the prediction API.
  static Future<PredictionResult> predict({
    required String text,
    required String gender,
    required int age,
  }) async {
    final url = Uri.parse("$_baseUrl/predict");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": text,
        "gender": gender,
        "age": age,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PredictionResult.fromJson(data);
    } else {
      throw Exception("Failed to get prediction: ${response.statusCode}");
    }
  }
}
