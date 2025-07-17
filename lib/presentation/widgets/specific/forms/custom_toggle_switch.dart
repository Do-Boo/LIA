// File: lib/presentation/widgets/specific/forms/custom_toggle_switch.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

/// LIA 브랜드에 맞는 커스텀 토글 스위치입니다.
///
/// Material Design 기본 Switch 대신 LIA의 브랜드 색상과 디자인을 적용한
/// 커스텀 토글 스위치입니다. 18세 서현 페르소나에 맞는 친근하고 트렌디한 디자인입니다.
///
/// 주요 특징:
/// - LIA 핑크 그라데이션 배경 (활성화 시)
/// - 연한 회색 배경 (비활성화 시)
/// - 흰색 원형 토글 버튼 + 그림자 효과
/// - 활성화 시 작은 체크 아이콘 표시
/// - 200ms 부드러운 전환 애니메이션
/// - 터치 영역 최적화
/// - 둥근 모서리로 친근한 느낌
///
/// 사용 예시:
/// ```dart
/// CustomToggleSwitch(
///   value: _isEnabled,
///   onChanged: (bool value) {
///     setState(() => _isEnabled = value);
///   },
/// )
/// ```
///
/// @param value 현재 스위치 상태 (true: 활성화, false: 비활성화)
/// @param onChanged 상태 변경 시 호출되는 콜백 함수
class CustomToggleSwitch extends StatefulWidget {
  /// 현재 스위치의 활성화 상태입니다.
  final bool value;
  
  /// 스위치 상태가 변경될 때 호출되는 콜백 함수입니다.
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  
  /// 토글 애니메이션을 제어하는 컨트롤러입니다.
  late AnimationController _animationController;
  
  /// 토글 버튼의 위치 애니메이션입니다.
  late Animation<double> _toggleAnimation;
  
  /// 배경 색상 애니메이션입니다.
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    // 200ms 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // 토글 버튼 위치 애니메이션 (0.0 ~ 1.0)
    _toggleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // 배경 색상 애니메이션 (회색 → 핑크 그라데이션)
    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // 초기 상태에 따라 애니메이션 설정
    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 부모 위젯에서 value가 변경되면 애니메이션 실행
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 스위치 터치 시 상태를 토글하는 메서드입니다.
  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 56,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: widget.value 
                ? AppColors.primaryGradient 
                : null,
              color: widget.value 
                ? null 
                : Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: widget.value 
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 토글 버튼
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: widget.value ? 28 : 4,
                  top: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: widget.value 
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 16,
                        )
                      : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 