// File: lib/data/models/analysis_data.dart
// 📊 분석 데이터 모델 클래스

import 'analysis_key_event.dart';
import 'analysis_metadata.dart';
import 'emotion_data_point.dart';
import 'personality_analysis.dart';

/// 📊 분석 데이터 모델 클래스
class AnalysisData {
  const AnalysisData({
    required this.someIndex,
    required this.developmentPossibility,
    required this.aiSummary,
    required this.partnerMbti,
    required this.partnerTags,
    required this.communicationStyle,
    required this.emotionData,
    required this.keyEvents,
    required this.recommendedTopics,
    required this.improvementTips,
    required this.metadata,
    this.personalityAnalysis,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) => AnalysisData(
    someIndex: json['someIndex'] ?? 0,
    developmentPossibility: json['developmentPossibility'] ?? 0,
    aiSummary: json['aiSummary'] ?? '',
    partnerMbti: json['partnerMbti'] ?? '',
    partnerTags: List<String>.from(json['partnerTags'] ?? []),
    communicationStyle: json['communicationStyle'] ?? '',
    emotionData:
        (json['emotionData'] as List<dynamic>?)
            ?.map((e) => EmotionDataPoint.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    keyEvents:
        (json['keyEvents'] as List<dynamic>?)
            ?.map((e) => AnalysisKeyEvent.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    recommendedTopics: List<String>.from(json['recommendedTopics'] ?? []),
    improvementTips: List<String>.from(json['improvementTips'] ?? []),
    metadata: AnalysisMetadata.fromJson(json['analysisMetadata'] ?? {}),
    personalityAnalysis: json['personalityAnalysis'] != null
        ? PersonalityAnalysis.fromJson(json['personalityAnalysis'])
        : null,
  );
  final int someIndex;
  final int developmentPossibility;
  final String aiSummary;
  final String partnerMbti;
  final List<String> partnerTags;
  final String communicationStyle;
  final List<EmotionDataPoint> emotionData;
  final List<AnalysisKeyEvent> keyEvents;
  final List<String> recommendedTopics;
  final List<String> improvementTips;
  final AnalysisMetadata metadata;
  final PersonalityAnalysis? personalityAnalysis;

  Map<String, dynamic> toJson() => {
    'someIndex': someIndex,
    'developmentPossibility': developmentPossibility,
    'aiSummary': aiSummary,
    'partnerMbti': partnerMbti,
    'partnerTags': partnerTags,
    'communicationStyle': communicationStyle,
    'emotionData': emotionData.map((item) => item.toJson()).toList(),
    'keyEvents': keyEvents.map((item) => item.toJson()).toList(),
    'recommendedTopics': recommendedTopics,
    'improvementTips': improvementTips,
    'analysisMetadata': metadata.toJson(),
    if (personalityAnalysis != null)
      'personalityAnalysis': personalityAnalysis!.toJson(),
  };
}
