import 'dart:convert';

import 'package:first_project/models/chat_model.dart';

import 'gemini_service.dart';

class ChatService {
  // Hardcoded emergency rules for safety
  static final List<String> emergencyKeywords = [
    "chest pain",
    "shortness of breath",
    "cannot breathe",
    "can't breathe",
    "heart attack",
    "stroke",
    "coughing blood",
    "left arm numb",
    "sudden weakness",
    "drooping face",
    "suicide",
    "kill myself"
  ];

  static Future<SymptomAnalysis> processMessage(String message) async {
    final lowerMessage = message.toLowerCase();
    bool isEmergency = false;
    String triggerWord = "";

    // 1. Rule-Based Safety Net (Detection)
    for (var keyword in emergencyKeywords) {
      if (lowerMessage.contains(keyword)) {
        isEmergency = true;
        triggerWord = keyword;
        break; // Flag as emergency and stop checking
      }
    }

    // 2. AI Intelligence (Dynamic Generation)
    try {
      // We pass the emergency flag to Gemini so it can dynamically generate
      // the urgent response while strictly enforcing High Risk.
      final response = await GeminiService.getChatResponse(
        message, 
        isEmergency: isEmergency, 
        triggerWord: triggerWord,
      );
      
      // Handle potential markdown formatting from AI (e.g., ```json ... ```)
      String jsonStr = response;
      if (jsonStr.contains("```json")) {
        jsonStr = jsonStr.split("```json")[1].split("```")[0].trim();
      } else if (jsonStr.contains("```")) {
        jsonStr = jsonStr.split("```")[1].split("```")[0].trim();
      }
      
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      return SymptomAnalysis.fromJson(json);
    } catch (e) {
      return SymptomAnalysis(
        possibilities: ["Analysis Failed"],
        severity: isEmergency ? "High" : "Unknown",
        needsDoctor: isEmergency ? true : false,
        advice: isEmergency 
            ? "CRITICAL: Seek immediate medical attention or call an ambulance right away. Do not wait." 
            : "Unable to process your symptoms right now. If you feel unwell, please consult a doctor directly.",
        specialist: isEmergency ? "Emergency Medicine" : "General Practitioner",
      );
    }
  }
}