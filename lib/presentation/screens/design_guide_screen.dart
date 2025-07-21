// File: lib/presentation/screens/design_guide_screen.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';
import '../widgets/specific/forms/custom_date_picker.dart';
import '../widgets/specific/forms/custom_date_range_picker.dart';
import '../widgets/specific/headers/main_header.dart';
import '../widgets/specific/navigation/custom_tab_bar.dart';
import '../widgets/specific/navigation/custom_tab_bar_view.dart'
    hide LiaTabContents;

/// 디자인 가이드의 모든 컴포넌트를 보여주는 메인 화면입니다.
///
/// LIA 앱의 디자인 시스템을 체계적으로 정리하여 보여주는 화면으로,
/// Chart Demo Screen과 동일한 깔끔한 레이아웃을 적용합니다.
///
/// 주요 개선사항 (2025.07.16):
/// - 복잡한 반응형 그리드 → 단순한 세로 스크롤
/// - 과도한 애니메이션 → 필수적인 것만 유지
/// - 카드 디자인 통일 → Chart Demo 스타일 적용
/// - 일관된 간격과 패딩 적용
class DesignGuideScreen extends StatefulWidget {
  const DesignGuideScreen({super.key});

  @override
  State<DesignGuideScreen> createState() => _DesignGuideScreenState();
}

class _DesignGuideScreenState extends State<DesignGuideScreen> {
  // 상태 변수
  int _currentGenerationStep = 0;
  bool _isGenerationCompleted = false;

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
              const DashboardHeader(
                title: 'LIA 디자인 가이드',
                subtitle: 'LIA 앱의 디자인 시스템을 체계적으로 정리한 종합 가이드',
                icon: HugeIcons.strokeRoundedPaintBoard,
              ),

              AppSpacing.gapV24,
              // 설명 텍스트
              _buildIntroSection(),

              AppSpacing.gapV24,

              // 1. LIA 위젯 가이드
              SectionCard(
                number: '1',
                title: 'LIA 위젯 가이드',
                description: 'LIA 위젯을 한 번에 import해서 사용하세요',
                useNumberBadge: true,
                child: _buildLiaWidgetGuide(),
              ),

              AppSpacing.gapV24,

              // 2. Typography
              const SectionCard(
                number: '2',
                title: 'Typography (글꼴과 말투)',
                description: '앱에서 사용하는 다양한 텍스트 스타일과 메시지 예시를 보여줍니다',
                useNumberBadge: true,
                child: TypographyCard(),
              ),

              AppSpacing.gapV24,

              // 3. Color Palette
              const SectionCard(
                number: '3',
                title: 'Color Palette (테마 색상)',
                description: '앱에서 사용하는 주요 색상들과 그라데이션을 시각적으로 표시합니다',
                useNumberBadge: true,
                child: ColorPaletteCard(),
              ),

              AppSpacing.gapV24,

              // 4. Generating Progress
              SectionCard(
                number: '4',
                title: 'Generating Progress (AI 생성 진행)',
                description: 'AI 메시지 생성 중 로딩 상태를 보여줍니다',
                useNumberBadge: true,
                child: _buildGeneratingProgressDemo(),
              ),

              AppSpacing.gapV24,

              // 5. Header Navigation
              const SectionCard(
                number: '5',
                title: 'Header Navigation (상단 네비게이션)',
                description: '앱의 상단 네비게이션과 새로운 상황 카테고리들을 시연합니다',
                useNumberBadge: true,
                child: HeaderNavigationCard(),
              ),

              AppSpacing.gapV24,

              // 6. Main Header
              const SectionCard(
                number: '6',
                title: 'Main Header (메인 헤더)',
                description: '서현이의 개성이 담긴 메인 페이지 헤더예요!',
                useNumberBadge: true,
                child: NewMainHeaderCard(),
              ),

              AppSpacing.gapV24,

              // 7. Bottom Navigation
              const SectionCard(
                number: '7',
                title: 'Bottom Navigation (하단 네비게이션)',
                description: 'LIA 앱에서 사용하는 하단 네비게이션 바의 디자인과 상호작용을 보여줍니다',
                useNumberBadge: true,
                child: BottomNavigationCard(),
              ),

              AppSpacing.gapV24,

              // 8. Tab Bar
              const SectionCard(
                number: '8',
                title: 'Tab Bar (탭 네비게이션)',
                description: '18세 서현 페르소나에 맞는 탭 네비게이션 시스템을 시연합니다',
                useNumberBadge: true,
                child: TabBarCard(),
              ),

              AppSpacing.gapV24,

          // 9. Data Visualization
          _buildSectionTitle('9. Data Visualization (차트)'),
          _buildSectionDescription(
            '게이지 차트, 도넛 차트, 막대 차트 등 다양한 차트 컴포넌트를 시연합니다.',
          ),
          const DataVisualizationCard(),

          const SizedBox(height: 32),

          // 10. New Charts
          _buildSectionTitle('10. New Charts (새로운 차트)'),
          _buildSectionDescription('새로 추가된 고급 차트 위젯들을 보여줍니다.'),
          const NewChartsCard(),

          const SizedBox(height: 32),

          // 11. Form Elements
          _buildSectionTitle('11. Form Elements (폼 요소)'),
          _buildSectionDescription('기본적인 버튼들과 폼 관련 UI 요소들을 시연합니다.'),
          const FormElementsCard(),

          const SizedBox(height: 32),

          // 12. New Form Elements
          _buildSectionTitle('12. New Form Elements (새로운 폼 요소)'),
          _buildSectionDescription('새로 추가된 폼 요소들을 보여줍니다.'),
          const NewFormElementsCard(),

          const SizedBox(height: 32),

          // 13. Text Fields
          _buildSectionTitle('13. Text Fields (텍스트 입력)'),
          _buildSectionDescription('다양한 텍스트 입력 필드 스타일을 시연합니다.'),
          const TextFieldsCard(),

          const SizedBox(height: 32),

          // 14. Textarea
          _buildSectionTitle('14. Textarea (긴 텍스트 입력)'),
          _buildSectionDescription('멀티라인 텍스트 입력을 위한 텍스트 영역 컴포넌트를 시연합니다.'),
          const TextareaCard(),

          const SizedBox(height: 32),

          // 15. Interactive Widgets
          _buildSectionTitle('15. Interactive Widgets (상호작용 요소)'),
          _buildSectionDescription('체크박스, 스위치 등 사용자 상호작용 요소들을 시연합니다.'),
          const InteractiveWidgetsCard(),

          const SizedBox(height: 32),

          // 16. Gamification Widgets
          _buildSectionTitle('16. Gamification Widgets (게임화 요소)'),
          _buildSectionDescription('포인트, 배지, 레벨 등 게임화 관련 UI 요소들을 시연합니다.'),
          const GamificationWidgetsCard(),

          const SizedBox(height: 32),

          // 17. Animation Interaction
          _buildSectionTitle('17. Animation & Interaction (애니메이션)'),
          _buildSectionDescription('다양한 애니메이션 효과와 인터랙티브 요소들을 시연합니다.'),
          const AnimationInteractionCard(),

          const SizedBox(height: 32),

          // 18. Status Feedback
          _buildSectionTitle('18. Status Feedback (상태 피드백)'),
          _buildSectionDescription('로딩, 성공, 오류 등 다양한 상태를 나타내는 UI 요소들을 시연합니다.'),
          const StatusFeedbackCard(),

          const SizedBox(height: 32),

          // 19. New Feedback
          _buildSectionTitle('19. New Feedback (새로운 피드백)'),
          _buildSectionDescription('새로 추가된 피드백 위젯들을 보여줍니다.'),
          const NewFeedbackCard(),

          const SizedBox(height: 32),

          // 20. Modal
          _buildSectionTitle('20. Modal (모달 다이얼로그)'),
          _buildSectionDescription('커스텀 모달의 사용법과 스타일을 시연합니다.'),
          const ModalCard(),

          const SizedBox(height: 32),

                // 마무리 메시지
                _buildCompletionMessage(),

                AppSpacing.gapV24,
              ],
            ),
          ),
        ),
      ),
    );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _buildSectionDescription(String description) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      description,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText),
    ),
  );

  Widget _buildIntroSection() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIA 디자인 시스템',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'LIA 앱의 디자인 시스템을 체계적으로 정리하여 보여주는 가이드입니다. 각 컴포넌트의 사용법과 예시를 확인할 수 있습니다.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    ),
  );

  Widget _buildLiaWidgetGuide() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIA 위젯을 한 번에 import해서 사용하세요',
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Text(
            'import \'package:lia/presentation/widgets/lia_widgets.dart\';',
            style: AppTextStyles.body.copyWith(
              fontFamily: 'monospace',
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildGeneratingProgressDemo() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: GeneratingProgress(
      currentStep: _currentGenerationStep,
      isCompleted: _isGenerationCompleted,
      onCancel: () {
        setState(() {
          _currentGenerationStep = 0;
          _isGenerationCompleted = false;
        });
      },
    ),
  );

  Widget _buildCompletionMessage() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎉 디자인 가이드 완료!',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'LIA 앱의 모든 디자인 컴포넌트를 확인했습니다. 이제 멋진 앱을 만들어보세요!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    ),
  );
}

/// 타이포그래피 스타일을 보여주는 카드입니다.
///
/// 앱에서 사용하는 다양한 텍스트 스타일과 메시지 예시를 보여줍니다.
/// 2025.07.15 19:21:38 폰트 일관성 개선으로 계층적 폰트 시스템 적용
class TypographyCard extends StatelessWidget {
  const TypographyCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 폰트 계층 시스템 설명 추가
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 폰트 계층 시스템 (2025.07.15 개선)',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• Gaegu: 브랜드 타이틀만 (친근하고 캐주얼한 아이덴티티)\n• Pretendard: 섹션 제목, 중요 헤딩 (모던하고 세련된 제목)\n• NotoSansKR: 본문, 설명 텍스트 (가독성 최적화)',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 기존 텍스트 스타일 예시
        const Text('뭐라고 말할지 모르겠을 때?', style: AppTextStyles.questionTitle),
        const SizedBox(height: 8),
        const Text('AI 메시지 만들기', style: AppTextStyles.h1),
        const SizedBox(height: 8),
        const Text('썸남한테 보낼 메시지', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        const Text('상황이랑 말투만 골라! LIA가 다 해줄게 😎', style: AppTextStyles.subtitle),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '"오빠 스토리 완전 힙하다! 농구천재 아니야?"',
            style: AppTextStyles.body,
          ),
        ),
        const SizedBox(height: 8),
        const Text('어떤 메시지가 제일 좋아?', style: AppTextStyles.accessibleHelper),
        const SizedBox(height: 16),

        // 새로운 텍스트 스타일 예시들 추가
        _buildTextStyleDemo(),
        const SizedBox(height: 20),

        // 폰트 일관성 비교 섹션 추가
        _buildFontConsistencyDemo(),
      ],
    ),
  );

  /// 다양한 텍스트 스타일을 시연하는 위젯입니다.
  Widget _buildTextStyleDemo() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📝 텍스트 스타일 예시', style: AppTextStyles.h2),
        SizedBox(height: 12),
        Text('✅ 성공 메시지', style: AppTextStyles.success),
        SizedBox(height: 4),
        Text('❌ 오류 메시지', style: AppTextStyles.error),
        SizedBox(height: 4),
        Text('ℹ️ 정보 메시지', style: AppTextStyles.info),
        SizedBox(height: 4),
        Text('작은 캐션 텍스트 예시', style: AppTextStyles.caption),
        SizedBox(height: 4),
        Text('접근성 개선 도움말', style: AppTextStyles.accessibleHelper),
      ],
    ),
  );

  /// 폰트 일관성 개선 전후 비교를 보여주는 위젯입니다.
  Widget _buildFontConsistencyDemo() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.green.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎨 폰트 일관성 개선 효과',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // 개선 전 (문제점)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '❌ 개선 전 (문제점)',
                style: AppTextStyles.body.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '종합 분석 요약', // Gaegu 폰트 (손글씨 느낌)
                style: TextStyle(
                  fontFamily: 'Gaegu',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '너무 캐주얼한 제목과 일반적인 본문 사이의 톤 차이가 커서 통일감이 부족합니다.',
                style: AppTextStyles.body.copyWith(
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 개선 후 (해결책)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ 개선 후 (해결책)',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '종합 분석 요약', // Pretendard 폰트 (모던하고 세련됨)
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 4),
              Text(
                'Pretendard 폰트로 모던하고 세련된 제목과 NotoSansKR 본문이 자연스럽게 조화를 이룹니다.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 사용 가이드
        Text(
          '💡 사용 가이드',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• 브랜드 타이틀: Gaegu (LIA 로고 등)\n• 섹션 제목: Pretendard (종합 분석 요약, 상대방 프로파일링 등)\n• 본문 텍스트: NotoSansKR (설명, 도움말 등)',
          style: AppTextStyles.body.copyWith(
            color: AppColors.secondaryText,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}

/// 브랜드 색상 팔레트를 보여주는 카드입니다.
///
/// 앱에서 사용하는 주요 색상들과 그라데이션을 시각적으로 표시합니다.
class ColorPaletteCard extends StatelessWidget {
  const ColorPaletteCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 16,
      runSpacing: 16,
      children: [
        _ColorChip(
          gradient: AppColors.primaryGradient,
          name: 'Main Gradient',
          description: '주요 버튼/포인트',
        ),
        _ColorChip(
          color: AppColors.primary,
          name: 'Lovely Pink',
          description: '#FF70A6',
        ),
        _ColorChip(
          color: AppColors.accent,
          name: 'Witty Purple',
          description: '#A162F7',
        ),
        _ColorChip(
          color: AppColors.yellow,
          name: 'Sparkle Yellow',
          description: '#FFD670',
        ),
        _ColorChip(
          color: AppColors.blue,
          name: 'Sky Blue',
          description: '#70A6FF',
        ),
        _ColorChip(
          color: AppColors.green,
          name: 'Fresh Green',
          description: '#70FFA6',
        ),
        _ColorChip(
          color: AppColors.charcoal,
          name: 'Charcoal',
          description: '#333 (기본 텍스트)',
        ),
        _ColorChip(
          color: AppColors.secondaryText,
          name: 'Secondary Text',
          description: '#555 (보조 텍스트)',
        ),
        _ColorChip(
          color: AppColors.cardBorder,
          name: 'Card Border',
          description: '#FFDE8 (테두리)',
        ),
        _ColorChip(
          gradient: AppColors.accentGradient,
          name: 'Accent Gradient',
          description: '보조 그라데이션',
        ),
        _ColorChip(
          gradient: AppColors.chartGradient,
          name: 'Chart Gradient',
          description: '차트용 그라데이션',
        ),
        _ColorChip(
          gradient: AppColors.successGradient,
          name: 'Success Gradient',
          description: '성공 상태',
        ),
      ],
    ),
  );
}

/// 색상 칩을 표시하는 위젯입니다.
///
/// 개별 색상이나 그라데이션을 시각적으로 보여주며,
/// 색상 이름과 설명을 함께 표시합니다.
class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.name,
    required this.description,
    this.color,
    this.gradient,
  });
  final Color? color;
  final Gradient? gradient;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 100,
    child: Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          description,
          style: AppTextStyles.helper,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

/// 헤더 네비게이션 요소들을 보여주는 카드입니다.
///
/// 앱의 상단 네비게이션과 새로운 상황 카테고리들을 시연합니다.
///
/// 18세 서현 페르소나에 맞는 상황별 메시지 카테고리를 제공합니다.
class HeaderNavigationCard extends StatefulWidget {
  const HeaderNavigationCard({super.key});

  @override
  State<HeaderNavigationCard> createState() => _HeaderNavigationCardState();
}

class _HeaderNavigationCardState extends State<HeaderNavigationCard> {
  String _selectedCategory = '인스타 스토리 답장';

  final List<String> _categories = [
    '인스타 스토리 답장',
    '읽씹 당한 후 재접근',
    '단답 답장 받았을 때',
    '첫 DM 보내기',
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // 기존 헤더
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.white),
              Text(
                'LIA',
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              Row(
                children: [
                  const PulsatingDot(),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 새로운 상황 카테고리 선택
        Text(
          '상황을 선택해주세요',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 12),
        _buildCategoryChips(),
      ],
    ),
  );

  /// 상황 카테고리 칩들을 생성하는 메서드입니다.
  Widget _buildCategoryChips() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _categories.map((category) {
      final isSelected = category == _selectedCategory;
      return GestureDetector(
        onTap: () {
          setState(() => _selectedCategory = category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.secondaryText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

/// 앱의 하단 네비게이션 바를 시연하는 카드입니다.
///
/// LIA 앱에서 사용하는 하단 네비게이션 바의 디자인과 상호작용을 보여줍니다.
/// 5개의 주요 탭과 선택 상태에 따른 시각적 피드백을 시연합니다.
class BottomNavigationCard extends StatefulWidget {
  const BottomNavigationCard({super.key});

  @override
  State<BottomNavigationCard> createState() => _BottomNavigationCardState();
}

class _BottomNavigationCardState extends State<BottomNavigationCard> {
  int _currentIndex = 0;
  bool _aiPressed = false;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          height: 95, // AI 버튼이 위로 튀어나오는 공간 확보 (110에서 105로 조정)
          padding: const EdgeInsets.only(top: 20), // 25에서 20으로 조정
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _aiPressed = false;
              });
            },
            onAITap: () {
              setState(() {
                _aiPressed = true;
                _currentIndex = -1; // AI 버튼은 별도 처리
              });
              // AI 기능 실행 시뮬레이션
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'AI가 메시지 만들어줄게! ✨',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 30,
                  ),
                  elevation: 0,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _aiPressed
              ? '🤖 AI 메시지 생성 모드'
              : '현재 선택된 탭: ${_getTabName(_currentIndex)}',
          style: AppTextStyles.helper.copyWith(
            color: _aiPressed ? AppColors.accent : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  /// 탭 인덱스에 따른 탭 이름을 반환하는 메서드입니다.
  String _getTabName(int index) {
    switch (index) {
      case 0:
        return '홈';
      case 1:
        return '채팅';
      case 2:
        return '보관함';
      case 3:
        return '프로필';
      default:
        return '홈';
    }
  }
}

/// 데이터 시각화 차트들을 보여주는 카드입니다.
///
/// 게이지 차트, 도넛 차트, 막대 차트 등 다양한 차트 컴포넌트를 시연합니다.
class DataVisualizationCard extends StatelessWidget {
  const DataVisualizationCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Column(
      children: [
        // 차트 데모
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 24,
          runSpacing: 24,
          children: [
            GaugeChart(
              data: {
                'value': 75,
                'maxValue': 100,
                'unit': '%',
                'primaryColor': 0xFF6C5CE7,
                'backgroundColor': 0xFFEEEEEE,
              },
            ),
            DonutChart(),
            BarChart(),
          ],
        ),
        SizedBox(height: 20),

        // 실제 사용 시나리오 추가
        ScenarioCard(
          title: '📊 차트 활용 시나리오',
          description: '서현이가 LIA 앱에서 차트를 보는 실제 상황들이에요!',
          scenarios: [
            ScenarioStep(
              title: '호감도 확인하기',
              description: '썸남과의 호감도를 게이지 차트로 확인해요',
              widget: 'GaugeChart',
              userQuote: '우리 호감도가 75%나 돼? 완전 좋은데!',
              expectedResult: '호감도 수치를 직관적으로 파악',
            ),
            ScenarioStep(
              title: '메시지 타입별 성공률 보기',
              description: '어떤 스타일의 메시지가 가장 효과적인지 도넛 차트로 확인해요',
              widget: 'DonutChart',
              userQuote: '센스있는 메시지가 제일 성공률 높네! 이 스타일로 가야지',
              expectedResult: '메시지 타입별 비율을 한눈에 파악',
            ),
            ScenarioStep(
              title: '주간 활동 비교하기',
              description: '이번 주와 지난 주 메시지 활동을 막대 차트로 비교해요',
              widget: 'BarChart',
              userQuote: '이번 주가 지난 주보다 메시지 많이 보냈네 ㅋㅋ',
              expectedResult: '기간별 데이터를 쉽게 비교',
            ),
          ],
        ),
      ],
    ),
  );
}

/// 폼 요소들을 보여주는 카드입니다.
///
/// 기본적인 버튼들과 폼 관련 UI 요소들을 시연합니다.
class FormElementsCard extends StatefulWidget {
  const FormElementsCard({super.key});

  @override
  State<FormElementsCard> createState() => _FormElementsCardState();
}

class _FormElementsCardState extends State<FormElementsCard> {
  double _sliderValue = 0.7;
  String _selectedEmotion = '세련되고 트렌디하게';

  final List<String> _emotions = [
    '세련되고 트렌디하게',
    '자연스럽고 쿨하게',
    '관심 있다는 표현으로',
    '친근하고 편안하게',
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // 버튼 데모
        Row(
          children: [
            Expanded(
              child: PrimaryButton(onPressed: () {}, text: '메시지 ㄱㄱ'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SecondaryButton(onPressed: () {}, text: '아니야 다시'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 파라미터 설명 추가
        const ParameterCard(
          widgetName: 'PrimaryButton',
          parameters: [
            ParameterInfo(
              name: 'onPressed',
              type: 'VoidCallback?',
              isRequired: true,
              description: '버튼을 눌렀을 때 실행될 함수예요! null이면 버튼이 비활성화돼요.',
              example: 'onPressed: () => print("버튼 클릭!")',
            ),
            ParameterInfo(
              name: 'text',
              type: 'String',
              isRequired: true,
              description: '버튼에 표시될 텍스트예요. 서현이 말투로 써보세요!',
              example: 'text: "메시지 ㄱㄱ"',
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 버튼 사용 시나리오 추가
        const ScenarioCard(
          title: '🔘 버튼 사용 시나리오',
          description: '서현이가 LIA 앱에서 버튼을 누르는 실제 상황들이에요!',
          scenarios: [
            ScenarioStep(
              title: '메시지 생성하기',
              description: '모든 정보를 입력한 후 메시지를 생성할 때 주요 버튼을 눌러요',
              widget: 'PrimaryButton',
              userQuote: '정보 다 입력했으니까 이제 메시지 ㄱㄱ!',
              expectedResult: 'AI가 메시지를 생성하기 시작',
            ),
            ScenarioStep(
              title: '취소하거나 다시 시도',
              description: '마음에 안 들거나 실수했을 때 보조 버튼으로 취소해요',
              widget: 'SecondaryButton',
              userQuote: '아니야, 다시 생각해볼게',
              expectedResult: '이전 화면으로 돌아가거나 초기화',
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildSliderDemo(),
        const SizedBox(height: 16),
        _buildEmotionSelector(),
      ],
    ),
  );

  /// 슬라이더 데모를 생성하는 메서드입니다.
  ///
  /// LIA 브랜드에 맞는 커스텀 슬라이더를 사용하여
  /// 18세 서현 페르소나에 맞는 친근하고 트렌디한 UI를 제공합니다.
  Widget _buildSliderDemo() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '친밀도 설정',
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      const SizedBox(height: 8),
      CustomSlider(
        value: _sliderValue,
        onChanged: (value) {
          setState(() => _sliderValue = value);
        },
      ),
    ],
  );

  /// 감정 표현 선택기를 생성하는 메서드입니다.
  ///
  /// 18세 서현 페르소나에 맞는 다양한 감정 표현 옵션을 제공합니다.
  Widget _buildEmotionSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '메시지 톤 선택',
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _emotions.map((emotion) {
          final isSelected = emotion == _selectedEmotion;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedEmotion = emotion);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.accentGradient : null,
                color: isSelected ? null : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.shade300),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                emotion,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.secondaryText,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

/// 텍스트 필드들을 보여주는 카드입니다.
///
/// 다양한 텍스트 입력 필드 스타일을 시연합니다.
class TextFieldsCard extends StatefulWidget {
  const TextFieldsCard({super.key});

  @override
  State<TextFieldsCard> createState() => _TextFieldsCardState();
}

class _TextFieldsCardState extends State<TextFieldsCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Column(
      children: [
        FloatingLabelTextField(label: '썸타는 사람 이름 알려줘!'),
        SizedBox(height: 16),
        TagInputField(),
        SizedBox(height: 20),

        // 파라미터 설명 추가
        ParameterCard(
          widgetName: 'FloatingLabelTextField',
          parameters: [
            ParameterInfo(
              name: 'label',
              type: 'String',
              isRequired: true,
              description: '플로팅 라벨에 표시될 텍스트예요. 친근하게 물어보세요!',
              example: 'label: "내 이름이 뭐야?"',
            ),
            ParameterInfo(
              name: 'controller',
              type: 'TextEditingController?',
              isRequired: false,
              description: '텍스트 입력을 제어하는 컨트롤러예요. 입력값을 가져올 때 필요해요.',
              example: 'controller: TextEditingController()',
            ),
            ParameterInfo(
              name: 'onChanged',
              type: 'Function(String)?',
              isRequired: false,
              description: '텍스트가 변경될 때마다 호출되는 함수예요.',
              example: 'onChanged: (text) => print(text)',
            ),
          ],
        ),
      ],
    ),
  );
}

/// 텍스트 영역을 보여주는 카드입니다.
///
/// 멀티라인 텍스트 입력을 위한 텍스트 영역 컴포넌트를 시연합니다.
class TextareaCard extends StatelessWidget {
  const TextareaCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: '오늘 있었던 일을 자세히 적어주세요',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    ),
  );
}

/// 인터랙티브 위젯들을 보여주는 카드입니다.
///
/// 체크박스, 스위치 등 사용자 상호작용 요소들을 시연합니다.
class InteractiveWidgetsCard extends StatefulWidget {
  const InteractiveWidgetsCard({super.key});

  @override
  State<InteractiveWidgetsCard> createState() => _InteractiveWidgetsCardState();
}

class _InteractiveWidgetsCardState extends State<InteractiveWidgetsCard> {
  bool _isNotificationEnabled = true;
  bool _isLocationEnabled = false;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        _buildSwitchRow('알림 설정', _isNotificationEnabled, (value) {
          setState(() => _isNotificationEnabled = value);
        }),
        const SizedBox(height: 16),
        _buildSwitchRow('위치 정보 사용', _isLocationEnabled, (value) {
          setState(() => _isLocationEnabled = value);
        }),
      ],
    ),
  );

  /// 스위치 행을 생성하는 메서드입니다.
  ///
  /// LIA 브랜드에 맞는 커스텀 토글 스위치를 사용하여
  /// 18세 서현 페르소나에 맞는 친근하고 트렌디한 UI를 제공합니다.
  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.body),
      CustomToggleSwitch(value: value, onChanged: onChanged),
    ],
  );
}

/// 게임화 요소들을 보여주는 카드입니다.
///
/// 포인트, 배지, 레벨 등 게임화 관련 UI 요소들을 시연합니다.
class GamificationWidgetsCard extends StatelessWidget {
  const GamificationWidgetsCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        _buildPointsDisplay(),
        const SizedBox(height: 16),
        _buildBadgeRow(),
      ],
    ),
  );

  /// 포인트 표시 위젯을 생성하는 메서드입니다.
  Widget _buildPointsDisplay() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: AppColors.accentGradient,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재 포인트',
              style: AppTextStyles.helper.copyWith(color: Colors.white70),
            ),
            Text(
              '1,250 P',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.star_rounded,
            color: AppColors.yellow,
            size: 24,
          ),
        ),
      ],
    ),
  );

  /// 배지 행을 생성하는 메서드입니다.
  Widget _buildBadgeRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildBadge(Icons.chat_bubble_outline_rounded, '대화 마스터', '30회 완료'),
      _buildBadge(Icons.favorite_outline_rounded, '인기 회원', '50개 반응'),
      _buildBadge(Icons.track_changes_rounded, '정확도 높음', '90% 성공'),
    ],
  );

  /// 개별 배지를 생성하는 메서드입니다.
  Widget _buildBadge(IconData icon, String title, String description) => Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 28),
      ),
      const SizedBox(height: 8),
      Text(
        title,
        style: AppTextStyles.helper.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      Text(
        description,
        style: AppTextStyles.helper.copyWith(color: AppColors.secondaryText),
      ),
    ],
  );
}

/// 애니메이션과 상호작용 요소들을 보여주는 카드입니다.
///
/// 다양한 애니메이션 효과와 인터랙티브 요소들을 시연합니다.
class AnimationInteractionCard extends StatelessWidget {
  const AnimationInteractionCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [HeartSpinner(), PulsatingDot()],
        ),
        SizedBox(height: 16),
        _MessageBubbleDemo(),
      ],
    ),
  );
}

/// 메시지 버블 데모를 보여주는 위젯입니다.
///
/// 채팅 메시지의 애니메이션 효과를 시연합니다.
class _MessageBubbleDemo extends StatefulWidget {
  const _MessageBubbleDemo();

  @override
  State<_MessageBubbleDemo> createState() => _MessageBubbleDemoState();
}

class _MessageBubbleDemoState extends State<_MessageBubbleDemo>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final List<String> _messages = ['안녕하세요', '오늘 어떻게 지내셨나요?', '영화 보러 갈까요?'];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _messages.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 200)),
        vsync: this,
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 500));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      _messages.length,
      (index) => _MessageItem(
        message: _messages[index],
        controller: _controllers[index],
      ),
    ),
  );
}

/// 개별 메시지 아이템을 표시하는 위젯입니다.
///
/// 메시지가 나타나는 애니메이션 효과를 제공합니다.
class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message, required this.controller});
  final String message;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, child) => Transform.translate(
      offset: Offset(
        0,
        20 * (1 - Curves.elasticOut.transform(controller.value)),
      ),
      child: Opacity(
        opacity: controller.value,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

/// 상태 피드백 요소들을 보여주는 카드입니다.
///
/// 로딩, 성공, 오류 등 다양한 상태를 나타내는 UI 요소들을 시연합니다.
class StatusFeedbackCard extends StatelessWidget {
  const StatusFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Column(
      children: [
        SkeletonUI(),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatusIndicator(
              icon: Icons.check_circle,
              color: AppColors.success,
              label: '완료',
            ),
            _StatusIndicator(icon: Icons.error, color: Colors.red, label: '오류'),
            _StatusIndicator(icon: Icons.info, color: Colors.blue, label: '정보'),
          ],
        ),
      ],
    ),
  );
}

/// 상태 표시기를 보여주는 위젯입니다.
///
/// 아이콘과 라벨로 구성된 상태 인디케이터를 표시합니다.
class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.icon,
    required this.color,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 8),
      Text(label, style: AppTextStyles.helper),
    ],
  );
}

/// 모달 다이얼로그를 보여주는 카드입니다.
///
/// 커스텀 모달의 사용법과 스타일을 시연합니다.
class ModalCard extends StatelessWidget {
  const ModalCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Center(
      child: Column(
        children: [
          PrimaryButton(
            onPressed: () {
              showCustomModal(
                context: context,
                title: '완료됐어! 🎉',
                content: 'LIA 디자인 가이드 확인 완료! 이제 멋진 앱을 만들어봐 ㄱㄱ',
                confirmText: '완전 좋아!',
              );
            },
            text: '기본 모달',
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            onPressed: () {
              showCustomConfirmModal(
                context: context,
                title: '정말 삭제할래? 🗑️',
                content: '삭제하면 다시 복구할 수 없어! 정말 괜찮아?',
                confirmText: '삭제할래',
                cancelText: '아니야',
                onConfirm: () {
                  // 삭제 로직
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('삭제 완료! 🗑️'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              );
            },
            text: '확인 모달',
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            onPressed: () {
              showMessageConfirmModal(
                context: context,
                message: '농구... 좋아하세요? 스토리 완전 멋있어ㅋㅋ',
                recipientName: '훈남',
                onSend: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('메시지 전송 완료! 💌'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              );
            },
            text: '메시지 모달',
          ),
        ],
      ),
    ),
  );
}

/// 새로운 차트 위젯들을 보여주는 카드입니다.
class NewChartsCard extends StatelessWidget {
  const NewChartsCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // Line Chart 데모
        LineChart(
          title: '호감도 변화 추이',
          data: [
            LineChartDataPoint(label: '월', value: 65),
            LineChartDataPoint(label: '화', value: 72),
            LineChartDataPoint(label: '수', value: 68),
            LineChartDataPoint(label: '목', value: 78),
            LineChartDataPoint(label: '금', value: 85),
            LineChartDataPoint(label: '토', value: 82),
            LineChartDataPoint(label: '일', value: 88),
          ],
          height: 160,
        ),
        const SizedBox(height: 20),

        // 설명 텍스트
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📈 Line Chart 활용 예시',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• 호감도 변화 추이 분석\n• 메시지 빈도 변화 추적\n• 대화 만족도 시간별 변화',
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

/// 새로운 폼 요소들을 보여주는 카드입니다.
class NewFormElementsCard extends StatefulWidget {
  const NewFormElementsCard({super.key});

  @override
  State<NewFormElementsCard> createState() => _NewFormElementsCardState();
}

class _NewFormElementsCardState extends State<NewFormElementsCard> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // Date Picker
        CustomDatePicker(
          label: '언제 만날까? 💕',
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() => _selectedDate = date);
          },
        ),
        const SizedBox(height: 20),

        // Date Range Picker
        CustomDateRangePicker(
          label: '여행 기간을 정해볼까?',
          selectedRange: _selectedDateRange,
          onRangeSelected: (range) {
            setState(() => _selectedDateRange = range);
          },
        ),
        const SizedBox(height: 20),

        // 사용 시나리오
        const ScenarioCard(
          title: '📅 Date Picker 사용 시나리오',
          description: '서현이가 데이트 날짜를 정하는 실제 상황들이에요!',
          scenarios: [
            ScenarioStep(
              title: '데이트 날짜 정하기',
              description: '썸남과 만날 날짜를 선택할 때 사용해요',
              widget: 'CustomDatePicker',
              userQuote: '이번 주 토요일 어때? 완전 좋을 것 같은데!',
              expectedResult: '선택한 날짜에 대한 친근한 피드백 제공',
            ),
            ScenarioStep(
              title: '여행 기간 계획하기',
              description: '함께 갈 여행의 기간을 정할 때 사용해요',
              widget: 'CustomDateRangePicker',
              userQuote: '2박 3일로 제주도 가면 딱 좋겠다!',
              expectedResult: '날짜 범위 선택과 기간 계산',
            ),
          ],
        ),
      ],
    ),
  );
}

/// 새로운 피드백 위젯들을 보여주는 카드입니다.
class NewFeedbackCard extends StatelessWidget {
  const NewFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // Toast 알림 버튼들
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  ToastNotification.show(
                    context: context,
                    message: '메시지 전송 완료! 💌',
                    type: ToastType.success,
                  );
                },
                text: '성공 토스트',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  ToastNotification.show(
                    context: context,
                    message: '앗, 뭔가 잘못됐어! 😅',
                    type: ToastType.error,
                  );
                },
                text: '오류 토스트',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  ToastNotification.show(
                    context: context,
                    message: '새로운 알림이 있어요! 📢',
                    type: ToastType.info,
                  );
                },
                text: '정보 토스트',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  ToastNotification.show(
                    context: context,
                    message: '이거 확인해봐! ⚠️',
                    type: ToastType.warning,
                  );
                },
                text: '경고 토스트',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 사용 시나리오
        const ScenarioCard(
          title: '🔔 Toast 알림 사용 시나리오',
          description: '서현이가 앱에서 받는 다양한 알림들이에요!',
          scenarios: [
            ScenarioStep(
              title: '메시지 전송 성공',
              description: '썸남에게 메시지를 성공적으로 보냈을 때',
              widget: 'ToastNotification.success',
              userQuote: '메시지 보내기 완료! 답장 올까?',
              expectedResult: '성공 알림과 함께 자동으로 사라짐',
            ),
            ScenarioStep(
              title: '네트워크 오류',
              description: '인터넷 연결에 문제가 있을 때',
              widget: 'ToastNotification.error',
              userQuote: '어? 왜 안 보내져? 인터넷 확인해봐야겠다',
              expectedResult: '오류 상황을 친근하게 안내',
            ),
            ScenarioStep(
              title: '새로운 기능 안내',
              description: '앱에 새로운 기능이 추가됐을 때',
              widget: 'ToastNotification.info',
              userQuote: '오! 새로운 기능이 생겼네? 써봐야지',
              expectedResult: '정보성 알림으로 사용자 유도',
            ),
          ],
        ),
      ],
    ),
  );
}

/// 새로운 메인 헤더 위젯을 보여주는 카드입니다.
class NewMainHeaderCard extends StatelessWidget {
  const NewMainHeaderCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '서현이의 개성이 담긴 메인 페이지 헤더예요! 💕',
          style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 16),

        // MainHeader 위젯 시연
        MainHeader(
          userStats: const {
            'messagesGenerated': 127,
            'successRate': 89.5,
            'consecutiveDays': 12,
          },
          onDesignGuidePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('디자인 가이드 버튼 클릭! 🎨'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
          onProfilePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('프로필 버튼 클릭! 👤'),
                backgroundColor: AppColors.accent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // 파라미터 설명
        const ParameterCard(
          widgetName: 'MainHeader',
          parameters: [
            ParameterInfo(
              name: 'userName',
              type: 'String',
              isRequired: false,
              description: '사용자 이름이야! 기본값은 "서현"이에요.',
              example: 'userName: "서현"',
            ),
            ParameterInfo(
              name: 'userStats',
              type: 'Map<String, dynamic>',
              isRequired: true,
              description: '사용자 통계 데이터예요. 생성 메시지 수, 성공률, 연속 사용일을 포함해요.',
              example:
                  'userStats: {"messagesGenerated": 127, "successRate": 89.5, "consecutiveDays": 12}',
            ),
            ParameterInfo(
              name: 'onDesignGuidePressed',
              type: 'VoidCallback?',
              isRequired: false,
              description: '디자인 가이드 버튼을 눌렀을 때 실행될 함수예요.',
              example: 'onDesignGuidePressed: () => Navigator.push(...)',
            ),
            ParameterInfo(
              name: 'onProfilePressed',
              type: 'VoidCallback?',
              isRequired: false,
              description: '프로필 버튼을 눌렀을 때 실행될 함수예요.',
              example: 'onProfilePressed: () => Navigator.push(...)',
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 사용 시나리오
        const ScenarioCard(
          title: '🎨 Main Header 사용 시나리오',
          description: '서현이가 앱을 열었을 때 가장 먼저 보는 헤더예요!',
          scenarios: [
            ScenarioStep(
              title: '개인화된 인사말',
              description: '서현이의 이름과 함께 친근한 인사말을 보여줘요',
              widget: 'MainHeader',
              userQuote: '안녕, 서현아! 완전 반가워!',
              expectedResult: '사용자에게 친근하고 개인화된 경험 제공',
            ),
            ScenarioStep(
              title: '실시간 통계 확인',
              description: '생성한 메시지 수, 성공률, 연속 사용일을 한눈에 확인해요',
              widget: 'MainHeader',
              userQuote: '와! 벌써 127개 메시지나 만들었네? 성공률도 89%!',
              expectedResult: '사용자의 활동을 시각적으로 피드백',
            ),
            ScenarioStep(
              title: '빠른 기능 접근',
              description: '디자인 가이드나 프로필 화면으로 빠르게 이동할 수 있어요',
              widget: 'MainHeader',
              userQuote: '디자인 가이드 궁금한데 바로 볼 수 있네!',
              expectedResult: '원하는 기능에 빠르게 접근 가능',
            ),
          ],
        ),
      ],
    ),
  );
}

/// 18세 서현 페르소나에 맞는 탭 네비게이션 시스템을 시연합니다.
class TabBarCard extends StatefulWidget {
  const TabBarCard({super.key});

  @override
  State<TabBarCard> createState() => _TabBarCardState();
}

class _TabBarCardState extends State<TabBarCard> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: LiaTabStyles.messageCategories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'body 영역용 심플한 탭바 시스템이에요! 상하단 네비게이션과 차별화된 깔끔한 디자인 💫',
          style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 16),

        // 심플한 TabBar 데모
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DefaultTabController(
            length: LiaTabStyles.messageCategories.length,
            child: Column(
              children: [
                CustomTabBar(tabs: LiaTabStyles.messageCategories),
                Expanded(
                  child: CustomTabBarView(
                    children: LiaTabContents.getMessageCategoryContents(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 매개변수 설명
        const ParameterCard(
          widgetName: 'CustomTabBar',
          parameters: [
            ParameterInfo(
              name: 'tabs',
              type: 'List<CustomTab>',
              isRequired: true,
              description: '탭 목록이에요. 각 탭은 아이콘과 텍스트를 가질 수 있어요.',
              example: 'tabs: [CustomTab(icon: Icons.home, text: "홈")]',
            ),
            ParameterInfo(
              name: 'height',
              type: 'double',
              isRequired: false,
              description: '탭바 높이예요. 기본값은 48이에요.',
              example: 'height: 48',
            ),
            ParameterInfo(
              name: 'backgroundColor',
              type: 'Color?',
              isRequired: false,
              description: '배경색이에요. 기본값은 background 색상이에요.',
              example: 'backgroundColor: AppColors.background',
            ),
            ParameterInfo(
              name: 'selectedTextColor',
              type: 'Color',
              isRequired: false,
              description: '선택된 탭 텍스트 색상이에요.',
              example: 'selectedTextColor: AppColors.primary',
            ),
            ParameterInfo(
              name: 'unselectedTextColor',
              type: 'Color',
              isRequired: false,
              description: '비선택된 탭 텍스트 색상이에요.',
              example: 'unselectedTextColor: AppColors.secondaryText',
            ),
            ParameterInfo(
              name: 'indicatorColor',
              type: 'Color',
              isRequired: false,
              description: '언더라인 인디케이터 색상이에요.',
              example: 'indicatorColor: AppColors.primary',
            ),
            ParameterInfo(
              name: 'indicatorWeight',
              type: 'double',
              isRequired: false,
              description: '인디케이터 두께예요.',
              example: 'indicatorWeight: 2.0',
            ),
          ],
        ),

        const SizedBox(height: 16),

        const ParameterCard(
          widgetName: 'CustomTabBarView',
          parameters: [
            ParameterInfo(
              name: 'children',
              type: 'List<Widget>',
              isRequired: true,
              description: '탭 뷰 컨텐츠들이에요. 각 탭에 표시될 위젯들이에요.',
              example: 'children: [HomeTab(), MessageTab(), ProfileTab()]',
            ),
            ParameterInfo(
              name: 'initialIndex',
              type: 'int?',
              isRequired: false,
              description: '초기 선택 탭 인덱스예요. 기본값은 0이에요.',
              example: 'initialIndex: 0',
            ),
            ParameterInfo(
              name: 'onTabChanged',
              type: 'ValueChanged<int>?',
              isRequired: false,
              description: '탭 변경 시 호출되는 콜백이에요.',
              example: r'onTabChanged: (index) => print("Tab $index")',
            ),
            ParameterInfo(
              name: 'animationDuration',
              type: 'Duration',
              isRequired: false,
              description: '페이지 전환 애니메이션 지속 시간이에요.',
              example: 'animationDuration: Duration(milliseconds: 250)',
            ),
            ParameterInfo(
              name: 'enableSwipeGesture',
              type: 'bool',
              isRequired: false,
              description: '스와이프 제스처 활성화 여부예요.',
              example: 'enableSwipeGesture: true',
            ),
            ParameterInfo(
              name: 'showPageIndicator',
              type: 'bool',
              isRequired: false,
              description: '페이지 인디케이터 표시 여부예요.',
              example: 'showPageIndicator: false',
            ),
            ParameterInfo(
              name: 'backgroundColor',
              type: 'Color?',
              isRequired: false,
              description: '배경색이에요.',
              example: 'backgroundColor: AppColors.background',
            ),
            ParameterInfo(
              name: 'padding',
              type: 'EdgeInsets',
              isRequired: false,
              description: '컨텐츠 패딩이에요.',
              example: 'padding: EdgeInsets.all(16)',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 사용 예시
        const CodeCopyCard(
          title: '사용 예시',
          code: '''
DefaultTabController(
  length: 4,
  child: Column(
    children: [
      CustomTabBar(
        tabs: LiaTabStyles.messageCategories,
        selectedTextColor: AppColors.primary,
        indicatorColor: AppColors.accent,
      ),
      Expanded(
        child: CustomTabBarView(
          children: LiaTabContents.getMessageCategoryContents(),
          enableSwipeGesture: true,
          showPageIndicator: false,
        ),
      ),
    ],
  ),
)''',
        ),

        const SizedBox(height: 16),

        // 사전 정의된 탭 스타일 안내
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎨 사전 정의된 탭 스타일',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• LiaTabStyles.messageCategories - 메시지 카테고리 탭들 (텍스트 중심)\n• LiaTabStyles.analysisTabs - 분석 결과 탭들 (텍스트 중심)\n• LiaTabStyles.settingsTabs - 설정 탭들 (아이콘 + 텍스트)\n\n• LiaTabContents.getMessageCategoryContents() - 메시지 카테고리 컨텐츠\n• LiaTabContents.getAnalysisContents() - 분석 결과 컨텐츠',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 디자인 원칙 안내
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✨ 디자인 원칙',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '• 상하단 네비게이션과 차별화된 심플한 디자인\n• 언더라인 인디케이터로 깔끔한 시각적 피드백\n• 눈에 띄지 않는 서브틀한 색상 사용\n• body 영역에 최적화된 높이와 패딩\n• 18세 서현 페르소나에 맞는 친근한 텍스트 스타일',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
