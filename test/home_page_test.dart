import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/bank_account.dart';
import 'package:simple_bank_flutter/ui/home_page.dart';
import 'package:simple_bank_flutter/ui/nav_item.dart';
import 'package:simple_bank_flutter/ui/theme.dart';
import 'package:simple_bank_flutter/ui/widgets/view_header.dart';

void main() {
  group('HomePage widget tests', () {
    testWidgets(
      'HomePage launches successfully with Check Balance selected initially',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        // Check branding
        expect(find.text('Simple Bank'), findsOneWidget);
        expect(find.text('Personal Banking'), findsOneWidget);

        // 5 NavItems
        final navItemWidgets = tester
            .widgetList<NavItem>(find.byType(NavItem))
            .toList();
        expect(navItemWidgets.length, 5);

        // Item 1 Check Balance is selected
        expect(navItemWidgets[0].selected, isTrue);
        expect(navItemWidgets[0].label, 'Check Balance');

        // Other items are not selected
        expect(navItemWidgets[1].selected, isFalse);
        expect(navItemWidgets[2].selected, isFalse);
        expect(navItemWidgets[3].selected, isFalse);
        expect(navItemWidgets[4].selected, isFalse);

        // Check placeholder header
        expect(
          find.widgetWithText(ViewHeader, 'Check Balance'),
          findsOneWidget,
        );
        expect(find.text('Your account at a glance'), findsOneWidget);
      },
    );

    testWidgets(
      'Navigation items 1 to 4 switch views and update selected state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        // Switch to Item 2: Deposit Money
        await tester.tap(find.widgetWithText(NavItem, 'Deposit Money'));
        await tester.pumpAndSettle();

        var navItems = tester
            .widgetList<NavItem>(find.byType(NavItem))
            .toList();
        expect(navItems[0].selected, isFalse);
        expect(navItems[1].selected, isTrue);
        expect(navItems[2].selected, isFalse);
        expect(navItems[3].selected, isFalse);
        expect(navItems[4].selected, isFalse);
        expect(
          find.widgetWithText(ViewHeader, 'Deposit Money'),
          findsOneWidget,
        );
        expect(find.text('Add funds to your account'), findsOneWidget);

        // Switch to Item 3: Withdraw Money
        await tester.tap(find.widgetWithText(NavItem, 'Withdraw Money'));
        await tester.pumpAndSettle();

        navItems = tester.widgetList<NavItem>(find.byType(NavItem)).toList();
        expect(navItems[1].selected, isFalse);
        expect(navItems[2].selected, isTrue);
        expect(
          find.widgetWithText(ViewHeader, 'Withdraw Money'),
          findsOneWidget,
        );
        expect(find.text('Take funds from your account'), findsOneWidget);

        // Switch to Item 4: View Transaction History
        await tester.tap(
          find.widgetWithText(NavItem, 'View Transaction History'),
        );
        await tester.pumpAndSettle();

        navItems = tester.widgetList<NavItem>(find.byType(NavItem)).toList();
        expect(navItems[2].selected, isFalse);
        expect(navItems[3].selected, isTrue);
        expect(
          find.widgetWithText(ViewHeader, 'Transaction History'),
          findsOneWidget,
        );
        expect(
          find.text('All successful deposits and withdrawals'),
          findsOneWidget,
        );

        // Switch back to Item 1: Check Balance
        await tester.tap(find.widgetWithText(NavItem, 'Check Balance'));
        await tester.pumpAndSettle();

        navItems = tester.widgetList<NavItem>(find.byType(NavItem)).toList();
        expect(navItems[0].selected, isTrue);
        expect(navItems[3].selected, isFalse);
        expect(
          find.widgetWithText(ViewHeader, 'Check Balance'),
          findsOneWidget,
        );
        expect(find.text('Your account at a glance'), findsOneWidget);
      },
    );

    testWidgets('Ctrl+1 through Ctrl+5 shortcuts work across views', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const HomePage()),
      );
      await tester.pumpAndSettle();

      await _pressControlShortcut(tester, LogicalKeyboardKey.digit2);
      expect(find.text('Add funds to your account'), findsOneWidget);

      await _pressControlShortcut(tester, LogicalKeyboardKey.digit3);
      expect(find.text('Take funds from your account'), findsOneWidget);

      await _pressControlShortcut(tester, LogicalKeyboardKey.digit4);
      expect(
        find.text('All successful deposits and withdrawals'),
        findsOneWidget,
      );

      await _pressControlShortcut(tester, LogicalKeyboardKey.digit1);
      expect(find.text('Your account at a glance'), findsOneWidget);

      await _pressControlShortcut(tester, LogicalKeyboardKey.digit5);
      expect(find.text('Exit Simple Bank'), findsOneWidget);
      await tester.tap(find.text('Stay'));
      await tester.pumpAndSettle();
      expect(find.text('Your account at a glance'), findsOneWidget);
    });

    testWidgets(
      'Ctrl shortcuts work in AmountField while unmodified digits remain text input',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        await _pressControlShortcut(tester, LogicalKeyboardKey.digit2);
        final Finder amountField = find.byType(TextField);
        await tester.tap(amountField);
        await tester.enterText(amountField, '1');
        expect(tester.widget<TextField>(amountField).controller!.text, '1');

        await _pressControlShortcut(tester, LogicalKeyboardKey.digit3);
        expect(find.text('Take funds from your account'), findsOneWidget);
      },
    );

    testWidgets('Exit item is never highlighted as selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const HomePage()),
      );
      await tester.pumpAndSettle();

      final navItems = tester
          .widgetList<NavItem>(find.byType(NavItem))
          .toList();
      final exitItem = navItems.firstWhere((item) => item.label == 'Exit');
      expect(exitItem.selected, isFalse);
    });

    testWidgets(
      'Sidebar and content area render without layout overflow at 1000x680 and 860x560',
      (WidgetTester tester) async {
        // Set to PRD standard size: 1000 x 680
        tester.view.physicalSize = const Size(1000, 680);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Resize to minimum specified desktop size: 860 x 560
        tester.view.physicalSize = const Size(860, 560);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Content area can scroll when available height is constrained',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(860, 250);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        final scrollViewFinder = find.descendant(
          of: find.byType(Expanded),
          matching: find.byType(SingleChildScrollView),
        );
        expect(scrollViewFinder, findsOneWidget);

        // Verify we can drag/scroll without errors
        await tester.drag(scrollViewFinder, const Offset(0, -50));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'BankAccount instance is retained and not recreated across view switches',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        final dynamic state = tester.state(find.byType(HomePage));
        final BankAccount initialAccount = state.account as BankAccount;
        expect(initialAccount.balance, 500000);

        // Switch views
        await tester.tap(find.widgetWithText(NavItem, 'Deposit Money'));
        await tester.pumpAndSettle();
        expect(state.account, same(initialAccount));

        await tester.tap(find.widgetWithText(NavItem, 'Withdraw Money'));
        await tester.pumpAndSettle();
        expect(state.account, same(initialAccount));

        await tester.tap(
          find.widgetWithText(NavItem, 'View Transaction History'),
        );
        await tester.pumpAndSettle();
        expect(state.account, same(initialAccount));

        await tester.tap(find.widgetWithText(NavItem, 'Check Balance'));
        await tester.pumpAndSettle();
        expect(state.account, same(initialAccount));
      },
    );
  });

  group('Exit Confirmation Dialog tests', () {
    testWidgets(
      'Clicking Exit opens confirmation dialog with required text and buttons',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(), home: const HomePage()),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(NavItem, 'Exit'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Exit Simple Bank'), findsOneWidget);
        expect(
          find.text(
            'Thank you for banking with us. Are you sure you want to exit?',
          ),
          findsOneWidget,
        );
        expect(find.widgetWithText(OutlinedButton, 'Stay'), findsOneWidget);
        expect(find.widgetWithText(FilledButton, 'Exit'), findsOneWidget);
      },
    );

    testWidgets(
      'Clicking Stay closes the dialog and keeps the application running',
      (WidgetTester tester) async {
        int? exitCode;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            home: HomePage(onExit: (code) => exitCode = code),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(NavItem, 'Exit'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.widgetWithText(OutlinedButton, 'Stay'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(exitCode, isNull);
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'Pressing Escape dismisses the dialog without terminating the app',
      (WidgetTester tester) async {
        int? exitCode;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            home: HomePage(onExit: (code) => exitCode = code),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(NavItem, 'Exit'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(exitCode, isNull);
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'Clicking outside barrier dismisses dialog without terminating the app',
      (WidgetTester tester) async {
        int? exitCode;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            home: HomePage(onExit: (code) => exitCode = code),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(NavItem, 'Exit'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap on modal barrier outside dialog content
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(exitCode, isNull);
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'Clicking Exit button in dialog invokes exit callback with code 0',
      (WidgetTester tester) async {
        int? exitCode;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            home: HomePage(onExit: (code) => exitCode = code),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(NavItem, 'Exit'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap Exit button inside the AlertDialog
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.widgetWithText(FilledButton, 'Exit'),
          ),
        );
        await tester.pumpAndSettle();

        expect(exitCode, 0);
      },
    );

    testWidgets('Simulated exit request returns cancel when Stay is clicked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const HomePage()),
      );
      await tester.pumpAndSettle();

      // Dispatch handleExitRequested directly or via ServicesBinding
      final binding = TestWidgetsFlutterBinding.instance;
      final exitFuture = binding.handleRequestAppExit();
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.byType(AlertDialog), findsOneWidget);

      // Click Stay
      await tester.tap(find.widgetWithText(OutlinedButton, 'Stay'));
      await tester.pumpAndSettle();

      final response = await exitFuture;
      expect(response, AppExitResponse.cancel);
    });

    testWidgets('Simulated exit request returns exit when Exit is clicked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const HomePage()),
      );
      await tester.pumpAndSettle();

      final binding = TestWidgetsFlutterBinding.instance;
      final exitFuture = binding.handleRequestAppExit();
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.byType(AlertDialog), findsOneWidget);

      // Click Exit
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Exit'),
        ),
      );
      await tester.pumpAndSettle();

      final response = await exitFuture;
      expect(response, AppExitResponse.exit);
    });
  });
}

Future<void> _pressControlShortcut(
  WidgetTester tester,
  LogicalKeyboardKey key,
) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyDownEvent(key);
  await tester.sendKeyUpEvent(key);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pumpAndSettle();
}
