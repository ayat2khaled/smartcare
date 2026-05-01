import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String apiKey = "YOUR_OPENAI_API_KEY";

  static Future<String> getChatResponse(String userMessage, {bool isEmergency = false, String triggerWord = ""}) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    List<Map<String, String>> messages = [
      {
        "role": "system",
        "content": "You are a medical triage assistant.\n\n"
            "Rules:\n"
            "- Analyze the user's symptoms\n"
            "- Give general possibilities (possible conditions)\n"
            "- Determine the severity of these symptoms (Low, Medium, High)\n"
            "- Tell the user whether they need to see a doctor or not based on these symptoms\n"
            "- If they need to see a doctor, recommend which specialist to go to\n"
            "- Always include a medical disclaimer\n\n"
            "Return ONLY valid JSON:\n"
            "{\n"
            "  \"possibilities\": [\"condition 1\", \"condition 2\"],\n"
            "  \"severity\": \"Low / Medium / High\",\n"
            "  \"needs_doctor\": true/false,\n"
            "  \"specialist\": \"Specialist Name or None\",\n"
            "  \"advice\": \"Your advice here\"\n"
            "}"
      }
    ];

    if (isEmergency) {
      messages.add({
        "role": "system",
        "content": "CRITICAL EMERGENCY DETECTED by system rule (User mentioned '$triggerWord').\n"
            "You MUST set 'severity' to 'High'.\n"
            "You MUST set 'needs_doctor' to true.\n"
            "You MUST set 'specialist' to 'Emergency Medicine'.\n"
            "Provide dynamic, highly urgent, and personalized 'advice' tailored to '$triggerWord' instructing them to seek immediate emergency help."
      });
    }

    messages.add({
      "role": "user",
      "content": userMessage
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("Failed to connect to OpenAI");
    }
  }
}