// File: lib/presentation/screens/main_layout.dart
// 2025.07.23 17:27:25 카카오톡 스타일 통일 - 뒤로가기 버튼 및 폰트 개선

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';
import 'ai_message_screen.dart';
import 'analyzed_people_screen.dart';
import 'coaching_center_screen.dart';
import 'main_screen.dart';
import 'my_screen.dart';
import 'notification_screen.dart';

/// 하단 네비게이션이 고정된 메인 레이아웃 화면
///
/// 카카오톡 스타일로 통일된 네비게이션 시스템
/// 모든 스크린이 동일한 패턴(상단 요약 + 하단 메뉴 리스트)을 따름
/// 분석 중일 때는 AppBar와 네비게이션 바 모두 숨김 처리
class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  late PageController _pageController;
  bool _isAnalyzing = false; // 분석 상태 추가

  // 네비게이션 화면들
  late final List<Widget> _screens;

  // 각 화면별 헤더 정보 - 카카오톡 스타일에 맞게 간단하고 직관적으로
  final List<String> _screenTitles = ['관계 분석', 'AI 코칭센터', '분석 히스토리', '프로필'];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // 화면들을 초기화 (MainScreen에 콜백 전달)
    _screens = [
      MainScreen(
        onAnalyzingStateChanged: (isAnalyzing) {
          setState(() {
            _isAnalyzing = isAnalyzing;
          });
        },
      ), // 0: 홈
      const CoachingCenterScreen(), // 1: 코칭센터
      const AnalyzedPeopleScreen(), // 2: 히스토리
      const MyScreen(), // 3: 프로필
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    // 분석 중일 때는 AppBar도 숨김 (카카오톡 스타일 통일성 유지)
    appBar: _isAnalyzing
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildCustomAppBar(),
          ),
    body: PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
      children: _screens,
    ),
    // 분석 중일 때만 네비게이션 숨김 (몰입감 있는 분석 경험)
    bottomNavigationBar: _isAnalyzing
        ? null
        : CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            onAITap: _onAITap,
          ),
  );

  /// 네비게이션 탭 처리
  void _onNavTap(int index) {
    if (index == _currentIndex) return; // 같은 화면이면 무시

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 커스텀 AppBar 위젯 (LIA 스타일)
  Widget _buildCustomAppBar() => DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: AppColors.surface, width: 0.5)),
    ),
    child: SafeArea(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // 왼쪽 버튼 (뒤로가기 또는 로고)
            _buildLeftButton(),

            // 중앙 타이틀
            Expanded(
              child: Text(
                _screenTitles[_currentIndex],
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // 오른쪽 버튼들 (알림, 설정 등)
            _buildRightButtons(),
          ],
        ),
      ),
    ),
  );

  /// 왼쪽 버튼 (뒤로가기 또는 로고)
  Widget _buildLeftButton() {
    if (Navigator.canPop(context)) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          HugeIcons.strokeRoundedBrain01,
          color: AppColors.textPrimary,
          size: 24,
        ),
      );
    }
  }

  /// 오른쪽 버튼들 (홈에서만 알림)
  Widget _buildRightButtons() {
    // 홈 화면에서만 알림 버튼 표시
    if (_currentIndex == 0) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: Stack(
            children: [
              const Icon(
                HugeIcons.strokeRoundedNotification01,
                color: AppColors.textPrimary,
                size: 24,
              ),
              // 알림 배지
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: _showNotifications,
          padding: EdgeInsets.zero,
        ),
      );
    }

    // 다른 화면에서는 빈 공간 (대칭을 위해)
    return const SizedBox(width: 48);
  }

  /// 알림 화면으로 이동
  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.surface, width: 0.5),
                ),
              ),
              child: SafeArea(
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // 뒤로가기 버튼
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            HugeIcons.strokeRoundedArrowLeft01,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      // 중앙 타이틀
                      Expanded(
                        child: Text(
                          '알림',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // 오른쪽 여백 (대칭을 위해)
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const NotificationScreen(),
        ),
      ),
    );
  }

  /// AI 메시지 버튼 처리 (카카오톡 스타일 모달 화면)
  void _onAITap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          // 새로운 LIA 스타일 AppBar 적용
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.surface, width: 0.5),
                ),
              ),
              child: SafeArea(
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // 뒤로가기 버튼
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            HugeIcons.strokeRoundedArrowLeft01,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),

                      // 중앙 타이틀
                      Expanded(
                        child: Text(
                          'AI 메시지 생성',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // 오른쪽 여백 (대칭을 위해)
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const AiMessageScreen(),
        ),
      ),
    );
  }
}
