// File: lib/presentation/widgets/specific/feedback/skeleton_ui.dart

import 'package:flutter/material.dart';

/// 콘텐츠 로딩 중 표시되는 스켈레톤 UI 위젯입니다.
///
/// 실제 콘텐츠가 로드되기 전에 콘텐츠의 구조를 미리 보여주어
/// 사용자에게 더 나은 로딩 경험을 제공합니다.
///
/// 주요 특징:
/// - 실제 콘텐츠 구조를 모방한 레이아웃
/// - 부드러운 반짝임(shimmer) 애니메이션
/// - 다양한 크기의 플레이스홀더 요소
/// - 접근성을 고려한 색상 대비
/// - 반응형 디자인
///
/// 사용 예시:
/// ```dart
/// SkeletonUI()  // 기본 스켈레톤 레이아웃
/// ```
///
/// 구성 요소:
/// - 프로필 이미지 플레이스홀더 (원형)
/// - 제목 텍스트 플레이스홀더 (긴 막대)
/// - 부제목 텍스트 플레이스홀더 (중간 막대)
/// - 본문 텍스트 플레이스홀더 (여러 줄)
class SkeletonUI extends StatefulWidget {
  const SkeletonUI({super.key});

  @override
  State<SkeletonUI> createState() => _SkeletonUIState();
}

class _SkeletonUIState extends State<SkeletonUI>
    with SingleTickerProviderStateMixin {
  /// 반짝임 애니메이션을 제어하는 컨트롤러입니다.
  late AnimationController _controller;
  
  /// 반짝임 애니메이션 값입니다.
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러 설정 (1.5초 주기)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 투명도 변화 애니메이션 (0.3 → 0.7)
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // 애니메이션 무한 반복 시작
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 스켈레톤 플레이스홀더 요소를 생성하는 메서드입니다.
  ///
  /// @param width 플레이스홀더의 너비
  /// @param height 플레이스홀더의 높이
  /// @param borderRadius 모서리 둥글기 (기본값: 8)
  /// @return 애니메이션이 적용된 플레이스홀더 Container
  Widget _buildSkeletonItem({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 섹션
          Row(
            children: [
              // 프로필 이미지 플레이스홀더
              _buildSkeletonItem(
                width: 60,
                height: 60,
                borderRadius: 30, // 원형
              ),
              const SizedBox(width: 16),
              // 이름과 상태 플레이스홀더
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonItem(width: 120, height: 20),
                    const SizedBox(height: 8),
                    _buildSkeletonItem(width: 80, height: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // 제목 플레이스홀더
          _buildSkeletonItem(width: double.infinity, height: 24),
          const SizedBox(height: 16),
          
          // 본문 텍스트 플레이스홀더들
          _buildSkeletonItem(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          _buildSkeletonItem(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          _buildSkeletonItem(width: 200, height: 16),
          const SizedBox(height: 24),
          
          // 버튼 플레이스홀더들
          Row(
            children: [
              _buildSkeletonItem(width: 100, height: 40, borderRadius: 20),
              const SizedBox(width: 12),
              _buildSkeletonItem(width: 80, height: 40, borderRadius: 20),
            ],
          ),
        ],
      ),
    );
  }
} 