// File: lib/core/app_text_styles.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// LIA 앱의 텍스트 스타일을 정의하는 클래스입니다.
///
/// 이 클래스를 통해 앱 전체의 타이포그래피를 일관되게 관리할 수 있습니다.
/// 모든 스타일은 static const로 정의되어 메모리 효율성을 보장합니다.
///
/// 폰트 시스템:
/// - Gaegu: 브랜드 타이틀과 컴포넌트 제목 (친근하고 캐주얼한 느낌)
/// - NotoSansKR: 본문, 설명 텍스트 (가독성 최적화)
///
/// 스타일 계층:
/// - [mainTitle]: 앱 메인 타이틀 (48px, Gaegu)
/// - [componentTitle]: 컴포넌트 제목 (32px, Gaegu)
/// - [h1]: 주요 헤딩 (32px, NotoSansKR)
/// - [h2]: 부제목 (24px, NotoSansKR)
/// - [h3]: 세 번째 헤딩 (20px, NotoSansKR)
/// - [questionTitle]: 질문형 제목 (20px, NotoSansKR)
/// - [subtitle]: 설명 텍스트 (18px, NotoSansKR)
/// - [body]: 본문 텍스트 (16px, NotoSansKR)
/// - [helper]: 도움말 텍스트 (14px, NotoSansKR)
/// - [accessibleHelper]: 접근성 개선 도움말 텍스트 (14px, NotoSansKR)
class AppTextStyles {
  /// 앱의 메인 타이틀 스타일입니다.
  ///
  /// Gaegu 폰트를 사용하여 친근하고 캐주얼한 브랜드 아이덴티티를 제공하며,
  /// 그림자 효과로 입체감을 더합니다.
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'Gaegu',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    shadows: [Shadow(color: AppColors.yellow, offset: Offset(2, 2))],
  );

  /// 컴포넌트 카드의 제목 스타일입니다.
  ///
  /// Gaegu 폰트를 사용하여 친근하고 캐주얼한 느낌을 제공하며,
  /// 각 섹션의 제목을 강조합니다.
  static const TextStyle componentTitle = TextStyle(
    fontFamily: 'Gaegu',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
    height: 1.3,
  );

  /// 주요 헤딩 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 가장 중요한 내용의 제목에 사용됩니다.
  /// 높은 폰트 굵기로 강한 시각적 임팩트를 제공합니다.
  static const TextStyle h1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.charcoal,
    height: 1.3,
  );

  /// 부제목 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 h1 다음으로 중요한 제목에 사용되며,
  /// 적절한 굵기로 가독성과 계층감을 제공합니다.
  static const TextStyle h2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal,
    height: 1.3,
  );

  /// 세 번째 수준의 헤딩 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 h2보다 작은 제목에 사용됩니다.
  /// 중간 크기의 제목으로 적절한 시각적 계층을 제공합니다.
  static const TextStyle h3 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.charcoal,
    height: 1.3,
  );

  /// 질문형 제목 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 사용자에게 질문을 던지는 제목에 사용되며,
  /// h1보다 부드럽고 친근한 느낌을 제공합니다.
  /// 18세 서현 페르소나의 톤에 맞는 캐주얼한 질문에 적합합니다.
  static const TextStyle questionTitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.charcoal,
    height: 1.4,
  );

  /// 설명 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 제목 아래의 부가 설명이나 중간 크기의 텍스트에 사용되며,
  /// 보조 텍스트 색상으로 시각적 계층을 구분합니다.
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  /// 차트 제목 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 제목 아래의 부가 설명이나 중간 크기의 텍스트에 사용되며,
  /// 보조 텍스트 색상으로 시각적 계층을 구분합니다.
  /// 모바일 최적화: 20px → 16px
  static const TextStyle chartTitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.4,
  );

  /// 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 일반적인 내용과 설명에 사용되는 기본 스타일이며,
  /// 최적의 가독성을 위해 적절한 줄 간격을 제공합니다.
  static const TextStyle body = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    color: AppColors.charcoal,
    height: 1.5,
  );

  /// 중간 크기의 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 body보다 약간 작은 크기로 부가 설명에 사용됩니다.
  /// 모바일 최적화: 15px → 14px
  static const TextStyle body1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.charcoal,
    height: 1.5,
  );

  /// 작은 크기의 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 body보다 작은 크기로 세부 정보에 사용됩니다.
  /// 모바일 최적화: 14px → 14px
  static const TextStyle body2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.charcoal,
    height: 1.5,
  );

  /// 도움말과 부가 정보 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 힌트, 캐션, 추가 설명 등에 사용되며,
  /// 작은 크기와 보조 색상으로 주요 내용을 방해하지 않습니다.
  static const TextStyle helper = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.secondaryText,
    height: 1.5,
  );

  /// 접근성을 고려한 도움말 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 기본 helper 스타일보다 색상 대비를 개선하여
  /// 시각적 접근성을 향상시킨 스타일입니다.
  /// 중요한 도움말이나 설명에 사용됩니다.
  static const TextStyle accessibleHelper = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.accessibleSecondaryText,
    height: 1.5,
  );

  /// 작은 캐션 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 이미지 설명, 저작권 표시, 매우 부가적인 정보에 사용되며,
  /// 가장 작은 크기의 텍스트 스타일입니다.
  /// 모바일 최적화: 12px → 12px
  static const TextStyle caption = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 12,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  /// 성공 메시지 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 성공, 완료, 확인 메시지에 사용되며,
  /// 긍정적인 피드백을 제공합니다.
  /// 모바일 최적화: 16px → 16px
  static const TextStyle success = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    height: 1.5,
  );

  /// 오류 메시지 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 에러, 경고, 실패 메시지에 사용되며,
  /// 주의를 끌기 위한 빨간색을 사용합니다.
  /// 모바일 최적화: 16px → 16px
  static const TextStyle error = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
    height: 1.5,
  );

  /// 정보 메시지 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 알림, 안내, 정보성 메시지에 사용되며,
  /// 중립적인 파란색을 사용합니다.
  /// 모바일 최적화: 16px → 16px
  static const TextStyle info = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.info,
    height: 1.5,
  );

  /// 중간 크기의 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 일반적인 본문 텍스트에 사용되며,
  /// body 스타일과 유사하지만 명확한 네이밍을 위해 추가했습니다.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.charcoal,
    height: 1.5,
  );

  /// 작은 크기의 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 작은 텍스트와 부가 정보에 사용됩니다.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 12,
    color: AppColors.charcoal,
    height: 1.4,
  );

  /// 큰 크기의 본문 텍스트 스타일입니다.
  ///
  /// NotoSansKR 폰트를 사용하여 강조된 본문 텍스트에 사용됩니다.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.charcoal,
    height: 1.5,
  );

  /// 작은 크기의 헤드라인 스타일입니다.
  ///
  /// Pretendard 폰트를 사용하여 중간 크기의 제목에 사용됩니다.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal,
    height: 1.3,
  );

  /// 큰 크기의 헤드라인 스타일입니다.
  ///
  /// Pretendard 폰트를 사용하여 큰 제목에 사용됩니다.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.charcoal,
    height: 1.3,
  );
}
