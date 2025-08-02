// File: lib/presentation/screens/design_guide_screen.dart
// 2025.07.23 14:56:44 카카오톡 스타일로 완전 리팩토링 + 린터 에러 수정

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 디자인 가이드 화면
///
/// LIA 앱의 디자인 시스템을 카카오톡 스타일로 보여주는 화면
/// 상단 디자인 요약 + 하단 컴포넌트 메뉴 리스트 패턴 적용
class DesignGuideScreen extends StatefulWidget {
  const DesignGuideScreen({super.key});

  @override
  State<DesignGuideScreen> createState() => _DesignGuideScreenState();
}

class _DesignGuideScreenState extends State<DesignGuideScreen> {
  // 디자인 시스템 데이터
  final Map<String, dynamic> _designData = {
    'totalComponents': 20,
    'categories': 6,
    'lastUpdate': '2025.07.23',
    'version': '2.0',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          // 상단 디자인 요약 섹션
          SliverToBoxAdapter(child: _buildDesignSummarySection()),

          // 컴포넌트 메뉴 섹션
          SliverToBoxAdapter(child: _buildComponentMenuContent()),
        ],
      ),
    ),
  );

  // 상단 디자인 요약 섹션 (카카오톡 스타일)
  Widget _buildDesignSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.white.withValues(alpha: 0),
    child: Column(
      children: [
        // 디자인 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedPaintBoard,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 디자인 가이드 타이틀
        Text(
          'LIA 디자인 가이드',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 시스템 정보
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_designData['totalComponents']}개 컴포넌트 • ${_designData['categories']}개 카테고리',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  /// 컴포넌트 메뉴 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildComponentMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 기본 요소
        _buildMenuGroup('기본 요소', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTextFont,
            title: 'Typography',
            subtitle: '폰트와 텍스트 스타일 시스템',
            onTap: () => _showComponent('Typography'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedPaintBoard,
            title: 'Color Palette',
            subtitle: '브랜드 컬러와 사용 가이드',
            onTap: () => _showComponent('ColorPalette'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBorderAll01,
            title: 'Spacing',
            subtitle: '일관된 간격과 레이아웃 시스템',
            onTap: () => _showComponent('Spacing'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 네비게이션
        _buildMenuGroup('네비게이션', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMenu01,
            title: 'Header Navigation',
            subtitle: '상단 네비게이션과 메뉴',
            onTap: () => _showComponent('HeaderNavigation'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMenuSquare,
            title: 'Bottom Navigation',
            subtitle: '하단 네비게이션 바',
            onTap: () => _showComponent('BottomNavigation'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMenu01,
            title: 'Tab Bar',
            subtitle: '탭 네비게이션 시스템',
            onTap: () => _showComponent('TabBar'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 폼 요소
        _buildMenuGroup('폼 요소', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBubbleChatNotification,
            title: 'Buttons',
            subtitle: '기본 버튼과 상호작용 요소',
            onTap: () => _showComponent('Buttons'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTextFont,
            title: 'Text Fields',
            subtitle: '텍스트 입력 필드와 폼',
            onTap: () => _showComponent('TextFields'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedToggleOn,
            title: 'Interactive Widgets',
            subtitle: '스위치, 체크박스 등 상호작용',
            onTap: () => _showComponent('InteractiveWidgets'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 데이터 표시
        _buildMenuGroup('데이터 표시', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: 'Charts',
            subtitle: '다양한 차트와 데이터 시각화',
            onTap: () => _showComponent('Charts'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedSquareArrowDown02,
            title: 'Cards',
            subtitle: '정보를 담는 카드 컴포넌트',
            onTap: () => _showComponent('Cards'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMenu01,
            title: 'Lists',
            subtitle: '목록과 아이템 표시',
            onTap: () => _showComponent('Lists'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 피드백
        _buildMenuGroup('피드백', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedLoading01,
            title: 'Loading States',
            subtitle: '로딩과 진행 상태 표시',
            onTap: () => _showComponent('LoadingStates'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedNotification01,
            title: 'Toast Notifications',
            subtitle: '알림과 메시지 표시',
            onTap: () => _showComponent('ToastNotifications'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedSquareArrowDown02,
            title: 'Modals',
            subtitle: '모달과 다이얼로그',
            onTap: () => _showComponent('Modals'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 애니메이션
        _buildMenuGroup('애니메이션', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedLoading01,
            title: 'Animations',
            subtitle: '다양한 애니메이션 효과',
            onTap: () => _showComponent('Animations'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedArrowRight01,
            title: 'Transitions',
            subtitle: '화면 전환과 상태 변화',
            onTap: () => _showComponent('Transitions'),
            iconColor: AppColors.accent,
          ),
        ]),

        // 사용 가이드
        _buildMenuGroup('사용 가이드', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBookOpen01,
            title: 'Usage Guide',
            subtitle: '컴포넌트 사용법과 예시',
            onTap: _showUsageGuide,
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedCode,
            title: 'Code Examples',
            subtitle: '실제 코드 예시와 템플릿',
            onTap: _showCodeExamples,
            iconColor: AppColors.accent,
          ),
        ]),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );

  // 메뉴 그룹 (섹션 헤더)
  Widget _buildMenuGroup(String title, List<Widget> items) => Column(
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
      ...items,
      const SizedBox(height: 16),
    ],
  );

  // 컴포넌트 표시
  void _showComponent(String componentType) {
    ToastNotification.show(
      context: context,
      message: '$componentType 컴포넌트를 확인합니다',
      type: ToastType.info,
    );
  }

  // 사용법 가이드
  void _showUsageGuide() {
    ToastNotification.show(
      context: context,
      message: '사용법 가이드를 확인합니다',
      type: ToastType.info,
    );
  }

  // 코드 예시
  void _showCodeExamples() {
    ToastNotification.show(
      context: context,
      message: '코드 예시를 확인합니다',
      type: ToastType.info,
    );
  }
}
