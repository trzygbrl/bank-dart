import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/bank_account.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';
import 'package:simple_bank_flutter/ui/theme.dart';
import 'package:simple_bank_flutter/ui/views/deposit_view.dart';

const Map<String, String> _invalidInputs = {
  '0': mustBePositiveMessage,
  '-50': mustBePositiveMessage,
  'abc': invalidNumberMessage,
  '': invalidNumberMessage,
  '1e3': invalidNumberMessage,
  '.5': invalidNumberMessage,
  '5.': invalidNumberMessage,
  '1,000': invalidNumberMessage,
  '10.999': maxTwoDecimalsMessage,
  '99999999999': tooLargeMessage,
};

Future<BankAccount> _pumpDeposit(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 680);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final BankAccount account = BankAccount();
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: DepositView(account: account)),
    ),
  );
  await tester.pumpAndSettle();
  return account;
}

String _fieldText(WidgetTester tester) {
  return tester.widget<TextField>(find.byType(TextField)).controller!.text;
}

Future<void> _enterAndDeposit(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.tap(find.widgetWithText(FilledButton, 'Deposit'));
  await tester.pump();
}

void main() {
  group('DepositView', () {
    testWidgets('shows the PRD layout text', (WidgetTester tester) async {
      await _pumpDeposit(tester);

      expect(find.text('Deposit Money'), findsOneWidget);
      expect(find.text('Add funds to your account'), findsOneWidget);
      expect(find.text('Deposit details'), findsOneWidget);
      expect(
        find.text('Available balance ${formatMoney(startingBalanceCentavos)}'),
        findsOneWidget,
      );
      expect(find.text('Amount'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Deposit'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Clear'), findsOneWidget);
    });

    testWidgets('a valid deposit updates the balance, history and field', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpDeposit(tester);

      await _enterAndDeposit(tester, '1000');

      expect(
        find.text('Deposit successful. New balance: ${formatMoney(600000)}'),
        findsOneWidget,
      );
      expect(_fieldText(tester), isEmpty);
      expect(account.balance, 600000);
      expect(account.transactions.length, 1);
      expect(
        find.text('Available balance ${formatMoney(600000)}'),
        findsOneWidget,
      );
    });

    testWidgets('surrounding spaces are trimmed', (WidgetTester tester) async {
      final BankAccount account = await _pumpDeposit(tester);

      await _enterAndDeposit(tester, ' 500 ');

      expect(account.balance, 550000);
      expect(account.transactions.length, 1);
    });

    testWidgets('two decimal places are accepted', (WidgetTester tester) async {
      final BankAccount account = await _pumpDeposit(tester);

      await _enterAndDeposit(tester, '250.75');

      expect(account.balance, 525075);
    });

    for (final MapEntry<String, String> entry in _invalidInputs.entries) {
      testWidgets("rejects '${entry.key}' with the exact PRD message", (
        WidgetTester tester,
      ) async {
        final BankAccount account = await _pumpDeposit(tester);

        await _enterAndDeposit(tester, entry.key);

        expect(find.text(entry.value), findsOneWidget);
        expect(account.balance, startingBalanceCentavos);
        expect(account.transactions, isEmpty);
      });
    }

    testWidgets('keeps the typed text after an error', (
      WidgetTester tester,
    ) async {
      await _pumpDeposit(tester);

      await _enterAndDeposit(tester, 'abc');

      expect(_fieldText(tester), 'abc');
    });

    testWidgets('pressing Enter submits the deposit', (
      WidgetTester tester,
    ) async {
      final BankAccount account = await _pumpDeposit(tester);

      await tester.enterText(find.byType(TextField), '250.75');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(account.balance, 525075);
      expect(account.transactions.length, 1);
    });

    testWidgets('Clear empties the field and the message', (
      WidgetTester tester,
    ) async {
      await _pumpDeposit(tester);

      await _enterAndDeposit(tester, 'abc');
      expect(find.text(invalidNumberMessage), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Clear'));
      await tester.pump();

      expect(_fieldText(tester), isEmpty);
      expect(find.text(invalidNumberMessage), findsNothing);
    });

    testWidgets('editing the field clears the message', (
      WidgetTester tester,
    ) async {
      await _pumpDeposit(tester);

      await _enterAndDeposit(tester, 'abc');
      expect(find.text(invalidNumberMessage), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'abcd');
      await tester.pump();

      expect(find.text(invalidNumberMessage), findsNothing);
    });
  });
}
