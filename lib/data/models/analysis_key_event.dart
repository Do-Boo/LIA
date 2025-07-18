// File: lib/data/models/analysis_key_event.dart
// 🎯 주요 이벤트 모델

/// 🎯 주요 이벤트 모델
class AnalysisKeyEvent {
  const AnalysisKeyEvent({
    required this.time,
    required this.event,
    required this.type,
    required this.description,
  });

  factory AnalysisKeyEvent.fromJson(Map<String, dynamic> json) =>
      AnalysisKeyEvent(
        time: json['time'] ?? '',
        event: json['event'] ?? '',
        type: json['type'] ?? 'positive',
        description: json['description'] ?? '',
      );
  final String time;
  final String event;
  final String type; // 'positive' 또는 'negative'
  final String description;

  Map<String, dynamic> toJson() => {
    'time': time,
    'event': event,
    'type': type,
    'description': description,
  };

  bool get isPositive => type == 'positive';
}
