// File: lib/presentation/screens/ai_message_screen.dart
// 2025.07.23 14:35:00 카카오톡 스타일로 완전 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 톤 옵션 모델
class ToneOption {
  const ToneOption({
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

/// 카테고리 옵션 모델
class CategoryOption {
  const CategoryOption({
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

/// AI 메시지 화면
///
/// AI 기반 메시지 생성 및 편집 기능을 제공하는 화면
/// 카카오톡 스타일의 심플하고 직관적인 구조로 구성
/// 상단 메시지 요약 + 중간 입력 영역 + 하단 결과 표시 패턴 적용
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
  int _selectedTone = 0;
  int _selectedCategory = 0;

  // AI 메시지 데이터
  final Map<String, dynamic> _messageData = {
    'totalGenerated': 127,
    'successRate': 89,
    'favoriteStyle': '친근함',
    'lastUsed': '2025.07.23',
  };

  // 톤 옵션
  final List<ToneOption> _toneOptions = [
    const ToneOption(
      title: '친근함',
      description: '편안하고 자연스러운 톤',
      icon: Icons.sentiment_satisfied,
      color: AppColors.primary,
    ),
    const ToneOption(
      title: '정중함',
      description: '예의 바르고 정중한 톤',
      icon: HugeIcons.strokeRoundedUserCheck01,
      color: AppColors.accent,
    ),
    const ToneOption(
      title: '유머러스',
      description: '재미있고 유쾌한 톤',
      icon: Icons.sentiment_very_satisfied,
      color: AppColors.green,
    ),
    const ToneOption(
      title: '로맨틱',
      description: '달콤하고 애정 어린 톤',
      icon: HugeIcons.strokeRoundedHeartAdd,
      color: Colors.pink,
    ),
  ];

  // 카테고리 옵션
  final List<CategoryOption> _categoryOptions = [
    const CategoryOption(
      title: '일반 메시지',
      description: '일상적인 대화',
      icon: HugeIcons.strokeRoundedMessage01,
      color: AppColors.textPrimary,
    ),
    const CategoryOption(
      title: '데이트 제안',
      description: '만남 제안하기',
      icon: HugeIcons.strokeRoundedCalendar01,
      color: AppColors.primary,
    ),
    const CategoryOption(
      title: '사과 메시지',
      description: '진심 어린 사과',
      icon: HugeIcons.strokeRoundedSad01,
      color: AppColors.accent,
    ),
    const CategoryOption(
      title: '감사 인사',
      description: '고마움 표현하기',
      icon: HugeIcons.strokeRoundedThumbsUp,
      color: AppColors.green,
    ),
    const CategoryOption(
      title: '위로 메시지',
      description: '따뜻한 위로와 격려',
      icon: HugeIcons.strokeRoundedHeartAdd,
      color: Colors.orange,
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
      child: _generatedMessage.isNotEmpty
          ? _buildWithResultScreen()
          : _buildInputScreenWithScroll(),
    ),
  );

  // 상단 메시지 요약 섹션 (카카오톡 스타일)
  Widget _buildMessageSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.white.withValues(alpha: 0),
    child: Column(
      children: [
        // AI 메시지 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 16),

        // AI 메시지 타이틀
        Text(
          'AI 메시지 생성',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 생성 통계
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '총 ${_messageData['totalGenerated']}개 생성 • 성공률 ${_messageData['successRate']}%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  // 설정 그룹 (섹션 헤더)
  Widget _buildSettingGroup(String title, Widget content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Text(
          title,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: content,
      ),
      const SizedBox(height: 16),
    ],
  );

  // 톤 선택기 (더 심플하게)
  Widget _buildToneSelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _toneOptions.asMap().entries.map((entry) {
      final index = entry.key;
      final tone = entry.value;
      final isSelected = _selectedTone == index;

      return GestureDetector(
        onTap: () => setState(() => _selectedTone = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? tone.color : AppColors.background,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? tone.color : AppColors.surface,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tone.icon,
                color: isSelected ? Colors.white : tone.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                tone.title,
                style: AppTextStyles.body2.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );

  // 카테고리 선택기 (카드 스타일로 깔끔하게)
  Widget _buildCategorySelector() => Column(
    children: _categoryOptions.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final isSelected = _selectedCategory == index;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => setState(() => _selectedCategory = index),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color.withValues(alpha: 0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? category.color : AppColors.surface,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category.color
                        : category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    category.icon,
                    color: isSelected ? Colors.white : category.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );

  // 상황 입력 필드 (더 깔끔하게)
  Widget _buildContextInput() => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.surface),
    ),
    child: TextField(
      controller: _contextController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: '어떤 상황인지 자세히 설명해주세요\n예: 처음 만난 사람에게 연락처를 물어보고 싶어요',
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          height: 1.4,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
      style: AppTextStyles.body2.copyWith(
        color: AppColors.textPrimary,
        height: 1.4,
      ),
    ),
  );

  // 메시지 입력 필드 (더 깔끔하게)
  Widget _buildMessageInput() => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.surface),
    ),
    child: TextField(
      controller: _messageController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: '추가로 포함하고 싶은 내용이 있다면 적어주세요 (선택사항)',
        hintStyle: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          height: 1.4,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
      style: AppTextStyles.body2.copyWith(
        color: AppColors.textPrimary,
        height: 1.4,
      ),
    ),
  );

  // 생성 버튼 (더 시각적으로 임팩트 있게)
  Widget _buildGenerateButton() => Container(
    padding: const EdgeInsets.all(24),
    child: SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateMessage,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isGenerating
              ? AppColors.surface
              : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '메시지 생성 중...',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'AI 메시지 생성하기',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );

  // 하단 결과 표시 영역
  Widget _buildResultSection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              '생성된 메시지',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            _generatedMessage,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _generateMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: AppColors.surface),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedRefresh,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '다시 생성',
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _copyMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedCopy01,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '복사하기',
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // 메시지 생성
  Future<void> _generateMessage() async {
    if (_contextController.text.trim().isEmpty) {
      ToastNotification.show(
        context: context,
        message: '상황을 설명해주세요',
        type: ToastType.warning,
      );
      return;
    }

    setState(() => _isGenerating = true);

    // 시뮬레이션 (실제로는 AI API 호출)
    await Future.delayed(const Duration(seconds: 2));

    final tone = _toneOptions[_selectedTone];
    final category = _categoryOptions[_selectedCategory];

    // 샘플 메시지 생성
    final sampleMessages = {
      '일반 메시지': {
        '친근함': '안녕! 오늘 하루 어땠어? 나는 오늘 정말 바쁜 하루였는데, 너는 어떻게 지냈는지 궁금해 😊',
        '정중함': '안녕하세요. 오늘 하루 수고 많으셨습니다. 혹시 시간 되실 때 연락 주시면 감사하겠습니다.',
        '유머러스':
            '야호! 오늘도 열심히 살아가는 우리들 👏 혹시 오늘 재밌는 일 있었어? 나는 커피 마시다가 옷에 쏟았다는... 😅',
        '로맨틱': '오늘도 너 생각이 많이 났어 💕 뭐 하고 있는지 궁금하고, 얼굴도 보고 싶고... 시간 되면 연락해줘 ❤️',
      },
      '데이트 제안': {
        '친근함': '이번 주말에 시간 있어? 새로 생긴 카페 가보고 싶은데 같이 갈래? 분위기 좋다던데 😊',
        '정중함': '혹시 이번 주말에 시간이 되신다면, 함께 영화를 보러 가는 것은 어떨까요? 좋은 영화가 개봉했더라고요.',
        '유머러스': '나 혼자 맛집 탐방하기 외로워서... 같이 가줄 사람 구함! 지원자 받습니다 🙋‍♂️ 어때?',
        '로맨틱': '너와 함께 보내는 시간이 너무 소중해서... 이번 주말에 예쁜 곳에서 데이트 하지 않을래? 💕',
      },
    };

    final categoryMessages =
        sampleMessages[category.title] ?? sampleMessages['일반 메시지']!;
    final message = categoryMessages[tone.title] ?? '메시지를 생성할 수 없습니다.';

    setState(() {
      _generatedMessage = message;
      _isGenerating = false;
    });

    ToastNotification.show(
      context: context,
      message: '메시지가 생성되었습니다!',
      type: ToastType.success,
    );
  }

  // 메시지 복사
  void _copyMessage() {
    ToastNotification.show(
      context: context,
      message: '메시지가 클립보드에 복사되었습니다',
      type: ToastType.success,
    );
  }

  /// 입력 화면 (스크롤 가능)
  Widget _buildInputScreenWithScroll() => CustomScrollView(
    slivers: [
      // 상단 메시지 요약 섹션
      SliverToBoxAdapter(child: _buildMessageSummarySection()),

      // 입력 및 설정 영역
      SliverToBoxAdapter(child: _buildInputContent()),
    ],
  );

  /// 결과 포함 화면 (스크롤 가능)
  Widget _buildWithResultScreen() => CustomScrollView(
    slivers: [
      // 상단 메시지 요약 섹션
      SliverToBoxAdapter(child: _buildMessageSummarySection()),

      // 입력 및 설정 영역
      SliverToBoxAdapter(child: _buildInputContent()),

      // 결과 표시 영역
      SliverToBoxAdapter(child: _buildResultSection()),
    ],
  );

  /// 입력 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildInputContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 메시지 톤 선택
        _buildSettingGroup('메시지 톤', _buildToneSelector()),

        // 메시지 카테고리 선택
        _buildSettingGroup('메시지 카테고리', _buildCategorySelector()),

        // 상황 입력
        _buildSettingGroup('상황 설명', _buildContextInput()),

        // 추가 요청사항
        _buildSettingGroup('추가 요청사항', _buildMessageInput()),

        // 생성 버튼
        _buildGenerateButton(),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );
}
