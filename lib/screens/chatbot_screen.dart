import 'package:first_project/Services/data_service.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<Map<String, dynamic>>? results;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.results,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  List<String> _collectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "👋 Hello! I'm SmartCare AI Assistant.\n\nI can help you identify possible illnesses based on your symptoms.\n\n⚠️ Note: This is for informational purposes only. Always consult a qualified doctor for diagnosis and treatment.\n\nPlease describe your symptoms (e.g., \"I have fever, headache, and sore throat\"):",
    );
  }

  void _addBotMessage(String text,
      {List<Map<String, dynamic>>? results}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        time: DateTime.now(),
        results: results,
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      _processInput(text.toLowerCase());
    });
  }

  void _processInput(String input) {
    final newSymptoms = _extractSymptoms(input);

    if (newSymptoms.isEmpty &&
        !input.contains('yes') &&
        !input.contains('no') &&
        !input.contains('done') &&
        !input.contains('analyze') &&
        !input.contains('check') &&
        !input.contains('result')) {
      setState(() => _isTyping = false);
      _addBotMessage(
        "I couldn't detect specific symptoms in your message. Please describe your symptoms more clearly.\n\nFor example: \"I have a fever, sore throat, and body aches\"",
      );
      return;
    }

    if (newSymptoms.isNotEmpty) {
      _collectedSymptoms.addAll(newSymptoms);
      _collectedSymptoms = _collectedSymptoms.toSet().toList();
    }

    if (_collectedSymptoms.isEmpty) {
      setState(() => _isTyping = false);
      _addBotMessage(
        "Please tell me your symptoms so I can help identify possible conditions.",
      );
      return;
    }

    final results = DataService.matchSymptoms(_collectedSymptoms);

    setState(() => _isTyping = false);

    if (results.isEmpty) {
      _addBotMessage(
        "I couldn't find a clear match for your symptoms: ${_collectedSymptoms.join(', ')}.\n\nPlease consult a doctor for proper evaluation. Would you like to add more symptoms?",
      );
    } else {
      String symptomsText = _collectedSymptoms.join(', ');
      _addBotMessage(
        "Based on your symptoms: $symptomsText\n\nHere are the most likely conditions:",
        results: results,
      );

      Future.delayed(const Duration(milliseconds: 400), () {
        _addBotMessage(
          "⚕️ Important Reminder: These are possible conditions based on symptoms only. Please visit a doctor for accurate diagnosis.\n\nWould you like to check other symptoms? Just type them!",
        );
        _collectedSymptoms = [];
      });
    }
  }

  List<String> _extractSymptoms(String input) {
    const symptomKeywords = [
      'fever', 'cough', 'headache', 'sore throat', 'fatigue', 'tired',
      'nausea', 'vomiting', 'diarrhea', 'chest pain', 'shortness of breath',
      'runny nose', 'sneezing', 'body ache', 'muscle pain', 'joint pain',
      'dizziness', 'blurred vision', 'rash', 'itching', 'swelling',
      'loss of taste', 'loss of smell', 'abdominal pain', 'stomach pain',
      'back pain', 'neck pain', 'difficulty breathing', 'wheezing',
      'palpitations', 'anxiety', 'depression', 'insomnia', 'weakness',
      'pale skin', 'cold hands', 'frequent urination', 'excessive thirst',
      'weight loss', 'burning sensation', 'cloudy urine', 'chills',
      'light sensitivity', 'sound sensitivity', 'congestion',
      'difficulty swallowing', 'sweating', 'itchy eyes', 'watery eyes',
    ];

    List<String> found = [];
    for (var keyword in symptomKeywords) {
      if (input.contains(keyword)) {
        found.add(keyword);
      }
    }
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.medical_services,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SmartCare AI',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text('Symptom Checker',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _messages.clear();
                _collectedSymptoms.clear();
              });
              _addBotMessage(
                "👋 Chat reset! Please describe your symptoms and I'll help identify possible conditions.",
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator(cardColor);
                }
                final msg = _messages[index];
                return _buildMessageBubble(
                    msg, cardColor, textColor, isDark, primaryColor);
              },
            ),
          ),

          if (_messages.length == 1) _buildQuickChips(isDark, primaryColor),

          _buildInputField(cardColor, textColor, isDark, primaryColor),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, Color cardColor,
      Color textColor, bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: msg.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.medical_services,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: msg.isUser ? primaryColor : cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: msg.isUser
                          ? const Radius.circular(18)
                          : Radius.zero,
                      bottomRight: msg.isUser
                          ? Radius.zero
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser ? Colors.white : textColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (msg.isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                  child: Icon(Icons.person,
                      color: isDark ? Colors.white60 : Colors.grey, size: 18),
                ),
              ],
            ],
          ),

          // Disease results
          if (msg.results != null && msg.results!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Column(
                children: msg.results!.map((result) {
                  final disease = result['disease'] as DiseaseInfo;
                  final confidence =
                      (result['confidence'] as double).toInt();
                  final matched =
                      result['matchedSymptoms'] as List<String>;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_hospital,
                                color: primaryColor, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                disease.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: confidence > 50
                                    ? Colors.orange.withValues(alpha: 0.15)
                                    : Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$confidence% match',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: confidence > 50
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          disease.description,
                          style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: matched
                              .map((s) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(s,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: primaryColor)),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined,
                                size: 13, color: Colors.green),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                disease.prevention,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color cardColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.medical_services,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0),
                _dot(200),
                _dot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildQuickChips(bool isDark, Color primaryColor) {
    final chips = [
      '🤒 Fever & headache',
      '😷 Cough & sore throat',
      '😴 Fatigue & dizziness',
      '🤢 Stomach pain & nausea',
      '🫁 Shortness of breath',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips
              .map((chip) => GestureDetector(
                    onTap: () => _handleUserMessage(chip),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        chip,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildInputField(
      Color cardColor, Color textColor, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: textColor),
                onSubmitted: _handleUserMessage,
                decoration: InputDecoration(
                  hintText: 'Describe your symptoms...',
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _handleUserMessage(_controller.text),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
