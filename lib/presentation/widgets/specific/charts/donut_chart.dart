// File: lib/presentation/widgets/specific/charts/donut_chart.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';
import 'chart_common.dart';

/// 도넛 차트 데이터 모델
class DonutChartData {
  DonutChartData({required this.label, required this.value, this.color});

  factory DonutChartData.fromJson(Map<String, dynamic> json) => DonutChartData(
    label: json['label'] ?? '',
    value: (json['value'] ?? 0).toDouble(),
    color: json['color'] != null ? Color(json['color']) : null,
  );
  final String label;
  final double value;
  final Color? color;

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    if (color != null) 'color': color!.value,
  };
}

/// 도넛 차트 위젯
class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.size = 200,
  });

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

  List<DonutChartData> _parseAndColorData() {
    List<DonutChartData> chartData;
    if (data == null) {
      // 기본 데이터
      chartData = [
        DonutChartData(label: '긍정적', value: 65),
        DonutChartData(label: '중립적', value: 25),
        DonutChartData(label: '부정적', value: 10),
      ];
    } else if (data is List) {
      chartData = (data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return DonutChartData.fromJson(item);
        } else if (item is DonutChartData) {
          return item;
        }
        return DonutChartData(label: '', value: 0);
      }).toList();
    } else {
      chartData = [];
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

    for (int i = 0; i < chartData.length; i++) {
      if (chartData[i].color == null) {
        chartData[i] = DonutChartData(
          label: chartData[i].label,
          value: chartData[i].value,
          color: colors[i % colors.length],
        );
      }
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _parseAndColorData();
    final displayTitle = title ?? '감정 분석 결과';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 제목 표시
          _buildTitle(displayTitle),
          const SizedBox(height: 20),

          // 상단 범례
          if (showLegend &&
              (legendPosition == LegendPosition.topLeft ||
                  legendPosition == LegendPosition.topCenter ||
                  legendPosition == LegendPosition.topRight)) ...[
            _buildLegend(chartData),
            const SizedBox(height: 20),
          ],

          // 차트
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            builder: (context, animationValue, child) => SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  data: chartData,
                  animation: animationValue,
                ),
                size: Size(size, size),
              ),
            ),
          ),

          // 하단 범례
          if (showLegend &&
              (legendPosition == LegendPosition.bottomLeft ||
                  legendPosition == LegendPosition.bottomCenter ||
                  legendPosition == LegendPosition.bottomRight)) ...[
            const SizedBox(height: 20),
            _buildLegend(chartData),
          ],
        ],
      ),
    );
  }

  /// 제목 위젯 생성
  Widget _buildTitle(String title) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (titleIcon != null) ...[
        Icon(titleIcon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
      ],
      Text(title, style: AppTextStyles.chartTitle),
    ],
  );

  /// 범례 위젯 생성
  Widget _buildLegend(List<DonutChartData> chartData) {
    WrapAlignment alignment;
    switch (legendPosition) {
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
      children: chartData
          .map((data) => _buildLegendItem(data, chartData))
          .toList(),
    );
  }

  /// 범례 아이템 생성
  Widget _buildLegendItem(DonutChartData data, List<DonutChartData> allData) {
    final total = allData.fold(0.0, (sum, item) => sum + item.value);
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
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// 도넛 차트 페인터
class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({required this.data, required this.animation});
  final List<DonutChartData> data;
  final double animation;

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

    double currentAngle = -pi / 2; // 시작 각도 (위쪽)

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * pi * animation;

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
