// File: lib/presentation/widgets/common/scenario_card.dart

import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

/// 실제 사용 시나리오를 보여주는 카드입니다.
///
/// 18세 서현 페르소나의 실제 사용 상황을 기반으로 한 구체적인 예시를 제공하여,
/// 개발자들이 위젯을 언제, 어떻게 사용해야 하는지 쉽게 이해할 수 있도록 도와줍니다.
///
/// ## 🎯 사용 시나리오
/// - **위젯 사용법 가이드**: 실제 화면에서의 위젯 활용법
/// - **UX 시나리오**: 사용자 여정에 따른 위젯 배치
/// - **개발 가이드**: 구체적인 구현 상황 예시
/// - **디자인 문서**: 시나리오 기반 디자인 설명
///
/// ## 🎨 디자인 특징
/// - **스토리텔링**: 서현이의 실제 상황을 스토리로 설명
/// - **단계별 설명**: 사용자 행동에 따른 단계별 안내
/// - **시각적 구분**: 각 시나리오를 명확히 구분
/// - **친근한 톤**: 18세 페르소나에 맞는 친근한 설명
///
/// ## 💡 사용법
/// ```dart
/// ScenarioCard(
///   title: '메시지 생성 시나리오',
///   scenarios: [
///     ScenarioStep(
///       title: '상황 입력',
///       description: '서현이가 썸남에게 보낼 메시지 상황을 입력해요',
///       widget: 'FloatingLabelTextField',
///     ),
///   ],
/// )
/// ```
class ScenarioCard extends StatelessWidget {
  /// 시나리오 카드의 제목입니다.
  final String title;
  
  /// 시나리오 단계들입니다.
  final List<ScenarioStep> scenarios;
  
  /// 전체 시나리오 설명 (옵션)입니다.
  final String? description;

  const ScenarioCard({
    super.key,
    required this.title,
    required this.scenarios,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.yellow.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.movie_creation,
                  color: AppColors.yellow,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 전체 설명 (있는 경우)
          if (description != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description!,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
            ),
          ],
          
          // 시나리오 단계들
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: scenarios.asMap().entries.map((entry) {
                final index = entry.key;
                final scenario = entry.value;
                return _buildScenarioStep(scenario, index + 1);
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// 개별 시나리오 단계를 생성합니다.
  Widget _buildScenarioStep(ScenarioStep scenario, int stepNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 단계 번호
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: AppTextStyles.helper.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 단계 내용
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 단계 제목과 위젯 뱃지
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scenario.title,
                          style: AppTextStyles.helper.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.charcoal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      
                      // 위젯 뱃지
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          scenario.widget,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 단계 설명
                  Text(
                    scenario.description,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                  
                  // 서현이 대사 (있는 경우)
                  if (scenario.userQuote != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.format_quote,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              scenario.userQuote!,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // 기대 결과 (있는 경우)
                  if (scenario.expectedResult != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '결과: ${scenario.expectedResult!}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 시나리오 단계 정보를 담는 데이터 클래스입니다.
class ScenarioStep {
  /// 단계 제목
  final String title;
  
  /// 단계 설명
  final String description;
  
  /// 사용되는 위젯
  final String widget;
  
  /// 사용자(서현이)의 대사 (옵션)
  final String? userQuote;
  
  /// 기대되는 결과 (옵션)
  final String? expectedResult;

  const ScenarioStep({
    required this.title,
    required this.description,
    required this.widget,
    this.userQuote,
    this.expectedResult,
  });
} 