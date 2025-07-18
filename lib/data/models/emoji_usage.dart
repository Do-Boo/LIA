// File: lib/data/models/emoji_usage.dart
// 😊 이모지 사용량 모델

/// 😊 이모지 사용량 모델
class EmojiUsage {
  const EmojiUsage({required this.my, required this.partner});

  factory EmojiUsage.fromJson(Map<String, dynamic> json) =>
      EmojiUsage(my: json['my'] ?? 0, partner: json['partner'] ?? 0);
  final int my;
  final int partner;

  Map<String, dynamic> toJson() => {'my': my, 'partner': partner};
}
