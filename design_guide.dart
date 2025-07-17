import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// LIA 앱의 메인 컬러 및 스타일을 정의하는 클래스입니다.
// 앱 전체의 디자인 일관성을 유지합니다.
class AppColors {
  static const Color background = Color(0xFFFFF8FB);
  static const Color primary = Color(0xFFFF70A6);
  static const Color accent = Color(0xFFA162F7);
  static const Color yellow = Color(0xFFFFD670);
  static const Color charcoal = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF555555);
  static const Color cardBorder = Color(0xFFFFDDE8);
  static const Color success = Color(0xFF28a745); // 성공 상태 색상 추가

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF9770), Color(0xFFFF70A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFFA162F7), Color(0xFFB681F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// 폰트 스타일 정의
class AppTextStyles {
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'Gaegu',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    shadows: [
      Shadow(
        color: AppColors.yellow,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const TextStyle componentTitle = TextStyle(
    fontFamily: 'Gaegu',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.charcoal,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal,
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16,
    color: AppColors.charcoal,
    height: 1.5,
  );

  static const TextStyle helper = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14,
    color: AppColors.secondaryText,
    height: 1.5,
  );
}

void main() {
  runApp(const LiaDesignGuideApp());
}

/// LIA 디자인 가이드 앱의 루트 위젯입니다.
///
/// 앱의 전체적인 테마와 라우팅을 설정합니다.
class LiaDesignGuideApp extends StatelessWidget {
  const LiaDesignGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 머티리얼 디자인의 영향을 최소화하고 커스텀 디자인 시스템을 적용합니다.
    final theme = ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'NotoSansKR',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // Chip 테마를 HTML 디자인에 맞게 수정
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accent.withOpacity(0.1),
        labelStyle:
            const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      // 슬라이더 테마
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),
    );

    return MaterialApp(
      title: 'LIA Design Guide',
      theme: theme,
      home: const DesignGuideScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 디자인 가이드의 모든 컴포넌트를 보여주는 메인 화면입니다.
class DesignGuideScreen extends StatelessWidget {
  const DesignGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Design Guide",
              style: AppTextStyles.mainTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // 모든 카드를 순차적 애니메이션으로 표시합니다.
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 400),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 60.0,
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
                  children: const [
                    TypographyCard(),
                    ColorPaletteCard(),
                    HeaderNavigationCard(),
                    DataVisualizationCard(),
                    FormElementsCard(),
                    TextFieldsCard(),
                    TextareaCard(),
                    InteractiveWidgetsCard(),
                    GamificationWidgetsCard(),
                    AnimationInteractionCard(),
                    StatusFeedbackCard(),
                    ModalCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 공용 위젯 ---

/// 디자인 컴포넌트를 감싸는 공용 카드 위젯입니다.
///
/// 마우스를 올렸을 때(Hover) 부드러운 애니메이션 효과와 그림자 효과를 제공하여
/// 사용자에게 시각적인 피드백을 줍니다.
class ComponentCard extends StatefulWidget {
  final String title;
  final Widget child;

  const ComponentCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<ComponentCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final transform = _isHovering
        ? (Matrix4.identity()
          ..translate(0.0, -6.0, 0.0)
          ..rotateZ(0.01))
        : Matrix4.identity();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: transform,
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_isHovering ? 0.25 : 0.15),
              blurRadius: _isHovering ? 24 : 16,
              offset: Offset(0, _isHovering ? 12 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: AppTextStyles.componentTitle),
                const DashedDivider(),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 컴포넌트 카드 내에서 사용하는 점선 구분선 위젯입니다.
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          const dashHeight = 2.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.cardBorder),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// --- 카드 섹션 ---

class TypographyCard extends StatelessWidget {
  const TypographyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'TYPOGRAPHY (글꼴과 말투)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("어떤 말을 보낼지 고민될 땐?", style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text("AI 메시지 만들기", style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text("상황이랑 말투만 고르면 LIA가 알려줄게!", style: AppTextStyles.subtitle),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"오빠 스토리 완전 힙하다! 농구천재 아니야?"',
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(height: 8),
          Text("가장 맘에 드는 메시지를 골라봐", style: AppTextStyles.helper),
        ],
      ),
    );
  }
}

class ColorPaletteCard extends StatelessWidget {
  const ColorPaletteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'COLOR PALETTE (테마 색상)',
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 16,
        runSpacing: 16,
        children: const [
          _ColorChip(
            gradient: AppColors.primaryGradient,
            name: 'Main Gradient',
            description: '주요 버튼/포인트',
          ),
          _ColorChip(
            color: AppColors.primary,
            name: 'Lovely Pink',
            description: '#FF70A6',
          ),
          _ColorChip(
            color: AppColors.accent,
            name: 'Witty Purple',
            description: '#A162F7',
          ),
          _ColorChip(
            color: AppColors.yellow,
            name: 'Sparkle Yellow',
            description: '#FFD670',
          ),
          _ColorChip(
            color: AppColors.charcoal,
            name: 'Charcoal',
            description: '#333 (기본 텍스트)',
          ),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final String name;
  final String description;

  const _ColorChip(
      {this.color, this.gradient, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(description, style: AppTextStyles.helper, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class HeaderNavigationCard extends StatelessWidget {
  const HeaderNavigationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'HEADER & NAVIGATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("앱 헤더", style: AppTextStyles.helper.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                // HTML의 이미지 플레이스홀더를 로컬 위젯으로 대체하여 안정성 확보
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    "LIA",
                    style: TextStyle(
                      fontFamily: 'Gaegu',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "서현(ENFP)님, 오늘은 어떤 썸을 도와줄까요?",
                    style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                const Icon(Icons.notifications_none,
                    color: AppColors.primary, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text("하단 내비게이션",
              style: AppTextStyles.helper.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _BottomNavBarDemo(),
        ],
      ),
    );
  }
}

class _BottomNavBarDemo extends StatelessWidget {
  const _BottomNavBarDemo();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(icon: Icons.home_filled, label: '홈'),
                  _BottomNavItem(icon: Icons.chat_bubble, label: '메시지'),
                  SizedBox(width: 40), // FAB 공간
                  _BottomNavItem(icon: Icons.favorite, label: '보관함'),
                  _BottomNavItem(icon: Icons.person, label: '마이'),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -24,
          child: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary,
                  blurRadius: 10,
                  spreadRadius: -2,
                )
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.secondaryText),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class DataVisualizationCard extends StatelessWidget {
  const DataVisualizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '관계 데이터 시각화 (차트, 표)',
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 화면 너비가 좁을 경우 세로로 배치
          if (constraints.maxWidth < 700) {
            return Column(
              children: const [
                _GaugeChart(),
                SizedBox(height: 24),
                _DonutChart(),
                SizedBox(height: 24),
                _BarChart(),
              ],
            );
          }
          // 넓은 화면에서는 가로로 배치
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(child: _GaugeChart()),
              SizedBox(width: 16),
              Expanded(child: _DonutChart()),
              SizedBox(width: 16),
              Expanded(child: _BarChart()),
            ],
          );
        },
      ),
    );
  }
}

/// 호감도 같은 단일 값 진행률을 보여주는 게이지 차트 위젯입니다.
class _GaugeChart extends StatelessWidget {
  const _GaugeChart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("훈남(ISTP)과의 호감도",
            style: AppTextStyles.helper.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("📈 게이지 차트 - 진행률 시각화",
            style: AppTextStyles.helper.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        SizedBox(
          width: 180,
          child: AspectRatio(
            aspectRatio: 1.0, // 정사각형 비율 강제
            child: Container(
              // [수정] 차트가 잘리는 현상을 막기 위해 여백을 15 -> 20으로 늘렸습니다.
              padding: const EdgeInsets.all(20),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 0.75),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      // 배경 원형
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 14,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary.withOpacity(0.1),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                      // 진행률 원형 (그라데이션)
                      ShaderMask(
                        shaderCallback: (rect) {
                          return AppColors.primaryGradient.createShader(rect);
                        },
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 14,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // 중앙 텍스트
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${(value * 100).toInt()}%",
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 대화 주제 분석 등 카테고리별 비율을 보여주는 도넛 차트 위젯입니다.
/// HTML의 이미지 플레이스홀더와 달리, CustomPaint를 사용해 실제로 그려집니다.
class _DonutChart extends StatelessWidget {
  const _DonutChart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("대화 주제 분석",
            style: AppTextStyles.helper.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("📊 도넛 차트 - 카테고리별 비율 표시",
            style: AppTextStyles.helper.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        Container(
          width: 180,
          height: 180,
          // [수정] 게이지 차트와 일관성을 맞추고, 잘림 현상을 방지하기 위해 여백을 추가합니다.
          padding: const EdgeInsets.all(20),
          child: CustomPaint(
            painter: _DonutChartPainter(),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('#취미', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text('40%', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      Text('#일상 35%', style: TextStyle(fontSize: 9, color: AppColors.accent)),
                      Text('#학교 25%', style: TextStyle(fontSize: 9, color: AppColors.yellow)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPaint를 사용하여 도넛 차트를 그리는 페인터 클래스입니다.
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 20.0;
    // [수정] 반지름 계산 시 스트로크 두께를 고려하여, 원이 캔버스 영역을 벗어나지 않도록 합니다.
    final radius = (math.min(size.width, size.height) / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final data = [
      {'value': 0.40, 'color': AppColors.primary},
      {'value': 0.35, 'color': AppColors.accent},
      {'value': 0.25, 'color': AppColors.yellow},
    ];

    double startAngle = -math.pi / 2; // 12시 방향에서 시작

    for (var item in data) {
      final sweepAngle = (item['value'] as double) * 2 * math.pi;
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round; // 끝을 둥글게 처리
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("메시지 성공률",
            style: AppTextStyles.helper.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              _Bar(heightFactor: 0.6, label: '월'),
              _Bar(heightFactor: 0.75, label: '화'),
              _Bar(heightFactor: 0.95, label: '수', isHighlighted: true),
              _Bar(heightFactor: 0.5, label: '목'),
              _Bar(heightFactor: 0.85, label: '금'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double heightFactor;
  final String label;
  final bool isHighlighted;

  const _Bar(
      {required this.heightFactor,
      required this.label,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: FractionallySizedBox(
            heightFactor: heightFactor,
            child: Container(
              width: 24,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                gradient: isHighlighted ? AppColors.primaryGradient : null,
                color: isHighlighted ? null : Colors.blue.withOpacity(0.2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

class FormElementsCard extends StatefulWidget {
  const FormElementsCard({super.key});

  @override
  State<FormElementsCard> createState() => _FormElementsCardState();
}

class _FormElementsCardState extends State<FormElementsCard> {
  String? _dropdownValue = '인스타 스토리 답장';
  final Set<String> _selectedChips = {'재치있게', '플러팅'};
  double _sliderValue = 75;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'AI 메시지 필터',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("어떤 상황이야?",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder, width: 2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dropdownValue,
                isExpanded: true,
                items: ['인스타 스토리 답장', '대화 시작하기', '읽씹 당했을 때', '약속 잡기']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _dropdownValue = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text("어떤 말투로 보낼까? (중복 선택 가능)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['재치있게', '플러팅', '쿨하게'].map((label) {
              final isSelected = _selectedChips.contains(label);
              return FilterChip(
                label: Text(label,
                    style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.secondaryText,
                        fontWeight: FontWeight.bold)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedChips.add(label);
                    } else {
                      _selectedChips.remove(label);
                    }
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.1),
                checkmarkColor: AppColors.primary,
                shape: StadiumBorder(
                    side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.cardBorder,
                        width: 2)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text("호감 표현은 이 정도로만!",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: _sliderValue.round().toString(),
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("친구처럼", style: AppTextStyles.helper),
              Text("완전 티내기", style: AppTextStyles.helper),
            ],
          ),
        ],
      ),
    );
  }
}

/// HTML의 Floating Label 애니메이션을 그대로 구현한 커스텀 TextField 입니다.
///
/// 사용자가 입력을 시작하거나 포커스가 있을 때 레이블이 위로 떠오르는
/// 애니메이션 효과를 제공하여 UX를 향상시킵니다.
class FloatingLabelTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;

  const FloatingLabelTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.controller,
  });

  @override
  State<FloatingLabelTextField> createState() => _FloatingLabelTextFieldState();
}

class _FloatingLabelTextFieldState extends State<FloatingLabelTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller?.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      _hasText = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFloating = _isFocused || _hasText;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.cardBorder,
          width: 2,
        ),
        color: Colors.white, // 레이블이 올라갈 때 배경색을 덮기 위함
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 실제 입력 필드
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 28, 20, 12), // 레이블 공간 확보
              border: InputBorder.none,
              hintText: _isFocused ? '' : widget.hintText,
              hintStyle: AppTextStyles.body.copyWith(color: Colors.grey.shade400),
            ),
          ),
          // 애니메이션되는 레이블
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: isFloating ? -12 : 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white, // TextField 배경색과 동일하게 설정
              child: Text(
                widget.labelText,
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: isFloating ? 12 : 16,
                  color: isFloating ? AppColors.primary : Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldsCard extends StatefulWidget {
  const TextFieldsCard({super.key});

  @override
  State<TextFieldsCard> createState() => _TextFieldsCardState();
}

class _TextFieldsCardState extends State<TextFieldsCard> {
  late final TextEditingController _floatingController;
  late final TextEditingController _successController;

  @override
  void initState() {
    super.initState();
    _floatingController = TextEditingController();
    _successController = TextEditingController(text: "박서준");
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'TEXTFIELD (글자 입력창)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 기본 상태
          Text("기본 상태",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: "썸남/썸녀의 이름을 입력해봐",
              filled: true,
              fillColor: Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 입력 중 (Focus) - 커스텀 위젯 사용
          Text("입력 중 (Focus)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          FloatingLabelTextField(
            controller: _floatingController,
            hintText: "썸남/썸녀 이름",
            labelText: "썸남/썸녀 이름",
          ),
          const SizedBox(height: 24),
          // 에러 상태
          Text("에러 상태",
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: "잘못된 입력",
              errorText: "이름을 꼭 입력해줘!",
              filled: true,
              fillColor: Color(0xFFFFF0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 성공 상태
          Text("성공 상태",
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.success)),
          const SizedBox(height: 8),
          TextField(
            controller: _successController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.success.withOpacity(0.05),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.success, width: 2),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.success, width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.success, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextareaCard extends StatefulWidget {
  const TextareaCard({super.key});

  @override
  State<TextareaCard> createState() => _TextareaCardState();
}

class _TextareaCardState extends State<TextareaCard> {
  int _charCount = 0;
  final int _maxLength = 500;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: 'TEXTAREA (대화 내용 붙여넣기)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              TextField(
                maxLines: 6,
                maxLength: _maxLength,
                onChanged: (value) {
                  setState(() {
                    _charCount = value.length;
                  });
                },
                decoration: InputDecoration(
                  hintText: "썸남/썸녀와의 대화 내용을 붙여넣기 해봐! LIA가 분석해줄게 👀",
                  counterText: "", // 기본 카운터 숨기기
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Text(
                  "$_charCount / $_maxLength",
                  style: TextStyle(
                    color: _charCount > _maxLength
                        ? Colors.red
                        : AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              onPressed: () {},
              text: '분석하기 ✨',
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveWidgetsCard extends StatelessWidget {
  const InteractiveWidgetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '새로운 인터랙티브 위젯',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("토스트 알림 (Toast / Snackbar)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SecondaryButton(
            onPressed: () {
              // 머티리얼 느낌을 없앤 커스텀 스낵바
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("메시지가 복사되었어요! 📋",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  backgroundColor: AppColors.charcoal.withOpacity(0.85),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  elevation: 0,
                ),
              );
            },
            text: '"복사 완료!" 토스트 띄우기',
          ),
          const SizedBox(height: 24),
          Text("태그 입력 (Tag Input Field)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _TagInputField(),
          const SizedBox(height: 24),
          Text("온보딩 코치마크 (Onboarding Coach Marks)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const _CoachMarkDemo(),
        ],
      ),
    );
  }
}

class _TagInputField extends StatefulWidget {
  const _TagInputField();

  @override
  State<_TagInputField> createState() => __TagInputFieldState();
}

class __TagInputFieldState extends State<_TagInputField> {
  final List<String> _tags = ['#농구', '#힙합'];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _addTag() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tags.add('#${_controller.text}');
        _controller.clear();
      });
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 2),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ..._tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tag,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    setState(() {
                      _tags.remove(tag);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.close,
                        color: Colors.white70, size: 14),
                  ),
                )
              ],
            ),
          )),
          SizedBox(
            width: 150,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (_) => _addTag(),
              decoration: const InputDecoration(
                hintText: "#고양이",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachMarkDemo extends StatelessWidget {
  const _CoachMarkDemo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Pulsating Dot
            const PulsatingDot(),
            // Coach Mark Bubble
            Positioned(
              bottom: 30,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 200,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 15)
                      ],
                    ),
                    child: const Text(
                      "이 버튼을 누르면\n썸남/썸녀를 추가할 수 있어!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // 말풍선 꼬리
                  Positioned(
                    bottom: -14,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 16,
                        height: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 온보딩 가이드 등에서 특정 위젯에 주목을 끌기 위한 맥동하는 점 애니메이션 위젯입니다.
class PulsatingDot extends StatefulWidget {
  const PulsatingDot({super.key});

  @override
  State<PulsatingDot> createState() => _PulsatingDotState();
}

class _PulsatingDotState extends State<PulsatingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final easeValue = Curves.easeInOut.transform(_controller.value);
        final opacity = 1.0 - easeValue;
        final size = 20 + (15 * easeValue);

        return Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
        );
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class GamificationWidgetsCard extends StatefulWidget {
  const GamificationWidgetsCard({super.key});

  @override
  State<GamificationWidgetsCard> createState() =>
      _GamificationWidgetsCardState();
}

class _GamificationWidgetsCardState extends State<GamificationWidgetsCard> {
  int? _selectedPollOption;
  bool _voted = false;

  void _handleVote(int optionIndex) {
    if (_voted) return;
    setState(() {
      _selectedPollOption = optionIndex;
      _voted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '앱의 재미와 깊이를 더하는 위젯',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게임화 위젯
          Text("게임화 위젯 (Gamification)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _GamificationContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("오늘의 퀘스트 🎯",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16)),
                    Text("+10 포텐",
                        style: TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("썸남에게 칭찬 한 번 하기!"),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 7일 출석체크 위젯 (신규 추가)
          _GamificationContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("7일 출석체크 🗓️",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CheckInDay(day: '월', emoji: '💝', isChecked: true),
                    _CheckInDay(day: '화', emoji: '💝', isChecked: true),
                    _CheckInDay(day: '수', emoji: '💝', isChecked: true),
                    _CheckInDay(day: '목', emoji: '🎁', isChecked: true),
                    _CheckInDay(day: '금', emoji: '🤍', isChecked: false),
                    _CheckInDay(day: '토', emoji: '🤍', isChecked: false),
                    _CheckInDay(day: '일', emoji: '🤍', isChecked: false),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 커뮤니티 위젯
          Text("커뮤니티 위젯 (Community)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _GamificationContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("실시간 고민 투표 🤔",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                const Text("썸남이 'ㅋㅋ'만 보냈을 때, 더 끌리는 답장은?"),
                const SizedBox(height: 16),
                _PollOption(
                  text: "A. (사진) 나도 이거 완전 웃긴데 ㅋㅋ",
                  percentage: 72,
                  isSelected: _selectedPollOption == 0,
                  showResult: _voted,
                  onTap: () => _handleVote(0),
                ),
                const SizedBox(height: 8),
                _PollOption(
                  text: "B. 웃기만 하지 말고 말 좀 해봐 ㅋㅋ",
                  percentage: 28,
                  isSelected: _selectedPollOption == 1,
                  showResult: _voted,
                  onTap: () => _handleVote(1),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("총 1,204명 참여", style: AppTextStyles.helper),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GamificationContainer extends StatelessWidget {
  final Widget child;
  const _GamificationContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFFFF5F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }
}

class _CheckInDay extends StatelessWidget {
  final String day;
  final String emoji;
  final bool isChecked;

  const _CheckInDay({required this.day, required this.emoji, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isChecked ? 1.0 : 0.4,
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(emoji, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

/// 커뮤니티 투표 위젯의 각 선택지를 나타내는 컴포넌트입니다.
///
/// 투표 시 선택된 옵션에 시각적 피드백을 주고, 투표 결과를
/// 애니메이션과 함께 보여줍니다.
class _PollOption extends StatelessWidget {
  final String text;
  final int percentage;
  final bool isSelected;
  final bool showResult;
  final VoidCallback onTap;

  const _PollOption({
    required this.text,
    required this.percentage,
    required this.isSelected,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52, // 고정 높이로 레이아웃 안정성 확보
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF3E8FF) : Colors.white,
              border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.cardBorder,
                  width: 2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ] : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14), // 테두리 안쪽 라운딩
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // 진행바 배경
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    width: showResult
                        ? constraints.maxWidth * (percentage / 100)
                        : 0,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE9D5FF),
                          AppColors.accent.withOpacity(0.2),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  // 텍스트와 퍼센트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.accent : AppColors.charcoal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showResult)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "$percentage%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class AnimationInteractionCard extends StatelessWidget {
  const AnimationInteractionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '애니메이션 & 인터랙션 💃',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("리스트 등장 & '찜하기' 인터랙션",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _AnimatedMessageList(),
        ],
      ),
    );
  }
}

class _AnimatedMessageList extends StatelessWidget {
  const _AnimatedMessageList();

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: const [
            _MessageItem(
              tag: '#밈활용',
              tagColor: Colors.purple,
              message: "농구... 좋아하세요? 스토리 완전 멋있어ㅋㅋ",
            ),
            SizedBox(height: 8),
            _MessageItem(
              tag: '#직접칭찬',
              tagColor: Colors.pink,
              message: "스토리 봤는데 농구 완전 잘한다! 경기 또 언제 해?",
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageItem extends StatefulWidget {
  final String tag;
  final Color tagColor;
  final String message;

  const _MessageItem(
      {required this.tag, required this.tagColor, required this.message});

  @override
  State<_MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<_MessageItem>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      _animationController.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("보관함에 저장했어요! 💖",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.charcoal,
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.tagColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(widget.tag,
                      style: TextStyle(
                          color: widget.tagColor, fontWeight: FontWeight.bold)),
                  backgroundColor: widget.tagColor.withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                const SizedBox(height: 8),
                Text(widget.message, style: AppTextStyles.body),
              ],
            ),
          ),
          ScaleTransition(
            scale: _scaleAnimation,
            child: IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.redAccent : Colors.grey,
              ),
              onPressed: _onLikeTap,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusFeedbackCard extends StatelessWidget {
  const StatusFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '상태 & 피드백',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("로딩중...",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: HeartSpinner(),
            ),
          ),
          const SizedBox(height: 24),
          // 스켈레톤 UI (신규 추가)
          Text("메시지 생성 중 (스켈레톤 UI)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _SkeletonUI(),
          const SizedBox(height: 24),
          Text("텅 비었을 때 (Empty State)",
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 2,
                  style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                const Text("💔", style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text("아직 썸남/썸녀 정보가 없어요",
                    style: AppTextStyles.h2.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Text("지금 바로 추가하고 LIA의 도움을 받아볼까요?",
                    style: AppTextStyles.helper, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                PrimaryButton(onPressed: () {}, text: "썸 상대 추가하기"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 데이터 로딩 중에 표시되는 스켈레톤 UI 위젯입니다.
/// 실제 콘텐츠의 레이아웃을 희미하게 보여주어 사용자 경험을 개선합니다.
class _SkeletonUI extends StatefulWidget {
  const _SkeletonUI();

  @override
  State<_SkeletonUI> createState() => _SkeletonUIState();
}

class _SkeletonUIState extends State<_SkeletonUI> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// HTML의 heartbeat 애니메이션을 모방한 하트 모양 로딩 스피너입니다.
class HeartSpinner extends StatefulWidget {
  const HeartSpinner({super.key});

  @override
  State<HeartSpinner> createState() => _HeartSpinnerState();
}

class _HeartSpinnerState extends State<HeartSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: const Icon(Icons.favorite, color: AppColors.primary, size: 50),
    );
  }
}

class ModalCard extends StatelessWidget {
  const ModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      title: '모달 (확인창)',
      child: Center(
        child: PrimaryButton(
          onPressed: () {
            // 커스텀 애니메이션이 적용된 모달 호출
            showCustomModal(
              context,
              child: const _LiaModalDialog(),
            );
          },
          text: "모달 열기",
        ),
      ),
    );
  }
}

/// 커스텀 모달 다이얼로그 위젯입니다.
class _LiaModalDialog extends StatelessWidget {
  const _LiaModalDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: -10,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("💌", style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text("이 메시지로 보낼까요?", style: AppTextStyles.h2),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('"농구... 좋아하세요? 스토리 완전 멋있어ㅋㅋ"'),
            ),
            const SizedBox(height: 8),
            const Text("전송 후에는 수정할 수 없어요!", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: "다시 고를래요",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: "네, 보낼래요!",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- 커스텀 버튼 ---

/// 앱의 주요 액션을 위한 프라이머리 버튼입니다.
/// 그라데이션 배경과 그림자 효과가 특징입니다.
class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const PrimaryButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 앱의 보조 액션을 위한 세컨더리 버튼입니다.
/// 밝은 회색 배경을 사용합니다.
class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const SecondaryButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          hoverColor: const Color(0xFFE9ECEF),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 커스텀 모달 표시 함수 ---

/// 배경 블러와 스케일 애니메이션이 적용된 커스텀 모달을 표시합니다.
void showCustomModal(BuildContext context, {required Widget child}) {
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    pageBuilder: (context, _, __) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, animChild) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8 * value, sigmaY: 8 * value),
            child: Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: animChild,
              ),
            ),
          );
        },
        child: child,
      );
    },
  ));
}