// File: lib/core/app_colors.dart

import 'package:flutter/material.dart';

/// LIA 앱의 핵심 색상을 정의하는 클래스입니다.
///
/// 이 클래스를 통해 앱 전체의 색상 테마를 일관되게 관리할 수 있습니다.
/// 모든 색상은 static const로 정의되어 메모리 효율성을 보장합니다.
///
/// 주요 색상:
/// - [primary]: 메인 핑크 색상 (#FF70A6)
/// - [accent]: 보조 퍼플 색상 (#A162F7)
/// - [yellow]: 포인트 옐로우 색상 (#FFD670)
/// - [blue]: 스카이 블루 색상 (#70A6FF)
/// - [green]: 프레시 그린 색상 (#70FFA6)
/// - [primaryGradient]: 주요 그라데이션 효과
/// - [accentGradient]: 보조 그라데이션 효과
class AppColors {
  /// 앱의 기본 배경 색상입니다.
  /// 연한 핑크톤으로 따뜻하고 친근한 느낌을 제공합니다.
  static const Color background = Color(0xFFFFF8FB);

  /// 앱의 주요 브랜드 색상입니다.
  /// 사랑스러운 핑크 색상으로 주요 버튼과 강조 요소에 사용됩니다.
  static const Color primary = Color(0xFFFF70A6);

  /// 앱의 보조 브랜드 색상입니다.
  /// 세련된 퍼플 색상으로 타이틀과 액센트 요소에 사용됩니다.
  static const Color accent = Color(0xFFA162F7);

  /// 밝고 활기찬 노란색입니다.
  /// 포인트 색상과 그림자 효과에 사용됩니다.
  static const Color yellow = Color(0xFFFFD670);

  /// 시원하고 신뢰감 있는 파란색입니다.
  /// 정보 표시와 보조 액센트에 사용됩니다.
  static const Color blue = Color(0xFF70A6FF);

  /// 신선하고 긍정적인 녹색입니다.
  /// 성공 상태와 완료 표시에 사용됩니다.
  static const Color green = Color(0xFF70FFA6);

  /// 우아하고 신비로운 보라색입니다.
  /// 차트와 데이터 시각화에 사용됩니다.
  static const Color purple = Color(0xFF9C27B0);

  /// 활기찬 오렌지색입니다.
  /// 포인트 색상과 차트 요소에 사용됩니다.
  static const Color orange = Color(0xFFFF9800);

  /// 부드러운 핑크색입니다.
  /// 차트와 UI 요소에 사용됩니다.
  static const Color pink = Color(0xFFE91E63);

  // ===== 텍스트 색상 =====
  /// 기본 텍스트 색상입니다.
  /// 진한 회색으로 가독성을 보장합니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color textPrimary = Color(
    0xFF1A1A1A,
  ); // #333333 → #1A1A1A로 더 진하게

  /// 보조 텍스트 색상입니다.
  /// 설명 텍스트와 부가 정보에 사용됩니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color textSecondary = Color(
    0xFF3A3A3A,
  ); // #555555 → #3A3A3A로 더 진하게

  // ===== 호환성을 위한 별칭 (Deprecated) =====
  /// @deprecated textPrimary를 사용하세요
  @Deprecated('Use textPrimary instead')
  static const Color charcoal = textPrimary;

  /// @deprecated textPrimary를 사용하세요
  @Deprecated('Use textPrimary instead')
  static const Color primaryText = textPrimary;

  /// @deprecated textSecondary를 사용하세요
  @Deprecated('Use textSecondary instead')
  static const Color secondaryText = Color(0xFF3A3A3A); // textSecondary와 동일하게 조정

  /// 접근성을 고려한 보조 텍스트 색상입니다.
  /// 더 진한 회색으로 색상 대비를 개선합니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color accessibleSecondaryText = Color(
    0xFF2A2A2A,
  ); // #444444 → #2A2A2A로 더 진하게

  /// 카드와 테두리에 사용되는 연한 핑크 색상입니다.
  /// 부드러운 구분선과 테두리 효과에 활용됩니다.
  static const Color cardBorder = Color(0xFFFFDDE8);

  /// 기본 테두리 색상입니다.
  /// 일반적인 구분선과 테두리에 사용됩니다.
  static const Color border = Color(0xFFE0E0E0);

  /// 비활성화 상태와 배경에 사용되는 연한 회색입니다.
  /// 버튼 비활성화 상태와 중성적인 배경에 사용됩니다.
  static const Color lightGray = Color(0xFFF1F3F5);

  /// 카드와 컴포넌트의 배경색입니다.
  /// 흰색 배경에 사용됩니다.
  static const Color surface = Color(0xFFFFFFFF);

  /// 성공 상태를 나타내는 녹색입니다.
  /// 완료된 작업이나 성공 메시지에 사용됩니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color success = Color(0xFF1E7E34); // #28a745 → #1E7E34로 더 진하게

  /// 오류 상태를 나타내는 빨간색입니다.
  /// 에러 메시지와 경고에 사용됩니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color error = Color(0xFFC82333); // #DC3545 → #C82333으로 더 진하게

  /// 정보 상태를 나타내는 파란색입니다.
  /// 알림과 정보 메시지에 사용됩니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color info = Color(0xFF117A8B); // #17A2B8 → #117A8B로 더 진하게

  /// 경고 상태를 나타내는 오렌지색입니다.
  /// 주의사항과 경고 메시지에 사용됩니다. (2025.07.23 17:31:28 가독성을 위해 더 진하게 조정)
  static const Color warning = Color(0xFFE0A800); // #FFC107 → #E0A800으로 더 진하게

  /// 주요 그라데이션 효과입니다.
  /// 핑크에서 퍼플로 이어지는 브랜드 그라데이션으로
  /// 주요 버튼과 강조 요소에 사용됩니다.
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 보조 그라데이션 효과입니다.
  /// 퍼플 톤의 우아한 그라데이션으로
  /// 액센트 요소와 태그에 사용됩니다.
  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFFA162F7), Color(0xFFB681F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 차트용 그라데이션 효과입니다.
  /// 옐로우에서 핑크로 이어지는 따뜻한 그라데이션으로
  /// 데이터 시각화 요소에 사용됩니다.
  static const Gradient chartGradient = LinearGradient(
    colors: [yellow, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 성공 그라데이션 효과입니다.
  /// 그린 톤의 그라데이션으로 완료 상태 표시에 사용됩니다.
  static const Gradient successGradient = LinearGradient(
    colors: [green, Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
