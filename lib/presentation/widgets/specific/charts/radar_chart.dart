// File: lib/presentation/widgets/specific/charts/radar_chart.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

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
    this.legendPosition = LegendPosition.bottomCenter,
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
      // 다중 시리즈 데이터 처리
      final dataList = widget.data as List;
      if (dataList.isNotEmpty && dataList.first is Map<String, dynamic>) {
        // 각 아이템이 시리즈 데이터인지 확인
        final firstItem = dataList.first as Map<String, dynamic>;
        if (firstItem.containsKey('name') && firstItem.containsKey('data')) {
          // 다중 시리즈 형식
          _chartSeries = dataList.map((item) {
            final seriesData = item as Map<String, dynamic>;
            return RadarChartSeries(
              name: seriesData['name'] ?? '',
              data: (seriesData['data'] as List? ?? [])
                  .map((dataPoint) => RadarChartDataPoint.fromJson(dataPoint))
                  .toList(),
              color: seriesData['color'] != null
                  ? Color(seriesData['color'])
                  : null,
            );
          }).toList();
        } else {
          // 단일 시리즈 데이터 포인트들
          final dataPoints = dataList.map((item) {
            if (item is Map<String, dynamic>) {
              return RadarChartDataPoint.fromJson(item);
            } else if (item is RadarChartDataPoint) {
              return item;
            }
            return RadarChartDataPoint(label: '', value: 0);
          }).toList();

          _chartSeries = [RadarChartSeries(name: '데이터', data: dataPoints)];
        }
      } else {
        // 빈 데이터
        _chartSeries = [];
      }
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            height: widget.size,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RadarChartPainter(
                    series: _chartSeries,
                    animation: _animation.value,
                  ),
                  size: Size.infinite,
                );
              },
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
      mainAxisAlignment: MainAxisAlignment.start,
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
    MainAxisAlignment alignment;
    switch (widget.legendPosition) {
      case LegendPosition.topLeft:
      case LegendPosition.bottomLeft:
        alignment = MainAxisAlignment.start;
        break;
      case LegendPosition.topCenter:
      case LegendPosition.bottomCenter:
        alignment = MainAxisAlignment.center;
        break;
      case LegendPosition.topRight:
      case LegendPosition.bottomRight:
        alignment = MainAxisAlignment.end;
        break;
    }

    return Row(
      mainAxisAlignment: alignment,
      children: _chartSeries
          .map(
            (series) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildLegendItem(series),
            ),
          )
          .toList(),
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

    // 모든 시리즈에서 최대 축 수를 찾기
    int maxAxisCount = 0;
    List<String> allLabels = [];

    for (final s in series) {
      if (s.data.length > maxAxisCount) {
        maxAxisCount = s.data.length;
        allLabels = s.data.map((d) => d.label).toList();
      }
    }

    if (maxAxisCount == 0) return;

    final maxValue = 100.0; // 기본 최대값

    // 격자 그리기
    _drawGrid(canvas, center, radius, maxAxisCount);

    // 축 라벨 그리기 (첫 번째 시리즈 또는 가장 긴 시리즈의 라벨 사용)
    _drawAxisLabels(canvas, center, radius, allLabels);

    // 데이터 시리즈 그리기
    for (final s in series) {
      if (s.data.isNotEmpty) {
        _drawDataSeries(canvas, center, radius, s, maxValue, maxAxisCount);
      }
    }
  }

  /// 격자 그리기
  void _drawGrid(Canvas canvas, Offset center, double radius, int axisCount) {
    final gridPaint = Paint()
      ..color = AppColors.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 동심원 그리기 (5단계)
    for (int i = 1; i <= 5; i++) {
      final circleRadius = radius * (i / 5);
      canvas.drawCircle(center, circleRadius, gridPaint);
    }

    // 축 선 그리기 (강조된 스타일)
    for (int i = 0; i < axisCount; i++) {
      final angle = (i * 2 * 3.14159) / axisCount - 3.14159 / 2;
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, axisPaint);
    }
  }

  /// 축 라벨 그리기
  void _drawAxisLabels(
    Canvas canvas,
    Offset center,
    double radius,
    List<String> labels,
  ) {
    for (int i = 0; i < labels.length; i++) {
      final angle = (i * 2 * 3.14159) / labels.length - 3.14159 / 2;
      final labelRadius = radius + 25;
      final labelPoint = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 배경 사각형 그리기
      final backgroundRect = RRect.fromLTRBR(
        labelPoint.dx - textPainter.width / 2 - 6,
        labelPoint.dy - textPainter.height / 2 - 4,
        labelPoint.dx + textPainter.width / 2 + 6,
        labelPoint.dy + textPainter.height / 2 + 4,
        const Radius.circular(6),
      );

      final backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRRect(backgroundRect, backgroundPaint);

      // 테두리 그리기
      final borderPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawRRect(backgroundRect, borderPaint);

      // 텍스트 그리기
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
    int axisCount,
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
    for (int i = 0; i < axisCount; i++) {
      final angle = (i * 2 * 3.14159) / axisCount - 3.14159 / 2;

      // 현재 축에 대한 데이터가 있는지 확인
      double value = 0;
      if (i < series.data.length) {
        value = series.data[i].value;
      }

      final normalizedValue = (value / maxValue).clamp(0.0, 1.0);
      final animatedValue = normalizedValue * animation;

      final pointRadius = radius * animatedValue;
      final point = Offset(
        center.dx + pointRadius * math.cos(angle),
        center.dy + pointRadius * math.sin(angle),
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

    // 데이터 포인트 그리기 (실제 데이터가 있는 포인트만)
    for (int i = 0; i < math.min(series.data.length, points.length); i++) {
      final point = points[i];

      // 데이터 포인트 원 그리기
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
