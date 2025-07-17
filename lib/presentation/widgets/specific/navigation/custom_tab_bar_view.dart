// File: lib/presentation/widgets/specific/navigation/custom_tab_bar_view.dart
// 2025.07.15 20:09:12 생성 - 18세 서현 페르소나 맞춤 TabBarView 위젯

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// LIA 앱에서 사용하는 커스텀 TabBarView 위젯입니다.
///
/// body 영역에서 사용하는 심플하고 깔끔한 스타일의 탭 뷰입니다.
/// 상하단 네비게이션과 차별화되는 미니멀한 디자인을 제공합니다.
///
/// 주요 특징:
/// - 부드러운 페이지 전환 애니메이션
/// - 스와이프 제스처 지원
/// - 심플한 페이지 인디케이터 (선택사항)
/// - 깔끔한 배경과 서브틀한 색상 사용
/// - 반응형 디자인 지원
///
/// 사용 예시:
/// ```dart
/// CustomTabBarView(
///   children: [
///     HomeTabContent(),
///     MessageTabContent(),
///     HistoryTabContent(),
///     ProfileTabContent(),
///   ],
/// )
/// ```
class CustomTabBarView extends StatefulWidget {
  /// 탭 뷰에 표시할 위젯 목록
  final List<Widget> children;

  /// 현재 선택된 탭 인덱스
  final int? initialIndex;

  /// 탭 변경 시 호출되는 콜백
  final ValueChanged<int>? onTabChanged;

  /// 페이지 전환 애니메이션 지속 시간 (기본값: 250ms)
  final Duration animationDuration;

  /// 페이지 전환 애니메이션 커브 (기본값: easeInOut)
  final Curve animationCurve;

  /// 스와이프 제스처 활성화 여부 (기본값: true)
  final bool enableSwipeGesture;

  /// 페이지 인디케이터 표시 여부 (기본값: false)
  final bool showPageIndicator;

  /// 페이지 인디케이터 색상 (기본값: primary)
  final Color? indicatorColor;

  /// 배경색 (기본값: background)
  final Color? backgroundColor;

  /// 패딩 (기본값: 16)
  final EdgeInsets padding;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.initialIndex,
    this.onTabChanged,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.enableSwipeGesture = true,
    this.showPageIndicator = false,
    this.indicatorColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
    _tabController = TabController(
      length: widget.children.length,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _pageController = PageController(initialPage: _currentIndex);

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _animateToPage(_tabController.index);
    }
  }

  void _animateToPage(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _pageController.animateToPage(
        index,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
      widget.onTabChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? AppColors.background,
      child: Column(
        children: [
          if (widget.showPageIndicator) _buildPageIndicator(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.children.length,
              physics: widget.enableSwipeGesture
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _tabController.animateTo(index);
                widget.onTabChanged?.call(index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: widget.padding,
                  child: widget.children[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 페이지 인디케이터를 생성하는 메서드입니다.
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.children.length,
          (index) => AnimatedContainer(
            duration: widget.animationDuration,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentIndex == index ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? (widget.indicatorColor ?? AppColors.primary)
                  : (widget.indicatorColor ?? AppColors.primary).withValues(
                      alpha: 0.3,
                    ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

/// 탭 컨텐츠를 감싸는 래퍼 위젯입니다.
///
/// 각 탭의 컨텐츠를 일관된 스타일로 감싸서 제공합니다.
class TabContentWrapper extends StatelessWidget {
  /// 탭 제목
  final String title;

  /// 탭 설명 (선택사항)
  final String? description;

  /// 탭 컨텐츠
  final Widget child;

  /// 헤더 표시 여부 (기본값: false)
  final bool showHeader;

  /// 헤더 배경색 (기본값: surface)
  final Color? headerBackgroundColor;

  /// 컨텐츠 패딩 (기본값: 16)
  final EdgeInsets contentPadding;

  const TabContentWrapper({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.showHeader = false,
    this.headerBackgroundColor,
    this.contentPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) _buildHeader(),
        Expanded(
          child: Container(padding: contentPadding, child: child),
        ),
      ],
    );
  }

  /// 헤더를 생성하는 메서드입니다.
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerBackgroundColor ?? AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.secondaryText,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 서현 페르소나에 맞는 사전 정의된 탭 컨텐츠들입니다.
///
/// 자주 사용되는 탭 컨텐츠들을 미리 정의하여 일관성을 유지합니다.
class LiaTabContents {
  /// 메시지 카테고리 탭 컨텐츠들
  static List<Widget> getMessageCategoryContents() {
    return [
      const TabContentWrapper(
        title: "스토리 답장",
        description: "인스타 스토리에 완벽한 답장을 보내보세요",
        child: _StoryReplyContent(),
      ),
      const TabContentWrapper(
        title: "재접근",
        description: "읽씹 당한 후 자연스럽게 재접근하는 메시지",
        child: _ReapproachContent(),
      ),
      const TabContentWrapper(
        title: "단답 대응",
        description: "단답 답장에도 센스있게 대응하는 방법",
        child: _ShortReplyContent(),
      ),
      const TabContentWrapper(
        title: "첫 DM",
        description: "첫 DM을 완벽하게 보내는 팁",
        child: _FirstDMContent(),
      ),
    ];
  }

  /// 분석 탭 컨텐츠들
  static List<Widget> getAnalysisContents() {
    return [
      const TabContentWrapper(
        title: "종합분석",
        description: "전체적인 분석 결과를 확인하세요",
        child: _AnalysisContent(),
      ),
      const TabContentWrapper(
        title: "프로파일",
        description: "상대방의 성격과 특성을 분석해보세요",
        child: _ProfileContent(),
      ),
      const TabContentWrapper(
        title: "감정흐름",
        description: "대화의 감정 변화를 확인하세요",
        child: _EmotionContent(),
      ),
      const TabContentWrapper(
        title: "액션플랜",
        description: "AI가 추천하는 다음 액션을 확인하세요",
        child: _ActionPlanContent(),
      ),
    ];
  }
}

/// 스토리 답장 컨텐츠
class _StoryReplyContent extends StatelessWidget {
  const _StoryReplyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "인스타 스토리 답장 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 재접근 컨텐츠
class _ReapproachContent extends StatelessWidget {
  const _ReapproachContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "읽씹 후 재접근 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 단답 대응 컨텐츠
class _ShortReplyContent extends StatelessWidget {
  const _ShortReplyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "단답 답장 대응 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 첫 DM 컨텐츠
class _FirstDMContent extends StatelessWidget {
  const _FirstDMContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "첫 DM 보내기 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 분석 컨텐츠
class _AnalysisContent extends StatelessWidget {
  const _AnalysisContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "종합 분석 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 프로파일 컨텐츠
class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "프로파일 분석 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 감정 컨텐츠
class _EmotionContent extends StatelessWidget {
  const _EmotionContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "감정 흐름 분석 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

/// 액션 플랜 컨텐츠
class _ActionPlanContent extends StatelessWidget {
  const _ActionPlanContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "AI 추천 액션 플랜 컨텐츠",
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}
