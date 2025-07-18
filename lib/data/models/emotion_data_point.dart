// File: lib/data/models/emotion_data_point.dart
// 📈 감정 데이터 포인트 모델

/// 📈 감정 데이터 포인트 모델
class EmotionDataPoint {
  const EmotionDataPoint({
    required this.time,
    required this.myEmotion,
    required this.partnerEmotion,
    required this.description,
  });

  factory EmotionDataPoint.fromJson(Map<String, dynamic> json) =>
      EmotionDataPoint(
        time: json['time'] ?? '',
        myEmotion: json['myEmotion'] ?? 0,
        partnerEmotion: json['partnerEmotion'] ?? 0,
        description: json['description'] ?? '',
      );
  final String time;
  final int myEmotion;
  final int partnerEmotion;
  final String description;

  Map<String, dynamic> toJson() => {
    'time': time,
    'myEmotion': myEmotion,
    'partnerEmotion': partnerEmotion,
    'description': description,
  };

  /// LineChart 위젯에서 사용할 수 있는 형태로 변환
  Map<String, dynamic> toChartData() => {
    'time': time,
    'myEmotion': myEmotion,
    'partnerEmotion': partnerEmotion,
  };
}
