import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/bank_account.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';
import 'package:simple_bank_flutter/ui/home_page.dart';
import 'package:simple_bank_flutter/ui/nav_item.dart';
import 'package:simple_bank_flutter/ui/theme.dart';

void main() {
  group('Check Balance view', () {
    Future<void> pumpHome(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 680);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const HomePage()),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'shows the starting balance and the startup caption at launch',
      (WidgetTester tester) async {
        await pumpHome(tester);

        expect(find.text('Current balance'), findsOneWidget);
        expect(find.text(formatMoney(startingBalanceCentavos)), findsOneWidget);
        expect(
          find.text(
            'Account initialized. Current balance: '
            '${formatMoney(startingBalanceCentavos)}',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows the plain caption after leaving and coming back', (
      WidgetTester tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.widgetWithText(NavItem, 'Deposit Money'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NavItem, 'Check Balance'));
      await tester.pumpAndSettle();

      expect(
        find.text('Current balance: ${formatMoney(startingBalanceCentavos)}'),
        findsOneWidget,
      );
      expect(find.textContaining('Account initialized'), findsNothing);

      final dynamic state = tester.state(find.byType(HomePage));
      final BankAccount account = state.account as BankAccount;
      expect(account.transactions, isEmpty);
    });

    testWidgets(
      'keeps the startup caption when Check Balance is clicked while open',
      (WidgetTester tester) async {
        await pumpHome(tester);

        await tester.tap(find.widgetWithText(NavItem, 'Check Balance'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Account initialized'), findsOneWidget);
      },
    );

    testWidgets('updates when the account balance changes', (
      WidgetTester tester,
    ) async {
      await pumpHome(tester);

      final dynamic state = tester.state(find.byType(HomePage));
      final BankAccount account = state.account as BankAccount;
      account.deposit(100000);
      await tester.pump();

      expect(find.text(formatMoney(600000)), findsWidgets);
      expect(account.transactions.length, 1);
    });
  });
}
