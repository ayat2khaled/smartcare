import 'package:first_project/models/chat_model.dart';

class AIService {
  static Future<SymptomAnalysis> analyze(List<String> symptoms) async {
    return SymptomAnalysis(
      possibilities: ["Gastroenteritis", "Influenza"],
      severity: "Medium",
      needsDoctor: true,
      specialist: "Gastroenterology",
      advice: "Drink fluids and rest",
    );
  }
}