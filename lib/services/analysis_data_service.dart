// File: lib/services/analysis_data_service.dart
// 🎯 분석 데이터 로딩 서비스

import 'dart:convert';

import 'package:flutter/services.dart';

/// 📊 분석 데이터 모델 클래스
class AnalysisData {
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

  AnalysisData({
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

  factory AnalysisData.fromJson(Map<String, dynamic> json) {
    return AnalysisData(
      someIndex: json['someIndex'] ?? 0,
      developmentPossibility: json['developmentPossibility'] ?? 0,
      aiSummary: json['aiSummary'] ?? '',
      partnerMbti: json['partnerMbti'] ?? '',
      partnerTags: List<String>.from(json['partnerTags'] ?? []),
      communicationStyle: json['communicationStyle'] ?? '',
      emotionData: (json['emotionData'] as List<dynamic>? ?? [])
          .map((item) => EmotionDataPoint.fromJson(item))
          .toList(),
      keyEvents: (json['keyEvents'] as List<dynamic>? ?? [])
          .map((item) => AnalysisKeyEvent.fromJson(item))
          .toList(),
      recommendedTopics: List<String>.from(json['recommendedTopics'] ?? []),
      improvementTips: List<String>.from(json['improvementTips'] ?? []),
      metadata: AnalysisMetadata.fromJson(json['analysisMetadata'] ?? {}),
      personalityAnalysis: json['personalityAnalysis'] != null 
        ? PersonalityAnalysis.fromJson(json['personalityAnalysis']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      if (personalityAnalysis != null) 'personalityAnalysis': personalityAnalysis!.toJson(),
    };
  }
}

/// 📈 감정 데이터 포인트 모델
class EmotionDataPoint {
  final String time;
  final int myEmotion;
  final int partnerEmotion;
  final String description;

  EmotionDataPoint({
    required this.time,
    required this.myEmotion,
    required this.partnerEmotion,
    required this.description,
  });

  factory EmotionDataPoint.fromJson(Map<String, dynamic> json) {
    return EmotionDataPoint(
      time: json['time'] ?? '',
      myEmotion: json['myEmotion'] ?? 0,
      partnerEmotion: json['partnerEmotion'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'myEmotion': myEmotion,
      'partnerEmotion': partnerEmotion,
      'description': description,
    };
  }

  // LineChart 위젯에서 사용할 수 있는 형태로 변환
  Map<String, dynamic> toChartData() {
    return {
      'time': time,
      'myEmotion': myEmotion,
      'partnerEmotion': partnerEmotion,
    };
  }
}

/// 🎯 주요 이벤트 모델
class AnalysisKeyEvent {
  final String time;
  final String event;
  final String type; // 'positive' 또는 'negative'
  final String description;

  AnalysisKeyEvent({
    required this.time,
    required this.event,
    required this.type,
    required this.description,
  });

  factory AnalysisKeyEvent.fromJson(Map<String, dynamic> json) {
    return AnalysisKeyEvent(
      time: json['time'] ?? '',
      event: json['event'] ?? '',
      type: json['type'] ?? 'positive',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'event': event,
      'type': type,
      'description': description,
    };
  }

  bool get isPositive => type == 'positive';
}

/// 🧠 성격 분석 데이터 모델
class PersonalityAnalysis {
  final Map<String, int> myPersonality;
  final Map<String, int> partnerPersonality;
  final int compatibilityScore;
  final List<String> strengths;
  final List<String> improvements;

  PersonalityAnalysis({
    required this.myPersonality,
    required this.partnerPersonality,
    required this.compatibilityScore,
    required this.strengths,
    required this.improvements,
  });

  factory PersonalityAnalysis.fromJson(Map<String, dynamic> json) {
    return PersonalityAnalysis(
      myPersonality: Map<String, int>.from(json['myPersonality'] ?? {}),
      partnerPersonality: Map<String, int>.from(json['partnerPersonality'] ?? {}),
      compatibilityScore: json['compatibilityScore'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myPersonality': myPersonality,
      'partnerPersonality': partnerPersonality,
      'compatibilityScore': compatibilityScore,
      'strengths': strengths,
      'improvements': improvements,
    };
  }

  /// 내 성격을 레이더 차트 데이터로 변환
  List<Map<String, dynamic>> get myRadarData {
    return myPersonality.entries.map((entry) => {
      'label': entry.key,
      'value': entry.value.toDouble(),
    }).toList();
  }

  /// 상대방 성격을 레이더 차트 데이터로 변환
  List<Map<String, dynamic>> get partnerRadarData {
    return partnerPersonality.entries.map((entry) => {
      'label': entry.key,
      'value': entry.value.toDouble(),
    }).toList();
  }
}

/// 📊 분석 메타데이터 모델
class AnalysisMetadata {
  final int totalMessages;
  final String analysisDate;
  final String conversationPeriod;
  final double responseRate;
  final String averageResponseTime;
  final EmojiUsage emojiUsage;
  final List<String> topKeywords;
  final SentimentScore sentimentScore;

  AnalysisMetadata({
    required this.totalMessages,
    required this.analysisDate,
    required this.conversationPeriod,
    required this.responseRate,
    required this.averageResponseTime,
    required this.emojiUsage,
    required this.topKeywords,
    required this.sentimentScore,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) {
    return AnalysisMetadata(
      totalMessages: json['totalMessages'] ?? 0,
      analysisDate: json['analysisDate'] ?? '',
      conversationPeriod: json['conversationPeriod'] ?? '',
      responseRate: (json['responseRate'] ?? 0.0).toDouble(),
      averageResponseTime: json['averageResponseTime'] ?? '',
      emojiUsage: EmojiUsage.fromJson(json['emojiUsage'] ?? {}),
      topKeywords: List<String>.from(json['topKeywords'] ?? []),
      sentimentScore: SentimentScore.fromJson(json['sentimentScore'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMessages': totalMessages,
      'analysisDate': analysisDate,
      'conversationPeriod': conversationPeriod,
      'responseRate': responseRate,
      'averageResponseTime': averageResponseTime,
      'emojiUsage': emojiUsage.toJson(),
      'topKeywords': topKeywords,
      'sentimentScore': sentimentScore.toJson(),
    };
  }
}

/// 😊 이모지 사용량 모델
class EmojiUsage {
  final int my;
  final int partner;

  EmojiUsage({required this.my, required this.partner});

  factory EmojiUsage.fromJson(Map<String, dynamic> json) {
    return EmojiUsage(my: json['my'] ?? 0, partner: json['partner'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'my': my, 'partner': partner};
  }
}

/// 📊 감정 점수 모델
class SentimentScore {
  final int positive;
  final int neutral;
  final int negative;

  SentimentScore({
    required this.positive,
    required this.neutral,
    required this.negative,
  });

  factory SentimentScore.fromJson(Map<String, dynamic> json) {
    return SentimentScore(
      positive: json['positive'] ?? 0,
      neutral: json['neutral'] ?? 0,
      negative: json['negative'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'positive': positive, 'neutral': neutral, 'negative': negative};
  }
}

/// 🔧 분석 데이터 서비스 클래스
class AnalysisDataService {
  static AnalysisData? _cachedData;

  /// 📁 JSON 파일에서 분석 데이터 로드
  static Future<AnalysisData> loadSampleData() async {
    // 캐시된 데이터가 있으면 반환
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      // assets에서 JSON 파일 로드
      final String jsonString = await rootBundle.loadString(
        'assets/data/analysis_sample.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 데이터 파싱 및 캐싱
      _cachedData = AnalysisData.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      // 오류 발생 시 기본 데이터 반환
      print('분석 데이터 로드 실패: $e');
      return _getDefaultData();
    }
  }

  /// 🔄 캐시 초기화
  static void clearCache() {
    _cachedData = null;
  }

  /// 📊 기본 분석 데이터 (오류 시 사용)
  static AnalysisData _getDefaultData() {
    return AnalysisData(
      someIndex: 50,
      developmentPossibility: 60,
      aiSummary: '기본 분석 데이터입니다.',
      partnerMbti: 'UNKNOWN',
      partnerTags: ['분석중'],
      communicationStyle: '분석 중입니다.',
      emotionData: [
        EmotionDataPoint(
          time: '1일차',
          myEmotion: 50,
          partnerEmotion: 50,
          description: '기본 데이터',
        ),
      ],
      keyEvents: [
        AnalysisKeyEvent(
          time: '1일차',
          event: '🔍 분석 시작',
          type: 'positive',
          description: '분석을 시작했습니다.',
        ),
      ],
      recommendedTopics: ['대화 주제를 분석 중입니다.'],
      improvementTips: ['관계 개선 팁을 준비 중입니다.'],
      metadata: AnalysisMetadata(
        totalMessages: 0,
        analysisDate: '',
        conversationPeriod: '',
        responseRate: 0.0,
        averageResponseTime: '',
        emojiUsage: EmojiUsage(my: 0, partner: 0),
        topKeywords: [],
        sentimentScore: SentimentScore(positive: 0, neutral: 0, negative: 0),
      ),
    );
  }

  /// 📈 차트용 감정 데이터 변환
  static List<Map<String, dynamic>> convertEmotionDataForChart(
    List<EmotionDataPoint> emotionData,
  ) {
    return emotionData.map((point) => point.toChartData()).toList();
  }

  /// 🎯 주요 이벤트 필터링
  static List<AnalysisKeyEvent> getPositiveEvents(List<AnalysisKeyEvent> events) {
    return events.where((event) => event.isPositive).toList();
  }

  static List<AnalysisKeyEvent> getNegativeEvents(List<AnalysisKeyEvent> events) {
    return events.where((event) => !event.isPositive).toList();
  }
}
