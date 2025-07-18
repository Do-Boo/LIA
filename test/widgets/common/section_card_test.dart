// File: test/widgets/common/section_card_test.dart
// SectionCard 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia/presentation/widgets/common/section_card.dart';

void main() {
  group('SectionCard Widget Tests', () {
    testWidgets('SectionCard displays all required elements', (tester) async {
      // Arrange
      const testNumber = '1';
      const testTitle = 'Test Title';
      const testDescription = 'Test Description';
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('SectionCard shows number badge when showNumber is true', (
      tester,
    ) async {
      // Arrange
      const testNumber = '2';
      const testTitle = 'Test Title';
      const testDescription = 'Test Description';
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsOneWidget);

      // 번호 뱃지 컨테이너 확인
      final numberBadge = find.byType(Container).first;
      expect(numberBadge, findsOneWidget);
    });

    testWidgets('SectionCard hides number badge when showNumber is false', (
      tester,
    ) async {
      // Arrange
      const testNumber = '3';
      const testTitle = 'Test Title';
      const testDescription = 'Test Description';
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              showNumber: false,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsNothing);
    });

    testWidgets('SimpleSectionCard works correctly', (tester) async {
      // Arrange
      const testTitle = 'Simple Title';
      const testDescription = 'Simple Description';
      const testChild = Text('Simple Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SimpleSectionCard(
              title: testTitle,
              description: testDescription,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Simple Child'), findsOneWidget);

      // 번호가 표시되지 않아야 함
      expect(find.text(''), findsNothing);
    });

    testWidgets('SectionCard applies custom styling correctly', (tester) async {
      // Arrange
      const testNumber = '4';
      const testTitle = 'Styled Title';
      const testDescription = 'Styled Description';
      const testChild = Text('Styled Child');
      const customBackgroundColor = Colors.red;
      const customBorderColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              backgroundColor: customBackgroundColor,
              borderColor: customBorderColor,
              showShadow: false,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Styled Child'), findsOneWidget);

      // 커스텀 스타일이 적용되었는지 확인
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, customBackgroundColor);
      expect(decoration.border?.top.color, customBorderColor);
      expect(decoration.boxShadow, isNull); // showShadow: false
    });

    testWidgets('SectionCard handles responsive design correctly', (
      tester,
    ) async {
      // Arrange
      const testNumber = '5';
      const testTitle = 'Responsive Title';
      const testDescription = 'Responsive Description';
      const testChild = Text('Responsive Child');

      // Act - 태블릿 크기로 테스트
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Responsive Child'), findsOneWidget);

      // 화면 크기 복원
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('SectionCard handles custom margins and padding', (
      tester,
    ) async {
      // Arrange
      const testNumber = '6';
      const testTitle = 'Margin Title';
      const testDescription = 'Margin Description';
      const testChild = Text('Margin Child');
      const customPadding = EdgeInsets.all(24);
      const customMargin = EdgeInsets.all(16);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              number: testNumber,
              title: testTitle,
              description: testDescription,
              padding: customPadding,
              margin: customMargin,
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testNumber), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Margin Child'), findsOneWidget);

      // 패딩과 마진이 적용되었는지 확인
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, customPadding);
      expect(container.margin, customMargin);
    });
  });
}
