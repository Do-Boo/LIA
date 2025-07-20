// File: lib/presentation/widgets/specific/charts/pie_chart.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../base/base_chart.dart';

/// 파이 차트 데이터 모델 (호환성을 위해 유지)
///
/// @deprecated StandardChartData를 사용하세요
@Deprecated('Use StandardChartData instead')
class PieChartData {
  const PieChartData({
    required this.label,
    required this.value,
    required this.color,
    required this.description,
  });

  /// JSON으로부터 데이터 생성
  factory PieChartData.fromJson(Map<String, dynamic> json) => PieChartData(
    label: json['label'] ?? '',
    value: (json['value'] ?? 0).toDouble(),
    color: Color(json['color'] ?? 0xFF6C5CE7),
    description: json['description'] ?? '',
  );
  final String label;
  final double value;
  final Color color;
  final String description;

  /// JSON으로 변환
  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    'color': color.value,
    'description': description,
  };

  /// StandardChartData로 변환
  StandardChartData toStandardChartData() => StandardChartData(
    label: label,
    value: value,
    color: color,
    metadata: {'description': description},
  );
}

/// 파이 차트 위젯
///
/// BaseChart를 상속받아 표준화된 차트 인터페이스를 제공합니다.
class PieChart extends BaseChart {
  const PieChart({
    super.key,
    super.title,
    super.titleIcon,
    super.data,
    super.showLegend,
    super.legendPosition,
    this.size = 200,
    super.enableAnimation,
    super.animationDuration,
    super.animationCurve,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
  }) : super(height: size);

  /// 차트 크기 (높이 대신 크기 사용)
  final double size; // size를 height로 전달

  @override
  Widget buildChart(
    BuildContext context,
    List<StandardChartData> chartData,
    Animation<double> animation,
  ) => _PieChartWidget(data: chartData, animation: animation.value, size: size);

  @override
  List<StandardChartData> getDefaultData() => [
    const StandardChartData(
      label: '긍정적',
      value: 65,
      color: AppColors.primary,
      metadata: {'description': '긍정적인 감정 표현'},
    ),
    const StandardChartData(
      label: '중립적',
      value: 25,
      color: AppColors.accent,
      metadata: {'description': '중립적인 감정 표현'},
    ),
    const StandardChartData(
      label: '부정적',
      value: 10,
      color: AppColors.blue,
      metadata: {'description': '부정적인 감정 표현'},
    ),
  ];

  @override
  List<StandardChartData> parseData(dynamic rawData) {
    if (rawData == null) return getDefaultData();

    if (rawData is List<StandardChartData>) {
      return rawData;
    }

    if (rawData is List<PieChartData>) {
      // 기존 PieChartData 지원 (호환성)
      return rawData.map((item) => item.toStandardChartData()).toList();
    }

    if (rawData is List) {
      return rawData.map((item) {
        if (item is StandardChartData) return item;
        if (item is PieChartData) return item.toStandardChartData();
        if (item is Map<String, dynamic>)
          return StandardChartData.fromJson(item);
        return StandardChartData(label: item.toString(), value: 0);
      }).toList();
    }

    return getDefaultData();
  }
}

/// 파이 차트 내부 위젯 (StatefulWidget으로 상호작용 지원)
class _PieChartWidget extends StatefulWidget {
  const _PieChartWidget({
    required this.data,
    required this.animation,
    required this.size,
  });
  final List<StandardChartData> data;
  final double animation;
  final double size;

  @override
  State<_PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<_PieChartWidget> {
  int? _selectedIndex;

  void _onTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final tapPosition = renderBox.globalToLocal(details.globalPosition);
    final center = Offset(widget.size / 2, widget.size / 2);
    final distance = (tapPosition - center).distance;
    final radius = widget.size / 2 - 20;

    if (distance <= radius) {
      final angle = (tapPosition - center).direction;
      double totalValue = 0;
      for (final item in widget.data) {
        totalValue += item.value;
      }

      double currentAngle = -pi / 2; // 시작 각도 (위쪽)
      for (int i = 0; i < widget.data.length; i++) {
        final sweepAngle = (widget.data[i].value / totalValue) * 2 * pi;
        if (angle >= currentAngle && angle <= currentAngle + sweepAngle) {
          setState(() {
            _selectedIndex = _selectedIndex == i ? null : i;
          });
          break;
        }
        currentAngle += sweepAngle;
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapUp: _onTap,
    child: CustomPaint(
      painter: _PieChartPainter(
        data: widget.data,
        animation: widget.animation,
        selectedIndex: _selectedIndex,
      ),
      size: Size(widget.size, widget.size),
    ),
  );
}

/// 파이 차트 페인터
class _PieChartPainter extends CustomPainter {
  const _PieChartPainter({
    required this.data,
    required this.animation,
    this.selectedIndex,
  });

  final List<StandardChartData> data;
  final double animation;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    double totalValue = 0;
    for (final item in data) {
      totalValue += item.value;
    }
    if (totalValue == 0) return;

    double currentAngle = -pi / 2; // 시작 각도 (위쪽)

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / totalValue) * 2 * pi * animation;

      paint.color = item.color ?? AppColors.primary;

      // 선택된 섹션은 약간 바깥쪽으로 이동
      final sectionCenter = center;
      final sectionRadius = selectedIndex == i ? radius * 1.1 : radius;

      if (selectedIndex == i) {
        final offsetDistance = radius * 0.1;
        final offsetAngle = currentAngle + sweepAngle / 2;
        final offsetX = offsetDistance * cos(offsetAngle);
        final offsetY = offsetDistance * sin(offsetAngle);
        final adjustedCenter = Offset(center.dx + offsetX, center.dy + offsetY);

        canvas.drawArc(
          Rect.fromCircle(center: adjustedCenter, radius: sectionRadius),
          currentAngle,
          sweepAngle,
          true,
          paint,
        );
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: sectionCenter, radius: sectionRadius),
          currentAngle,
          sweepAngle,
          true,
          paint,
        );
      }

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
