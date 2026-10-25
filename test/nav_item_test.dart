import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/ui/nav_item.dart';
import 'package:simple_bank_flutter/ui/theme.dart';

void main() {
  group('NavItem widget tests', () {
    testWidgets('The number and label render correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: NavItem(
              number: 1,
              label: 'Check Balance',
              selected: false,
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Check Balance'), findsOneWidget);
    });

    testWidgets('Selected state displays primary fill, onPrimary text, and mint indicator bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: NavItem(
              number: 2,
              label: 'Deposit Money',
              selected: true,
            ),
          ),
        ),
      );

      // Check mint indicator bar exists
      final mintBarFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.color == AppColors.mint,
      );
      expect(mintBarFinder, findsOneWidget);

      // Check background fill is primary
      final primaryBgFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.color == AppColors.primary,
      );
      expect(primaryBgFinder, findsOneWidget);

      // Check label text style color is onPrimary
      final textWidget = tester.widget<Text>(find.text('Deposit Money'));
      expect(textWidget.style?.color, AppColors.onPrimary);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('Unselected state displays navText color and transparent indicator bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: NavItem(
              number: 3,
              label: 'Withdraw Money',
              selected: false,
            ),
          ),
        ),
      );

      // No mint bar
      final mintBarFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.color == AppColors.mint,
      );
      expect(mintBarFinder, findsNothing);

      // Check label text style color is navText
      final textWidget = tester.widget<Text>(find.text('Withdraw Money'));
      expect(textWidget.style?.color, AppColors.navText);
      expect(textWidget.style?.fontWeight, FontWeight.normal);
    });

    testWidgets('Hover state provides visual feedback with translucent tint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: Scaffold(
            body: NavItem(
              number: 4,
              label: 'View Transaction History',
              selected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // Initially unhovered: transparent
      final initialBgFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.color == Colors.white.withValues(alpha: 0.08),
      );
      expect(initialBgFinder, findsNothing);

      // Hover over NavItem
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(NavItem)));
      await tester.pumpAndSettle();

      // Now hovered: translucent white container appears
      final hoveredBgFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.color == Colors.white.withValues(alpha: 0.08),
      );
      expect(hoveredBgFinder, findsOneWidget);

      await gesture.removePointer();
    });

    testWidgets('Keyboard focus displays visible focus ring in AppColors.lavender', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: Scaffold(
            body: NavItem(
              number: 1,
              label: 'Check Balance',
              selected: false,
              focusNode: focusNode,
              onTap: () {},
            ),
          ),
        ),
      );

      // Initially unfocused: no focus ring
      final focusRingFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).border ==
                Border.all(color: AppColors.lavender, width: 2.0),
      );
      expect(focusRingFinder, findsNothing);

      // Request focus
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Focus ring is rendered
      expect(focusRingFinder, findsOneWidget);
    });

    testWidgets('Enter and Space keys activate the item', (
      WidgetTester tester,
    ) async {
      int tapCount = 0;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: Scaffold(
            body: NavItem(
              number: 1,
              label: 'Check Balance',
              selected: false,
              focusNode: focusNode,
              onTap: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Send Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(tapCount, 1);

      // Send Space key
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(tapCount, 2);
    });

    testWidgets('Tap gesture activates the item', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: Scaffold(
            body: NavItem(
              number: 5,
              label: 'Exit',
              selected: false,
              onTap: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NavItem));
      await tester.pumpAndSettle();
      expect(tapCount, 1);
    });

    testWidgets('Semantic information reflects label and selected state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: NavItem(
              number: 1,
              label: 'Check Balance',
              selected: true,
            ),
          ),
        ),
      );

      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Check Balance',
        ),
      );
      expect(semanticsWidget.properties.label, 'Check Balance');
      expect(semanticsWidget.properties.selected, isTrue);
      expect(semanticsWidget.properties.button, isTrue);
    });
  });
}
