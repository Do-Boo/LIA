import 'package:flutter/material.dart';
import 'package:lia/presentation/screens/chart_demo_screen.dart';

import 'core/app_colors.dart';
import 'presentation/screens/design_guide_screen.dart';
import 'presentation/screens/main_layout.dart';

/// LIA 앱의 메인 진입점입니다.
///
/// 이 함수는 Flutter 앱을 시작하는 진입점으로,
/// LiaApp 위젯을 실행합니다.
void main() {
  runApp(const MyApp());
}

/// LIA 앱의 루트 위젯입니다.
///
/// 앱의 전체적인 테마와 라우팅을 설정하며,
/// Material Design의 영향을 최소화하고 커스텀 디자인 시스템을 적용합니다.
///
/// 주요 설정:
/// - 브랜드 색상을 기반으로 한 테마
/// - 커스텀 폰트 패밀리 (NotoSansKR)
/// - 터치 효과 최소화 (splash, highlight 제거)
/// - 커스텀 Chip 및 Slider 테마
/// - 디버그 배너 비활성화
///
/// 홈 화면으로 MainScreen을 설정하여
/// 18세 서현 페르소나에 맞는 메인 화면을 제공합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'NotoSansKR',
    );

    return MaterialApp(
      title: 'LIA - AI 메시지 대필 서비스',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(initialIndex: 0), // 홈 (MainScreen)
        '/coaching': (context) => const MainLayout(initialIndex: 1), // 코칭센터
        '/history': (context) => const MainLayout(initialIndex: 2), // 히스토리
        '/my': (context) => const MainLayout(initialIndex: 3), // MY
        '/ai-message': (context) => const ChartDemoScreen(), // AI 메시지 (독립 화면)
        '/design-guide': (context) =>
            const DesignGuideScreen(), // 디자인 가이드 (독립 화면)
      },
    );
  }
}
