import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/main.dart' as app;
import 'package:simple_bank_flutter/ui/widgets/amount_field.dart';
import 'package:simple_bank_flutter/ui/widgets/app_card.dart';
import 'package:simple_bank_flutter/ui/widgets/balance_chip.dart';
import 'package:simple_bank_flutter/ui/widgets/message_box.dart';
import 'package:simple_bank_flutter/ui/widgets/view_header.dart';

void main() {
  testWidgets('App launches with title, disabled debug banner, and temporary demo inside one AppCard', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    final MaterialApp materialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(materialApp.title, 'Simple Bank');
    expect(materialApp.debugShowCheckedModeBanner, isFalse);

    // Verify exactly one AppCard exists
    final appCardFinder = find.byType(AppCard);
    expect(appCardFinder, findsOneWidget);

    // Verify all 7 required components are inside the AppCard
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(ViewHeader)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(AmountField)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(FilledButton)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(OutlinedButton)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(BalanceChip)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: appCardFinder, matching: find.byType(MessageBox)),
      findsNWidgets(2),
    );

    // Verify error and success message boxes are both present
    expect(
      find.byWidgetPredicate(
        (w) => w is MessageBox && w.kind == MessageBoxKind.error,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is MessageBox && w.kind == MessageBoxKind.success,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Demo buttons and input field have functional interactions', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Type into the amount field
    await tester.enterText(textFieldFinder, '500.00');
    await tester.pumpAndSettle();
    expect(find.text('500.00'), findsOneWidget);

    // Tap Submit button
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Action submitted for \u20B1500.00.'), findsOneWidget);

    // Tap Clear button
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear'));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.controller!.text, '');
    expect(find.text('Field cleared.'), findsOneWidget);

    // Submit while empty triggers error state
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();

    final AmountField amountField = tester.widget<AmountField>(
      find.byType(AmountField),
    );
    expect(amountField.hasError, isTrue);
  });
}
