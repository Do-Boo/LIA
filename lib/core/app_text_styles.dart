// File: lib/core/app_text_styles.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// LIA 앱의 텍스트 스타일을 정의하는 클래스입니다.
///
/// 이 클래스를 통해 앱 전체의 타이포그래피를 일관되게 관리할 수 있습니다.
/// 모든 스타일은 static const로 정의되어 메모리 효율성을 보장합니다.
///
/// 폰트 계층 시스템 (2025.07.23 17:27:25 가독성 개선):
/// - Gaegu: 브랜드 타이틀만 사용 (친근하고 캐주얼한 브랜드 아이덴티티)
/// - Pretendard: 섹션 제목, 중요 헤딩 (모던하고 세련된 제목용 폰트)
/// - NotoSansKR: 본문, 설명 텍스트 (가독성 최적화된 본문용 폰트)
///
/// 스타일 계층 (모바일 최적화 + 가독성 강화):
/// - [mainTitle]: 앱 메인 타이틀 (36px, Gaegu) - 브랜드 전용
/// - [sectionTitle]: 섹션 카드 제목 (20px, Pretendard) - 통일된 섹션 타이틀
/// - [sectionDescription]: 섹션 설명 (15px, NotoSansKR) - 통일된 섹션 설명
/// - [cardTitle]: 카드 제목 (17px, Pretendard) - 통일된 카드 타이틀
/// - [cardDescription]: 카드 설명 (14px, NotoSansKR) - 통일된 카드 설명
/// - [h1~h3]: 기존 헤딩 스타일 유지 (호환성)
/// - [body, helper]: 본문 및 도움말 텍스트 (크기 및 fontWeight 강화)
class AppTextStyles {
  // ===== 브랜드 타이틀 =====
  /// 앱의 메인 타이틀 스타일입니다.
  ///
  /// Gaegu 폰트를 사용하여 친근하고 캐주얼한 브랜드 아이덴티티를 제공하며,
  /// 그림자 효과로 입체감을 더합니다.
  /// 오직 앱 브랜드 타이틀에만 사용됩니다.
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'Gaegu',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    shadows: [Shadow(color: AppColors.yellow, offset: Offset(2, 2))],
  );

  // ===== 통일된 섹션 스타일 =====
  /// 섹션 카드의 제목 스타일입니다.
  ///
  /// 모든 SectionCard, ComponentCard에서 사용하는 통일된 제목 스타일입니다.
  /// Pretendard 폰트로 모던하고 세련된 느낌을 제공합니다.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20, // 18 → 20으로 증가
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 섹션 카드의 설명 스타일입니다.
  ///
  /// 모든 SectionCard, ComponentCard에서 사용하는 통일된 설명 스타일입니다.
  /// NotoSansKR 폰트로 가독성을 최적화했습니다.
  static const TextStyle sectionDescription = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 15, // 14 → 15로 증가
    fontWeight: FontWeight.w600, // w500 → w600으로 증가
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===== 통일된 카드 스타일 =====
  /// 카드 제목 스타일입니다.
  ///
  /// 카드 내부 제목, 아이템 제목에 사용하는 통일된 스타일입니다.
  /// 섹션 제목보다 작지만 충분히 강조된 스타일입니다.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 카드 설명 스타일입니다.
  ///
  /// 카드 내부 설명, 아이템 설명에 사용하는 통일된 스타일입니다.
  /// 적절한 크기와 색상으로 가독성을 보장합니다.
  static const TextStyle cardDescription = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14, // 13 → 14로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===== 대시보드 헤더 스타일 =====
  /// 대시보드 헤더 제목 스타일입니다.
  ///
  /// DashboardHeader 컴포넌트에서 사용하는 메인 제목 스타일입니다.
  static const TextStyle dashboardTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 26, // 24 → 26으로 증가
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 대시보드 헤더 부제목 스타일입니다.
  ///
  /// DashboardHeader 컴포넌트에서 사용하는 설명 스타일입니다.
  static const TextStyle dashboardSubtitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16, // 15 → 16으로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===== 기존 헤딩 스타일 (호환성 유지) =====
  /// 주요 헤딩 스타일입니다.
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24, // 22 → 24로 증가
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 부제목 스타일입니다.
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20, // 18 → 20으로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 세 번째 수준의 헤딩 스타일입니다.
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18, // 16 → 18로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ===== 본문 텍스트 스타일 (크기 및 fontWeight 강화) =====
  /// 본문 텍스트 스타일입니다.
  ///
  /// 모바일에서의 가독성을 위해 크기와 fontWeight를 강화했습니다.
  static const TextStyle body = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 15, // 14 → 15로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 큰 크기의 본문 텍스트 스타일입니다.
  static const TextStyle body1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16, // 15 → 16으로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 기본 크기의 본문 텍스트 스타일입니다.
  static const TextStyle body2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 15, // 14 → 15로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 도움말과 부가 정보 텍스트 스타일입니다.
  ///
  /// 모바일에서의 가독성을 위해 크기와 fontWeight를 강화했습니다.
  static const TextStyle helper = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 13, // 12 → 13으로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// 작은 캐션 텍스트 스타일입니다.
  static const TextStyle caption = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 13, // 12 → 13으로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===== 특수 목적 스타일 =====
  /// 컴포넌트 제목 스타일입니다. (호환성 유지)
  static const TextStyle componentTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24, // 22 → 24로 증가
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
    height: 1.3,
  );

  /// 질문형 제목 스타일입니다. (호환성 유지)
  static const TextStyle questionTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20, // 18 → 20으로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 설명 텍스트 스타일입니다. (호환성 유지)
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// 차트 제목 텍스트 스타일입니다.
  static const TextStyle chartTitle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.4,
  );

  // ===== 상태별 메시지 스타일 =====
  /// 성공 메시지 텍스트 스타일입니다.
  static const TextStyle success = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    height: 1.5,
  );

  /// 오류 메시지 텍스트 스타일입니다.
  static const TextStyle error = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.error,
    height: 1.5,
  );

  /// 정보 메시지 텍스트 스타일입니다.
  static const TextStyle info = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 17, // 16 → 17로 증가
    fontWeight: FontWeight.w600,
    color: AppColors.info,
    height: 1.5,
  );

  // ===== 호환성 유지 스타일 =====
  /// 접근성을 고려한 도움말 텍스트 스타일입니다.
  static const TextStyle accessibleHelper = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accessibleSecondaryText,
    height: 1.5,
  );

  /// 중간 크기의 본문 텍스트 스타일입니다.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 작은 크기의 본문 텍스트 스타일입니다.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 큰 크기의 본문 텍스트 스타일입니다.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 작은 크기의 헤드라인 스타일입니다.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 큰 크기의 헤드라인 스타일입니다.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
}
