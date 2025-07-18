// File: lib/services/analysis_data_service.dart
// 🎯 분석 데이터 로딩 서비스

import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/models/models.dart';

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
      throw Exception('분석 데이터 로드 실패: $e');
    }
  }

  /// 🔄 캐시 초기화
  static void clearCache() {
    _cachedData = null;
  }

  /// 📊 기본 분석 데이터 (오류 시 사용)
  static AnalysisData getDefaultData() => const AnalysisData(
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
      responseRate: 0,
      averageResponseTime: '',
      emojiUsage: EmojiUsage(my: 0, partner: 0),
      topKeywords: [],
      sentimentScore: SentimentScore(positive: 0, neutral: 0, negative: 0),
    ),
  );

  /// 📈 차트용 감정 데이터 변환
  static List<Map<String, dynamic>> convertEmotionDataForChart(
    List<EmotionDataPoint> emotionData,
  ) => emotionData.map((point) => point.toChartData()).toList();

  /// 🎯 주요 이벤트 필터링
  static List<AnalysisKeyEvent> getPositiveEvents(
    List<AnalysisKeyEvent> events,
  ) => events.where((event) => event.isPositive).toList();

  static List<AnalysisKeyEvent> getNegativeEvents(
    List<AnalysisKeyEvent> events,
  ) => events.where((event) => !event.isPositive).toList();
}
