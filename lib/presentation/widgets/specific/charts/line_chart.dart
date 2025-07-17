// File: lib/presentation/widgets/specific/charts/line_chart.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 라인 차트 데이터 포인트 모델
class LineChartDataPoint {
  final String label;
  final double value;

  LineChartDataPoint({required this.label, required this.value});

  factory LineChartDataPoint.fromJson(Map<String, dynamic> json) {
    return LineChartDataPoint(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }
}

/// 라인 차트 시리즈 모델
class LineChartSeries {
  final String name;
  final List<LineChartDataPoint> data;
  final Color? color;

  LineChartSeries({required this.name, required this.data, this.color});

  factory LineChartSeries.fromJson(Map<String, dynamic> json) {
    return LineChartSeries(
      name: json['name'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => LineChartDataPoint.fromJson(item))
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

/// 라인 차트 위젯
class LineChart extends StatefulWidget {
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

  /// 차트 높이
  final double height;

  const LineChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottom,
    this.height = 200,
  });

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<LineChartSeries> _chartSeries = [];

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
        LineChartSeries(
          name: '감정 점수',
          data: [
            LineChartDataPoint(label: '월', value: 75),
            LineChartDataPoint(label: '화', value: 80),
            LineChartDataPoint(label: '수', value: 65),
            LineChartDataPoint(label: '목', value: 90),
            LineChartDataPoint(label: '금', value: 85),
            LineChartDataPoint(label: '토', value: 95),
            LineChartDataPoint(label: '일', value: 88),
          ],
        ),
      ];
    } else if (widget.data is List) {
      // 단일 시리즈 데이터 (LineChartDataPoint 리스트)
      final dataPoints = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return LineChartDataPoint.fromJson(item);
        } else if (item is LineChartDataPoint) {
          return item;
        }
        return LineChartDataPoint(label: '', value: 0);
      }).toList();

      _chartSeries = [LineChartSeries(name: '데이터', data: dataPoints)];
    } else if (widget.data is Map<String, dynamic>) {
      // 단일 시리즈 데이터 (JSON 형식)
      _chartSeries = [LineChartSeries.fromJson(widget.data)];
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
        _chartSeries[i] = LineChartSeries(
          name: _chartSeries[i].name,
          data: _chartSeries[i].data,
          color: colors[i % colors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '시간별 변화';

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
              widget.legendPosition == LegendPosition.top) ...[
            _buildLegend(),
            const SizedBox(height: 20),
          ],

          // 차트
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LineChartPainter(
                    data: _chartSeries
                        .expand((series) => series.data)
                        .map((point) => point.toJson())
                        .toList(),
                    animation: _animation.value,
                  ),
                  size: Size.infinite,
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
  Widget _buildLegendItem(LineChartSeries series) {
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

/// 라인 차트 페인터
class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animation;

  _LineChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 최적화된 여백 설정 (왼쪽 여백 60 → 40으로 줄임)
    const double leftMargin = 40;
    const double rightMargin = 20;
    const double topMargin = 20;
    const double bottomMargin = 40;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;

    // 데이터에서 최대/최소값 계산
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    for (var point in data) {
      final value = (point['value'] as num).toDouble();
      minValue = math.min(minValue, value);
      maxValue = math.max(maxValue, value);
    }

    // 값 범위가 0이면 기본값 설정
    if (minValue == maxValue) {
      minValue = maxValue - 1;
      maxValue = maxValue + 1;
    }

    final valueRange = maxValue - minValue;

    // 격자 그리기
    _drawGrid(
      canvas,
      size,
      leftMargin,
      rightMargin,
      topMargin,
      bottomMargin,
      chartWidth,
      chartHeight,
      minValue,
      maxValue,
      valueRange,
    );

    // 축 레이블 그리기
    _drawAxisLabels(
      canvas,
      leftMargin,
      topMargin,
      bottomMargin,
      chartWidth,
      chartHeight,
      minValue,
      maxValue,
      valueRange,
    );

    // 라인 그리기
    if (data.length > 1) {
      final path = Path();
      final paint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < data.length; i++) {
        final point = data[i];
        final value = (point['value'] as num).toDouble();

        final x = leftMargin + (i / (data.length - 1)) * chartWidth;
        final y =
            topMargin +
            chartHeight -
            ((value - minValue) / valueRange) * chartHeight;

        // 애니메이션 적용
        final animatedY =
            topMargin +
            chartHeight -
            ((value - minValue) / valueRange) * chartHeight * animation;

        if (i == 0) {
          path.moveTo(x, animatedY);
        } else {
          path.lineTo(x, animatedY);
        }
      }

      canvas.drawPath(path, paint);

      // 데이터 포인트 그리기
      for (int i = 0; i < data.length; i++) {
        final point = data[i];
        final value = (point['value'] as num).toDouble();

        final x = leftMargin + (i / (data.length - 1)) * chartWidth;
        final animatedY =
            topMargin +
            chartHeight -
            ((value - minValue) / valueRange) * chartHeight * animation;

        final pointPaint = Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, animatedY), 3, pointPaint);

        // 포인트 테두리
        final borderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(Offset(x, animatedY), 3, borderPaint);
      }
    }
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double leftMargin,
    double rightMargin,
    double topMargin,
    double bottomMargin,
    double chartWidth,
    double chartHeight,
    double minValue,
    double maxValue,
    double valueRange,
  ) {
    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // 수평 격자선 (Y축)
    for (int i = 0; i <= 4; i++) {
      final y = topMargin + (i / 4) * chartHeight;
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + chartWidth, y),
        gridPaint,
      );
    }

    // 수직 격자선 (X축)
    final xSteps = math.min(data.length - 1, 6);
    for (int i = 0; i <= xSteps; i++) {
      final x = leftMargin + (i / xSteps) * chartWidth;
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + chartHeight),
        gridPaint,
      );
    }
  }

  void _drawAxisLabels(
    Canvas canvas,
    double leftMargin,
    double topMargin,
    double bottomMargin,
    double chartWidth,
    double chartHeight,
    double minValue,
    double maxValue,
    double valueRange,
  ) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    // Y축 레이블 (5개 레벨)
    for (int i = 0; i <= 4; i++) {
      final value = maxValue - (i / 4) * valueRange;
      final y = topMargin + (i / 4) * chartHeight;

      textPainter.text = TextSpan(
        text: value.toStringAsFixed(0),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.secondaryText,
          fontSize: 11,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(leftMargin - 8 - textPainter.width, y - textPainter.height / 2),
      );
    }

    // X축 레이블 (인덱스 기반)
    final xSteps = math.min(data.length - 1, 6);
    for (int i = 0; i <= xSteps; i++) {
      final dataIndex = ((i / xSteps) * (data.length - 1)).round();
      final x = leftMargin + (i / xSteps) * chartWidth;

      textPainter.text = TextSpan(
        text: (dataIndex + 1).toString(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.secondaryText,
          fontSize: 11,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, topMargin + chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
