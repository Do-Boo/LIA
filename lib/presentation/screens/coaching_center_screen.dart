// File: lib/presentation/screens/coaching_center_screen.dart
// 2025.07.18 13:27:31 코칭센터 화면 main_screen.dart 스타일로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 코칭센터 화면
///
/// AI 메시지 작성 가이드, 팁, 상황별 템플릿을 제공하는 화면
/// 18세 서현 페르소나에 맞는 연애 상담 및 조언 제공
/// main_screen.dart 스타일로 통일된 디자인 적용
class CoachingCenterScreen extends StatefulWidget {
  const CoachingCenterScreen({super.key});

  @override
  State<CoachingCenterScreen> createState() => _CoachingCenterScreenState();
}

class _CoachingCenterScreenState extends State<CoachingCenterScreen> {
  // 카테고리 선택 상태 제거 - 더 이상 필요 없음

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
        vertical: 12,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.gapV16,

            // 1. 내 대화 분석 결과
            _buildSimpleSection(
              '내 대화 분석 결과',
              '12개의 대화를 분석하여 당신의 대화 스타일을 분석했습니다',
              HugeIcons.strokeRoundedAnalytics01,
              _buildAnalysisInsightContent(),
            ),

            AppSpacing.gapV24,

            // 2. 대화 스타일 진단
            _buildSimpleSection(
              '대화 스타일 진단',
              '당신의 대화 유형과 특성을 자세히 알아보세요',
              HugeIcons.strokeRoundedUserCheck01,
              _buildConversationStyleContent(),
            ),

            AppSpacing.gapV24,

            // 3. 감정 표현 분석
            _buildSimpleSection(
              '감정 표현 분석',
              '메시지에서 감정을 어떻게 표현하는지 분석합니다',
              HugeIcons.strokeRoundedHeartAdd,
              _buildEmotionAnalysisContent(),
            ),

            AppSpacing.gapV24,

            // 4. 개선 포인트
            _buildSimpleSection(
              '개선 포인트',
              '더 효과적인 소통을 위한 구체적인 개선 방안을 제시합니다',
              HugeIcons.strokeRoundedTarget01,
              _buildImprovementPointsContent(),
            ),

            AppSpacing.gapV40,
          ],
        ),
      ),
    ),
  );

  // 분석 기반 인사이트 컨텐츠 - SectionCard 내부용으로 변경
  Widget _buildAnalysisInsightContent() => Column(
    children: [
      // 분석 결과 요약
      Row(
        children: [
          Expanded(
            child: _buildInsightMetric('대화 스타일', '신중형', AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildInsightMetric('호감도', '78점', AppColors.green)),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInsightMetric('개선 포인트', '감정 표현', AppColors.accent),
          ),
        ],
      ),

      const SizedBox(height: 16),
      Text(
        '💡 분석 결과, 당신은 신중하고 배려심 많은 대화를 나누지만, 감정 표현을 조금 더 적극적으로 해보시면 좋을 것 같아요!',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),

      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: SecondaryButton(
              onPressed: _showDetailedAnalysis,
              text: '상세 분석 보기',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              onPressed: _startPersonalizedCoaching,
              text: '맞춤 코칭 시작',
            ),
          ),
        ],
      ),
    ],
  );

  // 대화 스타일 진단 컨텐츠
  Widget _buildConversationStyleContent() => Column(
    children: [
      _buildAnalysisCard(
        '신중한 대화 스타일',
        '메시지를 보내기 전에 충분히 고민하는 편이에요. 실수를 줄이고 상대방을 배려하려는 마음이 크답니다.',
        HugeIcons.strokeRoundedIdea,
        AppColors.primary,
        '85%',
      ),
      const SizedBox(height: 12),
      _buildAnalysisCard(
        '질문형 대화 선호',
        '상대방에게 관심을 보이며 질문을 많이 하는 편이에요. 대화를 이끌어가려는 적극성이 보여요.',
        HugeIcons.strokeRoundedMessageQuestion,
        AppColors.green,
        '72%',
      ),
      const SizedBox(height: 12),
      _buildAnalysisCard(
        '감정 표현 절제',
        '감정을 직접적으로 표현하기보다는 은근하게 전달하는 스타일이에요. 조금 더 솔직해도 좋을 것 같아요.',
        HugeIcons.strokeRoundedHeartAdd,
        AppColors.accent,
        '58%',
      ),
    ],
  );

  // 감정 표현 분석 컨텐츠
  Widget _buildEmotionAnalysisContent() => Column(
    children: [
      _buildEmotionChart(),
      const SizedBox(height: 16),
      Text(
        '당신의 메시지에서 가장 많이 나타나는 감정은 "배려"와 "관심"이에요. 긍정적인 감정 표현을 조금 더 늘려보시면 어떨까요?',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    ],
  );

  // 개선 포인트 컨텐츠
  Widget _buildImprovementPointsContent() => Column(
    children: [
      _buildImprovementCard(
        '감정 표현 늘리기',
        '좋은 감정을 더 적극적으로 표현해보세요',
        '• "기뻐" → "정말 기뻐!" \n• "고마워" → "진짜 고마워 ❤️"',
        AppColors.primary,
        '우선순위 높음',
      ),
      const SizedBox(height: 12),
      _buildImprovementCard(
        '대화 주도권 갖기',
        '질문만 하지 말고 자신의 이야기도 들려주세요',
        '• 상대방 이야기에 공감한 후 본인 경험 공유\n• "나도 비슷한 경험이 있어" 같은 표현 사용',
        AppColors.green,
        '우선순위 중간',
      ),
      const SizedBox(height: 12),
      _buildImprovementCard(
        '타이밍 조절',
        '답장 속도를 조금 더 빠르게 해보세요',
        '• 2-3시간 내 답장하기\n• 바쁠 때는 "바빠서 나중에 답장할게" 미리 알리기',
        AppColors.accent,
        '우선순위 낮음',
      ),
    ],
  );

  // 분석 카드 위젯
  Widget _buildAnalysisCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String percentage,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.1)),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    percentage,
                    style: AppTextStyles.cardDescription.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.cardDescription.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // 감정 차트 위젯
  Widget _buildEmotionChart() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
    ),
    child: Column(
      children: [
        Text(
          '감정 표현 분포',
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildEmotionBar('배려/관심', 85, AppColors.primary),
        const SizedBox(height: 8),
        _buildEmotionBar('기쁨/행복', 45, AppColors.green),
        const SizedBox(height: 8),
        _buildEmotionBar('걱정/불안', 30, AppColors.accent),
        const SizedBox(height: 8),
        _buildEmotionBar('사랑/애정', 25, Colors.pink),
      ],
    ),
  );

  // 감정 바 위젯
  Widget _buildEmotionBar(String emotion, int percentage, Color color) => Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          emotion,
          style: AppTextStyles.cardDescription.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        '$percentage%',
        style: AppTextStyles.cardDescription.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ],
  );

  // 개선 포인트 카드 위젯
  Widget _buildImprovementCard(
    String title,
    String description,
    String examples,
    Color color,
    String priority,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priority,
                style: AppTextStyles.cardDescription.copyWith(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTextStyles.cardDescription.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            examples,
            style: AppTextStyles.cardDescription.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );

  // 인사이트 지표 위젯
  Widget _buildInsightMetric(String title, String value, Color color) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.cardTitle.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.cardDescription.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  // 개인화된 조언 컨텐츠 - 분석 기반 리얼 조언으로 변경
  Widget _buildPersonalizedAdviceContent() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '서',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '서현이의 리얼 조언',
                    style: AppTextStyles.cardTitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '분석 결과를 바탕으로 한 맞춤형 조언',
                    style: AppTextStyles.cardDescription.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '"분석해보니 너는 감정 표현을 조금 어려워하는 것 같아. 그런데 그게 나쁜 건 아니야! 오히려 신중한 편이라서 더 진짜 같은 느낌이 들어. 다만 조금만 더 솔직하게 표현해도 좋을 것 같아. 상대방도 너의 진심을 알고 싶어할 거야. 작은 것부터 시작해봐!"',
          style: AppTextStyles.body1.copyWith(
            fontStyle: FontStyle.italic,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // 구체적인 액션 제안
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedTarget01,
                    color: AppColors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '오늘 당장 해볼 수 있는 것',
                    style: AppTextStyles.cardDescription.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• "오늘 하루 어땠어?" 대신 "오늘 뭐가 제일 재밌었어?"로 물어보기\n• 답장할 때 이모티콘 하나씩 더 추가해보기\n• 상대방이 말한 내용에 대해 한 가지 더 질문하기',
                style: AppTextStyles.cardDescription.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: _showMoreAdvice,
                text: '더 자세한 분석',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                onPressed: _startPersonalizedCoaching,
                text: '맞춤 코칭 받기',
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // 더 많은 조언 보기
  void _showMoreAdvice() {
    ToastNotification.show(
      context: context,
      message: '더 많은 조언 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 상세 분석 보기
  void _showDetailedAnalysis() {
    ToastNotification.show(
      context: context,
      message: '상세 분석 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 맞춤 코칭 시작
  void _startPersonalizedCoaching() {
    ToastNotification.show(
      context: context,
      message: '맞춤 코칭 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 간단한 섹션 위젯
  Widget _buildSimpleSection(
    String title,
    String description,
    IconData icon,
    Widget content,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppSpacing.gapV8,
      Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.cardDescription.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      AppSpacing.gapV16,
      content,
    ],
  );
}
