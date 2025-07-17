// File: lib/presentation/widgets/common/component_card.dart

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import 'dashed_divider.dart';

/// 디자인 컴포넌트를 감싸는 공용 카드 위젯입니다.
///
/// 각 디자인 가이드 섹션을 일관된 스타일로 표시하며,
/// 단순하고 깔끔한 디자인으로 컨텐츠에 집중할 수 있도록 합니다.
///
/// UI/UX 개선 사항 (2025.07.15 21:15:00):
/// - 불필요한 Container 중첩 제거
/// - 패딩 24px → 16px로 축소
/// - 과도한 애니메이션 효과 제거
/// - 그림자 효과 간소화
/// - 컨텐츠 영역 확대
///
/// @param title 카드 상단에 표시될 제목 텍스트
/// @param subtitle 제목 아래 표시될 부제목 (선택사항)
/// @param child 카드 내부에 표시될 위젯 내용
class ComponentCard extends StatelessWidget {
  /// 카드의 제목입니다.
  /// 컴포넌트 타이틀 스타일로 표시됩니다.
  final String title;

  /// 카드의 부제목입니다 (선택사항).
  /// 제목 아래에 작은 글씨로 표시됩니다.
  final String? subtitle;

  /// 카드 내부에 표시될 위젯입니다.
  /// 제목 아래 점선 구분선 다음에 배치됩니다.
  final Widget child;

  const ComponentCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.componentTitle),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: AppTextStyles.helper.copyWith(
                  color: AppColors.accent.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const DashedDivider(),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
