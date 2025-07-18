// File: test/services/analysis_data_service_test.dart
// 🧪 AnalysisDataService 유닛 테스트

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia/data/models/models.dart';
import 'package:lia/services/analysis_data_service.dart';

void main() {
  group('AnalysisDataService', () {
    setUp(AnalysisDataService.clearCache);

    group('loadSampleData', () {
      test('should load data from JSON file successfully', () async {
        // Arrange
        const String mockJsonData = '''
        {
          "someIndex": 75,
          "developmentPossibility": 85,
          "aiSummary": "Test AI Summary",
          "partnerMbti": "ENFP",
          "partnerTags": ["활발한", "긍정적인"],
          "communicationStyle": "친근하고 활발한 스타일",
          "emotionData": [
            {
              "time": "1일차",
              "myEmotion": 70,
              "partnerEmotion": 80,
              "description": "첫 만남"
            }
          ],
          "keyEvents": [
            {
              "time": "1일차",
              "event": "첫 대화",
              "type": "positive",
              "description": "좋은 첫인상"
            }
          ],
          "recommendedTopics": ["여행", "음악"],
          "improvementTips": ["더 자주 연락하기"],
          "analysisMetadata": {
            "totalMessages": 100,
            "analysisDate": "2025-07-18",
            "conversationPeriod": "7일",
            "responseRate": 0.85,
            "averageResponseTime": "2분",
            "emojiUsage": {
              "my": 15,
              "partner": 20
            },
            "topKeywords": ["안녕", "좋아"],
            "sentimentScore": {
              "positive": 70,
              "neutral": 20,
              "negative": 10
            }
          }
        }
        ''';

        // Mock the asset loading
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              methodCall,
            ) async {
              if (methodCall.method == 'loadString' &&
                  methodCall.arguments == 'assets/data/analysis_sample.json') {
                return mockJsonData;
              }
              return null;
            });

        // Act
        final result = await AnalysisDataService.loadSampleData();

        // Assert
        expect(result, isA<AnalysisData>());
        expect(result.someIndex, 75);
        expect(result.developmentPossibility, 85);
        expect(result.aiSummary, 'Test AI Summary');
        expect(result.partnerMbti, 'ENFP');
        expect(result.partnerTags, ['활발한', '긍정적인']);
        expect(result.communicationStyle, '친근하고 활발한 스타일');
        expect(result.emotionData.length, 1);
        expect(result.keyEvents.length, 1);
        expect(result.recommendedTopics, ['여행', '음악']);
        expect(result.improvementTips, ['더 자주 연락하기']);
        expect(result.metadata.totalMessages, 100);
      });

      test('should cache data after first load', () async {
        // Arrange
        const String mockJsonData = '''
        {
          "someIndex": 50,
          "developmentPossibility": 60,
          "aiSummary": "Cached Test",
          "partnerMbti": "INTJ",
          "partnerTags": ["분석적인"],
          "communicationStyle": "논리적인 스타일",
          "emotionData": [],
          "keyEvents": [],
          "recommendedTopics": [],
          "improvementTips": [],
          "analysisMetadata": {
            "totalMessages": 0,
            "analysisDate": "",
            "conversationPeriod": "",
            "responseRate": 0.0,
            "averageResponseTime": "",
            "emojiUsage": {"my": 0, "partner": 0},
            "topKeywords": [],
            "sentimentScore": {"positive": 0, "neutral": 0, "negative": 0}
          }
        }
        ''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              methodCall,
            ) async {
              if (methodCall.method == 'loadString') {
                return mockJsonData;
              }
              return null;
            });

        // Act
        final firstResult = await AnalysisDataService.loadSampleData();

        // Clear the mock to ensure second call uses cache
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('flutter/assets'),
              (methodCall) async => null,
            );

        final secondResult = await AnalysisDataService.loadSampleData();

        // Assert
        expect(firstResult.aiSummary, 'Cached Test');
        expect(secondResult.aiSummary, 'Cached Test');
        expect(identical(firstResult, secondResult), true);
      });

      test('should throw exception when JSON loading fails', () async {
        // Arrange
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              methodCall,
            ) async {
              throw Exception('Asset loading failed');
            });

        // Act & Assert
        expect(
          AnalysisDataService.loadSampleData,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('분석 데이터 로드 실패'),
            ),
          ),
        );
      });

      test('should handle invalid JSON gracefully', () async {
        // Arrange
        const String invalidJson = 'invalid json content';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('flutter/assets'),
              (methodCall) async => invalidJson,
            );

        // Act & Assert
        expect(AnalysisDataService.loadSampleData, throwsA(isA<Exception>()));
      });
    });

    group('clearCache', () {
      test('should clear cached data', () async {
        // Arrange
        const String mockJsonData = '''
        {
          "someIndex": 50,
          "developmentPossibility": 60,
          "aiSummary": "Test",
          "partnerMbti": "INTJ",
          "partnerTags": [],
          "communicationStyle": "",
          "emotionData": [],
          "keyEvents": [],
          "recommendedTopics": [],
          "improvementTips": [],
          "analysisMetadata": {
            "totalMessages": 0,
            "analysisDate": "",
            "conversationPeriod": "",
            "responseRate": 0.0,
            "averageResponseTime": "",
            "emojiUsage": {"my": 0, "partner": 0},
            "topKeywords": [],
            "sentimentScore": {"positive": 0, "neutral": 0, "negative": 0}
          }
        }
        ''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('flutter/assets'),
              (methodCall) async => mockJsonData,
            );

        // Load data to cache it
        await AnalysisDataService.loadSampleData();

        // Act
        AnalysisDataService.clearCache();

        // Assert - Next load should fetch from file again
        final result = await AnalysisDataService.loadSampleData();
        expect(result, isA<AnalysisData>());
      });
    });

    group('getDefaultData', () {
      test('should return default analysis data', () {
        // Act
        final result = AnalysisDataService.getDefaultData();

        // Assert
        expect(result, isA<AnalysisData>());
        expect(result.someIndex, 50);
        expect(result.developmentPossibility, 60);
        expect(result.aiSummary, '기본 분석 데이터입니다.');
        expect(result.partnerMbti, 'UNKNOWN');
        expect(result.partnerTags, ['분석중']);
        expect(result.communicationStyle, '분석 중입니다.');
        expect(result.emotionData.length, 1);
        expect(result.keyEvents.length, 1);
        expect(result.recommendedTopics, ['대화 주제를 분석 중입니다.']);
        expect(result.improvementTips, ['관계 개선 팁을 준비 중입니다.']);
        expect(result.metadata.totalMessages, 0);
      });

      test('should return consistent default data', () {
        // Act
        final result1 = AnalysisDataService.getDefaultData();
        final result2 = AnalysisDataService.getDefaultData();

        // Assert
        expect(result1.someIndex, result2.someIndex);
        expect(result1.aiSummary, result2.aiSummary);
        expect(result1.partnerMbti, result2.partnerMbti);
      });
    });

    group('convertEmotionDataForChart', () {
      test('should convert emotion data to chart format', () {
        // Arrange
        final emotionData = [
          const EmotionDataPoint(
            time: '1일차',
            myEmotion: 70,
            partnerEmotion: 80,
            description: '첫 만남',
          ),
          const EmotionDataPoint(
            time: '2일차',
            myEmotion: 75,
            partnerEmotion: 85,
            description: '두 번째 만남',
          ),
        ];

        // Act
        final result = AnalysisDataService.convertEmotionDataForChart(
          emotionData,
        );

        // Assert
        expect(result.length, 2);
        expect(result[0]['time'], '1일차');
        expect(result[0]['myEmotion'], 70);
        expect(result[0]['partnerEmotion'], 80);
        expect(result[1]['time'], '2일차');
        expect(result[1]['myEmotion'], 75);
        expect(result[1]['partnerEmotion'], 85);
      });

      test('should handle empty emotion data', () {
        // Arrange
        final emotionData = <EmotionDataPoint>[];

        // Act
        final result = AnalysisDataService.convertEmotionDataForChart(
          emotionData,
        );

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getPositiveEvents', () {
      test('should filter positive events correctly', () {
        // Arrange
        final events = [
          const AnalysisKeyEvent(
            time: '1일차',
            event: '좋은 대화',
            type: 'positive',
            description: '긍정적인 대화',
          ),
          const AnalysisKeyEvent(
            time: '2일차',
            event: '오해 발생',
            type: 'negative',
            description: '부정적인 상황',
          ),
          const AnalysisKeyEvent(
            time: '3일차',
            event: '화해',
            type: 'positive',
            description: '관계 개선',
          ),
        ];

        // Act
        final result = AnalysisDataService.getPositiveEvents(events);

        // Assert
        expect(result.length, 2);
        expect(result[0].event, '좋은 대화');
        expect(result[1].event, '화해');
        expect(result.every((event) => event.isPositive), true);
      });

      test('should return empty list when no positive events', () {
        // Arrange
        final events = [
          const AnalysisKeyEvent(
            time: '1일차',
            event: '오해',
            type: 'negative',
            description: '부정적인 상황',
          ),
        ];

        // Act
        final result = AnalysisDataService.getPositiveEvents(events);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getNegativeEvents', () {
      test('should filter negative events correctly', () {
        // Arrange
        final events = [
          const AnalysisKeyEvent(
            time: '1일차',
            event: '좋은 대화',
            type: 'positive',
            description: '긍정적인 대화',
          ),
          const AnalysisKeyEvent(
            time: '2일차',
            event: '오해 발생',
            type: 'negative',
            description: '부정적인 상황',
          ),
          const AnalysisKeyEvent(
            time: '3일차',
            event: '갈등',
            type: 'negative',
            description: '관계 악화',
          ),
        ];

        // Act
        final result = AnalysisDataService.getNegativeEvents(events);

        // Assert
        expect(result.length, 2);
        expect(result[0].event, '오해 발생');
        expect(result[1].event, '갈등');
        expect(result.every((event) => !event.isPositive), true);
      });

      test('should return empty list when no negative events', () {
        // Arrange
        final events = [
          const AnalysisKeyEvent(
            time: '1일차',
            event: '좋은 대화',
            type: 'positive',
            description: '긍정적인 대화',
          ),
        ];

        // Act
        final result = AnalysisDataService.getNegativeEvents(events);

        // Assert
        expect(result, isEmpty);
      });
    });

    tearDown(() {
      // 각 테스트 후 정리
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/assets'),
            null,
          );
    });
  });
}
