// File: lib/presentation/widgets/specific/feedback/pulsating_dot.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

/// 맥박처럼 뛰는 점 애니메이션 위젯입니다.
///
/// 온라인 상태, 알림, 활성 상태 등을 나타내는 데 사용되는
/// 작은 원형 인디케이터가 크기가 변하면서 맥박치는 효과를 제공합니다.
///
/// 주요 특징:
/// - 부드러운 크기 변화 애니메이션
/// - 브랜드 색상의 원형 인디케이터
/// - 무한 반복 애니메이션
/// - 접근성을 고려한 적절한 크기
/// - 메모리 효율적인 애니메이션 관리
///
/// 사용 예시:
/// ```dart
/// PulsatingDot()  // 기본 맥박 점
/// ```
///
/// 애니메이션 설정:
/// - 크기: 8px → 12px (1.5초 반복)
/// - 곡선: Curves.easeInOut
/// - 반복: 무한 (reverse: true)
class PulsatingDot extends StatefulWidget {
  const PulsatingDot({super.key});

  @override
  State<PulsatingDot> createState() => _PulsatingDotState();
}

class _PulsatingDotState extends State<PulsatingDot>
    with SingleTickerProviderStateMixin {
  /// 맥박 애니메이션을 제어하는 컨트롤러입니다.
  late AnimationController _controller;
  
  /// 크기 변화 애니메이션 값입니다.
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러 설정 (1.5초 주기)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 크기 변화 애니메이션 (8px → 12px)
    _animation = Tween<double>(
      begin: 8.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // 애니메이션 무한 반복 시작 (앞뒤로 반복)
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
} 