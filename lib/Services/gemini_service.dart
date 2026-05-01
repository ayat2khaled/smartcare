import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyBHX89SzvZfzi7ui3qqaMHcgMzUXuPXAJI';

  static Future<String> getChatResponse(String userMessage, {bool isEmergency = false, String triggerWord = ""}) async {
    String systemInstructionText = "You are a medical triage assistant.\n\n"
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
        "}";

    if (isEmergency) {
      systemInstructionText += "\n\nCRITICAL EMERGENCY DETECTED by system rule (User mentioned '$triggerWord').\n"
          "You MUST set 'severity' to 'High'.\n"
          "You MUST set 'needs_doctor' to true.\n"
          "You MUST set 'specialist' to 'Emergency Medicine'.\n"
          "Provide dynamic, highly urgent, and personalized 'advice' tailored to '$triggerWord' instructing them to seek immediate emergency help.";
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstructionText),
    );

    final chat = model.startChat();
    final response = await chat.sendMessage(Content.text(userMessage));
    
    return response.text ?? "";
  }
}
