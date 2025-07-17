// File: lib/presentation/widgets/specific/charts/bar_chart.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 바 차트 데이터 모델
class BarChartData {
  final String label;
  final double value;
  final Color? color;

  BarChartData({required this.label, required this.value, this.color});

  factory BarChartData.fromJson(Map<String, dynamic> json) {
    return BarChartData(
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

/// 범례 위치 열거형
enum LegendPosition {
  top, // 상단
  bottom, // 하단
}

/// 대화 주제 분포를 막대 차트로 표시하는 위젯
///
/// 통일된 차트 인터페이스를 지원하며, 다음 기능들을 제공합니다:
/// - JSON 데이터 형식 지원
/// - 제목 및 아이콘 표시
/// - 범례 표시 여부 및 위치 선택
/// - 기본 데이터 제공
/// - 애니메이션 효과
class BarChart extends StatefulWidget {
  /// 차트 제목 (선택사항)
  final String? title;

  /// 차트 제목 아이콘 (선택사항)
  final IconData? titleIcon;

  /// 차트 데이터 (JSON 형식 또는 BarChartData 리스트)
  final dynamic data;

  /// 범례 표시 여부
  final bool showLegend;

  /// 범례 위치
  final LegendPosition legendPosition;

  /// 차트 높이
  final double height;

  const BarChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottom,
    this.height = 200,
  });

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<BarChartData> _chartData = [];

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
        BarChartData(label: '카페 데이트', value: 85),
        BarChartData(label: '취미 공유', value: 72),
        BarChartData(label: '일상 대화', value: 68),
        BarChartData(label: '음식 이야기', value: 55),
        BarChartData(label: '영화/드라마', value: 42),
      ];
    } else if (widget.data is List) {
      // JSON 리스트 형식
      _chartData = (widget.data as List).map((item) {
        if (item is Map<String, dynamic>) {
          return BarChartData.fromJson(item);
        } else if (item is BarChartData) {
          return item;
        }
        return BarChartData(label: '', value: 0);
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
        _chartData[i] = BarChartData(
          label: _chartData[i].label,
          value: _chartData[i].value,
          color: colors[i % colors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (widget.title != null) ...[
            _buildTitle(),
            const SizedBox(height: 16),
          ],

          // 상단 범례
          if (widget.showLegend &&
              widget.legendPosition == LegendPosition.top) ...[
            _buildLegend(),
            const SizedBox(height: 16),
          ],

          // 차트
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BarChartPainter(
                    data: _chartData,
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
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  /// 제목 위젯 생성
  Widget _buildTitle() {
    return Row(
      children: [
        if (widget.titleIcon != null) ...[
          Icon(widget.titleIcon!, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Text(widget.title!, style: AppTextStyles.chartTitle),
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
  Widget _buildLegendItem(BarChartData data) {
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
          data.label,
          style: AppTextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

/// 바 차트 페인터
class _BarChartPainter extends CustomPainter {
  final List<BarChartData> data;
  final double animation;

  _BarChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // 최대값 계산
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return;

    // 라벨 공간을 위한 패딩
    const leftPadding = 80.0;
    const rightPadding = 40.0;
    final chartWidth = size.width - leftPadding - rightPadding;

    // 가로 바 차트 그리기
    final barHeight = size.height / data.length * 0.6;
    final barSpacing = size.height / data.length * 0.4;

    for (int i = 0; i < data.length; i++) {
      final barData = data[i];
      final barWidth = (barData.value / maxValue) * chartWidth * animation;

      final x = leftPadding;
      final y = i * (barHeight + barSpacing) + barSpacing / 2;

      // 바 그리기
      paint.color = barData.color ?? AppColors.primary;
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(barRect, paint);

      // 값 표시 (바 끝에)
      final textPainter = TextPainter(
        text: TextSpan(
          text: barData.value.toInt().toString(),
          style: const TextStyle(
            color: AppColors.charcoal,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textX = x + barWidth + 4;
      final textY = y + (barHeight - textPainter.height) / 2;

      if (textX + textPainter.width <= size.width - rightPadding) {
        textPainter.paint(canvas, Offset(textX, textY));
      }

      // 라벨 표시 (왼쪽에)
      final labelPainter = TextPainter(
        text: TextSpan(
          text: barData.label,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();

      final labelX = leftPadding - labelPainter.width - 8;
      final labelY = y + (barHeight - labelPainter.height) / 2;

      if (labelX >= 0) {
        labelPainter.paint(canvas, Offset(labelX, labelY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
