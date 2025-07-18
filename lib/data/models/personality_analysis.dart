// File: lib/data/models/personality_analysis.dart
// 🧠 성격 분석 데이터 모델

/// 🧠 성격 분석 데이터 모델
class PersonalityAnalysis {
  const PersonalityAnalysis({
    required this.myPersonality,
    required this.partnerPersonality,
    required this.compatibilityScore,
    required this.strengths,
    required this.improvements,
  });

  factory PersonalityAnalysis.fromJson(Map<String, dynamic> json) =>
      PersonalityAnalysis(
        myPersonality: Map<String, int>.from(json['myPersonality'] ?? {}),
        partnerPersonality: Map<String, int>.from(
          json['partnerPersonality'] ?? {},
        ),
        compatibilityScore: json['compatibilityScore'] ?? 0,
        strengths: List<String>.from(json['strengths'] ?? []),
        improvements: List<String>.from(json['improvements'] ?? []),
      );
  final Map<String, int> myPersonality;
  final Map<String, int> partnerPersonality;
  final int compatibilityScore;
  final List<String> strengths;
  final List<String> improvements;

  Map<String, dynamic> toJson() => {
    'myPersonality': myPersonality,
    'partnerPersonality': partnerPersonality,
    'compatibilityScore': compatibilityScore,
    'strengths': strengths,
    'improvements': improvements,
  };

  /// 내 성격을 레이더 차트 데이터로 변환
  List<Map<String, dynamic>> get myRadarData => myPersonality.entries
      .map((entry) => {'label': entry.key, 'value': entry.value.toDouble()})
      .toList();

  /// 상대방 성격을 레이더 차트 데이터로 변환
  List<Map<String, dynamic>> get partnerRadarData => partnerPersonality.entries
      .map((entry) => {'label': entry.key, 'value': entry.value.toDouble()})
      .toList();
}
