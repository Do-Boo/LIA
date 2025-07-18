// File: test/unit/models/analysis_data_test.dart
// 🧪 AnalysisData 모델 유닛 테스트

import 'package:flutter_test/flutter_test.dart';
import 'package:lia/data/models/models.dart';

void main() {
  group('AnalysisData', () {
    group('fromJson', () {
      test('should create AnalysisData from complete JSON', () {
        // Arrange
        final json = {
          'someIndex': 75,
          'developmentPossibility': 85,
          'aiSummary': 'Test AI Summary',
          'partnerMbti': 'ENFP',
          'partnerTags': ['활발한', '긍정적인'],
          'communicationStyle': '친근하고 활발한 스타일',
          'emotionData': [
            {
              'time': '1일차',
              'myEmotion': 70,
              'partnerEmotion': 80,
              'description': '첫 만남',
            },
          ],
          'keyEvents': [
            {
              'time': '1일차',
              'event': '첫 대화',
              'type': 'positive',
              'description': '좋은 첫인상',
            },
          ],
          'recommendedTopics': ['여행', '음악'],
          'improvementTips': ['더 자주 연락하기'],
          'analysisMetadata': {
            'totalMessages': 100,
            'analysisDate': '2025-07-18',
            'conversationPeriod': '7일',
            'responseRate': 0.85,
            'averageResponseTime': '2분',
            'emojiUsage': {'my': 15, 'partner': 20},
            'topKeywords': ['안녕', '좋아'],
            'sentimentScore': {'positive': 70, 'neutral': 20, 'negative': 10},
          },
          'personalityAnalysis': {
            'myPersonality': {'외향성': 70, '개방성': 80},
            'partnerPersonality': {'외향성': 90, '개방성': 60},
            'compatibilityScore': 85,
            'strengths': ['대화가 잘 통함'],
            'improvements': ['더 자주 만나기'],
          },
        };

        // Act
        final result = AnalysisData.fromJson(json);

        // Assert
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
        expect(result.metadata, isA<AnalysisMetadata>());
        expect(result.personalityAnalysis, isA<PersonalityAnalysis>());
      });

      test(
        'should create AnalysisData with default values for missing fields',
        () {
          // Arrange
          final json = <String, dynamic>{};

          // Act
          final result = AnalysisData.fromJson(json);

          // Assert
          expect(result.someIndex, 0);
          expect(result.developmentPossibility, 0);
          expect(result.aiSummary, '');
          expect(result.partnerMbti, '');
          expect(result.partnerTags, isEmpty);
          expect(result.communicationStyle, '');
          expect(result.emotionData, isEmpty);
          expect(result.keyEvents, isEmpty);
          expect(result.recommendedTopics, isEmpty);
          expect(result.improvementTips, isEmpty);
          expect(result.personalityAnalysis, isNull);
        },
      );

      test('should handle null personalityAnalysis', () {
        // Arrange
        final json = {
          'someIndex': 50,
          'developmentPossibility': 60,
          'aiSummary': 'Test',
          'partnerMbti': 'INTJ',
          'partnerTags': <String>[],
          'communicationStyle': '',
          'emotionData': <Map<String, dynamic>>[],
          'keyEvents': <Map<String, dynamic>>[],
          'recommendedTopics': <String>[],
          'improvementTips': <String>[],
          'analysisMetadata': <String, dynamic>{},
          'personalityAnalysis': null,
        };

        // Act
        final result = AnalysisData.fromJson(json);

        // Assert
        expect(result.personalityAnalysis, isNull);
      });
    });

    group('toJson', () {
      test('should convert AnalysisData to JSON', () {
        // Arrange
        const analysisData = AnalysisData(
          someIndex: 75,
          developmentPossibility: 85,
          aiSummary: 'Test AI Summary',
          partnerMbti: 'ENFP',
          partnerTags: ['활발한', '긍정적인'],
          communicationStyle: '친근하고 활발한 스타일',
          emotionData: [
            EmotionDataPoint(
              time: '1일차',
              myEmotion: 70,
              partnerEmotion: 80,
              description: '첫 만남',
            ),
          ],
          keyEvents: [
            AnalysisKeyEvent(
              time: '1일차',
              event: '첫 대화',
              type: 'positive',
              description: '좋은 첫인상',
            ),
          ],
          recommendedTopics: ['여행', '음악'],
          improvementTips: ['더 자주 연락하기'],
          metadata: AnalysisMetadata(
            totalMessages: 100,
            analysisDate: '2025-07-18',
            conversationPeriod: '7일',
            responseRate: 0.85,
            averageResponseTime: '2분',
            emojiUsage: EmojiUsage(my: 15, partner: 20),
            topKeywords: ['안녕', '좋아'],
            sentimentScore: SentimentScore(
              positive: 70,
              neutral: 20,
              negative: 10,
            ),
          ),
          personalityAnalysis: PersonalityAnalysis(
            myPersonality: {'외향성': 70, '개방성': 80},
            partnerPersonality: {'외향성': 90, '개방성': 60},
            compatibilityScore: 85,
            strengths: ['대화가 잘 통함'],
            improvements: ['더 자주 만나기'],
          ),
        );

        // Act
        final result = analysisData.toJson();

        // Assert
        expect(result['someIndex'], 75);
        expect(result['developmentPossibility'], 85);
        expect(result['aiSummary'], 'Test AI Summary');
        expect(result['partnerMbti'], 'ENFP');
        expect(result['partnerTags'], ['활발한', '긍정적인']);
        expect(result['communicationStyle'], '친근하고 활발한 스타일');
        expect(result['emotionData'], isA<List>());
        expect(result['keyEvents'], isA<List>());
        expect(result['recommendedTopics'], ['여행', '음악']);
        expect(result['improvementTips'], ['더 자주 연락하기']);
        expect(result['analysisMetadata'], isA<Map<String, dynamic>>());
        expect(result['personalityAnalysis'], isA<Map<String, dynamic>>());
      });

      test(
        'should convert AnalysisData to JSON without personalityAnalysis',
        () {
          // Arrange
          const analysisData = AnalysisData(
            someIndex: 50,
            developmentPossibility: 60,
            aiSummary: 'Test',
            partnerMbti: 'INTJ',
            partnerTags: <String>[],
            communicationStyle: '',
            emotionData: <EmotionDataPoint>[],
            keyEvents: <AnalysisKeyEvent>[],
            recommendedTopics: <String>[],
            improvementTips: <String>[],
            metadata: AnalysisMetadata(
              totalMessages: 0,
              analysisDate: '',
              conversationPeriod: '',
              responseRate: 0,
              averageResponseTime: '',
              emojiUsage: EmojiUsage(my: 0, partner: 0),
              topKeywords: <String>[],
              sentimentScore: SentimentScore(
                positive: 0,
                neutral: 0,
                negative: 0,
              ),
            ),
          );

          // Act
          final result = analysisData.toJson();

          // Assert
          expect(result.containsKey('personalityAnalysis'), false);
        },
      );
    });

    group('const constructor', () {
      test('should create const AnalysisData instance', () {
        // Act
        const analysisData = AnalysisData(
          someIndex: 50,
          developmentPossibility: 60,
          aiSummary: 'Test',
          partnerMbti: 'INTJ',
          partnerTags: <String>[],
          communicationStyle: '',
          emotionData: <EmotionDataPoint>[],
          keyEvents: <AnalysisKeyEvent>[],
          recommendedTopics: <String>[],
          improvementTips: <String>[],
          metadata: AnalysisMetadata(
            totalMessages: 0,
            analysisDate: '',
            conversationPeriod: '',
            responseRate: 0,
            averageResponseTime: '',
            emojiUsage: EmojiUsage(my: 0, partner: 0),
            topKeywords: <String>[],
            sentimentScore: SentimentScore(
              positive: 0,
              neutral: 0,
              negative: 0,
            ),
          ),
        );

        // Assert
        expect(analysisData.someIndex, 50);
        expect(analysisData.personalityAnalysis, isNull);
      });
    });
  });
}
