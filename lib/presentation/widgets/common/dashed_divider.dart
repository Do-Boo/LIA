// File: lib/presentation/widgets/common/dashed_divider.dart

import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

/// 컴포넌트 카드 내에서 사용하는 점선 구분선 위젯입니다.
///
/// 제목과 내용 사이를 시각적으로 구분하며,
/// 동적으로 화면 너비에 맞춰 점선의 개수를 계산하여 표시합니다.
///
/// 주요 특징:
/// - 화면 너비에 반응하는 반응형 디자인
/// - 일정한 간격의 점선 패턴
/// - 카드 테두리 색상과 일치하는 색상 사용
/// - 적절한 상하 여백으로 시각적 분리 효과
///
/// 사용 위치:
/// - ComponentCard 내부의 제목과 내용 사이
/// - 기타 섹션 구분이 필요한 곳
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 사용 가능한 너비 계산
          final boxWidth = constraints.constrainWidth();
          
          // 각 점선의 너비와 높이
          const dashWidth = 5.0;
          const dashHeight = 2.0;
          
          // 너비에 맞는 점선 개수 계산
          // 점선 사이의 간격도 고려하여 전체 너비를 2배로 나눔
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.cardBorder),
                ),
              );
            }),
          );
        },
      ),
    );
  }
} 