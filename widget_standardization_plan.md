# 🎯 위젯 표준화 계획서

## 📋 개요

LIA 프로젝트의 비슷한 위젯들을 표준화하여 사용 방법을 통일하고, 개발 효율성과 코드 일관성을 향상시키는 계획입니다.

## 🔍 현재 위젯 분석

### 📊 차트 위젯 계열

#### 현재 상황
```dart
// 각각 다른 인터페이스 사용 (예상)
BarChart(data: [...], title: "제목", showLegend: true)
PieChart(chartData: [...], chartTitle: "제목", legendVisible: true)  
LineChart(values: [...], name: "제목", legend: true)
```

#### 🎯 표준화 목표
```dart
// 통일된 인터페이스
BarChart(data: [...], title: "제목", showLegend: true)
PieChart(data: [...], title: "제목", showLegend: true)
LineChart(data: [...], title: "제목", showLegend: true)
```

### 🏗️ 레이아웃 위젯 계열

#### Header 위젯들
```dart
// 현재 (예상)
DashboardHeader(title: "제목", subtitle: "부제목", actions: [...])
SectionHeader(headerText: "제목", description: "설명")
PageHeader(pageName: "제목", info: "정보")

// 표준화 후  
DashboardHeader(title: "제목", subtitle: "부제목", actions: [...])
SectionHeader(title: "제목", subtitle: "설명") 
PageHeader(title: "제목", subtitle: "정보")
```

#### Card 위젯들
```dart
// 현재 (예상)
ComponentCard(title: "제목", content: Widget, padding: EdgeInsets)
InfoCard(cardTitle: "제목", child: Widget, margin: EdgeInsets)
DataCard(name: "제목", body: Widget, spacing: double)

// 표준화 후
ComponentCard(title: "제목", child: Widget, padding: EdgeInsets)
InfoCard(title: "제목", child: Widget, padding: EdgeInsets)  
DataCard(title: "제목", child: Widget, padding: EdgeInsets)
```

## 🎨 표준화 설계 원칙

### 1. 📝 API 일관성 원칙
```dart
/// 모든 위젯이 따라야 할 기본 인터페이스 패턴
abstract class StandardWidget {
  // 필수 속성들
  final String? title;           // 제목 (일관된 이름)
  final String? subtitle;        // 부제목 (일관된 이름)  
  final Widget? child;           // 자식 위젯 (일관된 이름)
  
  // 선택적 속성들
  final EdgeInsets? padding;     // 패딩 (일관된 이름)
  final double? height;          // 높이 (일관된 이름)
  final VoidCallback? onTap;     // 탭 콜백 (일관된 이름)
}
```

### 2. 🔄 데이터 형식 통일
```dart
/// 모든 차트 위젯이 공통으로 사용할 데이터 형식
abstract class ChartData {
  Map<String, dynamic> toJson();
  static ChartData fromJson(Map<String, dynamic> json);
}

/// 표준 차트 데이터 형식
class StandardChartData implements ChartData {
  final String label;
  final double value;  
  final Color? color;
  final Map<String, dynamic>? metadata;
  
  // JSON 직렬화 지원
  @override
  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    if (color != null) 'color': color!.value,
    if (metadata != null) ...metadata!,
  };
  
  static StandardChartData fromJson(Map<String, dynamic> json) => 
    StandardChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: json['color'] != null ? Color(json['color']) : null,
      metadata: json['metadata'],
    );
}
```

### 3. 🎛️ 설정 옵션 표준화
```dart
/// 공통 설정 옵션들
class StandardWidgetConfig {
  // 범례 관련
  final bool showLegend;
  final LegendPosition legendPosition;
  
  // 애니메이션 관련
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  
  // 스타일 관련
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final BoxShadow? shadow;
  
  const StandardWidgetConfig({
    this.showLegend = true,
    this.legendPosition = LegendPosition.bottomCenter,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.shadow,
  });
}
```

## 🏗️ 표준화 아키텍처

### 1. 📊 차트 위젯 표준화

#### BaseChart 추상 클래스
```dart
// lib/presentation/widgets/base/base_chart.dart

abstract class BaseChart extends StatefulWidget {
  /// 차트 제목
  final String? title;
  
  /// 차트 제목 아이콘
  final IconData? titleIcon;
  
  /// 차트 데이터 (표준 형식)
  final List<StandardChartData>? data;
  
  /// 범례 표시 여부
  final bool showLegend;
  
  /// 범례 위치
  final LegendPosition legendPosition;
  
  /// 차트 높이
  final double height;
  
  /// 애니메이션 설정
  final bool enableAnimation;
  final Duration animationDuration;
  final Curve animationCurve;
  
  /// 스타일 설정
  final EdgeInsets padding;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  
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

  /// 차트별 고유 렌더링 로직 (하위 클래스에서 구현)
  Widget buildChart(
    BuildContext context,
    List<StandardChartData> chartData,
    Animation<double> animation,
  );
  
  /// 기본 차트 데이터 (하위 클래스에서 구현)
  List<StandardChartData> getDefaultData();

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

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );
  }

  void _parseData() {
    _chartData = widget.data ?? widget.getDefaultData();
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
        _chartData[i] = StandardChartData(
          label: _chartData[i].label,
          value: _chartData[i].value,
          color: defaultColors[i % defaultColors.length],
          metadata: _chartData[i].metadata,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        borderRadius: widget.borderRadius,
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
                    builder: (context, child) {
                      return widget.buildChart(context, _chartData, _animation);
                    },
                  )
                : widget.buildChart(context, _chartData, 
                    AlwaysStoppedAnimation(1.0)),
          ),

          // 하단 범례
          if (widget.showLegend && _isBottomLegend()) ...[
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

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

  Widget _buildLegend() {
    return ChartLegend(
      data: _chartData,
      position: widget.legendPosition,
    );
  }

  bool _isTopLegend() {
    return [
      LegendPosition.topLeft,
      LegendPosition.topCenter,
      LegendPosition.topRight,
    ].contains(widget.legendPosition);
  }

  bool _isBottomLegend() {
    return [
      LegendPosition.bottomLeft,
      LegendPosition.bottomCenter,
      LegendPosition.bottomRight,
    ].contains(widget.legendPosition);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

#### 표준화된 BarChart 구현
```dart
// lib/presentation/widgets/specific/charts/bar_chart.dart

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
  ) {
    return CustomPaint(
      painter: BarChartPainter(
        data: chartData,
        animation: animation.value,
      ),
      size: Size.infinite,
    );
  }

  @override
  List<StandardChartData> getDefaultData() {
    return [
      StandardChartData(label: '카페 데이트', value: 85),
      StandardChartData(label: '취미 공유', value: 72),
      StandardChartData(label: '일상 대화', value: 68),
      StandardChartData(label: '음식 이야기', value: 55),
      StandardChartData(label: '영화/드라마', value: 42),
    ];
  }
}
```

### 2. 🏗️ 레이아웃 위젯 표준화

#### BaseCard 추상 클래스
```dart
// lib/presentation/widgets/base/base_card.dart

abstract class BaseCard extends StatelessWidget {
  /// 카드 제목
  final String? title;
  
  /// 카드 부제목
  final String? subtitle;
  
  /// 카드 내용
  final Widget child;
  
  /// 패딩
  final EdgeInsets padding;
  
  /// 마진  
  final EdgeInsets margin;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 테두리
  final BorderRadius borderRadius;
  final Border? border;
  
  /// 그림자
  final List<BoxShadow>? boxShadow;
  
  /// 탭 콜백
  final VoidCallback? onTap;

  const BaseCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.border,
    this.boxShadow,
    this.onTap,
  });

  /// 헤더 위젯 빌더 (하위 클래스에서 커스터마이징 가능)
  Widget? buildHeader(BuildContext context) {
    if (title == null && subtitle == null) return null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!, style: AppTextStyles.componentTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: AppTextStyles.body2),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = buildHeader(context);
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius,
        border: border ?? Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[
                  header,
                  const SizedBox(height: 16),
                  const DashedDivider(),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### 표준화된 ComponentCard 구현
```dart
// lib/presentation/widgets/common/component_card.dart

class ComponentCard extends BaseCard {
  const ComponentCard({
    super.key,
    super.title,
    super.subtitle,
    required super.child,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.boxShadow,
    super.onTap,
  });
}

class InfoCard extends BaseCard {
  const InfoCard({
    super.key,
    super.title,
    super.subtitle,
    required super.child,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.boxShadow,
    super.onTap,
  });
}

class DataCard extends BaseCard {
  const DataCard({
    super.key,
    super.title,
    super.subtitle,
    required super.child,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.boxShadow,
    super.onTap,
  });
}
```

### 3. 🎯 Header 위젯 표준화

#### BaseHeader 추상 클래스
```dart
// lib/presentation/widgets/base/base_header.dart

abstract class BaseHeader extends StatelessWidget {
  /// 헤더 제목
  final String title;
  
  /// 헤더 부제목
  final String? subtitle;
  
  /// 헤더 아이콘
  final IconData? icon;
  
  /// 액션 버튼들
  final List<HeaderAction>? actions;
  
  /// 배경 그라데이션
  final Gradient? gradient;
  
  /// 헤더 높이
  final double? height;
  
  /// 패딩
  final EdgeInsets padding;

  const BaseHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actions,
    this.gradient,
    this.height,
    this.padding = const EdgeInsets.all(20),
  });

  /// 헤더 스타일 정의 (하위 클래스에서 커스터마이징)
  HeaderStyle getHeaderStyle() => const HeaderStyle();

  @override
  Widget build(BuildContext context) {
    final style = getHeaderStyle();
    
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? style.defaultGradient,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 메인 콘텐츠
          Row(
            children: [
              if (icon != null) ...[
                _buildIcon(style),
                const SizedBox(width: 16),
              ],
              Expanded(child: _buildTitleSection(style)),
            ],
          ),
          
          // 액션 버튼들
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildActions(style),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(HeaderStyle style) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: style.iconColor, size: 24),
    );
  }

  Widget _buildTitleSection(HeaderStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: style.titleStyle),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: style.subtitleStyle),
        ],
      ],
    );
  }

  Widget _buildActions(HeaderStyle style) {
    return Row(
      children: actions!
          .map((action) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: action != actions!.last ? 12 : 0,
                  ),
                  child: _buildActionButton(action, style),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionButton(HeaderAction action, HeaderStyle style) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, color: style.actionIconColor, size: 20),
            const SizedBox(height: 4),
            Text(action.title, style: style.actionTextStyle),
          ],
        ),
      ),
    );
  }
}

/// 헤더 스타일 설정
class HeaderStyle {
  final Gradient defaultGradient;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final Color iconColor;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color actionIconColor;
  final TextStyle actionTextStyle;

  const HeaderStyle({
    this.defaultGradient = AppColors.primaryGradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x4DFF70A6),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
    this.iconColor = AppColors.surface,
    this.titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: AppColors.surface,
    ),
    this.subtitleStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xE6FFFFFF),
      height: 1.4,
    ),
    this.actionIconColor = AppColors.surface,
    this.actionTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.surface,
    ),
  });
}

/// 헤더 액션 데이터 클래스
class HeaderAction {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const HeaderAction({
    required this.title,
    required this.icon,
    this.onTap,
  });
}
```

## 📝 사용 예시

### 표준화 전
```dart
// 일관성 없는 사용법
BarChart(
  chartData: barData,
  chartTitle: "주제 분포",
  showLegendItems: true,
  chartHeight: 200,
);

PieChart(
  data: pieData,
  title: "감정 분석", 
  legendVisible: true,
  size: 200,
);

ComponentCard(
  cardTitle: "분석 결과",
  content: Text("내용"),
  cardPadding: EdgeInsets.all(16),
);
```

### 표준화 후
```dart
// 일관된 사용법
BarChart(
  data: barData,
  title: "주제 분포",
  showLegend: true,
  height: 200,
);

PieChart(
  data: pieData,
  title: "감정 분석",
  showLegend: true,
  height: 200,
);

ComponentCard(
  title: "분석 결과",
  child: Text("내용"),
  padding: EdgeInsets.all(16),
);
```

## 🚀 마이그레이션 계획

### Phase 1: 베이스 클래스 생성 (1주)
1. **BaseChart 클래스** 구현
2. **BaseCard 클래스** 구현  
3. **BaseHeader 클래스** 구현
4. **표준 데이터 모델** 정의

### Phase 2: 기존 위젯 마이그레이션 (2주)
1. **차트 위젯들** 베이스 클래스 상속으로 변경
2. **카드 위젯들** 베이스 클래스 상속으로 변경
3. **헤더 위젯들** 베이스 클래스 상속으로 변경
4. **기존 사용처** 새 API로 업데이트

### Phase 3: 테스트 및 문서화 (1주)
1. **단위 테스트** 작성
2. **통합 테스트** 실행
3. **사용 가이드** 문서화
4. **코드 리뷰** 및 최종 검증

## 📊 성과 지표

### 🎯 정량적 지표
- **API 일관성**: 90% 이상의 속성명 통일
- **코드 재사용**: 70% 이상의 공통 코드 활용
- **개발 시간**: 새 위젯 개발 시간 50% 단축
- **버그 감소**: 위젯 관련 버그 60% 감소

### 🏆 정성적 지표
- **개발자 경험**: 직관적이고 예측 가능한 API
- **코드 품질**: 높은 가독성과 유지보수성  
- **확장성**: 새 기능 추가 시 기존 패턴 활용 가능
- **팀 효율성**: 코드 리뷰 시간 단축 및 온보딩 개선

## ⚠️ 주의사항

### 🔄 마이그레이션 시 고려사항
1. **기존 코드 호환성** - 단계적 마이그레이션으로 리스크 최소화
2. **성능 영향** - 베이스 클래스 오버헤드 모니터링
3. **팀 교육** - 새 표준에 대한 팀원 교육 필요
4. **문서 업데이트** - 기존 문서 및 가이드 업데이트

### 🎯 성공 조건
1. **전체 팀 합의** - 표준화 방향에 대한 팀 동의
2. **점진적 적용** - 한 번에 모든 것을 바꾸지 않고 단계적 적용
3. **충분한 테스트** - 회귀 방지를 위한 철저한 테스트
4. **지속적 개선** - 사용하면서 발견되는 문제점 지속 개선

---

**🎉 결론:** 이 표준화 계획을 통해 LIA 프로젝트의 위젯들은 일관된 API를 갖게 되어, 개발 효율성과 코드 품질이 크게 향상될 것입니다.