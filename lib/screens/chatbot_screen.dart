import 'package:flutter/material.dart';
import 'package:first_project/Services/prediction_service.dart';

class MedicalChatScreen extends StatefulWidget {
  const MedicalChatScreen({super.key});

  @override
  State<MedicalChatScreen> createState() => _MedicalChatScreenState();
}

// Conversation states
enum _ChatState { askGender, askAge, ready }

class _MedicalChatScreenState extends State<MedicalChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // User info collected through conversation
  _ChatState _state = _ChatState.askGender;
  String _gender = "";
  int _age = 0;

  @override
  void initState() {
    super.initState();
    // Start by greeting, then ask for gender after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _addBotMessage(
        "👋 Welcome to SmartCare!\n\n"
        "I'm your AI-powered Symptom Checker. "
        "Tell me what you're feeling, and I'll help identify possible conditions "
        "and guide you to the right specialist.\n\n"
        "⚠️ Please note: This is a preliminary analysis only "
        "and does not replace professional medical advice."
      );
      Future.delayed(const Duration(milliseconds: 1000), () {
        _addBotMessage("Let's get started! I just need a couple of quick details first. 😊");
        Future.delayed(const Duration(milliseconds: 600), () {
          _addBotMessage("What is your gender?", type: "gender_options");
        });
      });
    });
  }

  void _addBotMessage(String text, {String type = "text"}) {
    setState(() {
      _messages.add({"role": "bot", "content": text, "type": type});
    });
    _scrollToBottom();
  }

  void _selectGender(String gender) {
    setState(() {
      _messages.add({"role": "user", "content": gender});
    });
    _gender = gender.toLowerCase();
    setState(() => _state = _ChatState.askAge);
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 200), () {
      _addBotMessage("Welcome! 😊 Nice to meet you.\n\nLet's get started with your profile.");
      Future.delayed(const Duration(milliseconds: 400), () {
        _addBotMessage("How old are you?");
      });
    });
  }

  Future<void> _handleSend() async {
    if (_controller.text.trim().isEmpty) return;
    String userMsg = _controller.text.trim();

    setState(() {
      _messages.add({"role": "user", "content": userMsg});
    });
    _controller.clear();
    _scrollToBottom();

    switch (_state) {
      case _ChatState.askGender:
        // Should not happen since gender is now buttons, but fallback
        _selectGender(userMsg);
        break;
      case _ChatState.askAge:
        _handleAgeInput(userMsg);
        break;
      case _ChatState.ready:
        await _handleSymptomInput(userMsg);
        break;
    }
  }

  void _handleAgeInput(String input) {
    final parsed = int.tryParse(input.trim());
    if (parsed == null || parsed <= 0 || parsed > 120) {
      _addBotMessage("Please enter a valid age (e.g. 25).");
      return;
    }
    _age = parsed;
    setState(() => _state = _ChatState.ready);
    _addBotMessage("Perfect! ✅\n\nYou're a $_gender, age $_age.\n\n"
        "Now describe your symptoms and I'll analyze them for you. 🩺");
  }

  Future<void> _handleSymptomInput(String symptoms) async {
    setState(() => _isLoading = true);
    _scrollToBottom();

    try {
      final result = await PredictionService.predict(
        text: symptoms,
        gender: _gender,
        age: _age,
      );

      if (result.predictions.isNotEmpty) {
        // Determine severity based on top probability
        final topProb = result.predictions.first.probability;
        String severity;
        if (topProb >= 0.5) {
          severity = "High";
        } else if (topProb >= 0.2) {
          severity = "Medium";
        } else {
          severity = "Low";
        }

        // Add the analysis result as a special message type
        setState(() {
          _messages.add({
            "role": "bot",
            "type": "analysis",
            "content": "",
            "result": result,
            "severity": severity,
          });
        });
        _scrollToBottom();

        // Prompt for another check
        Future.delayed(const Duration(milliseconds: 600), () {
          _addBotMessage("Feel free to describe any other symptoms if you'd like another analysis. 💬");
        });
      } else {
        _addBotMessage(
          "I couldn't recognize the symptoms you described.\n\n"
          "Could you try again with clearer or more specific terms?\n\n"
          "For example: \"I have a headache and fever\" or \"my stomach hurts and I feel nauseous\".",
          type: "error",
        );
      }
    } catch (e) {
      _addBotMessage(
        "I wasn't able to understand what you wrote properly.\n\n"
        "Please try describing your symptoms in a different way.\n\n"
        "💡 Tip: Use simple, clear descriptions like:\n"
        "  • \"I have a headache\"\n"
        "  • \"My throat hurts and I have a fever\"\n"
        "  • \"I feel dizzy and tired\"",
        type: "error",
      );
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _state = _ChatState.askGender;
      _gender = "";
      _age = 0;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _addBotMessage(
        "👋 Welcome to SmartCare!\n\n"
        "I'm your AI-powered Symptom Checker. "
        "Tell me what you're feeling, and I'll help identify possible conditions "
        "and guide you to the right specialist.\n\n"
        "⚠️ Please note: This is a preliminary analysis only "
        "and does not replace professional medical advice."
      );
      Future.delayed(const Duration(milliseconds: 1000), () {
        _addBotMessage("Let's get started! I just need a couple of quick details first. 😊");
        Future.delayed(const Duration(milliseconds: 600), () {
          _addBotMessage("What is your gender?", type: "gender_options");
        });
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F6F8);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputFieldBg = isDark ? const Color(0xFF253350) : Colors.grey[100];
    final inputBorder = isDark ? const Color(0xFF334155) : Colors.grey[300]!;
    final hintColor = isDark ? const Color(0xFF64748B) : Colors.grey;

    String hintText;
    switch (_state) {
      case _ChatState.askGender:
        hintText = "Select your gender above...";
        break;
      case _ChatState.askAge:
        hintText = "Enter your age...";
        break;
      case _ChatState.ready:
        hintText = "Describe your symptoms...";
        break;
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55.0),
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.health_and_safety, color: Colors.white, size: 28),
          ),
          titleSpacing: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SmartCare",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Preliminary analysis only - not a medical consultation.",
                style: TextStyle(color: Colors.white70, fontSize: 10),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _resetChat,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['role'] == "user") {
                  return _buildUserBubble(msg['content'], primaryColor);
                } else {
                  final type = msg['type'] ?? 'text';
                  if (type == "gender_options") {
                    return _buildGenderOptions(msg['content'], primaryColor);
                  } else if (type == "analysis") {
                    return _buildAnalysisCard(msg['result'], msg['severity'], primaryColor);
                  } else if (type == "error") {
                    return _buildErrorBubble(msg['content'], primaryColor);
                  } else {
                    return _buildBotBubble(msg['content'], primaryColor);
                  }
                }
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                  ),
                  const SizedBox(width: 8),
                  Text("Analyzing...", style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey)),
                ],
              ),
            ),
          if (_state != _ChatState.askGender) _buildInputArea(primaryColor, hintText, isDark, inputBg, inputFieldBg, inputBorder, hintColor),
        ],
      ),
    );
  }

  // ─── User message bubble ───
  Widget _buildUserBubble(String message, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ─── Bot text bubble ───
  Widget _buildBotBubble(String text, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor,
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEBEBEB),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : Colors.black87, fontSize: 15, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Error bubble (visually distinct) ───
  Widget _buildErrorBubble(String text, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEF4444),
            child: Icon(Icons.warning_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D1B1B) : const Color(0xFFFEF2F2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFCA5A5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626), size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "Couldn't analyze",
                        style: TextStyle(
                          color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : Colors.grey[800], fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Gender selection options ───
  Widget _buildGenderOptions(String label, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool alreadySelected = _state != _ChatState.askGender;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor,
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEBEBEB),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : Colors.black87, fontSize: 15, height: 1.4),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildOptionButton(
                      icon: Icons.male,
                      label: "Male",
                      color: const Color(0xFF3B82F6),
                      onTap: alreadySelected ? null : () => _selectGender("Male"),
                      disabled: alreadySelected,
                    ),
                    const SizedBox(width: 10),
                    _buildOptionButton(
                      icon: Icons.female,
                      label: "Female",
                      color: const Color(0xFFEC4899),
                      onTap: alreadySelected ? null : () => _selectGender("Female"),
                      disabled: alreadySelected,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey[300] : color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: disabled ? [] : [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Analysis result card ───
  Widget _buildAnalysisCard(PredictionResult result, String severity, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color severityColor;
    IconData severityIcon;
    String severityDescription;

    switch (severity) {
      case "High":
        severityColor = const Color(0xFFEF4444);
        severityIcon = Icons.warning_rounded;
        severityDescription = "Your symptoms indicate a potentially serious condition. "
            "We strongly recommend seeing a doctor as soon as possible.";
        break;
      case "Medium":
        severityColor = const Color(0xFFF59E0B);
        severityIcon = Icons.info_rounded;
        severityDescription = "Your symptoms suggest a moderate concern. "
            "It's a good idea to schedule a doctor visit to be safe.";
        break;
      default:
        severityColor = const Color(0xFF22C55E);
        severityIcon = Icons.check_circle_rounded;
        severityDescription = "Your symptoms appear to be minor. "
            "Monitor them and consult a doctor if they persist or worsen.";
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor,
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Severity header ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: severityColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(severityIcon, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$severity Severity",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                severity == "High"
                                    ? "Immediate attention recommended"
                                    : severity == "Medium"
                                        ? "Doctor visit recommended"
                                        : "Monitor your symptoms",
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Body ──
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Severity explanation
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: severityColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: severityColor.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline, color: severityColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  severityDescription,
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFFCBD5E1) : Colors.grey[800],
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),



                        // Possible conditions
                        _buildCardSectionTitle("🏥  Possible Conditions"),
                        const SizedBox(height: 8),
                        ...result.predictions.map((p) {
                          final percent = (p.probability * 100).toStringAsFixed(1);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.disease,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: isDark ? const Color(0xFFE2E8F0) : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: p.probability,
                                          backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey[200],
                                          color: _getBarColor(p.probability),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "$percent%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _getBarColor(p.probability),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 12),

                        // Disclaimer
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF253350) : Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, size: 16, color: isDark ? const Color(0xFF64748B) : Colors.grey[500]),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "This is a preliminary analysis only and not a medical diagnosis. Please consult a healthcare professional.",
                                  style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey[600], fontSize: 11, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFFE2E8F0) : Colors.black87,
      ),
    );
  }

  Color _getBarColor(double probability) {
    if (probability >= 0.5) return const Color(0xFFEF4444);
    if (probability >= 0.2) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  // ─── Input area ───
  Widget _buildInputArea(Color primaryColor, String hintText, bool isDark, Color inputBg, Color? inputFieldBg, Color inputBorder, Color hintColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: inputBg,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: inputFieldBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: inputBorder),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: TextStyle(color: isDark ? const Color(0xFFE2E8F0) : Colors.black87),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: hintColor),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _isLoading ? null : _handleSend,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: primaryColor,
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}