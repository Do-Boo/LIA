// File: lib/presentation/screens/ai_message_screen.dart
// 2025.07.18 13:27:31 AI 메시지 화면 main_screen.dart 스타일로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// AI 메시지 화면
///
/// AI 기반 메시지 생성 및 편집 기능을 제공하는 화면
/// 18세 서현 페르소나에 맞는 맞춤형 메시지 작성 도구
/// main_screen.dart 스타일로 통일된 디자인 적용
class AiMessageScreen extends StatefulWidget {
  const AiMessageScreen({super.key});

  @override
  State<AiMessageScreen> createState() => _AiMessageScreenState();
}

class _AiMessageScreenState extends State<AiMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();

  // 메시지 생성 상태
  bool _isGenerating = false;
  String _generatedMessage = '';
  int _selectedTone = 0; // 0: 친근함, 1: 정중함, 2: 유머러스, 3: 로맨틱
  int _selectedCategory = 0; // 0: 일반, 1: 데이트, 2: 사과, 3: 감사, 4: 위로

  // 톤 옵션
  final List<ToneOption> _toneOptions = [
    ToneOption(
      title: '친근함',
      description: '편안하고 자연스러운 톤',
      icon: HugeIcons.strokeRoundedHappy,
      color: AppColors.primary,
    ),
    ToneOption(
      title: '정중함',
      description: '예의 바르고 정중한 톤',
      icon: HugeIcons.strokeRoundedUserCheck01,
      color: AppColors.accent,
    ),
    ToneOption(
      title: '유머러스',
      description: '재미있고 유쾌한 톤',
      icon: HugeIcons.strokeRoundedSmile,
      color: AppColors.green,
    ),
    ToneOption(
      title: '로맨틱',
      description: '달콤하고 애정 어린 톤',
      icon: HugeIcons.strokeRoundedHeartAdd,
      color: AppColors.error,
    ),
  ];

  // 카테고리 옵션
  final List<CategoryOption> _categoryOptions = [
    CategoryOption(
      title: '일반 메시지',
      description: '일상적인 대화',
      icon: HugeIcons.strokeRoundedMessage01,
      color: AppColors.primaryText,
    ),
    CategoryOption(
      title: '데이트 제안',
      description: '만남 제안하기',
      icon: HugeIcons.strokeRoundedCalendarAdd01,
      color: AppColors.primary,
    ),
    CategoryOption(
      title: '사과 메시지',
      description: '진심 어린 사과',
      icon: HugeIcons.strokeRoundedApple01,
      color: AppColors.accent,
    ),
    CategoryOption(
      title: '감사 인사',
      description: '고마움 표현하기',
      icon: HugeIcons.strokeRoundedThumbsUp,
      color: AppColors.green,
    ),
    CategoryOption(
      title: '위로 메시지',
      description: '따뜻한 위로와 격려',
      icon: HugeIcons.strokeRoundedHandPrayer,
      color: AppColors.error,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
          vertical: 12,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.gapV24,

              // 대시보드 헤더
              DashboardHeader(
                title: 'AI 메시지 생성',
                subtitle: '상황에 맞는 완벽한 메시지를 AI가 만들어드려요',
                icon: HugeIcons.strokeRoundedMessage01,
                actions: [
                  DashboardAction(
                    title: '빠른 생성',
                    icon: HugeIcons.strokeRoundedFlash,
                    onTap: _quickGenerate,
                  ),
                  DashboardAction(
                    title: '템플릿',
                    icon: HugeIcons.strokeRoundedAlignBoxTopLeft,
                    onTap: _showTemplates,
                  ),
                  DashboardAction(
                    title: '히스토리',
                    icon: HugeIcons.strokeRoundedTimeQuarter02,
                    onTap: _showHistory,
                  ),
                ],
              ),

              AppSpacing.gapV24,

              // 1. 메시지 설정
              SectionCard(
                number: '1',
                title: '메시지 설정',
                description: '메시지 톤과 카테고리를 선택하세요',
                child: _buildMessageSettingsContent(),
              ),

              AppSpacing.gapV24,

              // 2. 상황 설명
              SectionCard(
                number: '2',
                title: '상황 설명',
                description: '메시지를 보내는 상황을 자세히 설명해주세요',
                child: _buildContextInputContent(),
              ),

              AppSpacing.gapV24,

              // 3. 메시지 생성 & 편집
              SectionCard(
                number: '3',
                title: 'AI 메시지 생성',
                description: 'AI가 상황에 맞는 완벽한 메시지를 생성합니다',
                child: _buildMessageGenerationContent(),
              ),

              AppSpacing.gapV24,

              // 4. 생성된 메시지 & 편집
              if (_generatedMessage.isNotEmpty)
                SectionCard(
                  number: '4',
                  title: '생성된 메시지',
                  description: '메시지를 확인하고 필요시 수정하세요',
                  child: _buildGeneratedMessageContent(),
                ),

              AppSpacing.gapV40,
            ],
          ),
        ),
      ),
    ),
  );

  // 메시지 설정 컨텐츠
  Widget _buildMessageSettingsContent() => Column(
    children: [
      // 톤 선택
      _buildToneSelector(),
      const SizedBox(height: 20),
      // 카테고리 선택
      _buildCategorySelector(),
    ],
  );

  // 생성된 메시지 컨텐츠 - 메인 화면의 인사이트 메시지 스타일 적용
  Widget _buildGeneratedMessageContent() => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.green.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI 생성 메시지',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                      Text(
                        '상황에 맞게 최적화된 메시지입니다',
                        style: AppTextStyles.sectionDescription.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 메시지 내용 - 인사이트 카드 스타일
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.green.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedMessage01,
                        size: 16,
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '완성된 메시지',
                        style: AppTextStyles.cardDescription.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _generatedMessage,
                    style: AppTextStyles.body1.copyWith(
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // 액션 버튼들
      Row(
        children: [
          Expanded(
            child: SecondaryButton(
              onPressed: _regenerateMessage,
              text: '🔄 다시 생성',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SecondaryButton(onPressed: _editMessage, text: '✏️ 직접 수정'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(onPressed: _copyMessage, text: '📋 복사하기'),
          ),
        ],
      ),
    ],
  );

  // 톤 선택기 - 메인 화면의 지표 카드 스타일 적용
  Widget _buildToneSelector() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.1),
          AppColors.accent.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedVoice,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '메시지 톤 선택',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '상황에 맞는 톤을 선택해주세요',
                    style: AppTextStyles.sectionDescription.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 톤 옵션들 - 지표 카드 스타일
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: _toneOptions.asMap().entries.map((entry) {
            final int index = entry.key;
            final ToneOption option = entry.value;
            final bool isSelected = index == _selectedTone;

            return GestureDetector(
              onTap: () => setState(() => _selectedTone = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            option.color,
                            option.color.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.9),
                            Colors.white.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? option.color
                        : option.color.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: option.color.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : option.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        option.icon,
                        color: isSelected ? Colors.white : option.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option.title,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: isSelected ? Colors.white : option.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: AppTextStyles.cardDescription.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            : AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );

  // 카테고리 선택기 - 메인 화면의 지표 카드 스타일 적용
  Widget _buildCategorySelector() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.1),
          AppColors.green.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      boxShadow: [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedMenuSquare,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '메시지 카테고리',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  Text(
                    '메시지 목적에 맞는 카테고리를 선택해주세요',
                    style: AppTextStyles.sectionDescription.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 카테고리 옵션들 - 지표 카드 스타일 (세로 스크롤 가능)
        SizedBox(
          height: 180,
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: _categoryOptions.asMap().entries.map((entry) {
              final int index = entry.key;
              final CategoryOption option = entry.value;
              final bool isSelected = index == _selectedCategory;

              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              option.color,
                              option.color.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? option.color
                          : option.color.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: option.color.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : option.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option.icon,
                          color: isSelected ? Colors.white : option.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.title,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: isSelected ? Colors.white : option.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: AppTextStyles.cardDescription.copyWith(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.textSecondary,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );

  // 상황 입력 컨텐츠
  Widget _buildContextInputContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '상황 설명',
        style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _contextController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: '예: 어제 데이트 후 감사 인사를 하고 싶어요',
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.secondaryText.withValues(alpha: 0.7),
          ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        style: AppTextStyles.body,
      ),
    ],
  );

  // 메시지 생성 컨텐츠
  Widget _buildMessageGenerationContent() => Column(
    children: [
      _buildGenerateButton(),
      if (_generatedMessage.isNotEmpty) ...[
        const SizedBox(height: 20),
        _buildGeneratedMessage(),
      ],
    ],
  );

  // 생성 버튼
  Widget _buildGenerateButton() => SizedBox(
    width: double.infinity,
    child: PrimaryButton(
      onPressed: _canGenerate() ? _generateMessage : null,
      text: _isGenerating ? '생성 중...' : 'AI 메시지 생성',
      isLoading: _isGenerating,
    ),
  );

  // 생성된 메시지 표시
  Widget _buildGeneratedMessage() => Container(
    width: double.infinity,
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
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'AI 생성 메시지',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _generatedMessage,
          style: AppTextStyles.body.copyWith(height: 1.5),
        ),
      ],
    ),
  );

  // 생성 가능 여부 확인
  bool _canGenerate() => _contextController.text.trim().isNotEmpty;

  // 메시지 생성
  Future<void> _generateMessage() async {
    if (!_canGenerate()) return;

    setState(() => _isGenerating = true);

    // 실제 AI 생성 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generatedMessage = _getSampleMessage();
    });

    ToastNotification.show(
      context: context,
      message: '메시지가 생성되었어요!',
      type: ToastType.success,
    );
  }

  // 샘플 메시지 반환
  String _getSampleMessage() {
    switch (_selectedCategory) {
      case 0: // 일반 메시지
        return '안녕하세요! 오늘 하루 어떻게 보내셨어요? 날씨가 정말 좋네요 😊';
      case 1: // 데이트 제안
        return '혹시 이번 주말에 시간 되시면 새로 생긴 카페 가볼까요? 분위기 좋다고 하더라고요 ☕';
      case 2: // 사과 메시지
        return '정말 죄송해요. 제가 잘못 생각했나 봐요. 다음에는 더 신중하게 할게요 🙏';
      case 3: // 감사 인사
        return '오늘 정말 즐거웠어요! 덕분에 기분이 많이 좋아졌답니다 💕';
      case 4: // 위로 메시지
        return '힘든 시간이겠지만 항상 응원하고 있어요. 언제든 이야기하고 싶으면 연락해주세요 🤗';
      default:
        return '안녕하세요! 좋은 하루 보내세요 😊';
    }
  }

  // 메시지 재생성
  void _regenerateMessage() {
    _generateMessage();
  }

  // 메시지 편집
  void _editMessage() {
    ToastNotification.show(
      context: context,
      message: '메시지 편집 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 메시지 복사
  void _copyMessage() {
    ToastNotification.show(
      context: context,
      message: '메시지가 클립보드에 복사되었어요!',
      type: ToastType.success,
    );
  }

  // 빠른 생성
  void _quickGenerate() {
    if (_contextController.text.trim().isEmpty) {
      _contextController.text = '일상적인 안부 인사를 하고 싶어요';
    }
    _generateMessage();
  }

  // 템플릿 보기
  void _showTemplates() {
    ToastNotification.show(
      context: context,
      message: '메시지 템플릿 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 히스토리 보기
  void _showHistory() {
    ToastNotification.show(
      context: context,
      message: '메시지 히스토리 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 빠른 통계 보기
  void _showQuickStats() {
    ToastNotification.show(
      context: context,
      message: '메시지 통계 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }
}

// 톤 옵션 클래스
class ToneOption {
  ToneOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

// 카테고리 옵션 클래스
class CategoryOption {
  CategoryOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
