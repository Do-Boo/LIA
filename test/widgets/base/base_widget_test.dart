// File: test/widgets/base/base_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia/core/app_colors.dart';
import 'package:lia/core/app_text_styles.dart';

/// 모든 위젯 테스트의 베이스 클래스
///
/// 공통 기능:
/// - 기본 앱 테마 제공
/// - 공통 Mock 객체 관리
/// - 표준 테스트 헬퍼 메서드
/// - 에러 핸들링
/// - 접근성 검증
abstract class BaseWidgetTest {
  /// 테스트용 앱 래퍼
  ///
  /// [child] 테스트할 위젯
  /// [theme] 커스텀 테마 (선택사항)
  /// [locale] 로케일 설정 (기본값: 한국어)
  /// [navigatorObservers] 네비게이션 관찰자 목록
  Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    Locale? locale,
    List<NavigatorObserver>? navigatorObservers,
  }) => MaterialApp(
    theme: theme ?? _getDefaultTheme(),
    locale: locale ?? const Locale('ko', 'KR'),
    navigatorObservers: navigatorObservers ?? [],
    home: Scaffold(body: child),
  );

  /// 기본 테마 설정
  /// LIA 앱과 동일한 테마를 제공합니다
  ThemeData _getDefaultTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    fontFamily: 'NotoSansKR',
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'Gaegu'),
      headlineMedium: TextStyle(fontFamily: 'Pretendard'),
      bodyLarge: TextStyle(fontFamily: 'NotoSansKR'),
      bodyMedium: TextStyle(fontFamily: 'NotoSansKR'),
    ),
  );

  /// 공통 위젯 파인더들
  CommonFinders get finders => CommonFinders();

  /// 공통 테스트 액션들
  CommonActions get actions => CommonActions();

  /// 공통 검증 메서드들
  CommonVerifications get verify => CommonVerifications();

  /// 표준 테스트 셋업
  /// 각 테스트 시작 전 호출됩니다
  Future<void> setUpTest() async {
    // 공통 초기화 로직
    // 서브클래스에서 오버라이드 가능
  }

  /// 표준 테스트 정리
  /// 각 테스트 완료 후 호출됩니다
  Future<void> tearDownTest() async {
    // 공통 정리 로직
    // 서브클래스에서 오버라이드 가능
  }

  /// 애니메이션 완료까지 대기
  ///
  /// [tester] 위젯 테스터
  /// [timeout] 최대 대기 시간 (기본값: 3초)
  Future<void> completeAnimations(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    await tester.pumpAndSettle(timeout);
  }

  /// 특정 위젯이 나타날 때까지 대기
  ///
  /// [tester] 위젯 테스터
  /// [finder] 찾을 위젯 파인더
  /// [timeout] 최대 대기 시간 (기본값: 5초)
  Future<void> waitForWidget(
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

  /// 접근성 검증
  ///
  /// [tester] 위젯 테스터
  Future<void> verifyAccessibility(WidgetTester tester) async {
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  }
}

/// 공통 파인더들
class CommonFinders {
  /// 테스트 키로 위젯 찾기
  Finder byTestKey(String key) => find.byKey(Key(key));

  /// 특정 텍스트를 포함하는 위젯 찾기
  Finder byTextContaining(String text) => find.textContaining(text);

  /// 특정 아이콘을 가진 위젯 찾기
  Finder byIconData(IconData icon) => find.byIcon(icon);

  /// 특정 타입의 위젯 찾기
  Finder byWidgetType<T extends Widget>() => find.byType(T);

  /// 특정 텍스트와 정확히 일치하는 위젯 찾기
  Finder byExactText(String text) => find.text(text);

  /// 로딩 인디케이터 찾기
  Finder loadingIndicator() => find.byType(CircularProgressIndicator);

  /// 에러 위젯 찾기
  Finder errorWidget() => find.byType(ErrorWidget);

  /// 스크롤 가능한 위젯 찾기
  Finder scrollable() => find.byType(Scrollable);

  /// 버튼 찾기 (모든 버튼 타입)
  Finder anyButton() => find.byWidgetPredicate(
    (widget) =>
        widget is ElevatedButton ||
        widget is TextButton ||
        widget is OutlinedButton ||
        widget is FloatingActionButton ||
        widget is IconButton,
  );

  /// 입력 필드 찾기
  Finder textField() => find.byType(TextField);
}

/// 공통 액션들
class CommonActions {
  /// 테스트 키로 위젯 탭하기
  ///
  /// [tester] 위젯 테스터
  /// [key] 테스트 키
  Future<void> tapByKey(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  /// 텍스트로 위젯 탭하기
  ///
  /// [tester] 위젯 테스터
  /// [text] 탭할 텍스트
  Future<void> tapByText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// 입력 필드에 텍스트 입력하기
  ///
  /// [tester] 위젯 테스터
  /// [key] 입력 필드의 테스트 키
  /// [text] 입력할 텍스트
  Future<void> enterText(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pumpAndSettle();
  }

  /// 스크롤 동작 수행
  ///
  /// [tester] 위젯 테스터
  /// [finder] 스크롤할 위젯 파인더
  /// [offset] 스크롤 오프셋
  Future<void> scroll(WidgetTester tester, Finder finder, Offset offset) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle();
  }

  /// 위로 스크롤
  ///
  /// [tester] 위젯 테스터
  /// [finder] 스크롤할 위젯 파인더 (선택사항)
  /// [pixels] 스크롤할 픽셀 수 (기본값: 300)
  Future<void> scrollUp(
    WidgetTester tester, {
    Finder? finder,
    double pixels = 300,
  }) async {
    final scrollFinder = finder ?? find.byType(Scrollable).first;
    await tester.drag(scrollFinder, Offset(0, pixels));
    await tester.pumpAndSettle();
  }

  /// 아래로 스크롤
  ///
  /// [tester] 위젯 테스터
  /// [finder] 스크롤할 위젯 파인더 (선택사항)
  /// [pixels] 스크롤할 픽셀 수 (기본값: 300)
  Future<void> scrollDown(
    WidgetTester tester, {
    Finder? finder,
    double pixels = 300,
  }) async {
    final scrollFinder = finder ?? find.byType(Scrollable).first;
    await tester.drag(scrollFinder, Offset(0, -pixels));
    await tester.pumpAndSettle();
  }

  /// 롱 프레스 동작
  ///
  /// [tester] 위젯 테스터
  /// [finder] 롱 프레스할 위젯 파인더
  Future<void> longPress(WidgetTester tester, Finder finder) async {
    await tester.longPress(finder);
    await tester.pumpAndSettle();
  }

  /// 더블 탭 동작
  ///
  /// [tester] 위젯 테스터
  /// [finder] 더블 탭할 위젯 파인더
  Future<void> doubleTap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}

/// 공통 검증들
class CommonVerifications {
  /// 위젯이 존재하는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  void widgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// 위젯이 존재하지 않는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  void widgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  /// 여러 위젯이 존재하는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  /// [count] 예상 개수
  void widgetCount(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// 텍스트가 일치하는지 검증
  ///
  /// [expected] 예상 텍스트
  /// [finder] 검증할 위젯 파인더 (선택사항)
  void textEquals(String expected, {Finder? finder}) {
    final textFinder = finder ?? find.text(expected);
    expect(textFinder, findsOneWidget);
  }

  /// 텍스트가 포함되어 있는지 검증
  ///
  /// [expected] 포함되어야 할 텍스트
  void textContains(String expected) {
    expect(find.textContaining(expected), findsAtLeastNWidgets(1));
  }

  /// 위젯이 보이는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  void widgetVisible(Finder finder) {
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;
    expect(widget, isA<Widget>());
  }

  /// 위젯이 활성화되어 있는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  void widgetEnabled(Finder finder) {
    final element = finder.evaluate().first;
    final widget = element.widget;

    if (widget is ElevatedButton) {
      expect(widget.onPressed, isNotNull);
    } else if (widget is TextButton) {
      expect(widget.onPressed, isNotNull);
    } else if (widget is OutlinedButton) {
      expect(widget.onPressed, isNotNull);
    }
  }

  /// 위젯이 비활성화되어 있는지 검증
  ///
  /// [finder] 검증할 위젯 파인더
  void widgetDisabled(Finder finder) {
    final element = finder.evaluate().first;
    final widget = element.widget;

    if (widget is ElevatedButton) {
      expect(widget.onPressed, isNull);
    } else if (widget is TextButton) {
      expect(widget.onPressed, isNull);
    } else if (widget is OutlinedButton) {
      expect(widget.onPressed, isNull);
    }
  }

  /// 스크롤 위치 검증
  ///
  /// [scrollable] 스크롤 위젯 파인더
  /// [expectedOffset] 예상 스크롤 오프셋
  void scrollPosition(Finder scrollable, double expectedOffset) {
    final scrollableState = tester.state<ScrollableState>(scrollable);
    expect(scrollableState.position.pixels, expectedOffset);
  }

  /// 로딩 상태 검증
  void loadingState() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// 에러 상태 검증
  ///
  /// [errorMessage] 예상 에러 메시지 (선택사항)
  void errorState({String? errorMessage}) {
    expect(find.byType(ErrorWidget), findsOneWidget);
    if (errorMessage != null) {
      expect(find.text(errorMessage), findsOneWidget);
    }
  }

  /// 빈 상태 검증
  ///
  /// [emptyMessage] 예상 빈 상태 메시지 (선택사항)
  void emptyState({String? emptyMessage}) {
    if (emptyMessage != null) {
      expect(find.text(emptyMessage), findsOneWidget);
    }
    // 일반적으로 리스트나 그리드가 비어있는지 확인
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(GridView), findsNothing);
  }
}
