class SymptomService {
  static List<String> extractSymptoms(String text) {
    final symptoms = <String>[];

    if (text.contains("headache")) symptoms.add("headache");
    if (text.contains("Fever")) symptoms.add("Fever");
    if (text.contains("Vomiting")) symptoms.add("Vomiting");
    if (text.contains("Chest pain")) symptoms.add("Chest pain");
    if (text.contains("Shortness of breath")) symptoms.add("Shortness of breath");
    if (text.contains("Dizziness")) symptoms.add("Dizziness");

    return symptoms;
  }
  static bool isHighRisk(List<String> symptoms) {
    return symptoms.contains("Chest pain") ||
           symptoms.contains("Shortness of breath");
  }

}