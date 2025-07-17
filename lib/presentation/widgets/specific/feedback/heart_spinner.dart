// File: lib/presentation/widgets/specific/feedback/heart_spinner.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

/// 하트가 심장 박동처럼 두근거리며 파동이 퍼지는 로딩 애니메이션 위젯입니다.
///
/// 18세 서현 페르소나에 맞는 감성적이고 트렌디한 하트 애니메이션을 제공합니다.
/// 기존 하트 아이콘을 사용하여 실제 심장 박동처럼 두근거리는 효과와 
/// 하트 테두리에서 퍼지는 파동 효과를 구현합니다.
///
/// 주요 특징:
/// - 기존 하트 아이콘 사용 (Icons.favorite)
/// - 실제 심장 박동 리듬: 빠르게 커지고 천천히 줄어듦
/// - 하트 테두리에서 퍼지는 파동 효과
/// - LIA 브랜드 색상 적용
/// - 부드러운 투명도 변화
/// - 메모리 효율적인 애니메이션 관리
///
/// 사용 예시:
/// ```dart
/// HeartSpinner()  // 두근거리는 하트 스피너
/// ```
///
/// 애니메이션 설정:
/// - 하트 박동: 1.0배 → 1.4배 → 1.0배 (1초 주기)
/// - 커지는 속도: 빠름 (Curves.easeOut)
/// - 줄어드는 속도: 느림 (Curves.easeIn)
/// - 파동 효과: 하트 테두리에서 3개의 동심원이 순차적으로 확장
class HeartSpinner extends StatefulWidget {
  const HeartSpinner({super.key});

  @override
  State<HeartSpinner> createState() => _HeartSpinnerState();
}

class _HeartSpinnerState extends State<HeartSpinner>
    with TickerProviderStateMixin {
  /// 하트 박동 애니메이션을 제어하는 컨트롤러입니다.
  late AnimationController _heartbeatController;
  
  /// 파동 효과 애니메이션을 제어하는 컨트롤러입니다.
  late AnimationController _waveController;
  
  /// 하트 박동 크기 애니메이션입니다.
  late Animation<double> _heartbeatAnimation;
  
  /// 파동 확산 애니메이션입니다.
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    // 하트 박동 애니메이션 컨트롤러 설정 (1초 주기)
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // 파동 효과 애니메이션 컨트롤러 설정 (1.5초 주기)
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 하트 박동 애니메이션 (빠르게 커지고 천천히 줄어듦)
    _heartbeatAnimation = TweenSequence<double>([
      // 빠르게 커지기 (30% 시간)
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      // 천천히 줄어들기 (70% 시간)
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_heartbeatController);
    
    // 파동 확산 애니메이션 (0 → 1)
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeOut,
    ));
    
    // 애니메이션 무한 반복 시작
    _heartbeatController.repeat();
    _waveController.repeat();
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: AnimatedBuilder(
          animation: Listenable.merge([_heartbeatController, _waveController]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // 파동 효과 (3개의 동심원)
                ..._buildWaveEffects(),
                
                // 메인 하트
                Transform.scale(
                  scale: _heartbeatAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10 * _heartbeatAnimation.value,
                          spreadRadius: 2 * _heartbeatAnimation.value,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 파동 효과를 생성하는 메서드입니다.
  List<Widget> _buildWaveEffects() {
    List<Widget> waves = [];
    
    // 3개의 파동을 순차적으로 생성
    for (int i = 0; i < 3; i++) {
      final waveDelay = i * 0.3; // 각 파동의 지연 시간
      final adjustedWaveValue = (_waveAnimation.value - waveDelay).clamp(0.0, 1.0);
      
      if (adjustedWaveValue > 0) {
        final waveSize = 60 + (80 * adjustedWaveValue); // 60에서 140까지 확장
        final opacity = (1.0 - adjustedWaveValue) * 0.4; // 점점 투명해짐
        
        waves.add(
          Container(
            width: waveSize,
            height: waveSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: opacity),
                width: 2,
              ),
            ),
          ),
        );
      }
    }
    
    return waves;
  }
} 