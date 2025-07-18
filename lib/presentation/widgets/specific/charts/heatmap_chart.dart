// File: lib/presentation/widgets/specific/charts/heatmap_chart.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 히트맵 차트 위젯
class HeatmapChart extends StatefulWidget {
  /// 차트 제목 (선택사항)
  final String? title;

  /// 차트 제목 아이콘 (선택사항)
  final IconData? titleIcon;

  /// 히트맵 데이터 (JSON 형식 지원)
  final dynamic data;

  /// 범례 표시 여부
  final bool showLegend;

  /// 범례 위치
  final LegendPosition legendPosition;

  /// 차트 높이
  final double height;

  const HeatmapChart({
    super.key,
    this.title,
    this.titleIcon,
    required this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.height = 300,
  });

  @override
  State<HeatmapChart> createState() => _HeatmapChartState();
}

class _HeatmapChartState extends State<HeatmapChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // LIA 컨셉에 맞는 핑크 기반 색상 그라데이션
  final List<Color> _heatmapColors = [
    const Color(0xFFF5F5F5), // 매우 연한 회색 - 데이터 없음
    const Color(0xFFFFE8F0), // 매우 연한 핑크 - 매우 낮은 활동
    const Color(0xFFFFD1E0), // 연한 핑크 - 낮은 활동
    const Color(0xFFFFB3D0), // 중간 핑크 - 중간 활동
    const Color(0xFFFF85B8), // 진한 핑크 - 높은 활동
    AppColors.primary, // LIA 메인 핑크 (#FF70A6) - 매우 높은 활동
  ];

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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _parseData() {
    if (widget.data is List) {
      return (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else {
          // HeatmapData 객체인 경우
          return {
            'row': item.x ?? 0,
            'col': item.y ?? 0,
            'value': item.value ?? 0.0,
          };
        }
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? '활동 히트맵';

    return SizedBox(
      height: widget.height,
      child: Container(
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
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _HeatmapChartPainter(
                      data: _parseData(),
                      animation: _animation.value,
                      colors: _heatmapColors,
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
      ),
    );
  }

  /// 제목 위젯 생성
  Widget _buildTitle(String title) {
    return Row(
      children: [
        if (widget.titleIcon != null) ...[
          HugeIcon(icon: widget.titleIcon!, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Text(title, style: AppTextStyles.chartTitle),
      ],
    );
  }

  /// 범례 위젯 생성 (실제 사용되는 색상과 일치)
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
      children: [
        Text(
          '적음',
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(width: 8),
        // 첫 번째 색상(회색)은 제외하고 핑크 그라데이션만 표시
        ..._heatmapColors
            .skip(1)
            .map(
              (color) => Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.white, width: 0.5),
                ),
              ),
            ),
        const SizedBox(width: 8),
        Text(
          '많음',
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 히트맵 차트 페인터
class _HeatmapChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double animation;
  final List<Color> colors;

  _HeatmapChartPainter({
    required this.data,
    required this.animation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 축 레이블을 위한 여백 설정 - 왼쪽 여백을 늘려서 요일 레이블 공간 확보
    const double leftMargin = 40; // 30 → 40으로 증가
    const double rightMargin = 10;
    const double topMargin = 5;
    const double bottomMargin = 20;

    final double chartWidth = size.width - leftMargin - rightMargin;
    final double chartHeight = size.height - topMargin - bottomMargin;

    // 데이터에서 최대 행과 열 계산
    int maxRows = 0;
    int maxCols = 0;
    double maxValue = 0;

    for (var item in data) {
      final row = item['row'] as int;
      final col = item['col'] as int;
      final value = (item['value'] as num).toDouble();

      maxRows = math.max(maxRows, row + 1);
      maxCols = math.max(maxCols, col + 1);
      maxValue = math.max(maxValue, value);
    }

    // 최소 셀 크기 설정하되 부모 위젯을 초과하지 않도록 제한
    const double minCellSize = 10.0; // 12 → 10으로 줄여서 작은 화면에서도 표시 가능
    const double maxCellSize = 20.0; // 최대 셀 크기 제한 추가

    // 셀 크기 계산 - 최소/최대 크기 제한
    final double cellSize = math.max(
      minCellSize,
      math.min(
        maxCellSize,
        math.min(chartWidth / maxCols, chartHeight / maxRows),
      ),
    );

    // 실제 차트 크기 계산
    final double actualChartWidth = cellSize * maxCols;
    final double actualChartHeight = cellSize * maxRows;

    // 중앙 정렬을 위한 오프셋 계산
    final double offsetX = leftMargin + (chartWidth - actualChartWidth) / 2;
    final double offsetY = topMargin + (chartHeight - actualChartHeight) / 2;

    // Y축 레이블 그리기 (요일) - 먼저 그리기
    _drawYAxisLabels(canvas, offsetY, cellSize, maxRows);

    // X축 레이블 그리기 (시간)
    _drawXAxisLabels(
      canvas,
      offsetX,
      offsetY + actualChartHeight, // cellSize * maxRows 대신 actualChartHeight 사용
      cellSize,
      maxCols,
    );

    // 각 셀 그리기
    for (var item in data) {
      final row = item['row'] as int;
      final col = item['col'] as int;
      final value = (item['value'] as num).toDouble();

      // 값에 따른 색상 인덱스 계산 (0-5)
      final colorIndex = maxValue > 0
          ? ((value / maxValue) * (colors.length - 1)).round().clamp(
              0,
              colors.length - 1,
            )
          : 0;

      final color = colors[colorIndex];

      final paint = Paint()
        ..color = color.withOpacity(animation)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        offsetX + (col * cellSize),
        offsetY + (row * cellSize),
        cellSize,
        cellSize,
      );

      // 셀 그리기 (둥근 모서리)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(1),
        ), // 2 → 1로 줄여서 더 각진 모양
        paint,
      );

      // 셀 테두리 그리기
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(animation)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5; // 1 → 0.5로 줄여서 더 얇은 테두리

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(1),
        ), // 2 → 1로 줄여서 더 각진 모양
        borderPaint,
      );
    }
  }

  void _drawYAxisLabels(
    Canvas canvas,
    double offsetY,
    double cellSize,
    int maxRows,
  ) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (int i = 0; i < math.min(maxRows, days.length); i++) {
      final y = offsetY + (i * cellSize) + (cellSize / 2);

      textPainter.text = TextSpan(
        text: days[i],
        style: AppTextStyles.caption.copyWith(
          color: AppColors.secondaryText,
          fontSize: 12,
        ),
      );
      textPainter.layout();

      // 레이블 위치를 왼쪽 여백 증가에 맞춰 조정
      textPainter.paint(
        canvas,
        Offset(
          38 - textPainter.width,
          y - textPainter.height / 2,
        ), // 28 → 38로 조정
      );
    }
  }

  void _drawXAxisLabels(
    Canvas canvas,
    double offsetX,
    double baselineY,
    double cellSize,
    int maxCols,
  ) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // 4시간 간격으로 레이블 표시 (0, 4, 8, 12, 16, 20)
    for (int i = 0; i < maxCols; i += 4) {
      if (i < maxCols) {
        final x = offsetX + (i * cellSize) + (cellSize / 2);

        textPainter.text = TextSpan(
          text: '${i}h', // '시' 대신 'h'로 간소화
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondaryText,
            fontSize: 10,
          ),
        );
        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, baselineY + 3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
