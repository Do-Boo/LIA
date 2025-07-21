// File: lib/presentation/widgets/common/section_card.dart
// 📦 공용 섹션 카드 위젯

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_spacing.dart';
import '../../../core/app_text_styles.dart';

/// 번호가 매겨진 섹션 카드 위젯
///
/// 모든 화면에서 일관된 섹션 스타일을 제공합니다.
/// 숫자 넘버링과 아이콘을 유동적으로 선택할 수 있습니다.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.number,
    required this.title,
    required this.description,
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.showShadow = true,
    this.showNumber = true,
    this.icon,
    this.iconColor,
    this.useNumberBadge = false, // 기본값은 아이콘 모드
  });

  /// 섹션 번호 (예: '1', '2', '3')
  final String number;

  /// 섹션 제목
  final String title;

  /// 섹션 설명
  final String description;

  /// 섹션 내용 위젯
  final Widget child;

  /// 카드 패딩 (기본값: 반응형)
  final EdgeInsets? padding;

  /// 카드 마진 (기본값: 없음)
  final EdgeInsets? margin;

  /// 카드 배경색 (기본값: 흰색)
  final Color? backgroundColor;

  /// 테두리 색상 (기본값: primary 색상의 10% 투명도)
  final Color? borderColor;

  /// 그림자 표시 여부 (기본값: true)
  final bool showShadow;

  /// 번호 표시 여부 (기본값: true)
  final bool showNumber;

  /// 헤더 아이콘 (기본값: Analytics 아이콘)
  final IconData? icon;

  /// 아이콘 색상 (기본값: primary)
  final Color? iconColor;

  /// 번호 뱃지 사용 여부 (true: 숫자 뱃지, false: 아이콘)
  final bool useNumberBadge;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(isTablet ? 20 : 16),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: Border.all(
          color: borderColor ?? AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 영역 (번호 뱃지 또는 아이콘 + 제목 + 설명)
          _buildHeader(context),

          AppSpacing.gapV16,

          // 콘텐츠 영역
          child,
        ],
      ),
    );
  }

  /// 헤더 영역 빌드 (유동적 디자인)
  Widget _buildHeader(BuildContext context) => Row(
    children: [
      // 번호 뱃지 또는 아이콘 컨테이너
      if (showNumber) ...[_buildHeaderContainer(), const SizedBox(width: 12)],

      // 제목과 설명 (가로 확장)
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: iconColor ?? AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(description, style: AppTextStyles.sectionDescription),
          ],
        ),
      ),
    ],
  );

  /// 통합된 헤더 컨테이너 빌드 (아이콘 또는 숫자)
  Widget _buildHeaderContainer() => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: (iconColor ?? AppColors.primary).withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    child: useNumberBadge
        ? Center(
            child: Text(
              number,
              style: AppTextStyles.h2.copyWith(
                color: iconColor ?? AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        : Icon(
            icon ?? HugeIcons.strokeRoundedAnalytics01,
            size: 20,
            color: iconColor ?? AppColors.primary,
          ),
  );
}

/// 번호 없는 일반 섹션 카드
class SimpleSectionCard extends SectionCard {
  const SimpleSectionCard({
    required super.title,
    required super.description,
    required super.child,
    super.key,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderColor,
    super.showShadow = true,
    super.icon,
    super.iconColor,
    super.useNumberBadge = false,
  }) : super(number: '', showNumber: false);
}

/// 숫자 뱃지 전용 섹션 카드
class NumberedSectionCard extends SectionCard {
  const NumberedSectionCard({
    required super.number,
    required super.title,
    required super.description,
    required super.child,
    super.key,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderColor,
    super.showShadow = true,
    super.iconColor,
  }) : super(useNumberBadge: true);
}

/// 아이콘 전용 섹션 카드
class IconSectionCard extends SectionCard {
  const IconSectionCard({
    required super.title,
    required super.description,
    required super.child,
    super.key,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderColor,
    super.showShadow = true,
    super.icon,
    super.iconColor,
  }) : super(number: '', useNumberBadge: false);
}
