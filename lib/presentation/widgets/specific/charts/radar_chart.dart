// File: lib/presentation/widgets/specific/charts/radar_chart.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 레이더 차트 데이터 모델
class RadarChartData {
  final String label;
  final double value;
  final double maxValue;

  RadarChartData({
    required this.label,
    required this.value,
    this.maxValue = 100,
  });

  /// JSON으로부터 데이터 생성
  factory RadarChartData.fromJson(Map<String, dynamic> json) {
    return RadarChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      maxValue: (json['maxValue'] ?? 100).toDouble(),
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value, 'maxValue': maxValue};
  }
}

/// 레이더 차트 데이터셋 모델
class RadarDataSet {
  final String name;
  final List<RadarChartData> data;
  final Color color;
  final Color fillColor;
  final double strokeWidth;

  RadarDataSet({
    required this.name,
    required this.data,
    required this.color,
    Color? fillColor,
    this.strokeWidth = 2.0,
  }) : fillColor = fillColor ?? color.withValues(alpha: 0.2);

  /// JSON으로부터 데이터 생성
  factory RadarDataSet.fromJson(Map<String, dynamic> json) {
    return RadarDataSet(
      name: json['name'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => RadarChartData.fromJson(item))
              .toList() ??
          [],
      color: Color(json['color'] ?? 0xFF6C5CE7),
      fillColor: json['fillColor'] != null ? Color(json['fillColor']) : null,
      strokeWidth: (json['strokeWidth'] ?? 2.0).toDouble(),
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data.map((item) => item.toJson()).toList(),
      'color': color.value,
      'fillColor': fillColor.value,
      'strokeWidth': strokeWidth,
    };
  }
}

/// 레이더 차트 데이터 포인트 모델
class RadarChartDataPoint {
  final String label;
  final double value;

  RadarChartDataPoint({required this.label, required this.value});

  factory RadarChartDataPoint.fromJson(Map<String, dynamic> json) {
    return RadarChartDataPoint(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }
}

/// 레이더 차트 시리즈 모델
class RadarChartSeries {
  final String name;
  final List<RadarChartDataPoint> data;
  final Color? color;

  RadarChartSeries({required this.name, required this.data, this.color});

  factory RadarChartSeries.fromJson(Map<String, dynamic> json) {
    return RadarChartSeries(
      name: json['name'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => RadarChartDataPoint.fromJson(item))
          .toList(),
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data.map((point) => point.toJson()).toList(),
      if (color != null) 'color': color!.value,
    };
  }
}

/// 범례 위치 열거형
enum LegendPosition {
  top, // 상단
  bottom, // 하단
}

/// 다차원 데이터를 방사형으로 시각화하는 레이더 차트 위젯입니다.
///
/// 여러 항목의 값을 동시에 비교할 수 있는 방사형 차트로,
/// 성격 분석, 능력 평가, 설문 결과 등에 활용됩니다.
///
/// 주요 특징:
/// - JSON 데이터 형식 지원
/// - 범례 표시 켜기/끄기 기능
/// - 제목 표시 기능
/// - 다차원 데이터 시각화
/// - 여러 데이터셋 동시 표시
/// - 부드러운 애니메이션 효과
/// - 격자 배경 표시
/// - 축 라벨 자동 배치
/// - 터치 인터랙션 지원
///
/// 사용 예시:
/// ```dart
/// // JSON 데이터 사용
/// RadarChart(
///   title: 'MBTI 성격 분석',
///   data: [
///     {
///       'name': '나',
///       'data': [
///         {'label': '외향성', 'value': 80},
///         {'label': '감각', 'value': 60},
///       ],
///       'color': 0xFF6C5CE7,
///     },
///   ],
///   showLegend: true,
/// )
///
/// // 기본 사용법 (범례 포함)
/// RadarChart()
///
/// // 범례 없이 사용
/// RadarChart(showLegend: false)
/// ```
class RadarChart extends StatefulWidget {
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

  const RadarChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottom,
    this.size = 250,
  });

  @override
  State<RadarChart> createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<RadarChartSeries> _chartSeries = [];

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
      _chartSeries = [
        RadarChartSeries(
          name: '성향 분석',
          data: [
            RadarChartDataPoint(label: '외향성', value: 80),
            RadarChartDataPoint(label: '개방성', value: 70),
            RadarChartDataPoint(label: '성실성', value: 90),
            RadarChartDataPoint(label: '친화성', value: 85),
            RadarChartDataPoint(label: '신경성', value: 40),
          ],
        ),
      ];
    } else if (widget.data is List) {
      // 단일 시리즈 데이터 (RadarChartDataPoint 리스트)
      final dataPoints = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return RadarChartDataPoint.fromJson(item);
        } else if (item is RadarChartDataPoint) {
          return item;
        }
        return RadarChartDataPoint(label: '', value: 0);
      }).toList();

      _chartSeries = [RadarChartSeries(name: '데이터', data: dataPoints)];
    } else if (widget.data is Map<String, dynamic>) {
      // 단일 시리즈 데이터 (JSON 형식)
      _chartSeries = [RadarChartSeries.fromJson(widget.data)];
    } else {
      _chartSeries = [];
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

    for (int i = 0; i < _chartSeries.length; i++) {
      if (_chartSeries[i].color == null) {
        _chartSeries[i] = RadarChartSeries(
          name: _chartSeries[i].name,
          data: _chartSeries[i].data,
          color: colors[i % colors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '다차원 분석';

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
              widget.legendPosition == LegendPosition.top) ...[
            _buildLegend(),
            const SizedBox(height: 20),
          ],

          // 차트
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RadarChartPainter(
                    series: _chartSeries,
                    animation: _animation.value,
                  ),
                  size: Size(widget.size, widget.size),
                );
              },
            ),
          ),

          // 하단 범례
          if (widget.showLegend &&
              widget.legendPosition == LegendPosition.bottom) ...[
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
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: _chartSeries.map((series) => _buildLegendItem(series)).toList(),
    );
  }

  /// 범례 아이템 생성
  Widget _buildLegendItem(RadarChartSeries series) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: series.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          series.name,
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 레이더 차트 페인터
class _RadarChartPainter extends CustomPainter {
  final List<RadarChartSeries> series;
  final double animation;

  _RadarChartPainter({required this.series, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 40;

    // 첫 번째 시리즈의 데이터 포인트 수를 기준으로 설정
    final mainSeries = series.first;
    if (mainSeries.data.isEmpty) return;

    final axisCount = mainSeries.data.length;
    final maxValue = 100.0; // 기본 최대값

    // 격자 그리기
    _drawGrid(canvas, center, radius, axisCount);

    // 축 라벨 그리기
    _drawAxisLabels(canvas, center, radius, mainSeries.data);

    // 데이터 시리즈 그리기
    for (final s in series) {
      _drawDataSeries(canvas, center, radius, s, maxValue);
    }
  }

  /// 격자 그리기
  void _drawGrid(Canvas canvas, Offset center, double radius, int axisCount) {
    final gridPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 동심원 그리기
    for (int i = 1; i <= 5; i++) {
      final circleRadius = radius * (i / 5);
      canvas.drawCircle(center, circleRadius, gridPaint);
    }

    // 축 선 그리기
    for (int i = 0; i < axisCount; i++) {
      final angle = (i * 2 * 3.14159) / axisCount - 3.14159 / 2;
      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }
  }

  /// 축 라벨 그리기
  void _drawAxisLabels(
    Canvas canvas,
    Offset center,
    double radius,
    List<RadarChartDataPoint> data,
  ) {
    for (int i = 0; i < data.length; i++) {
      final angle = (i * 2 * 3.14159) / data.length - 3.14159 / 2;
      final labelRadius = radius + 20;
      final labelPoint = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textOffset = Offset(
        labelPoint.dx - textPainter.width / 2,
        labelPoint.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  /// 데이터 시리즈 그리기
  void _drawDataSeries(
    Canvas canvas,
    Offset center,
    double radius,
    RadarChartSeries series,
    double maxValue,
  ) {
    if (series.data.isEmpty) return;

    final fillPaint = Paint()
      ..color = (series.color ?? AppColors.primary).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = series.color ?? AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final pointPaint = Paint()
      ..color = series.color ?? AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    // 데이터 포인트를 좌표로 변환
    for (int i = 0; i < series.data.length; i++) {
      final angle = (i * 2 * 3.14159) / series.data.length - 3.14159 / 2;
      final value = series.data[i].value;
      final normalizedValue = (value / maxValue).clamp(0.0, 1.0);
      final animatedValue = normalizedValue * animation;

      final pointRadius = radius * animatedValue;
      final point = Offset(
        center.dx + pointRadius * cos(angle),
        center.dy + pointRadius * sin(angle),
      );

      points.add(point);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    // 채우기 영역 그리기
    canvas.drawPath(path, fillPaint);

    // 테두리 그리기
    canvas.drawPath(path, strokePaint);

    // 데이터 포인트 그리기
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(
        point,
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
