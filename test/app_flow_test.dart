import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/main.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';
import 'package:simple_bank_flutter/ui/nav_item.dart';
import 'package:simple_bank_flutter/ui/theme.dart';

void main() {
  testWidgets('complete banking session from launch through Exit and Stay', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 680);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SimpleBankApp());
    await tester.pumpAndSettle();

    final String startingBalance = formatMoney(500000);
    final String depositedBalance = formatMoney(600000);
    final String withdrawnBalance = formatMoney(349950);
    final String depositAmount = formatMoney(100000);
    final String withdrawalAmount = formatMoney(250050);

    expect(find.text(startingBalance), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('by JAKLAT Inc.')).style!.fontSize,
      14,
    );
    expect(
      find.text('Account initialized. Current balance: $startingBalance'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(NavItem, 'View Transaction History'));
    await tester.pumpAndSettle();
    expect(find.text('No transactions yet.'), findsOneWidget);
    expect(find.text('No.'), findsNothing);

    await tester.tap(find.widgetWithText(NavItem, 'Deposit Money'));
    await tester.pumpAndSettle();
    final Finder amountField = find.byType(TextField);
    await tester.enterText(amountField, '1000');
    await tester.tap(find.widgetWithText(FilledButton, 'Deposit'));
    await tester.pumpAndSettle();

    expect(
      find.text('Deposit successful. New balance: $depositedBalance'),
      findsOneWidget,
    );
    expect(tester.widget<TextField>(amountField).controller!.text, isEmpty);
    expect(find.text('Available balance $depositedBalance'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavItem, 'Withdraw Money'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '9000');
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Insufficient funds. Your balance is $depositedBalance; '
        'you cannot withdraw ${formatMoney(900000)}.',
      ),
      findsOneWidget,
    );
    expect(find.text('Available balance $depositedBalance'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2500.50');
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pumpAndSettle();

    expect(
      find.text('Withdrawal successful. New balance: $withdrawnBalance'),
      findsOneWidget,
    );
    expect(find.text('Available balance $withdrawnBalance'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavItem, 'View Transaction History'));
    await tester.pumpAndSettle();

    final Finder transactionRows = find.byType(ListView);
    expect(find.text('2 transaction(s)'), findsOneWidget);
    expect(find.text('No.'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Balance After'), findsOneWidget);
    expect(
      find.descendant(of: transactionRows, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: transactionRows, matching: find.text('Deposit')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: transactionRows, matching: find.text(depositAmount)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: transactionRows,
        matching: find.text(depositedBalance),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: transactionRows, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: transactionRows, matching: find.text('Withdrawal')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: transactionRows,
        matching: find.text(withdrawalAmount),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: transactionRows,
        matching: find.text(withdrawnBalance),
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: transactionRows,
              matching: find.text('Deposit'),
            ),
          )
          .style!
          .color,
      AppColors.success,
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(
              of: transactionRows,
              matching: find.text('Withdrawal'),
            ),
          )
          .style!
          .color,
      AppColors.withdrawal,
    );

    final double depositRowY = tester
        .getTopLeft(
          find.descendant(of: transactionRows, matching: find.text('Deposit')),
        )
        .dy;
    final double withdrawalRowY = tester
        .getTopLeft(
          find.descendant(
            of: transactionRows,
            matching: find.text('Withdrawal'),
          ),
        )
        .dy;
    expect(depositRowY, lessThan(withdrawalRowY));

    await tester.tap(find.widgetWithText(NavItem, 'Exit'));
    await tester.pumpAndSettle();
    expect(find.text('Exit SimplyBank'), findsOneWidget);
    expect(
      find.text(
        'Thank you for banking with us. Are you sure you want to exit?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Stay'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SimpleBankApp), findsOneWidget);
    expect(find.widgetWithText(NavItem, 'Exit'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavItem, 'Check Balance'));
    await tester.pumpAndSettle();
    expect(find.text(withdrawnBalance), findsOneWidget);
  });

  testWidgets('TC-16 records only successful deposit and withdrawal attempts', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 680);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SimpleBankApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavItem, 'Deposit Money'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '3000');
    await tester.tap(find.widgetWithText(FilledButton, 'Deposit'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavItem, 'Withdraw Money'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '2500.50');
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'abc');
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Invalid input. Please enter a numeric amount '
        '(e.g., 500 or 250.75).',
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), '6000');
    await tester.tap(find.widgetWithText(FilledButton, 'Withdraw'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Insufficient funds. Your balance is ${formatMoney(549950)}; '
        'you cannot withdraw ${formatMoney(600000)}.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(NavItem, 'View Transaction History'));
    await tester.pumpAndSettle();
    expect(find.text('2 transaction(s)'), findsOneWidget);
    expect(find.text(formatMoney(300000)), findsOneWidget);
    expect(find.text(formatMoney(800000)), findsOneWidget);
    expect(find.text(formatMoney(250050)), findsOneWidget);
    expect(find.text(formatMoney(549950)), findsOneWidget);
    expect(
      find.descendant(of: find.byType(ListView), matching: find.text('3')),
      findsNothing,
    );
  });
}
