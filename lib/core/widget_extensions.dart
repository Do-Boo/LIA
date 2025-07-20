// File: lib/core/widget_extensions.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Widget을 확장하여 공통 스타일과 레이아웃 패턴을 제공하는 Extension Methods
///
/// 이 확장을 통해 반복되는 코드를 줄이고 일관된 UI 스타일을 적용할 수 있습니다.
///
/// 사용 예시:
/// ```dart
/// Text('내용').cardStyle()
/// MyWidget().responsive(tablet: TabletWidget())
/// ```
extension WidgetExtensions on Widget {
  /// 표준 카드 스타일을 적용합니다.
  ///
  /// [padding] 내부 여백 (기본값: 16px)
  /// [backgroundColor] 배경색 (기본값: AppColors.surface)
  /// [borderRadius] 모서리 둥글기 (기본값: 12px)
  /// [border] 테두리 (기본값: primary 색상 20% 투명도)
  /// [boxShadow] 그림자 효과
  Widget cardStyle({
    EdgeInsets? padding,
    Color? backgroundColor,
    double borderRadius = 12,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border:
          border ?? Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      boxShadow: boxShadow,
    ),
    child: this,
  );

  /// 반응형 레이아웃을 적용합니다.
  ///
  /// [mobile] 모바일용 위젯 (기본값: 현재 위젯)
  /// [tablet] 태블릿용 위젯
  /// [desktop] 데스크톱용 위젯
  /// [mobileBreakpoint] 모바일 브레이크포인트 (기본값: 768px)
  /// [desktopBreakpoint] 데스크톱 브레이크포인트 (기본값: 1200px)
  Widget responsive({
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
    double mobileBreakpoint = 768,
    double desktopBreakpoint = 1200,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= desktopBreakpoint && desktop != null) {
        return desktop;
      } else if (constraints.maxWidth >= mobileBreakpoint && tablet != null) {
        return tablet;
      }
      return mobile ?? this;
    },
  );

  /// 조건부로 위젯을 표시합니다.
  ///
  /// [condition] 표시 조건
  /// [fallback] 조건이 false일 때 표시할 위젯
  Widget showIf(bool condition, {Widget? fallback}) =>
      condition ? this : (fallback ?? const SizedBox.shrink());

  /// 위젯에 패딩을 적용합니다.
  ///
  /// [padding] 적용할 패딩
  Widget withPadding(EdgeInsets padding) =>
      Padding(padding: padding, child: this);

  /// 위젯에 마진을 적용합니다.
  ///
  /// [margin] 적용할 마진
  Widget withMargin(EdgeInsets margin) =>
      Container(margin: margin, child: this);

  /// 위젯을 중앙 정렬합니다.
  Widget centered() => Center(child: this);

  /// 위젯을 Expanded로 감쌉니다.
  ///
  /// [flex] flex 값 (기본값: 1)
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// 위젯을 Flexible로 감쌉니다.
  ///
  /// [flex] flex 값 (기본값: 1)
  /// [fit] FlexFit 타입 (기본값: FlexFit.loose)
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// 위젯에 제스처 인식을 추가합니다.
  ///
  /// [onTap] 탭 콜백
  /// [onLongPress] 롱 프레스 콜백
  /// [onDoubleTap] 더블 탭 콜백
  Widget onTap(
    VoidCallback? onTap, {
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
  }) => GestureDetector(
    onTap: onTap,
    onLongPress: onLongPress,
    onDoubleTap: onDoubleTap,
    child: this,
  );

  /// 위젯에 애니메이션 효과를 추가합니다.
  ///
  /// [duration] 애니메이션 지속 시간 (기본값: 300ms)
  /// [curve] 애니메이션 곡선 (기본값: Curves.easeInOut)
  Widget animated({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) => AnimatedSwitcher(
    duration: duration,
    switchInCurve: curve,
    switchOutCurve: curve,
    child: this,
  );

  /// 위젯에 그림자 효과를 추가합니다.
  ///
  /// [elevation] 그림자 높이 (기본값: 2)
  /// [shadowColor] 그림자 색상
  /// [borderRadius] 모서리 둥글기 (기본값: 8)
  Widget withShadow({
    double elevation = 2,
    Color? shadowColor,
    double borderRadius = 8,
  }) => Material(
    elevation: elevation,
    shadowColor: shadowColor,
    borderRadius: BorderRadius.circular(borderRadius),
    child: this,
  );
}

/// List<Widget>을 확장하여 공통 레이아웃 패턴을 제공하는 Extension Methods
extension WidgetListExtensions on List<Widget> {
  /// 위젯들 사이에 간격을 추가합니다.
  ///
  /// [spacing] 간격 크기
  /// [direction] 방향 (기본값: Axis.vertical)
  List<Widget> separated(double spacing, {Axis direction = Axis.vertical}) {
    if (isEmpty) return this;

    final separator = direction == Axis.vertical
        ? SizedBox(height: spacing)
        : SizedBox(width: spacing);

    final result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  /// 위젯들을 Column으로 배열합니다.
  ///
  /// [mainAxisAlignment] 주축 정렬 (기본값: MainAxisAlignment.start)
  /// [crossAxisAlignment] 교차축 정렬 (기본값: CrossAxisAlignment.start)
  /// [spacing] 위젯 간 간격
  Column toColumn({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double? spacing,
  }) {
    final children = spacing != null ? separated(spacing) : this;
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  /// 위젯들을 Row로 배열합니다.
  ///
  /// [mainAxisAlignment] 주축 정렬 (기본값: MainAxisAlignment.start)
  /// [crossAxisAlignment] 교차축 정렬 (기본값: CrossAxisAlignment.center)
  /// [spacing] 위젯 간 간격
  Row toRow({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double? spacing,
  }) {
    final children = spacing != null
        ? separated(spacing, direction: Axis.horizontal)
        : this;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  /// 위젯들을 Wrap으로 배열합니다.
  ///
  /// [spacing] 수평 간격 (기본값: 8)
  /// [runSpacing] 수직 간격 (기본값: 8)
  /// [alignment] 정렬 방식 (기본값: WrapAlignment.start)
  Wrap toWrap({
    double spacing = 8,
    double runSpacing = 8,
    WrapAlignment alignment = WrapAlignment.start,
  }) => Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    alignment: alignment,
    children: this,
  );
}
