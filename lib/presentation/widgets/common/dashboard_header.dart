// File: lib/presentation/widgets/common/dashboard_header.dart
// 📦 공용 대시보드 헤더 위젯

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_spacing.dart';
import '../../../core/app_text_styles.dart';

/// 대시보드 헤더 위젯
///
/// 모든 화면에서 일관된 헤더 스타일을 제공합니다.
/// 그라데이션 배경과 액션 버튼들을 포함합니다.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
    this.actions,
    this.gradient,
    this.height,
    this.padding,
  });

  /// 헤더 제목
  final String title;

  /// 헤더 부제목
  final String subtitle;

  /// 헤더 아이콘 (선택사항)
  final IconData? icon;

  /// 액션 버튼들 (선택사항)
  final List<DashboardAction>? actions;

  /// 배경 그라데이션 (기본값: primaryGradient)
  final Gradient? gradient;

  /// 헤더 높이 (기본값: null - 자동 크기)
  final double? height;

  /// 패딩 (기본값: 20px)
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: padding ?? AppSpacing.paddingMD,
    decoration: BoxDecoration(
      gradient: gradient ?? AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 메인 콘텐츠 영역
        Row(
          children: [
            // 아이콘 (있는 경우)
            if (icon != null) ...[
              Container(
                padding: AppSpacing.paddingSM,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.surface, size: 24),
              ),
              AppSpacing.gapH16,
            ],

            // 제목과 부제목
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.dashboardTitle.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
                  AppSpacing.gapV4,
                  Text(
                    subtitle,
                    style: AppTextStyles.dashboardSubtitle.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 액션 버튼들 (있는 경우)
        if (actions != null && actions!.isNotEmpty) ...[
          AppSpacing.gapV16,
          _buildActions(),
        ],
      ],
    ),
  );

  /// 액션 버튼들 빌드
  Widget _buildActions() => Row(
    children: actions!
        .map(
          (action) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: action != actions!.last ? 12 : 0),
              child: _buildActionButton(action),
            ),
          ),
        )
        .toList(),
  );

  /// 개별 액션 버튼 빌드
  Widget _buildActionButton(DashboardAction action) => GestureDetector(
    onTap: action.onTap,
    child: Container(
      padding: AppSpacing.paddingSM,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, color: AppColors.surface, size: 20),
          AppSpacing.gapV4,
          Text(
            action.title,
            style: AppTextStyles.helper.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// 대시보드 액션 데이터 클래스
class DashboardAction {
  const DashboardAction({required this.title, required this.icon, this.onTap});

  /// 액션 제목
  final String title;

  /// 액션 아이콘
  final IconData icon;

  /// 액션 콜백
  final VoidCallback? onTap;
}

/// 간단한 대시보드 헤더 (액션 없음)
class SimpleDashboardHeader extends DashboardHeader {
  const SimpleDashboardHeader({
    required super.title,
    required super.subtitle,
    super.key,
    super.icon,
    super.gradient,
    super.height,
    super.padding,
  }) : super(actions: null);
}

/// 아이콘이 있는 대시보드 헤더
class IconDashboardHeader extends DashboardHeader {
  const IconDashboardHeader({
    required super.title,
    required super.subtitle,
    required IconData headerIcon,
    super.key,
    super.actions,
    super.gradient,
    super.height,
    super.padding,
  }) : super(icon: headerIcon);
}
