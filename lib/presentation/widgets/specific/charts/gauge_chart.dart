// File: lib/presentation/widgets/specific/charts/gauge_chart.dart

import 'package:flutter/material.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 게이지 차트 데이터 모델
class GaugeChartData {
  final String label;
  final double value;
  final Color? color;

  GaugeChartData({required this.label, required this.value, this.color});

  factory GaugeChartData.fromJson(Map<String, dynamic> json) {
    return GaugeChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      if (color != null) 'color': color!.value,
    };
  }
}

/// 게이지 차트 위젯
class GaugeChart extends StatefulWidget {
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

  const GaugeChart({
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
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<GaugeChartData> _chartData = [];

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
      _chartData = [GaugeChartData(label: '진행률', value: 75)];
    } else if (widget.data is List) {
      _chartData = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return GaugeChartData.fromJson(item);
        } else if (item is GaugeChartData) {
          return item;
        }
        return GaugeChartData(label: '', value: 0);
      }).toList();
    } else if (widget.data is Map<String, dynamic>) {
      _chartData = [GaugeChartData.fromJson(widget.data)];
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
      if (_chartData[i].color == null) {
        _chartData[i] = GaugeChartData(
          label: _chartData[i].label,
          value: _chartData[i].value,
          color: colors[i % colors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '진행률';
    final mainData = _chartData.isNotEmpty
        ? _chartData.first
        : GaugeChartData(label: '진행률', value: 0);

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
            height: widget.size,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _GaugeChartPainter(
                        data: mainData,
                        animation: _animation.value,
                        maxValue: widget.maxValue,
                      ),
                      size: Size(widget.size, widget.size),
                    );
                  },
                ),
                // 중앙 값 표시
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${mainData.value.toInt()}',
                        style: AppTextStyles.h1.copyWith(
                          color: mainData.color ?? AppColors.primary,
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
  Widget _buildLegendItem(GaugeChartData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: data.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${data.label}: ${data.value.toInt()}%',
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 게이지 차트 페인터
class _GaugeChartPainter extends CustomPainter {
  final GaugeChartData data;
  final double animation;
  final double maxValue;

  _GaugeChartPainter({
    required this.data,
    required this.animation,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 배경 호
    final backgroundPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 * 0.75, // 시작 각도
      3.14159 * 1.5, // 270도 호
      false,
      backgroundPaint,
    );

    // 진행률 호
    final progressPaint = Paint()
      ..color = data.color ?? AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (data.value / maxValue) * 3.14159 * 1.5 * animation;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 * 0.75, // 시작 각도
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
