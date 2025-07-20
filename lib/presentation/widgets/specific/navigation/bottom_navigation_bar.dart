import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/app_colors.dart';

/// LIA 앱의 하단 네비게이션 바 컴포넌트입니다.
///
/// 앱의 주요 섹션들을 탐색할 수 있는 하단 네비게이션을 제공합니다.
/// 중앙에 FloatingActionButton(AI)이 있고, 양쪽에 4개의 탭이 배치됩니다.
/// 선택된 탭은 일정한 너비의 배경으로 강조되며, 부드러운 애니메이션 효과가 적용됩니다.
///
/// 주요 기능:
/// - 4개의 일반 탭 (홈, 가상 채팅, 가이드, MY) + 중앙 AI 메시지 버튼
/// - 선택된 탭 강조 표시 (일정한 너비)
/// - 부드러운 애니메이션 효과
/// - 블러 효과가 적용된 반투명 배경
/// - 브랜드 색상 적용
/// - AI 버튼 심장 박동 애니메이션 및 인터랙션
///
/// 사용 예시:
/// ```dart
/// CustomBottomNavigationBar(
///   currentIndex: 0,
///   onTap: (index) {
///     // 탭 변경 처리
///   },
///   onAITap: () {
///     // AI 버튼 처리
///   },
/// )
/// ```
class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
    this.onAITap,
  });

  /// 현재 선택된 탭의 인덱스입니다. (AI 버튼 제외)
  final int currentIndex;

  /// 탭이 선택되었을 때 호출되는 콜백 함수입니다.
  final Function(int) onTap;

  /// AI 버튼이 눌렸을 때 호출되는 콜백 함수입니다.
  final VoidCallback? onAITap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _heartbeatController;
  late AnimationController _tapController;
  late Animation<double> _heartbeatAnimation;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();

    // 심장 박동 애니메이션 (지속적)
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heartbeatAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    // 탭 애니메이션 (인터랙션)
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _tapAnimation = Tween<double>(
      begin: 1,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));

    // 심장 박동 시작
    _startHeartbeat();
  }

  void _startHeartbeat() {
    _heartbeatController.repeat(reverse: true);
  }

  void _onAIButtonTap() {
    // 탭 애니메이션 실행
    _tapController.forward().then((_) {
      _tapController.reverse();
    });

    // 콜백 실행
    widget.onAITap?.call();
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.bottomCenter,
    clipBehavior: Clip.none,
    children: [
      // 메인 네비게이션 바
      Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        height: 65 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, HugeIcons.strokeRoundedHome01, '홈'),
            _buildNavItem(1, HugeIcons.strokeRoundedMessageMultiple01, '가상 채팅'),
            const SizedBox(width: 40), // AI 메시지 버튼 공간
            _buildNavItem(2, HugeIcons.strokeRoundedBookOpen01, '가이드'),
            _buildNavItem(3, HugeIcons.strokeRoundedUserCircle, 'MY'),
          ],
        ),
      ),

      // 중앙 AI 메시지 FloatingActionButton (심장 박동 + 인터랙션)
      Positioned(
        top: -16,
        child: AnimatedBuilder(
          animation: Listenable.merge([_heartbeatAnimation, _tapAnimation]),
          builder: (context, child) => Transform.scale(
            scale: _heartbeatAnimation.value * _tapAnimation.value,
            child: GestureDetector(
              onTap: _onAIButtonTap,
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: _heartbeatAnimation.value * 2 - 1, // 맥박 효과
                      offset: const Offset(0, 3),
                    ),
                    // 추가 글로우 효과
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: _heartbeatAnimation.value * 4 - 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  /// 개별 네비게이션 아이템을 생성하는 메서드입니다.
  ///
  /// [index]: 아이템의 인덱스
  /// [icon]: 아이템의 아이콘
  /// [label]: 아이템의 라벨 텍스트
  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = widget.currentIndex == index;

    // 선택된 상태일 때 사용할 filled 아이콘들
    IconData selectedIcon;
    switch (index) {
      case 0:
        selectedIcon = HugeIcons.strokeRoundedHome01;
        break;
      case 1:
        selectedIcon = HugeIcons.strokeRoundedMessageMultiple01;
        break;
      case 2:
        selectedIcon = HugeIcons.strokeRoundedBookOpen01;
        break;
      case 3:
        selectedIcon = HugeIcons.strokeRoundedUserCircle;
        break;
      default:
        selectedIcon = icon;
    }

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 60, // 모든 탭에 고정된 너비 적용
        height: 50,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.secondaryText,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.secondaryText,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
