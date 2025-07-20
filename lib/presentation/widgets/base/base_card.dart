// File: lib/presentation/widgets/base/base_card.dart

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// 모든 카드 위젯의 베이스 클래스
///
/// 공통 기능:
/// - 표준 카드 스타일 제공
/// - 패딩, 색상, 테두리 설정
/// - 반응형 레이아웃 지원
/// - 애니메이션 효과
/// - 접근성 지원
abstract class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    this.title,
    this.titleIcon,
    this.titleColor,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 12,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
    this.margin,
    this.height,
    this.width,
    this.isClickable = false,
    this.onTap,
    this.onLongPress,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  /// 카드 제목
  final String? title;

  /// 카드 제목 아이콘
  final IconData? titleIcon;

  /// 카드 제목 색상
  final Color? titleColor;

  /// 내부 패딩
  final EdgeInsets? padding;

  /// 배경색
  final Color? backgroundColor;

  /// 테두리 둥글기
  final double borderRadius;

  /// 테두리 색상
  final Color? borderColor;

  /// 테두리 두께
  final double borderWidth;

  /// 그림자 효과
  final List<BoxShadow>? boxShadow;

  /// 마진
  final EdgeInsets? margin;

  /// 카드 높이 (null이면 자동)
  final double? height;

  /// 카드 너비 (null이면 자동)
  final double? width;

  /// 클릭 가능 여부
  final bool isClickable;

  /// 클릭 콜백
  final VoidCallback? onTap;

  /// 롱 프레스 콜백
  final VoidCallback? onLongPress;

  /// 애니메이션 활성화
  final bool enableAnimation;

  /// 애니메이션 지속시간
  final Duration animationDuration;

  /// 애니메이션 커브
  final Curve animationCurve;

  /// 카드 내용을 구현하는 추상 메서드
  Widget buildContent(BuildContext context);

  /// 제목 위젯 생성 (재정의 가능)
  Widget buildTitle(BuildContext context) {
    if (title == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (titleIcon != null) ...[
          Icon(titleIcon, size: 20, color: titleColor ?? AppColors.primary),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: titleColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// 기본 카드 스타일 제공
  BoxDecoration getCardDecoration() => BoxDecoration(
    color: backgroundColor ?? AppColors.surface,
    borderRadius: BorderRadius.circular(borderRadius),
    border: borderColor != null
        ? Border.all(color: borderColor!, width: borderWidth)
        : Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: borderWidth,
          ),
    boxShadow:
        boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
  );

  /// 카드 콘텐츠 레이아웃 (재정의 가능)
  Widget buildCardLayout(BuildContext context, Widget content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      buildTitle(context),
      if (title != null) const SizedBox(height: 16),
      content,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final content = buildContent(context);
    final cardLayout = buildCardLayout(context, content);

    Widget cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: getCardDecoration(),
      child: cardLayout,
    );

    // 클릭 가능한 카드인 경우 GestureDetector로 감싸기
    if (isClickable || onTap != null || onLongPress != null) {
      cardWidget = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardWidget,
      );
    }

    // 애니메이션 효과 적용
    if (enableAnimation) {
      cardWidget = AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

/// 간단한 텍스트 카드
class SimpleCard extends BaseCard {
  const SimpleCard({
    required this.text,
    super.key,
    this.textStyle,
    super.title,
    super.titleIcon,
    super.titleColor,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.borderColor,
    super.borderWidth,
    super.boxShadow,
    super.margin,
    super.height,
    super.width,
    super.isClickable,
    super.onTap,
    super.onLongPress,
    super.enableAnimation,
    super.animationDuration,
    super.animationCurve,
  });
  final String text;
  final TextStyle? textStyle;

  @override
  Widget buildContent(BuildContext context) =>
      Text(text, style: textStyle ?? Theme.of(context).textTheme.bodyMedium);
}

/// 아이콘과 텍스트가 있는 카드
class IconTextCard extends BaseCard {
  const IconTextCard({
    required this.icon,
    required this.text,
    super.key,
    this.subtitle,
    this.iconColor,
    this.textStyle,
    this.subtitleStyle,
    super.title,
    super.titleIcon,
    super.titleColor,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.borderColor,
    super.borderWidth,
    super.boxShadow,
    super.margin,
    super.height,
    super.width,
    super.isClickable,
    super.onTap,
    super.onLongPress,
    super.enableAnimation,
    super.animationDuration,
    super.animationCurve,
  });
  final IconData icon;
  final String text;
  final String? subtitle;
  final Color? iconColor;
  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget buildContent(BuildContext context) => Row(
    children: [
      Icon(icon, size: 24, color: iconColor ?? AppColors.primary),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style:
                    subtitleStyle ??
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

/// 리스트 아이템 카드
class ListItemCard extends BaseCard {
  const ListItemCard({
    required this.children,
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8,
    super.title,
    super.titleIcon,
    super.titleColor,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.borderColor,
    super.borderWidth,
    super.boxShadow,
    super.margin,
    super.height,
    super.width,
    super.isClickable,
    super.onTap,
    super.onLongPress,
    super.enableAnimation,
    super.animationDuration,
    super.animationCurve,
  });
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget buildContent(BuildContext context) => Column(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      for (int i = 0; i < children.length; i++) ...[
        children[i],
        if (i < children.length - 1) SizedBox(height: spacing),
      ],
    ],
  );
}
