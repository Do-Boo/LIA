# 🧪 테스트 확장성 가이드

## 🎯 목표: `/test/widgets/` 최대 확장성 및 호환성

이 가이드는 LIA 프로젝트의 위젯 테스트를 최대한 확장 가능하고 호환성 있게 설계하는 방법을 제시합니다.

## 📁 현재 테스트 구조 분석

### 기존 구조 (예상)
```
test/
├── unit/
├── integration/
└── widgets/
    ├── common/
    ├── specific/
    └── test_helpers/
```

### 📊 확장성 있는 새 구조 제안
```
test/
├── widgets/
│   ├── base/
│   │   ├── base_widget_test.dart          # 모든 위젯 테스트의 베이스
│   │   ├── chart_test_base.dart           # 차트 위젯 전용 베이스
│   │   └── screen_test_base.dart          # 화면 위젯 전용 베이스
│   ├── common/
│   │   ├── dashboard_header_test.dart
│   │   ├── dashed_divider_test.dart
│   │   └── component_card_test.dart
│   ├── specific/
│   │   ├── charts/
│   │   │   ├── bar_chart_test.dart
│   │   │   ├── pie_chart_test.dart
│   │   │   └── line_chart_test.dart
│   │   └── forms/
│   ├── screens/
│   │   ├── main_screen_test.dart
│   │   ├── analysis_screen_test.dart
│   │   └── settings_screen_test.dart
│   ├── utils/
│   │   ├── test_data_factory.dart         # 테스트 데이터 생성기
│   │   ├── widget_test_helpers.dart       # 공통 헬퍼 함수들
│   │   ├── mock_factories.dart            # Mock 객체 팩토리들
│   │   └── golden_test_helpers.dart       # 골든 테스트 헬퍼들
│   ├── fixtures/
│   │   ├── chart_data/
│   │   ├── user_data/
│   │   └── api_responses/
│   └── mocks/
│       ├── mock_services.dart
│       ├── mock_repositories.dart
│       └── mock_providers.dart
```

## 🏗️ 확장성 있는 베이스 클래스 설계

### 1. 🎯 BaseWidgetTest - 최상위 베이스
```dart
// test/widgets/base/base_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// 모든 위젯 테스트의 베이스 클래스
/// 
/// 공통 기능:
/// - 기본 앱 테마 제공
/// - 공통 Mock 객체 관리
/// - 표준 테스트 헬퍼 메서드
/// - 에러 핸들링
abstract class BaseWidgetTest {
  /// 테스트용 앱 래퍼
  Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    Locale? locale,
  }) {
    return MaterialApp(
      theme: theme ?? _getDefaultTheme(),
      locale: locale ?? const Locale('ko', 'KR'),
      home: Scaffold(body: child),
    );
  }

  /// 기본 테마 설정
  ThemeData _getDefaultTheme() {
    return ThemeData(
      primarySwatch: Colors.pink,
      fontFamily: 'NotoSansKR',
    );
  }

  /// 공통 위젯 파인더들
  CommonFinders get finders => CommonFinders();
  
  /// 공통 테스트 액션들
  CommonActions get actions => CommonActions();
  
  /// 공통 검증 메서드들
  CommonVerifications get verify => CommonVerifications();

  /// 표준 테스트 셋업
  Future<void> setUpTest() async {
    // 공통 초기화 로직
  }

  /// 표준 테스트 정리
  Future<void> tearDownTest() async {
    // 공통 정리 로직
  }
}

/// 공통 파인더들
class CommonFinders {
  Finder byTestKey(String key) => find.byKey(Key(key));
  Finder byTextContaining(String text) => find.textContaining(text);
  Finder byIconData(IconData icon) => find.byIcon(icon);
}

/// 공통 액션들  
class CommonActions {
  Future<void> tapByKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }
  
  Future<void> enterText(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pumpAndSettle();
  }
}

/// 공통 검증들
class CommonVerifications {
  void widgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }
  
  void widgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }
  
  void textEquals(String expected, Finder finder) {
    expect(find.text(expected), finder);
  }
}
```

### 2. 📊 ChartTestBase - 차트 전용 베이스
```dart
// test/widgets/base/chart_test_base.dart

/// 모든 차트 위젯 테스트의 베이스 클래스
abstract class ChartTestBase extends BaseWidgetTest {
  /// 차트 테스트 데이터 생성
  List<ChartDataPoint> createTestChartData({
    int count = 5,
    double maxValue = 100,
  }) {
    return List.generate(count, (index) => ChartDataPoint(
      label: 'Label $index',
      value: (index + 1) * (maxValue / count),
      color: Colors.primaries[index % Colors.primaries.length],
    ));
  }

  /// 차트 애니메이션 완료 대기
  Future<void> waitForChartAnimation(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// 차트 제목 검증
  void verifyChartTitle(String expectedTitle) {
    verify.textEquals(expectedTitle, find.text(expectedTitle));
  }

  /// 범례 항목 개수 검증
  void verifyLegendItemCount(int expectedCount) {
    expect(find.byType(LegendItem), findsNWidgets(expectedCount));
  }

  /// 차트 데이터 포인트 검증
  void verifyDataPointCount(int expectedCount) {
    // 차트별로 오버라이드하여 구현
  }
}

/// 차트 테스트용 데이터 모델
class ChartDataPoint {
  final String label;
  final double value;
  final Color color;
  
  ChartDataPoint({
    required this.label,
    required this.value,
    required this.color,
  });
}
```

### 3. 📱 ScreenTestBase - 화면 전용 베이스
```dart
// test/widgets/base/screen_test_base.dart

/// 화면 위젯 테스트의 베이스 클래스
abstract class ScreenTestBase extends BaseWidgetTest {
  /// 화면 테스트용 네비게이션 설정
  Widget createScreenTest({
    required Widget screen,
    List<NavigatorObserver>? navigatorObservers,
  }) {
    return MaterialApp(
      navigatorObservers: navigatorObservers ?? [],
      home: screen,
    );
  }

  /// 공통 AppBar 검증
  void verifyAppBar({String? title, bool hasBackButton = false}) {
    expect(find.byType(AppBar), findsOneWidget);
    if (title != null) {
      expect(find.text(title), findsOneWidget);
    }
    if (hasBackButton) {
      expect(find.byType(BackButton), findsOneWidget);
    }
  }

  /// 공통 로딩 상태 검증
  void verifyLoadingState() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// 공통 에러 상태 검증
  void verifyErrorState(String? errorMessage) {
    expect(find.byType(ErrorWidget), findsOneWidget);
    if (errorMessage != null) {
      expect(find.text(errorMessage), findsOneWidget);
    }
  }

  /// 스크롤 동작 테스트
  Future<void> performScroll(
    WidgetTester tester, {
    required Finder scrollable,
    required Offset offset,
  }) async {
    await tester.drag(scrollable, offset);
    await tester.pumpAndSettle();
  }
}
```

## 🛠️ 헬퍼 유틸리티 설계

### 1. 🏭 TestDataFactory - 테스트 데이터 생성기
```dart
// test/widgets/utils/test_data_factory.dart

/// 모든 테스트 데이터 생성을 담당하는 팩토리 클래스
class TestDataFactory {
  /// 차트 데이터 생성
  static ChartTestDataBuilder chart() => ChartTestDataBuilder();
  
  /// 사용자 데이터 생성
  static UserTestDataBuilder user() => UserTestDataBuilder();
  
  /// 분석 결과 데이터 생성
  static AnalysisTestDataBuilder analysis() => AnalysisTestDataBuilder();
}

/// 플루언트 API를 사용한 차트 데이터 빌더
class ChartTestDataBuilder {
  List<Map<String, dynamic>> _data = [];
  
  ChartTestDataBuilder withItem(String label, double value) {
    _data.add({'label': label, 'value': value});
    return this;
  }
  
  ChartTestDataBuilder withRandomItems(int count) {
    final random = Random();
    for (int i = 0; i < count; i++) {
      _data.add({
        'label': 'Item ${i + 1}',
        'value': random.nextDouble() * 100,
      });
    }
    return this;
  }
  
  List<Map<String, dynamic>> build() => List.from(_data);
}

/// 사용자 데이터 빌더
class UserTestDataBuilder {
  Map<String, dynamic> _userData = {};
  
  UserTestDataBuilder withName(String name) {
    _userData['name'] = name;
    return this;
  }
  
  UserTestDataBuilder withAge(int age) {
    _userData['age'] = age;
    return this;
  }
  
  Map<String, dynamic> build() => Map.from(_userData);
}
```

### 2. 🔧 WidgetTestHelpers - 공통 헬퍼 함수들
```dart
// test/widgets/utils/widget_test_helpers.dart

/// 위젯 테스트용 헬퍼 함수 모음
class WidgetTestHelpers {
  /// 특정 위젯이 렌더링될 때까지 대기
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump();
      
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    throw TimeoutException('Widget not found within timeout', timeout);
  }

  /// 애니메이션 완료까지 대기
  static Future<void> completeAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  /// 스크린샷 비교 (골든 테스트)
  static Future<void> expectGoldenMatches(
    WidgetTester tester,
    String goldenPath,
  ) async {
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(goldenPath),
    );
  }

  /// 접근성 검증
  static Future<void> verifyAccessibility(WidgetTester tester) async {
    final handle = tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
      SystemChannels.accessibility,
      (dynamic message) async => null,
    );
    
    await tester.binding.accessibilityController.handleMessage(
      StandardMethodCodec().encodeMethodCall(
        const MethodCall('announce', <String, dynamic>{
          'message': 'Test accessibility',
        }),
      ),
    );
    
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
      SystemChannels.accessibility,
      handle,
    );
  }
}
```

### 3. 🎭 MockFactories - Mock 객체 팩토리
```dart
// test/widgets/utils/mock_factories.dart

/// Mock 객체 생성을 담당하는 팩토리들
class MockFactories {
  /// 서비스 Mock 생성
  static MockServiceBuilder service() => MockServiceBuilder();
  
  /// 프로바이더 Mock 생성  
  static MockProviderBuilder provider() => MockProviderBuilder();
  
  /// API 응답 Mock 생성
  static MockApiBuilder api() => MockApiBuilder();
}

class MockServiceBuilder {
  final Map<Type, Mock> _mocks = {};
  
  MockServiceBuilder withAnalysisService([AnalysisDataService? mock]) {
    _mocks[AnalysisDataService] = mock ?? MockAnalysisDataService();
    return this;
  }
  
  MockServiceBuilder withStorageService([StorageService? mock]) {
    _mocks[StorageService] = mock ?? MockStorageService();
    return this;
  }
  
  Map<Type, Mock> build() => Map.from(_mocks);
}
```

## 🧪 표준화된 테스트 패턴

### 1. 📊 차트 위젯 테스트 패턴
```dart
// test/widgets/specific/charts/bar_chart_test.dart

class BarChartTest extends ChartTestBase {
  group('BarChart Widget Tests', () {
    testWidgets('should render with default data', (tester) async {
      // Given
      const widget = BarChart();
      
      // When
      await tester.pumpWidget(createTestApp(child: widget));
      await waitForChartAnimation(tester);
      
      // Then
      verify.widgetExists(find.byType(BarChart));
      verifyDataPointCount(5); // 기본 데이터 개수
    });

    testWidgets('should render with custom data', (tester) async {
      // Given
      final testData = createTestChartData(count: 3);
      final widget = BarChart(data: testData);
      
      // When
      await tester.pumpWidget(createTestApp(child: widget));
      await waitForChartAnimation(tester);
      
      // Then
      verifyDataPointCount(3);
      verifyLegendItemCount(3);
    });

    testWidgets('should show title when provided', (tester) async {
      // Given
      const title = 'Test Chart Title';
      const widget = BarChart(title: title);
      
      // When
      await tester.pumpWidget(createTestApp(child: widget));
      
      // Then
      verifyChartTitle(title);
    });
  });
}
```

### 2. 🏠 화면 위젯 테스트 패턴
```dart
// test/widgets/screens/main_screen_test.dart

class MainScreenTest extends ScreenTestBase {
  group('MainScreen Widget Tests', () {
    testWidgets('should render all main components', (tester) async {
      // Given
      final screen = MainScreen();
      
      // When
      await tester.pumpWidget(createScreenTest(screen: screen));
      
      // Then
      verifyAppBar(title: 'LIA');
      verify.widgetExists(find.byType(DashboardHeader));
      verify.widgetExists(find.byType(BottomNavigationBar));
    });

    testWidgets('should handle navigation correctly', (tester) async {
      // Given
      final navigatorObserver = MockNavigatorObserver();
      final screen = MainScreen();
      
      // When
      await tester.pumpWidget(createScreenTest(
        screen: screen,
        navigatorObservers: [navigatorObserver],
      ));
      
      await actions.tapByKey(tester, 'analysis_button');
      
      // Then
      verify(navigatorObserver.didPush(any, any));
    });
  });
}
```

## 🔄 호환성 보장 전략

### 1. 📋 테스트 인터페이스 표준화
```dart
/// 모든 위젯 테스트가 구현해야 하는 인터페이스
abstract class TestableWidget {
  /// 기본 렌더링 테스트
  Future<void> testBasicRendering(WidgetTester tester);
  
  /// 상호작용 테스트
  Future<void> testInteractions(WidgetTester tester);
  
  /// 에러 상태 테스트
  Future<void> testErrorStates(WidgetTester tester);
  
  /// 접근성 테스트
  Future<void> testAccessibility(WidgetTester tester);
}
```

### 2. 🔧 설정 중앙화
```dart
// test/widgets/config/test_config.dart

/// 모든 테스트의 설정을 중앙화
class TestConfig {
  // 기본 타임아웃 설정
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration animationTimeout = Duration(seconds: 3);
  
  // 테스트 환경 설정
  static const bool enableGoldenTests = true;
  static const bool enableAccessibilityTests = true;
  
  // Mock 데이터 경로
  static const String fixturesPath = 'test/widgets/fixtures';
  static const String goldensPath = 'test/widgets/goldens';
  
  /// 환경별 설정 로드
  static Map<String, dynamic> getEnvironmentConfig(String env) {
    switch (env) {
      case 'CI':
        return {'enableGoldenTests': false};
      case 'local':
        return {'enableGoldenTests': true};
      default:
        return {};
    }
  }
}
```

## 📈 성능 최적화

### 1. 🎯 테스트 실행 최적화
```dart
// test/widgets/utils/test_performance.dart

/// 테스트 성능 최적화 유틸리티
class TestPerformance {
  /// 병렬 테스트 실행을 위한 그룹핑
  static void runParallelTests(List<Function> tests) {
    // 관련 테스트들을 병렬로 실행
  }
  
  /// 리소스 집약적 테스트를 위한 최적화
  static Future<void> optimizeForHeavyTest() async {
    // 메모리 정리, 캐시 클리어 등
  }
  
  /// 테스트 실행 시간 측정
  static Future<Duration> measureTestTime(Function test) async {
    final stopwatch = Stopwatch()..start();
    await test();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
}
```

### 2. 💾 캐싱 전략
```dart
/// 테스트 데이터 캐싱으로 성능 향상
class TestDataCache {
  static final Map<String, dynamic> _cache = {};
  
  static T getOrCreate<T>(String key, T Function() factory) {
    if (!_cache.containsKey(key)) {
      _cache[key] = factory();
    }
    return _cache[key] as T;
  }
  
  static void clearCache() {
    _cache.clear();
  }
}
```

## 🚀 실행 가이드

### 1. 프로젝트 초기 설정
```bash
# 새 테스트 구조 생성
mkdir -p test/widgets/{base,common,specific/{charts,forms},screens,utils,fixtures,mocks}

# 베이스 클래스들 생성
touch test/widgets/base/{base_widget_test,chart_test_base,screen_test_base}.dart

# 유틸리티들 생성  
touch test/widgets/utils/{test_data_factory,widget_test_helpers,mock_factories}.dart
```

### 2. 기존 테스트 마이그레이션
```bash
# 기존 테스트들을 새 구조로 이동
# 각 테스트를 베이스 클래스 상속으로 변경
```

### 3. CI/CD 통합
```yaml
# .github/workflows/test.yml
name: Widget Tests
on: [push, pull_request]

jobs:
  widget-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      
      - name: Run widget tests
        run: flutter test test/widgets/
        
      - name: Upload golden files
        if: failure()
        uses: actions/upload-artifact@v2
        with:
          name: golden-failures
          path: test/widgets/goldens/
```

## 📊 확장성 지표

### 성공 지표
- ✅ **코드 재사용률**: 90% 이상의 공통 코드 활용
- ✅ **테스트 작성 시간**: 50% 단축
- ✅ **유지보수 비용**: 60% 감소  
- ✅ **신규 개발자 온보딩**: 1일 내 테스트 작성 가능

### 품질 지표
- ✅ **테스트 커버리지**: 80% 이상 유지
- ✅ **테스트 실행 시간**: 5분 이내
- ✅ **테스트 안정성**: 99% 이상
- ✅ **골든 테스트 정확도**: 픽셀 완벽 매칭

---

**🎯 결론:** 이 확장성 가이드를 통해 LIA 프로젝트의 위젯 테스트는 확장 가능하고 유지보수가 쉬우며, 새로운 기능 추가 시에도 일관된 품질을 보장할 수 있습니다.