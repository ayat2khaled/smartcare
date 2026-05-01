class SymptomAnalysis {
  final List<String> possibilities;
  final String severity;
  final bool needsDoctor;
  final String specialist;
  final String advice;

  SymptomAnalysis({
    required this.possibilities,
    required this.severity,
    required this.needsDoctor,
    required this.specialist,
    required this.advice,
  });

  factory SymptomAnalysis.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysis(
      possibilities: List<String>.from(json['possibilities'] ?? []),
      severity: json['severity'] ?? 'Unknown',
      needsDoctor: json['needs_doctor'] ?? false,
      specialist: json['specialist'] ?? 'None',
      advice: json['advice'] ?? '',
    );
  }
}