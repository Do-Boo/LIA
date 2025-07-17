// File: lib/presentation/widgets/common/parameter_card.dart

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

/// 위젯의 파라미터를 설명하는 카드입니다.
///
/// 18세 서현 페르소나를 위한 친근하고 이해하기 쉬운 파라미터 설명을 제공합니다.
/// 각 파라미터의 타입, 필수 여부, 설명을 시각적으로 보여줍니다.
///
/// ## 🎯 사용 시나리오
/// - **위젯 문서화**: 각 위젯의 파라미터 설명
/// - **개발 가이드**: 파라미터 사용법 안내
/// - **API 문서**: 함수나 클래스의 파라미터 설명
/// - **튜토리얼**: 단계별 파라미터 설명
///
/// ## 🎨 디자인 특징
/// - **구조화된 레이아웃**: 파라미터명, 타입, 설명이 명확히 구분
/// - **색상 코딩**: 필수/선택 파라미터를 색상으로 구분
/// - **타입 뱃지**: 파라미터 타입을 뱃지로 표시
/// - **친근한 설명**: 서현 페르소나에 맞는 쉬운 설명
///
/// ## 💡 사용법
/// ```dart
/// ParameterCard(
///   widgetName: 'PrimaryButton',
///   parameters: [
///     ParameterInfo(
///       name: 'onPressed',
///       type: 'VoidCallback?',
///       isRequired: true,
///       description: '버튼을 눌렀을 때 실행될 함수예요',
///     ),
///   ],
/// )
/// ```
class ParameterCard extends StatelessWidget {
  /// 위젯 이름입니다.
  final String widgetName;

  /// 파라미터 정보 리스트입니다.
  final List<ParameterInfo> parameters;

  const ParameterCard({
    super.key,
    required this.widgetName,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 - 단순화
            Row(
              children: [
                Icon(Icons.settings, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$widgetName 파라미터',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 파라미터 리스트
            ...parameters.map((param) => _buildParameterItem(param)),
          ],
        ),
      ),
    );
  }

  /// 개별 파라미터 아이템을 생성합니다.
  Widget _buildParameterItem(ParameterInfo param) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: param.isRequired
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 파라미터명과 타입
            Row(
              children: [
                // 파라미터명
                Expanded(
                  child: Text(
                    param.name,
                    style: AppTextStyles.helper.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                      fontSize: 16,
                    ),
                  ),
                ),

                // 필수 여부 뱃지
                if (param.isRequired) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '필수',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // 타입 뱃지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    param.type,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Courier', // 코드 폰트
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 파라미터 설명
            Text(
              param.description,
              style: AppTextStyles.body.copyWith(
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),

            // 예시 (있는 경우)
            if (param.example != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.charcoal.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 예시:',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      param.example!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.charcoal,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 파라미터 정보를 담는 데이터 클래스입니다.
class ParameterInfo {
  /// 파라미터 이름
  final String name;

  /// 파라미터 타입
  final String type;

  /// 필수 파라미터 여부
  final bool isRequired;

  /// 파라미터 설명
  final String description;

  /// 사용 예시 (옵션)
  final String? example;

  const ParameterInfo({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.description,
    this.example,
  });
}
