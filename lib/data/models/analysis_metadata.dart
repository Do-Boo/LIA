// File: lib/data/models/analysis_metadata.dart
// 📊 분석 메타데이터 모델

import 'emoji_usage.dart';
import 'sentiment_score.dart';

/// 📊 분석 메타데이터 모델
class AnalysisMetadata {
  const AnalysisMetadata({
    required this.totalMessages,
    required this.analysisDate,
    required this.conversationPeriod,
    required this.responseRate,
    required this.averageResponseTime,
    required this.emojiUsage,
    required this.topKeywords,
    required this.sentimentScore,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) =>
      AnalysisMetadata(
        totalMessages: json['totalMessages'] ?? 0,
        analysisDate: json['analysisDate'] ?? '',
        conversationPeriod: json['conversationPeriod'] ?? '',
        responseRate: (json['responseRate'] ?? 0.0).toDouble(),
        averageResponseTime: json['averageResponseTime'] ?? '',
        emojiUsage: EmojiUsage.fromJson(json['emojiUsage'] ?? {}),
        topKeywords: List<String>.from(json['topKeywords'] ?? []),
        sentimentScore: SentimentScore.fromJson(json['sentimentScore'] ?? {}),
      );
  final int totalMessages;
  final String analysisDate;
  final String conversationPeriod;
  final double responseRate;
  final String averageResponseTime;
  final EmojiUsage emojiUsage;
  final List<String> topKeywords;
  final SentimentScore sentimentScore;

  Map<String, dynamic> toJson() => {
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
