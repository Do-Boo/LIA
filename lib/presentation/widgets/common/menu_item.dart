// File: lib/presentation/widgets/common/menu_item.dart
// Created on 2025.07.23 17:52:41 to provide reusable menu item widgets

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

/// 메뉴 아이템 위젯
///
/// LIA 앱 전체에서 사용되는 일관된 메뉴 아이템 UI를 제공합니다.
/// 카카오톡 스타일과 심플 스타일 두 가지 타입을 지원합니다.
///
/// **카카오톡 스타일**: 아이콘, 제목, 부제목, 오른쪽 화살표가 있는 ListTile 스타일
/// **심플 스타일**: 아이콘, 제목, 오른쪽 화살표만 있는 간단한 Row 스타일
class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.iconColor,
    this.iconBackgroundColor,
    this.isSimpleStyle = false,
  });

  const MenuItemWidget.defualt({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor,
  }) : isSimpleStyle = false;

  /// 심플 스타일 메뉴 아이템 생성자
  const MenuItemWidget.simple({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.iconColor,
    this.iconBackgroundColor,
  }) : subtitle = null,
       isSimpleStyle = true;

  /// 아이콘
  final IconData icon;

  /// 메뉴 제목
  final String title;

  /// 부제목 (카카오톡 스타일에서만 사용)
  final String? subtitle;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 아이콘 색상 (기본값: AppColors.primary)
  final Color? iconColor;

  /// 아이콘 배경 색상 (기본값: iconColor의 10% 투명도)
  final Color? iconBackgroundColor;

  /// 심플 스타일 여부 (기본값: false - 카카오톡 스타일)
  final bool isSimpleStyle;

  @override
  Widget build(BuildContext context) {
    if (isSimpleStyle) {
      return _buildSimpleStyle();
    } else {
      return _buildKakaoStyle();
    }
  }

  /// 카카오톡 스타일 메뉴 아이템 빌드
  Widget _buildKakaoStyle() {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBackgroundColor =
        iconBackgroundColor ?? effectiveIconColor.withValues(alpha: 0.1);

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: effectiveIconBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: effectiveIconColor, size: 20),
        ),
        title: Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        // subtitle: subtitle != null
        //     ? Text(
        //         subtitle!,
        //         style: AppTextStyles.caption.copyWith(
        //           color: AppColors.textSecondary,
        //         ),
        //       )
        //     : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  /// 심플 스타일 메뉴 아이템 빌드
  Widget _buildSimpleStyle() {
    final effectiveIconColor = iconColor ?? AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            Icon(icon, size: 24, color: effectiveIconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              HugeIcons.strokeRoundedArrowRight01,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
