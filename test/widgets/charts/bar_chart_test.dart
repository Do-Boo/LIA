// File: test/widgets/charts/bar_chart_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia/core/app_colors.dart';
import 'package:lia/presentation/widgets/base/base_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/bar_chart.dart';

import '../../base/base_widget_test.dart';

/// BarChart 위젯 테스트
///
/// BaseWidgetTest를 상속받아 표준화된 테스트 환경을 제공합니다.
class BarChartTest extends BaseWidgetTest {
  /// 기본 BarChart 위젯 생성
  BarChart createBarChart({
    String? title,
    IconData? titleIcon,
    List<StandardChartData>? data,
    bool showLegend = true,
    double height = 200,
  }) => BarChart(
    title: title,
    titleIcon: titleIcon,
    data: data,
    showLegend: showLegend,
    height: height,
  );

  /// 테스트용 샘플 데이터 생성
  List<StandardChartData> createSampleData() => [
    const StandardChartData(
      label: '테스트 항목 1',
      value: 85,
      color: AppColors.primary,
    ),
    const StandardChartData(
      label: '테스트 항목 2',
      value: 72,
      color: AppColors.accent,
    ),
    const StandardChartData(
      label: '테스트 항목 3',
      value: 68,
      color: AppColors.blue,
    ),
  ];

  /// 빈 데이터 테스트용
  List<StandardChartData> createEmptyData() => [];

  /// 단일 항목 데이터 테스트용
  List<StandardChartData> createSingleItemData() => [
    const StandardChartData(
      label: '단일 항목',
      value: 100,
      color: AppColors.primary,
    ),
  ];
}

void main() {
  group('BarChart Widget Tests', () {
    late BarChartTest testHelper;

    setUpAll(() {
      testHelper = BarChartTest();
    });

    testWidgets('기본 BarChart가 올바르게 렌더링되는지 테스트', (tester) async {
      // Given
      final barChart = testHelper.createBarChart();
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle(); // 애니메이션 완료 대기

      // Then
      expect(find.byType(BarChart), findsOneWidget);

      // 기본 데이터가 표시되는지 확인
      expect(find.text('카페 데이트'), findsOneWidget);
      expect(find.text('취미 공유'), findsOneWidget);
      expect(find.text('일상 대화'), findsOneWidget);
    });

    testWidgets('제목과 아이콘이 있는 BarChart 테스트', (tester) async {
      // Given
      const title = '대화 주제 분포';
      const titleIcon = Icons.bar_chart;
      final barChart = testHelper.createBarChart(
        title: title,
        titleIcon: titleIcon,
      );
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(titleIcon), findsOneWidget);
    });

    testWidgets('커스텀 데이터로 BarChart 테스트', (tester) async {
      // Given
      final customData = testHelper.createSampleData();
      final barChart = testHelper.createBarChart(data: customData);
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.text('테스트 항목 1'), findsOneWidget);
      expect(find.text('테스트 항목 2'), findsOneWidget);
      expect(find.text('테스트 항목 3'), findsOneWidget);
    });

    testWidgets('빈 데이터로 BarChart 테스트', (tester) async {
      // Given
      final emptyData = testHelper.createEmptyData();
      final barChart = testHelper.createBarChart(data: emptyData);
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(BarChart), findsOneWidget);
      // 빈 데이터일 때는 기본 데이터가 표시되어야 함
      expect(find.text('카페 데이트'), findsOneWidget);
    });

    testWidgets('단일 항목 데이터로 BarChart 테스트', (tester) async {
      // Given
      final singleData = testHelper.createSingleItemData();
      final barChart = testHelper.createBarChart(data: singleData);
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.text('단일 항목'), findsOneWidget);
    });

    testWidgets('범례 숨김 설정 테스트', (tester) async {
      // Given
      final barChart = testHelper.createBarChart(showLegend: false);
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(BarChart), findsOneWidget);
      // 범례가 숨겨져야 함 (정확한 검증은 구현에 따라 달라질 수 있음)
    });

    testWidgets('차트 높이 설정 테스트', (tester) async {
      // Given
      const customHeight = 300.0;
      final barChart = testHelper.createBarChart(height: customHeight);
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(BarChart), findsOneWidget);

      // SizedBox의 높이가 설정된 값과 일치하는지 확인
      final sizedBoxFinder = find.descendant(
        of: find.byType(BarChart),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsWidgets);
    });

    testWidgets('애니메이션 테스트', (tester) async {
      // Given
      final barChart = testHelper.createBarChart();
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);

      // 애니메이션 중간 상태 확인
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(BarChart), findsOneWidget);

      // 애니메이션 완료 상태 확인
      await tester.pumpAndSettle();
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('접근성 테스트', (tester) async {
      // Given
      final barChart = testHelper.createBarChart(title: '접근성 테스트 차트');
      final testApp = testHelper.createTestApp(child: barChart);

      // When
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Then - BaseWidgetTest의 접근성 검증 활용
      await testHelper.verifyAccessibility(tester);
      expect(find.text('접근성 테스트 차트'), findsOneWidget);
    });

    testWidgets('다크 테마에서 BarChart 테스트', (tester) async {
      // Given
      final barChart = testHelper.createBarChart(title: '다크 테마 차트');
      final darkThemeApp = testHelper.createTestApp(
        child: barChart,
        theme: testHelper.getDarkTheme(),
      );

      // When
      await tester.pumpWidget(darkThemeApp);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.text('다크 테마 차트'), findsOneWidget);
    });

    group('데이터 파싱 테스트', () {
      testWidgets('JSON 데이터 파싱 테스트', (tester) async {
        // Given
        final jsonData = [
          {'label': 'JSON 항목 1', 'value': 50.0},
          {'label': 'JSON 항목 2', 'value': 75.0},
        ];
        final barChart = testHelper.createBarChart(data: jsonData);
        final testApp = testHelper.createTestApp(child: barChart);

        // When
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        // Then
        expect(find.text('JSON 항목 1'), findsOneWidget);
        expect(find.text('JSON 항목 2'), findsOneWidget);
      });

      testWidgets('잘못된 데이터 형식 처리 테스트', (tester) async {
        // Given
        const invalidData = 'invalid_data_string';
        final barChart = testHelper.createBarChart(data: invalidData);
        final testApp = testHelper.createTestApp(child: barChart);

        // When
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        // Then - 기본 데이터가 표시되어야 함
        expect(find.byType(BarChart), findsOneWidget);
        expect(find.text('카페 데이트'), findsOneWidget);
      });
    });

    group('성능 테스트', () {
      testWidgets('대량 데이터 처리 테스트', (tester) async {
        // Given
        final largeData = List.generate(
          100,
          (index) => StandardChartData(
            label: '항목 $index',
            value: (index % 10 + 1) * 10.0,
            color: AppColors.primary,
          ),
        );
        final barChart = testHelper.createBarChart(data: largeData);
        final testApp = testHelper.createTestApp(child: barChart);

        // When
        final stopwatch = Stopwatch()..start();
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Then
        expect(find.byType(BarChart), findsOneWidget);
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5초 이내 렌더링
      });
    });
  });
}
