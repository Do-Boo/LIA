// File: lib/presentation/widgets/specific/charts/bar_chart.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';
import '../../base/base_chart.dart';

/// 바 차트 데이터 모델 (호환성을 위해 유지)
///
/// @deprecated StandardChartData를 사용하세요
@Deprecated('Use StandardChartData instead')
class BarChartData {
  BarChartData({required this.label, required this.value, this.color});

  factory BarChartData.fromJson(Map<String, dynamic> json) => BarChartData(
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

  /// StandardChartData로 변환
  StandardChartData toStandardChartData() =>
      StandardChartData(label: label, value: value, color: color);
}

/// 대화 주제 분포를 막대 차트로 표시하는 위젯
///
/// BaseChart를 상속받아 표준화된 차트 인터페이스를 제공합니다:
/// - JSON 데이터 형식 지원
/// - 제목 및 아이콘 표시
/// - 범례 표시 여부 및 위치 선택
/// - 기본 데이터 제공
/// - 애니메이션 효과
class BarChart extends BaseChart {
  const BarChart({
    super.key,
    super.title,
    super.titleIcon,
    super.data,
    super.showLegend,
    super.legendPosition,
    super.height,
    super.enableAnimation,
    super.animationDuration,
    super.animationCurve,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
  });

  @override
  Widget buildChart(
    BuildContext context,
    List<StandardChartData> chartData,
    Animation<double> animation,
  ) => CustomPaint(
    painter: _BarChartPainter(data: chartData, animation: animation.value),
    size: Size.infinite,
  );

  @override
  List<StandardChartData> getDefaultData() => [
    const StandardChartData(label: '카페 데이트', value: 85),
    const StandardChartData(label: '취미 공유', value: 72),
    const StandardChartData(label: '일상 대화', value: 68),
    const StandardChartData(label: '음식 이야기', value: 55),
    const StandardChartData(label: '영화/드라마', value: 42),
  ];

  @override
  List<StandardChartData> parseData(dynamic rawData) {
    if (rawData == null) return getDefaultData();

    if (rawData is List<StandardChartData>) {
      return rawData;
    }

    if (rawData is List<BarChartData>) {
      // 기존 BarChartData 지원 (호환성)
      return rawData.map((item) => item.toStandardChartData()).toList();
    }

    if (rawData is List) {
      return rawData.map((item) {
        if (item is StandardChartData) return item;
        if (item is BarChartData) return item.toStandardChartData();
        if (item is Map<String, dynamic>)
          return StandardChartData.fromJson(item);
        return StandardChartData(label: item.toString(), value: 0);
      }).toList();
    }

    return getDefaultData();
  }
}

/// 바 차트 페인터
class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({required this.data, required this.animation});

  final List<StandardChartData> data;
  final double animation;

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
    const progressBarHeight = 20.0; // 진행바 높이

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
            color: AppColors.textSecondary,
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
            color: AppColors.textSecondary,
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
