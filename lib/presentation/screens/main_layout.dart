// File: lib/presentation/screens/main_layout.dart
// 2025.07.16 11:41:15 생성 - 하단 네비게이션 고정을 위한 메인 레이아웃

import 'package:flutter/material.dart';

import '../widgets/lia_widgets.dart';
import 'analyzed_people_screen.dart';
import 'chart_demo_screen.dart';
import 'main_screen.dart';
import 'my_screen.dart';

/// 하단 네비게이션이 고정된 메인 레이아웃 화면입니다.
///
/// 문제점 해결:
/// - 화면 전환 시 하단 네비게이션 바가 함께 업데이트되는 문제
/// - 히스토리 버튼 라우팅 오류 (MY 버튼으로 잘못 연결됨)
///
/// 해결 방안:
/// - 하단 네비게이션을 고정하고 body만 변경
/// - 올바른 인덱스 매핑 (0:홈, 1:코칭센터, 2:히스토리, 3:MY)
/// - AI 버튼은 별도 처리
class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  late PageController _pageController;

  // 네비게이션 화면들
  final List<Widget> _screens = [
    const MainScreen(), // 0: 홈
    const AnalyzedPeopleScreen(), // 1: 코칭센터
    const ChartDemoScreen(), // 2: 히스토리
    const MyScreen(), // 3: MY
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
      children: _screens,
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
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
    Navigator.pushNamed(context, '/ai-message');
  }
}
