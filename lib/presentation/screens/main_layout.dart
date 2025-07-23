// File: lib/presentation/screens/main_layout.dart
// 2025.07.16 11:41:15 생성 - 하단 네비게이션 고정을 위한 메인 레이아웃

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';
import 'ai_message_screen.dart';
import 'analyzed_people_screen.dart';
import 'coaching_center_screen.dart';
import 'main_screen.dart';
import 'my_screen.dart';

/// 하단 네비게이션이 고정된 메인 레이아웃 화면입니다.
///
/// 문제점 해결:
/// - 화면 전환 시 하단 네비게이션 바가 함께 업데이트되는 문제
/// - 히스토리 버튼 라우팅 오류 (MY 버튼으로 잘못 연결됨)
/// - 헤더가 보이지 않는 문제 해결
///
/// 해결 방안:
/// - 하단 네비게이션을 고정하고 body만 변경
/// - 올바른 인덱스 매핑 (0:홈, 1:코칭센터, 2:히스토리, 3:MY)
/// - AI 버튼은 별도 처리
/// - 공통 헤더를 main_layout에서 관리
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

  // 각 화면별 헤더 정보 - 심플하게 제목만
  final List<String> _screenTitles = ['관계 분석', '나의 대화 분석', '분석 히스토리', '프로필'];

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
    // 분석 중일 때는 AppBar도 숨김
    appBar: _isAnalyzing
        ? null
        : AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              _screenTitles[_currentIndex],
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
    body: PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
      children: _screens,
    ),
    // 분석 중일 때만 네비게이션 숨김
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

  /// AI 메시지 버튼 처리
  void _onAITap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          // settings_screen.dart 스타일의 AppBar 적용
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                HugeIcons.strokeRoundedArrowLeft01,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'AI 메시지',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true, // 왼쪽 정렬
          ),
          body: const AiMessageScreen(),
        ),
      ),
    );
  }
}
