// File: lib/presentation/widgets/common/section_card.dart
// 📦 공용 섹션 카드 위젯

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_spacing.dart';
import '../../../core/app_text_styles.dart';

/// 번호가 매겨진 섹션 카드 위젯
///
/// 모든 화면에서 일관된 섹션 스타일을 제공합니다.
/// main_screen.dart의 _buildChartDemoSection 패턴을 공용화했습니다.
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
          // 헤더 영역 (번호 + 제목 + 설명)
          _buildHeader(context),

          AppSpacing.gapV16,

          // 콘텐츠 영역
          child,
        ],
      ),
    );
  }

  /// 헤더 영역 빌드
  Widget _buildHeader(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 번호와 제목
      Row(
        children: [
          if (showNumber) ...[_buildNumberBadge(), AppSpacing.gapH16],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),

      AppSpacing.gapV8,

      // 설명
      Text(
        description,
        style: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
    ],
  );

  /// 번호 뱃지 빌드
  Widget _buildNumberBadge() => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Text(
        number,
        style: AppTextStyles.body.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
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
  }) : super(number: '', showNumber: false);
}
