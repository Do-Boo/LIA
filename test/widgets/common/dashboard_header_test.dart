// File: test/widgets/common/dashboard_header_test.dart
// DashboardHeader 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lia/presentation/widgets/common/dashboard_header.dart';

void main() {
  group('DashboardHeader Widget Tests', () {
    testWidgets('DashboardHeader displays basic elements', (tester) async {
      // Arrange
      const testTitle = 'Test Title';
      const testSubtitle = 'Test Subtitle';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardHeader(title: testTitle, subtitle: testSubtitle),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
    });

    testWidgets('DashboardHeader displays icon when provided', (tester) async {
      // Arrange
      const testTitle = 'Test Title';
      const testSubtitle = 'Test Subtitle';
      const testIcon = HugeIcons.strokeRoundedHome01;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              icon: testIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('DashboardHeader displays action buttons when provided', (
      tester,
    ) async {
      // Arrange
      const testTitle = 'Test Title';
      const testSubtitle = 'Test Subtitle';
      bool action1Pressed = false;
      bool action2Pressed = false;

      final testActions = [
        DashboardAction(
          title: 'Action 1',
          icon: HugeIcons.strokeRoundedAdd01,
          onTap: () => action1Pressed = true,
        ),
        DashboardAction(
          title: 'Action 2',
          icon: HugeIcons.strokeRoundedEdit01,
          onTap: () => action2Pressed = true,
        ),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              actions: testActions,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
      expect(find.byIcon(HugeIcons.strokeRoundedAdd01), findsOneWidget);
      expect(find.byIcon(HugeIcons.strokeRoundedEdit01), findsOneWidget);

      // 액션 버튼 탭 테스트
      await tester.tap(find.text('Action 1'));
      await tester.pump();
      expect(action1Pressed, isTrue);

      await tester.tap(find.text('Action 2'));
      await tester.pump();
      expect(action2Pressed, isTrue);
    });

    testWidgets('SimpleDashboardHeader works correctly', (tester) async {
      // Arrange
      const testTitle = 'Simple Title';
      const testSubtitle = 'Simple Subtitle';
      const testIcon = HugeIcons.strokeRoundedUser;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SimpleDashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              icon: testIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.byIcon(testIcon), findsOneWidget);

      // 액션 버튼이 없어야 함
      expect(find.text('Action'), findsNothing);
    });

    testWidgets('IconDashboardHeader works correctly', (tester) async {
      // Arrange
      const testTitle = 'Icon Title';
      const testSubtitle = 'Icon Subtitle';
      const testIcon = HugeIcons.strokeRoundedAnalytics01;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IconDashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              headerIcon: testIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('DashboardHeader applies custom gradient correctly', (
      tester,
    ) async {
      // Arrange
      const testTitle = 'Gradient Title';
      const testSubtitle = 'Gradient Subtitle';
      const customGradient = LinearGradient(
        colors: [Colors.red, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              gradient: customGradient,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);

      // 커스텀 그라데이션이 적용되었는지 확인
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.gradient, customGradient);
    });

    testWidgets('DashboardHeader handles custom height and padding', (
      tester,
    ) async {
      // Arrange
      const testTitle = 'Custom Title';
      const testSubtitle = 'Custom Subtitle';
      const customHeight = 200.0;
      const customPadding = EdgeInsets.all(32);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              height: customHeight,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);

      // 커스텀 높이와 패딩이 적용되었는지 확인
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, customHeight);
      expect(container.padding, customPadding);
    });

    testWidgets('DashboardAction handles null onTap correctly', (tester) async {
      // Arrange
      const testTitle = 'Action Title';
      const testSubtitle = 'Action Subtitle';

      final testActions = [
        const DashboardAction(
          title: 'No Action',
          icon: HugeIcons.strokeRoundedInformationCircle,
        ),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              actions: testActions,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);
      expect(find.text('No Action'), findsOneWidget);
      expect(
        find.byIcon(HugeIcons.strokeRoundedInformationCircle),
        findsOneWidget,
      );

      // null onTap이어도 위젯이 정상적으로 렌더링되어야 함
      await tester.tap(find.text('No Action'));
      await tester.pump();
      // 에러가 발생하지 않아야 함
    });

    testWidgets('DashboardHeader handles empty actions list', (tester) async {
      // Arrange
      const testTitle = 'Empty Actions Title';
      const testSubtitle = 'Empty Actions Subtitle';
      const List<DashboardAction> emptyActions = [];

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              title: testTitle,
              subtitle: testSubtitle,
              actions: emptyActions,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);

      // 액션 버튼이 표시되지 않아야 함
      expect(find.text('Action'), findsNothing);
    });

    testWidgets(
      'DashboardHeader handles multiple actions with proper spacing',
      (tester) async {
        // Arrange
        const testTitle = 'Multiple Actions Title';
        const testSubtitle = 'Multiple Actions Subtitle';

        final testActions = [
          DashboardAction(
            title: 'First',
            icon: HugeIcons.strokeRoundedAdd01,
            onTap: () {},
          ),
          DashboardAction(
            title: 'Second',
            icon: HugeIcons.strokeRoundedEdit01,
            onTap: () {},
          ),
          DashboardAction(
            title: 'Third',
            icon: HugeIcons.strokeRoundedDelete01,
            onTap: () {},
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DashboardHeader(
                title: testTitle,
                subtitle: testSubtitle,
                actions: testActions,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(testTitle), findsOneWidget);
        expect(find.text(testSubtitle), findsOneWidget);
        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsOneWidget);
        expect(find.text('Third'), findsOneWidget);

        // 모든 액션 아이콘이 표시되어야 함
        expect(find.byIcon(HugeIcons.strokeRoundedAdd01), findsOneWidget);
        expect(find.byIcon(HugeIcons.strokeRoundedEdit01), findsOneWidget);
        expect(find.byIcon(HugeIcons.strokeRoundedDelete01), findsOneWidget);
      },
    );
  });
}
