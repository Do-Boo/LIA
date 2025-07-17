// File: lib/presentation/widgets/specific/charts/donut_chart.dart

import 'package:flutter/material.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 도넛 차트 데이터 모델
class DonutChartData {
  final String label;
  final double value;
  final Color? color;

  DonutChartData({required this.label, required this.value, this.color});

  factory DonutChartData.fromJson(Map<String, dynamic> json) {
    return DonutChartData(
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

/// 도넛 차트 위젯
class DonutChart extends StatefulWidget {
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

  const DonutChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.size = 200,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<DonutChartData> _chartData = [];

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
        DonutChartData(label: '긍정적', value: 65),
        DonutChartData(label: '중립적', value: 25),
        DonutChartData(label: '부정적', value: 10),
      ];
    } else if (widget.data is List) {
      _chartData = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return DonutChartData.fromJson(item);
        } else if (item is DonutChartData) {
          return item;
        }
        return DonutChartData(label: '', value: 0);
      }).toList();
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
        _chartData[i] = DonutChartData(
          label: _chartData[i].label,
          value: _chartData[i].value,
          color: colors[i % colors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '감정 분석 결과';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
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
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DonutChartPainter(
                    data: _chartData,
                    animation: _animation.value,
                  ),
                  size: Size(widget.size, widget.size),
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
  Widget _buildLegendItem(DonutChartData data) {
    final total = _chartData.fold(0.0, (sum, item) => sum + item.value);
    final percentage = total > 0 ? (data.value / total * 100).round() : 0;

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
          '${data.label} ($percentage%)',
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 도넛 차트 페인터
class _DonutChartPainter extends CustomPainter {
  final List<DonutChartData> data;
  final double animation;

  _DonutChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.6;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;

    final total = data.fold(0.0, (sum, item) => sum + item.value);
    if (total == 0) return;

    double currentAngle = -90 * (3.14159 / 180); // 시작 각도 (위쪽)

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * 3.14159 * animation;

      paint.color = item.color ?? AppColors.primary;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - (radius - innerRadius) / 2,
        ),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
