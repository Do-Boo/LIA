// File: lib/presentation/screens/coaching_center_screen.dart
// 2025.07.15 22:03:00 코칭센터 화면 구현 - Phase 4

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../widgets/common/component_card.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/common/secondary_button.dart';
import '../widgets/specific/feedback/toast_notification.dart';

/// 코칭센터 화면
///
/// AI 메시지 작성 가이드, 팁, 상황별 템플릿을 제공하는 화면
/// 18세 서현 페르소나에 맞는 연애 상담 및 조언 제공
class CoachingCenterScreen extends StatefulWidget {
  const CoachingCenterScreen({super.key});

  @override
  State<CoachingCenterScreen> createState() => _CoachingCenterScreenState();
}

class _CoachingCenterScreenState extends State<CoachingCenterScreen> {
  int _selectedCategoryIndex = 0;

  // 카테고리 리스트
  final List<CoachingCategory> _categories = [
    CoachingCategory(
      id: 'basic',
      title: '기본',
      icon: HugeIcons.strokeRoundedMessage01,
      description: '일상적인 대화 시작하기',
    ),
    CoachingCategory(
      id: 'dating',
      title: '데이트',
      icon: HugeIcons.strokeRoundedCalendar01,
      description: '자연스러운 만남 제안법',
    ),
    CoachingCategory(
      id: 'reply',
      title: '답장',
      icon: Icons.reply,
      description: '상황별 답장 가이드',
    ),
    CoachingCategory(
      id: 'emotion',
      title: '감정',
      icon: HugeIcons.strokeRoundedHeartAdd,
      description: '마음을 전하는 방법',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // 헤더 섹션
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedBookOpen01,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '코칭센터',
                      style: AppTextStyles.mainTitle.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'AI와 함께 완벽한 메시지 만들기',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoryTabs(),
        ],
      ),
    );
  }

  // 카테고리 탭
  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.asMap().entries.map((entry) {
          int index = entry.key;
          CoachingCategory category = entry.value;
          bool isSelected = index == _selectedCategoryIndex;

          return GestureDetector(
            onTap: () => _selectCategory(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: category.icon,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.title,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected ? Colors.white : AppColors.primaryText,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 메인 컨텐츠
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _buildQuickTips(),
              const SizedBox(height: 16),
              _buildTemplates(),
              const SizedBox(height: 16),
              _buildAdvancedTips(),
              const SizedBox(height: 16),
              _buildPersonalizedAdvice(),
            ],
          ),
        ),
      ),
    );
  }

  // 빠른 팁
  Widget _buildQuickTips() {
    final tips = _getQuickTips();

    return ComponentCard(
      title: '💡 빠른 팁',
      child: Column(children: tips.map((tip) => _buildTipItem(tip)).toList()),
    );
  }

  // 팁 아이템
  Widget _buildTipItem(CoachingTip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: tip.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: HugeIcon(icon: tip.icon, color: tip.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.description,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 메시지 템플릿
  Widget _buildTemplates() {
    final templates = _getTemplates();

    return ComponentCard(
      title: '📝 메시지 템플릿',
      child: Column(
        children: templates
            .map((template) => _buildTemplateItem(template))
            .toList(),
      ),
    );
  }

  // 템플릿 아이템
  Widget _buildTemplateItem(MessageTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  template.situation,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _useTemplate(template),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '사용하기',
                    style: AppTextStyles.helper.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(template.message, style: AppTextStyles.body),
          ),
          const SizedBox(height: 8),
          Text(
            template.explanation,
            style: AppTextStyles.helper.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // 고급 팁
  Widget _buildAdvancedTips() {
    return ComponentCard(
      title: '🎯 고급 팁',
      child: Column(
        children: [
          _buildAdvancedTipCard(
            '타이밍이 중요해요',
            '상대방의 활동 패턴을 파악하고 적절한 시간에 메시지를 보내세요.',
            HugeIcons.strokeRoundedClock01,
            AppColors.accent,
          ),
          const SizedBox(height: 12),
          _buildAdvancedTipCard(
            '감정 표현의 균형',
            '너무 급하지 않게, 그렇다고 너무 차갑지도 않게 적절한 선을 유지하세요.',
            Icons.balance,
            AppColors.green,
          ),
          const SizedBox(height: 12),
          _buildAdvancedTipCard(
            '개인화된 메시지',
            '상대방의 관심사와 성격을 고려한 맞춤형 메시지를 작성하세요.',
            HugeIcons.strokeRoundedUserCircle,
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  // 고급 팁 카드
  Widget _buildAdvancedTipCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 개인화된 조언
  Widget _buildPersonalizedAdvice() {
    return ComponentCard(
      title: '🎪 서현이만의 특별한 조언',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
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
                            '서현이의 연애 꿀팁',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '실제 경험을 바탕으로 한 리얼한 조언',
                            style: AppTextStyles.helper.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"솔직히 말하면, 너무 완벽한 메시지보다는 진짜 내 마음이 담긴 메시지가 더 좋아. 상대방도 사람이니까 진심을 알아봐. 그리고 답장 안 온다고 너무 스트레스 받지 마! 타이밍이 안 맞을 수도 있거든. 중요한 건 내가 먼저 마음을 여는 거야."',
                  style: AppTextStyles.body.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        onPressed: () => _showMoreAdvice(),
                        text: '더 많은 조언',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => _startPersonalizedCoaching(),
                        text: '1:1 코칭',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리별 빠른 팁 데이터
  List<CoachingTip> _getQuickTips() {
    switch (_selectedCategoryIndex) {
      case 0: // 기본 메시지
        return [
          CoachingTip(
            title: '자연스러운 시작',
            description: '안부 인사나 공통 관심사로 대화를 시작하세요',
            icon: HugeIcons.strokeRoundedMessage01,
            color: AppColors.primary,
          ),
          CoachingTip(
            title: '적절한 길이',
            description: '너무 길거나 짧지 않게, 2-3문장 정도가 적당해요',
            icon: HugeIcons.strokeRoundedTextFont,
            color: AppColors.accent,
          ),
          CoachingTip(
            title: '이모지 활용',
            description: '감정을 표현할 때 적절한 이모지를 사용하세요',
            icon: HugeIcons.strokeRoundedHappy,
            color: AppColors.green,
          ),
        ];
      case 1: // 데이트 제안
        return [
          CoachingTip(
            title: '구체적인 제안',
            description: '언제, 어디서, 무엇을 할지 구체적으로 제안하세요',
            icon: HugeIcons.strokeRoundedCalendar01,
            color: AppColors.primary,
          ),
          CoachingTip(
            title: '선택권 제공',
            description: '여러 옵션을 제시해서 상대방이 선택할 수 있게 하세요',
            icon: HugeIcons.strokeRoundedCheckList,
            color: AppColors.accent,
          ),
          CoachingTip(
            title: '부담 줄이기',
            description: '처음에는 가벼운 만남부터 제안하세요',
            icon: HugeIcons.strokeRoundedCoffee01,
            color: AppColors.green,
          ),
        ];
      case 2: // 답장 요령
        return [
          CoachingTip(
            title: '빠른 응답',
            description: '가능한 빨리 답장하되, 너무 즉답하지는 마세요',
            icon: HugeIcons.strokeRoundedClock01,
            color: AppColors.primary,
          ),
          CoachingTip(
            title: '질문 이어가기',
            description: '상대방의 말에 관심을 보이고 질문을 이어가세요',
            icon: Icons.help_outline,
            color: AppColors.accent,
          ),
          CoachingTip(
            title: '감정 공감',
            description: '상대방의 감정에 공감하는 답장을 보내세요',
            icon: HugeIcons.strokeRoundedHeartAdd,
            color: AppColors.green,
          ),
        ];
      case 3: // 감정 표현
        return [
          CoachingTip(
            title: '솔직한 표현',
            description: '내 감정을 솔직하게 표현하되 부담스럽지 않게',
            icon: Icons.favorite_outline,
            color: AppColors.primary,
          ),
          CoachingTip(
            title: '단계적 접근',
            description: '감정 표현도 단계적으로, 천천히 깊어지게',
            icon: HugeIcons.strokeRoundedStairs01,
            color: AppColors.accent,
          ),
          CoachingTip(
            title: '상황 고려',
            description: '상대방의 상황과 기분을 고려해서 표현하세요',
            icon: HugeIcons.strokeRoundedBrain,
            color: AppColors.green,
          ),
        ];
      default:
        return [];
    }
  }

  // 카테고리별 템플릿 데이터
  List<MessageTemplate> _getTemplates() {
    switch (_selectedCategoryIndex) {
      case 0: // 기본 메시지
        return [
          MessageTemplate(
            situation: '첫 인사',
            message: '안녕하세요! 오늘 하루 어떻게 보내셨어요? 😊',
            explanation: '친근하면서도 정중한 첫 인사. 상대방의 하루에 관심을 보여줍니다.',
          ),
          MessageTemplate(
            situation: '안부 인사',
            message: '요즘 어떻게 지내세요? 바쁘신 것 같던데 몸 조심하세요!',
            explanation: '상대방을 걱정하는 마음을 담은 따뜻한 안부 인사입니다.',
          ),
        ];
      case 1: // 데이트 제안
        return [
          MessageTemplate(
            situation: '카페 데이트',
            message: '이번 주말에 시간 되시면 새로 생긴 카페 가볼까요? 분위기 좋다고 하더라고요 ☕',
            explanation: '부담스럽지 않은 카페 데이트 제안. 새로운 장소로 호기심을 유발합니다.',
          ),
          MessageTemplate(
            situation: '영화 관람',
            message: '○○ 영화 보고 싶었는데, 혹시 같이 볼 사람 있을까요? 😄',
            explanation: '직접적이지 않으면서도 함께 하고 싶다는 의사를 전달합니다.',
          ),
        ];
      case 2: // 답장 요령
        return [
          MessageTemplate(
            situation: '늦은 답장',
            message: '답장이 늦어서 죄송해요! 바빠서 못 봤어요 😅 지금 봤는데...',
            explanation: '늦은 답장에 대한 사과와 함께 대화를 이어갑니다.',
          ),
          MessageTemplate(
            situation: '공감 답장',
            message: '정말 힘들었겠어요 ㅠㅠ 그런 일이 있었다니... 괜찮으세요?',
            explanation: '상대방의 어려움에 공감하고 위로하는 답장입니다.',
          ),
        ];
      case 3: // 감정 표현
        return [
          MessageTemplate(
            situation: '고마움 표현',
            message: '오늘 정말 고마웠어요! 덕분에 기분이 많이 좋아졌어요 💕',
            explanation: '감사한 마음을 솔직하게 표현하면서 긍정적인 감정을 전달합니다.',
          ),
          MessageTemplate(
            situation: '관심 표현',
            message: '○○님과 이야기하는 시간이 정말 즐거워요. 더 많은 이야기 나누고 싶어요 😊',
            explanation: '상대방에 대한 관심과 호감을 자연스럽게 표현합니다.',
          ),
        ];
      default:
        return [];
    }
  }

  // 카테고리 선택
  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  // 템플릿 사용
  void _useTemplate(MessageTemplate template) {
    ToastNotification.show(
      context: context,
      message: '템플릿이 적용되었어요! AI 메시지 화면에서 확인하세요',
      type: ToastType.success,
    );
  }

  // 더 많은 조언 보기
  void _showMoreAdvice() {
    ToastNotification.show(
      context: context,
      message: '더 많은 조언 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 개인화된 코칭 시작
  void _startPersonalizedCoaching() {
    ToastNotification.show(
      context: context,
      message: '1:1 코칭 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }
}

// 코칭 카테고리 모델
class CoachingCategory {
  final String id;
  final String title;
  final IconData icon;
  final String description;

  CoachingCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });
}

// 코칭 팁 모델
class CoachingTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  CoachingTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// 메시지 템플릿 모델
class MessageTemplate {
  final String situation;
  final String message;
  final String explanation;

  MessageTemplate({
    required this.situation,
    required this.message,
    required this.explanation,
  });
}
