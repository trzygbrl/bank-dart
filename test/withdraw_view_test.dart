import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/bank_account.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';
import 'package:simple_bank_flutter/ui/theme.dart';
import 'package:simple_bank_flutter/ui/views/withdraw_view.dart';

Future<BankAccount> _pumpWithdraw(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 680);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final BankAccount account = BankAccount();
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: WithdrawView(account: account)),
    ),
  );
  await tester.pumpAndSettle();
  return account;
}

String _fieldText(WidgetTester tester) {
  return tester.widget<TextField>(find.byType(TextField)).controller!.text;
}

Future<void> _enterAndWithdraw(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
  await tester.pump();
}

void main() {
  group('WithdrawView', () {
    testWidgets('shows the PRD layout text', (WidgetTester tester) async {
      await _pumpWithdraw(tester);

      expect(find.text('Withdraw Money'), findsOneWidget);
      expect(find.text('Take funds from your account'), findsOneWidget);
      expect(find.text('Withdrawal details'), findsOneWidget);
      expect(
        find.text('Available balance ${formatMoney(startingBalanceCentavos)}'),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Withdraw'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Clear'), findsOneWidget);
    });

    testWidgets('withdrawing 2000 from the starting balance leaves 3,000.00', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpWithdraw(tester);

      await _enterAndWithdraw(tester, '2000');

      expect(
        find.text(
          'Withdrawal successful. New balance: ${formatMoney(300000)}',
        ),
        findsOneWidget,
      );
      expect(_fieldText(tester), isEmpty);
      expect(account.balance, 300000);
      expect(account.transactions.length, 1);
      expect(
        find.text('Available balance ${formatMoney(300000)}'),
        findsOneWidget,
      );
    });

    testWidgets('withdrawing the whole balance leaves 0.00', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpWithdraw(tester);

      await _enterAndWithdraw(tester, '5000');

      expect(
        find.text('Withdrawal successful. New balance: ${formatMoney(0)}'),
        findsOneWidget,
      );
      expect(account.balance, 0);
      expect(account.transactions.length, 1);
    });

    testWidgets('withdrawing more than the balance is refused', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpWithdraw(tester);

      await _enterAndWithdraw(tester, '5000.01');

      expect(
        find.text(
          'Insufficient funds. Your balance is '
          '${formatMoney(startingBalanceCentavos)}; '
          'you cannot withdraw ${formatMoney(500001)}.',
        ),
        findsOneWidget,
      );
      expect(_fieldText(tester), '5000.01');
      expect(account.balance, startingBalanceCentavos);
      expect(account.transactions, isEmpty);
    });

    testWidgets('invalid input shows the same errors as deposit', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpWithdraw(tester);

      await _enterAndWithdraw(tester, '0');
      expect(find.text(mustBePositiveMessage), findsOneWidget);

      await _enterAndWithdraw(tester, '-1');
      expect(find.text(mustBePositiveMessage), findsOneWidget);

      await _enterAndWithdraw(tester, 'abc');
      expect(find.text(invalidNumberMessage), findsOneWidget);

      expect(account.balance, startingBalanceCentavos);
      expect(account.transactions, isEmpty);
    });

    testWidgets('Clear empties the field and the message', (
      WidgetTester tester,
    ) async {
      await _pumpWithdraw(tester);

      await _enterAndWithdraw(tester, 'abc');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Clear'));
      await tester.pump();

      expect(_fieldText(tester), isEmpty);
      expect(find.text(invalidNumberMessage), findsNothing);
    });
  });
}
