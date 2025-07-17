// File: lib/presentation/widgets/specific/charts/semicircle_gauge_chart.dart

import 'package:flutter/material.dart';
import 'package:lia/core/app_colors.dart';
import 'package:lia/core/app_text_styles.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

/// 반원 게이지 차트 데이터 모델
class SemicircleGaugeData {
  final double value;
  final double maxValue;
  final String unit;
  final Color primaryColor;
  final Color backgroundColor;
  final double? thresholdValue;

  SemicircleGaugeData({
    required this.value,
    this.maxValue = 100,
    this.unit = '%',
    this.primaryColor = AppColors.primary,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.thresholdValue,
  });

  /// JSON으로부터 데이터 생성
  factory SemicircleGaugeData.fromJson(Map<String, dynamic> json) {
    return SemicircleGaugeData(
      value: (json['value'] ?? 0).toDouble(),
      maxValue: (json['maxValue'] ?? 100).toDouble(),
      unit: json['unit'] ?? '%',
      primaryColor: Color(json['primaryColor'] ?? 0xFF6C5CE7),
      backgroundColor: Color(json['backgroundColor'] ?? 0xFFEEEEEE),
      thresholdValue: json['thresholdValue']?.toDouble(),
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'maxValue': maxValue,
      'unit': unit,
      'primaryColor': primaryColor.value,
      'backgroundColor': backgroundColor.value,
      'thresholdValue': thresholdValue,
    };
  }
}

/// 반원 게이지 차트 위젯
///
/// 공간 효율적인 반원 형태로 진행률이나 수치를 표시하는 차트입니다.
/// HTML의 stroke-dasharray 애니메이션 효과를 구현했습니다.
///
/// 주요 특징:
/// - JSON 데이터 형식 지원
/// - 범례 표시 켜기/끄기 기능
/// - 제목 표시 기능
/// - 반원 형태의 공간 효율성
/// - 부드러운 애니메이션
/// - 임계값 표시 기능
///
/// 사용 예시:
/// ```dart
/// // JSON 데이터 사용
/// SemicircleGaugeChart(
///   title: '현재 호감도',
///   data: {
///     'value': 75,
///     'maxValue': 100,
///     'unit': '%',
///     'primaryColor': 0xFF6C5CE7,
///     'backgroundColor': 0xFFEEEEEE,
///     'thresholdValue': 80,
///   },
///   showLegend: true,
/// )
///
/// // 기본 사용법 (범례 포함)
/// SemicircleGaugeChart()
///
/// // 범례 없이 사용
/// SemicircleGaugeChart(showLegend: false)
/// ```
class SemicircleGaugeChart extends StatefulWidget {
  /// 차트 제목 (선택사항)
  final String? title;

  /// 차트 제목 아이콘 (선택사항)
  final IconData? titleIcon;

  /// 차트 데이터
  final dynamic data;

  /// 범례 표시 여부
  final bool showLegend;

  /// 범례 위치
  final LegendPosition legendPosition;

  /// 차트 크기
  final double size;

  /// 최대값
  final double maxValue;

  const SemicircleGaugeChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.size = 200,
    this.maxValue = 100,
  });

  @override
  State<SemicircleGaugeChart> createState() => _SemicircleGaugeChartState();
}

class _SemicircleGaugeChartState extends State<SemicircleGaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<SemicircleGaugeData> _chartData = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _parseData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 데이터 파싱
  void _parseData() {
    if (widget.data == null) {
      // 기본 데이터
      _chartData = [
        SemicircleGaugeData(
          value: 75,
          maxValue: 100,
          unit: '%',
          primaryColor: AppColors.primary,
          backgroundColor: const Color(0xFFEEEEEE),
          thresholdValue: 80,
        ),
      ];
    } else if (widget.data is List) {
      _chartData = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return SemicircleGaugeData.fromJson(item);
        } else if (item is SemicircleGaugeData) {
          return item;
        }
        return SemicircleGaugeData(
          value: 0,
          maxValue: 100,
          unit: '%',
          primaryColor: AppColors.primary,
          backgroundColor: const Color(0xFFEEEEEE),
          thresholdValue: 80,
        );
      }).toList();
    } else if (widget.data is Map<String, dynamic>) {
      _chartData = [SemicircleGaugeData.fromJson(widget.data)];
    } else {
      _chartData = [];
    }

    // 색상 할당
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.blue,
      AppColors.green,
      AppColors.yellow,
      AppColors.purple,
      AppColors.orange,
      AppColors.pink,
    ];

    for (int i = 0; i < _chartData.length; i++) {
      if (_chartData[i].primaryColor == AppColors.primary) {
        // 기본 색상은 덮어쓰지 않음
        _chartData[i] = SemicircleGaugeData(
          value: _chartData[i].value,
          maxValue: _chartData[i].maxValue,
          unit: _chartData[i].unit,
          primaryColor: colors[i % colors.length],
          backgroundColor: _chartData[i].backgroundColor,
          thresholdValue: _chartData[i].thresholdValue,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '진행률';
    final mainData = _chartData.isNotEmpty
        ? _chartData.first
        : SemicircleGaugeData(
            value: 0,
            maxValue: 100,
            unit: '%',
            primaryColor: AppColors.primary,
            backgroundColor: const Color(0xFFEEEEEE),
            thresholdValue: 80,
          );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 제목 표시
          _buildTitle(displayTitle),
          const SizedBox(height: 20),

          // 상단 범례
          if (widget.showLegend &&
              (widget.legendPosition == LegendPosition.topLeft ||
                  widget.legendPosition == LegendPosition.topCenter ||
                  widget.legendPosition == LegendPosition.topRight)) ...[
            _buildLegend(),
            const SizedBox(height: 20),
          ],

          // 차트
          SizedBox(
            width: widget.size,
            height: widget.size / 2 + 40, // 반원이므로 높이 조정
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _SemicircleGaugeChartPainter(
                        data: mainData,
                        animation: _animation.value,
                        maxValue: widget.maxValue,
                      ),
                      size: Size(widget.size, widget.size / 2 + 40),
                    );
                  },
                ),
                // 중앙 값 표시
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        '${mainData.value.toInt()}',
                        style: AppTextStyles.h1.copyWith(
                          color: mainData.primaryColor,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        '%',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단 범례
          if (widget.showLegend &&
              (widget.legendPosition == LegendPosition.bottomLeft ||
                  widget.legendPosition == LegendPosition.bottomCenter ||
                  widget.legendPosition == LegendPosition.bottomRight)) ...[
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  /// 제목 위젯 생성
  Widget _buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.titleIcon != null) ...[
          Icon(widget.titleIcon!, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Text(title, style: AppTextStyles.chartTitle),
      ],
    );
  }

  /// 범례 위젯 생성
  Widget _buildLegend() {
    WrapAlignment alignment;
    switch (widget.legendPosition) {
      case LegendPosition.topLeft:
      case LegendPosition.bottomLeft:
        alignment = WrapAlignment.start;
        break;
      case LegendPosition.topCenter:
      case LegendPosition.bottomCenter:
        alignment = WrapAlignment.center;
        break;
      case LegendPosition.topRight:
      case LegendPosition.bottomRight:
        alignment = WrapAlignment.end;
        break;
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: alignment,
      children: _chartData.map((data) => _buildLegendItem(data)).toList(),
    );
  }

  /// 범례 아이템 생성
  Widget _buildLegendItem(SemicircleGaugeData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: data.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${data.value.toInt()}%',
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 반원 게이지 차트 페인터
class _SemicircleGaugeChartPainter extends CustomPainter {
  final SemicircleGaugeData data;
  final double animation;
  final double maxValue;

  _SemicircleGaugeChartPainter({
    required this.data,
    required this.animation,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2 - 20;

    // 배경 호 (반원)
    final backgroundPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // 180도 (왼쪽)
      3.14159, // 180도 호 (반원)
      false,
      backgroundPaint,
    );

    // 진행률 호 (반원)
    final progressPaint = Paint()
      ..color = data.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (data.value / maxValue) * 3.14159 * animation;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // 180도 (왼쪽)
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
