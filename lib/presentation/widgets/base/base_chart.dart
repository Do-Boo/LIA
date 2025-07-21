// File: lib/presentation/widgets/base/base_chart.dart

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../specific/charts/chart_common.dart';

/// 표준 차트 데이터 모델
///
/// 모든 차트 위젯이 공통으로 사용할 데이터 형식입니다.
class StandardChartData {
  const StandardChartData({
    required this.label,
    required this.value,
    this.color,
    this.metadata,
  });

  factory StandardChartData.fromJson(Map<String, dynamic> json) =>
      StandardChartData(
        label: json['label'] ?? '',
        value: (json['value'] ?? 0).toDouble(),
        color: json['color'] != null ? Color(json['color']) : null,
        metadata: json['metadata'],
      );
  final String label;
  final double value;
  final Color? color;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    if (color != null) 'color': color!.value,
    if (metadata != null) ...metadata!,
  };

  StandardChartData copyWith({
    String? label,
    double? value,
    Color? color,
    Map<String, dynamic>? metadata,
  }) => StandardChartData(
    label: label ?? this.label,
    value: value ?? this.value,
    color: color ?? this.color,
    metadata: metadata ?? this.metadata,
  );
}

/// 모든 차트 위젯이 상속받는 추상 베이스 클래스
///
/// 공통 기능:
/// - 제목 및 아이콘 표시
/// - 범례 표시 및 위치 제어
/// - 애니메이션 효과
/// - 표준 데이터 형식 지원
/// - 일관된 스타일링
abstract class BaseChart extends StatefulWidget {
  const BaseChart({
    super.key,
    this.title,
    this.titleIcon,
    this.data,
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.height = 200,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  /// 차트 제목
  final String? title;

  /// 차트 제목 아이콘
  final IconData? titleIcon;

  /// 차트 데이터 (표준 형식 또는 JSON)
  final dynamic data;

  /// 범례 표시 여부
  final bool showLegend;

  /// 범례 위치
  final LegendPosition legendPosition;

  /// 차트 높이
  final double height;

  /// 애니메이션 활성화 여부
  final bool enableAnimation;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  /// 애니메이션 곡선
  final Curve animationCurve;

  /// 스타일 설정
  final EdgeInsets padding;
  final Color? backgroundColor;
  final BorderRadius borderRadius;

  /// 차트별 고유 렌더링 로직 (하위 클래스에서 구현 필수)
  Widget buildChart(
    BuildContext context,
    List<StandardChartData> chartData,
    Animation<double> animation,
  );

  /// 기본 차트 데이터 (하위 클래스에서 구현 필수)
  List<StandardChartData> getDefaultData();

  /// 데이터를 StandardChartData로 변환 (하위 클래스에서 오버라이드 가능)
  List<StandardChartData> parseData(dynamic rawData) {
    if (rawData == null) return getDefaultData();

    if (rawData is List<StandardChartData>) {
      return rawData;
    }

    if (rawData is List) {
      return rawData.map((item) {
        if (item is StandardChartData) return item;
        if (item is Map<String, dynamic>)
          return StandardChartData.fromJson(item);
        return StandardChartData(label: item.toString(), value: 0);
      }).toList();
    }

    return getDefaultData();
  }

  @override
  State<BaseChart> createState() => _BaseChartState();
}

class _BaseChartState extends State<BaseChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<StandardChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _parseData();
    if (widget.enableAnimation) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(BaseChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _parseData();
    }
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );
  }

  void _parseData() {
    _chartData = widget.parseData(widget.data);
    _assignColors();
  }

  void _assignColors() {
    final defaultColors = [
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
        _chartData[i] = _chartData[i].copyWith(
          color: defaultColors[i % defaultColors.length],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: widget.padding,
    decoration: BoxDecoration(
      color: widget.backgroundColor ?? AppColors.surface,
      borderRadius: widget.borderRadius,
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
        if (widget.showLegend && _isTopLegend()) ...[
          _buildLegend(),
          const SizedBox(height: 16),
        ],

        // 차트 본체
        SizedBox(
          height: widget.height,
          child: widget.enableAnimation
              ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) =>
                      widget.buildChart(context, _chartData, _animation),
                )
              : widget.buildChart(
                  context,
                  _chartData,
                  const AlwaysStoppedAnimation(1),
                ),
        ),

        // 하단 범례
        if (widget.showLegend && _isBottomLegend()) ...[
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ],
    ),
  );

  Widget _buildTitle() => Row(
    children: [
      if (widget.titleIcon != null) ...[
        Icon(widget.titleIcon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
      ],
      Text(
        widget.title!,
        style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
      ),
    ],
  );

  Widget _buildLegend() =>
      ChartLegend(data: _chartData, position: widget.legendPosition);

  bool _isTopLegend() => [
    LegendPosition.topLeft,
    LegendPosition.topCenter,
    LegendPosition.topRight,
  ].contains(widget.legendPosition);

  bool _isBottomLegend() => [
    LegendPosition.bottomLeft,
    LegendPosition.bottomCenter,
    LegendPosition.bottomRight,
  ].contains(widget.legendPosition);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// 차트 범례 위젯
class ChartLegend extends StatelessWidget {
  const ChartLegend({required this.data, required this.position, super.key});
  final List<StandardChartData> data;
  final LegendPosition position;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = [
      LegendPosition.topCenter,
      LegendPosition.bottomCenter,
    ].contains(position);

    final alignment = _getAlignment();

    if (isHorizontal) {
      return Row(mainAxisAlignment: alignment, children: _buildLegendItems());
    } else {
      return Column(
        crossAxisAlignment: _getCrossAxisAlignment(),
        children: _buildLegendItems(),
      );
    }
  }

  MainAxisAlignment _getAlignment() {
    switch (position) {
      case LegendPosition.topLeft:
      case LegendPosition.bottomLeft:
        return MainAxisAlignment.start;
      case LegendPosition.topCenter:
      case LegendPosition.bottomCenter:
        return MainAxisAlignment.center;
      case LegendPosition.topRight:
      case LegendPosition.bottomRight:
        return MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (position) {
      case LegendPosition.topLeft:
      case LegendPosition.bottomLeft:
        return CrossAxisAlignment.start;
      case LegendPosition.topCenter:
      case LegendPosition.bottomCenter:
        return CrossAxisAlignment.center;
      case LegendPosition.topRight:
      case LegendPosition.bottomRight:
        return CrossAxisAlignment.end;
    }
  }

  List<Widget> _buildLegendItems() => data.map(_buildLegendItem).toList();

  Widget _buildLegendItem(StandardChartData item) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(item.label, style: AppTextStyles.cardDescription),
      ],
    ),
  );
}
