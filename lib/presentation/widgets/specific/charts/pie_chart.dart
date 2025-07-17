// File: lib/presentation/widgets/specific/charts/pie_chart.dart

import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 파이 차트 데이터 모델
class PieChartData {
  final String label;
  final double value;
  final Color color;
  final String description;

  const PieChartData({
    required this.label,
    required this.value,
    required this.color,
    required this.description,
  });

  /// JSON으로부터 데이터 생성
  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: Color(json['color'] ?? 0xFF6C5CE7),
      description: json['description'] ?? '',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'color': color.value,
      'description': description,
    };
  }
}

/// 범례 위치 열거형
enum LegendPosition {
  top, // 상단
  bottom, // 하단
}

/// 파이 차트 위젯
class PieChart extends StatefulWidget {
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

  const PieChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottom,
    this.size = 200,
  });

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<PieChartData> _chartData = [];
  int? _selectedIndex;

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
        PieChartData(
          label: '긍정적',
          value: 65,
          color: AppColors.primary,
          description: '긍정적인 반응',
        ),
        PieChartData(
          label: '중립적',
          value: 25,
          color: AppColors.accent,
          description: '중립적인 반응',
        ),
        PieChartData(
          label: '부정적',
          value: 10,
          color: AppColors.blue,
          description: '부정적인 반응',
        ),
      ];
    } else if (widget.data is List) {
      _chartData = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return PieChartData.fromJson(item);
        } else if (item is PieChartData) {
          return item;
        }
        return PieChartData(
          label: '',
          value: 0,
          color: AppColors.primary,
          description: '',
        );
      }).toList();
    } else {
      _chartData = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '감정 분석 결과';

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
            child: GestureDetector(
              onTapDown: _handleTapDown,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _PieChartPainter(
                      data: _chartData,
                      animation: _animation.value,
                      selectedIndex: _selectedIndex,
                    ),
                    size: Size(widget.size, widget.size),
                  );
                },
              ),
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
      children: _chartData.map((data) => _buildLegendItem(data)).toList(),
    );
  }

  /// 범례 아이템 생성
  Widget _buildLegendItem(PieChartData data) {
    final total = _chartData.fold(0.0, (sum, item) => sum + item.value);
    final percentage = total > 0 ? (data.value / total * 100).round() : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: data.color,
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

  /// 터치 이벤트 처리
  void _handleTapDown(TapDownDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final tapPosition = details.localPosition;
    final distance = (tapPosition - center).distance;

    if (distance > widget.size / 2) return;

    final angle = (tapPosition - center).direction;
    final total = _chartData.fold(0.0, (sum, item) => sum + item.value);

    double currentAngle = -pi / 2; // 시작 각도 (위쪽)

    for (int i = 0; i < _chartData.length; i++) {
      final sweepAngle = (_chartData[i].value / total) * 2 * pi;

      if (angle >= currentAngle && angle <= currentAngle + sweepAngle) {
        setState(() {
          _selectedIndex = _selectedIndex == i ? null : i;
        });
        return;
      }

      currentAngle += sweepAngle;
    }
  }
}

/// 파이 차트 페인터
class _PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final double animation;
  final int? selectedIndex;

  _PieChartPainter({
    required this.data,
    required this.animation,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    final total = data.fold(0.0, (sum, item) => sum + item.value);
    if (total == 0) return;

    double currentAngle = -pi / 2; // 시작 각도 (위쪽)

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * pi * animation;

      paint.color = item.color;

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
