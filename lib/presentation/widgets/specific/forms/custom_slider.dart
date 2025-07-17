// File: lib/presentation/widgets/specific/forms/custom_slider.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

/// LIA 브랜드에 맞는 커스텀 슬라이더입니다.
///
/// Material Design 기본 Slider에 LIA의 브랜드 색상과 디자인을 적용한
/// 커스텀 슬라이더입니다. 18세 서현 페르소나에 맞는 친근하고 트렌디한 디자인입니다.
///
/// 주요 특징:
/// - LIA 핑크 그라데이션 활성 트랙
/// - 연한 회색 비활성 트랙
/// - 그라데이션 썸(thumb) + 그림자 효과
/// - 부드러운 애니메이션
/// - 터치 영역 최적화
/// - 둥근 모서리로 친근한 느낌
///
/// 사용 예시:
/// ```dart
/// CustomSlider(
///   value: _sliderValue,
///   onChanged: (double value) {
///     setState(() => _sliderValue = value);
///   },
///   min: 0.0,
///   max: 1.0,
/// )
/// ```
///
/// @param value 현재 슬라이더 값
/// @param onChanged 값 변경 시 호출되는 콜백 함수
/// @param min 최소값 (기본값: 0.0)
/// @param max 최대값 (기본값: 1.0)
/// @param divisions 분할 개수 (선택사항)
/// @param label 값 표시 라벨 (선택사항)
class CustomSlider extends StatelessWidget {
  /// 현재 슬라이더의 값입니다.
  final double value;
  
  /// 슬라이더 값이 변경될 때 호출되는 콜백 함수입니다.
  final ValueChanged<double> onChanged;
  
  /// 슬라이더의 최소값입니다.
  final double min;
  
  /// 슬라이더의 최대값입니다.
  final double max;
  
  /// 슬라이더를 분할할 개수입니다 (선택사항).
  final int? divisions;
  
  /// 값을 표시할 라벨입니다 (선택사항).
  final String? label;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // 활성 트랙 색상 (LIA 핑크)
        activeTrackColor: AppColors.primary,
        
        // 비활성 트랙 색상 (연한 회색)
        inactiveTrackColor: Colors.grey.shade200,
        
        // 썸(thumb) 색상 및 스타일
        thumbColor: Colors.white,
        thumbShape: const _CustomSliderThumb(),
        
        // 오버레이 색상 (터치 시 나타나는 원)
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        
        // 트랙 높이
        trackHeight: 6,
        
        // 활성/비활성 트랙 모양
        trackShape: const RoundedRectSliderTrackShape(),
        
        // 값 표시 색상
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
        ),
      ),
    );
  }
}

/// 커스텀 슬라이더 썸(thumb) 모양을 정의하는 클래스입니다.
///
/// 그라데이션 배경과 그림자 효과가 있는 원형 썸을 만듭니다.
class _CustomSliderThumb extends SliderComponentShape {
  const _CustomSliderThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    
    // 그림자 그리기
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawCircle(
      center + const Offset(0, 2),
      12,
      shadowPaint,
    );
    
    // 그라데이션 썸 그리기
    final gradientPaint = Paint()
      ..shader = AppColors.primaryGradient.createShader(
        Rect.fromCircle(center: center, radius: 12),
      );
    
    canvas.drawCircle(center, 12, gradientPaint);
    
    // 흰색 테두리 그리기
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, 12, borderPaint);
  }
} 