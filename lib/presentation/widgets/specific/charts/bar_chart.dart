// File: lib/presentation/widgets/specific/charts/bar_chart.dart

import 'package:flutter/material.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';

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
    this.legendPosition = LegendPosition.bottomCenter,
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
              (widget.legendPosition == LegendPosition.topLeft ||
                  widget.legendPosition == LegendPosition.topCenter ||
                  widget.legendPosition == LegendPosition.topRight)) ...[
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
              (widget.legendPosition == LegendPosition.bottomLeft ||
                  widget.legendPosition == LegendPosition.bottomCenter ||
                  widget.legendPosition == LegendPosition.bottomRight)) ...[
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
      children: _chartData
          .map(
            (data) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildLegendItem(data),
            ),
          )
          .toList(),
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

    // 패딩 설정
    const topPadding = 20.0;
    const bottomPadding = 20.0;
    const leftPadding = 80.0; // 레이블 공간 확보
    const rightPadding = 60.0; // 퍼센트 공간 확보

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // 각 행의 높이 계산
    final rowHeight = chartHeight / data.length;
    final progressBarHeight = 20.0; // 진행바 높이

    for (int i = 0; i < data.length; i++) {
      final barData = data[i];
      final progressWidth = (barData.value / maxValue) * chartWidth * animation;

      // 각 행의 Y 위치
      final rowY = topPadding + i * rowHeight;

      // 진행바 Y 위치 (행 중앙에 배치)
      final progressY = rowY + (rowHeight - progressBarHeight) / 2;

      // 진행바 배경 (회색)
      final backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPadding, progressY, chartWidth, progressBarHeight),
        const Radius.circular(10),
      );
      paint.color = AppColors.lightGray;
      canvas.drawRRect(backgroundRect, paint);

      // 진행바 (컬러)
      if (progressWidth > 0) {
        final progressRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            leftPadding,
            progressY,
            progressWidth,
            progressBarHeight,
          ),
          const Radius.circular(10),
        );
        paint.color = barData.color ?? AppColors.primary;
        canvas.drawRRect(progressRect, paint);
      }

      // 라벨 (진행바 왼쪽, 같은 높이)
      final labelPainter = TextPainter(
        text: TextSpan(
          text: barData.label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondaryText,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();

      final labelX = leftPadding - labelPainter.width - 8;
      final labelY = progressY + (progressBarHeight - labelPainter.height) / 2;

      if (labelX >= 0) {
        labelPainter.paint(canvas, Offset(labelX, labelY));
      }

      // 퍼센트 (진행바 오른쪽, 같은 높이)
      final percentPainter = TextPainter(
        text: TextSpan(
          text: '${barData.value.toInt()}%',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondaryText,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      percentPainter.layout();

      final percentX = leftPadding + chartWidth + 8;
      final percentY =
          progressY + (progressBarHeight - percentPainter.height) / 2;

      if (percentX + percentPainter.width <= size.width) {
        percentPainter.paint(canvas, Offset(percentX, percentY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
