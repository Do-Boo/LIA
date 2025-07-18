// File: lib/data/models/sentiment_score.dart
// 📊 감정 점수 모델

/// 📊 감정 점수 모델
class SentimentScore {
  const SentimentScore({
    required this.positive,
    required this.neutral,
    required this.negative,
  });

  factory SentimentScore.fromJson(Map<String, dynamic> json) => SentimentScore(
    positive: json['positive'] ?? 0,
    neutral: json['neutral'] ?? 0,
    negative: json['negative'] ?? 0,
  );
  final int positive;
  final int neutral;
  final int negative;

  Map<String, dynamic> toJson() => {
    'positive': positive,
    'neutral': neutral,
    'negative': negative,
  };
}
