import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';
import 'package:simple_bank_flutter/ui/theme.dart';
import 'package:simple_bank_flutter/ui/widgets/amount_field.dart';
import 'package:simple_bank_flutter/ui/widgets/app_card.dart';
import 'package:simple_bank_flutter/ui/widgets/balance_chip.dart';
import 'package:simple_bank_flutter/ui/widgets/message_box.dart';
import 'package:simple_bank_flutter/ui/widgets/view_header.dart';

void main() {
  Widget wrapWidget(Widget child) {
    return MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('AppCard', () {
    testWidgets(
      'renders child with default 24px padding and surface decoration',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWidget(const AppCard(child: Text('Card Content'))),
        );

        expect(find.text('Card Content'), findsOneWidget);

        final containerFinder = find.byType(Container);
        expect(containerFinder, findsOneWidget);

        final container = tester.widget<Container>(containerFinder);
        expect(container.padding, const EdgeInsets.all(AppSpacing.sp24));

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, AppColors.surface);
        expect(
          decoration.borderRadius,
          BorderRadius.circular(AppSpacing.radiusCard),
        );
        expect(
          decoration.border,
          Border.all(color: AppColors.border, width: 1.0),
        );
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, 1);
        expect(decoration.boxShadow!.first.color, AppColors.cardShadow);
        expect(decoration.boxShadow!.first.blurRadius, 12.0);
        expect(decoration.boxShadow!.first.offset, const Offset(0, 2));
      },
    );

    testWidgets('respects custom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const AppCard(
            padding: EdgeInsets.all(8.0),
            child: Text('Custom Padding'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(8.0));
    });
  });

  group('ViewHeader', () {
    testWidgets(
      'displays title and subtitle with correct text styles and spacing',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWidget(
            const ViewHeader(title: 'Test Title', subtitle: 'Test Subtitle'),
          ),
        );

        final titleFinder = find.text('Test Title');
        final subtitleFinder = find.text('Test Subtitle');

        expect(titleFinder, findsOneWidget);
        expect(subtitleFinder, findsOneWidget);

        final titleText = tester.widget<Text>(titleFinder);
        expect(titleText.style, AppText.viewTitle);

        final subtitleText = tester.widget<Text>(subtitleFinder);
        expect(subtitleText.style, AppText.subtitle);

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(bottom: AppSpacing.sp24));
      },
    );
  });

  group('AmountField', () {
    testWidgets('displays currency prefix, hint, and has 44px height', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        wrapWidget(
          AmountField(
            controller: controller,
            focusNode: focusNode,
            hasError: false,
            semanticsLabel: 'Amount to deposit',
          ),
        ),
      );

      expect(find.text(currencySymbol), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);

      final size = tester.getSize(find.byType(AmountField));
      expect(size.height, AppSpacing.fieldHeight);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('accepts input and invokes callbacks', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String changedValue = '';
      String submittedValue = '';

      await tester.pumpWidget(
        wrapWidget(
          AmountField(
            controller: controller,
            focusNode: focusNode,
            hasError: false,
            semanticsLabel: 'Amount to deposit',
            onChanged: (val) => changedValue = val,
            onSubmitted: (val) => submittedValue = val,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '250.75');
      expect(controller.text, '250.75');
      expect(changedValue, '250.75');

      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submittedValue, '250.75');

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('changes border color when hasError changes', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      // Normal state (hasError = false)
      await tester.pumpWidget(
        wrapWidget(
          AmountField(
            controller: controller,
            focusNode: focusNode,
            hasError: false,
            semanticsLabel: 'Amount to deposit',
          ),
        ),
      );

      TextField textField = tester.widget<TextField>(find.byType(TextField));
      OutlineInputBorder normalBorder =
          textField.decoration!.enabledBorder as OutlineInputBorder;
      expect(normalBorder.borderSide.color, AppColors.border);
      expect(normalBorder.borderSide.width, 1.0);

      // Error state (hasError = true)
      await tester.pumpWidget(
        wrapWidget(
          AmountField(
            controller: controller,
            focusNode: focusNode,
            hasError: true,
            semanticsLabel: 'Amount to deposit',
          ),
        ),
      );

      textField = tester.widget<TextField>(find.byType(TextField));
      OutlineInputBorder errorBorder =
          textField.decoration!.enabledBorder as OutlineInputBorder;
      expect(errorBorder.borderSide.color, AppColors.error);
      expect(errorBorder.borderSide.width, 1.0);

      OutlineInputBorder focusedBorder =
          textField.decoration!.focusedBorder as OutlineInputBorder;
      expect(focusedBorder.borderSide.color, AppColors.error);
      expect(focusedBorder.borderSide.width, 2.0);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('exposes semantics label for accessibility', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        wrapWidget(
          AmountField(
            controller: controller,
            focusNode: focusNode,
            hasError: false,
            semanticsLabel: 'Amount to deposit',
          ),
        ),
      );

      expect(find.bySemanticsLabel('Amount to deposit'), findsOneWidget);

      controller.dispose();
      focusNode.dispose();
    });
  });

  group('MessageBox', () {
    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const MessageBox(
            kind: MessageBoxKind.error,
            text: 'Amount must be greater than zero.',
          ),
        ),
      );

      final textFinder = find.text('Amount must be greater than zero.');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style!.color, AppColors.error);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.errorBg);
      expect(decoration.border, Border.all(color: AppColors.error, width: 1.0));
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppSpacing.radiusControl),
      );
      expect(container.padding, const EdgeInsets.all(AppSpacing.sp12));
    });

    testWidgets('renders success state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const MessageBox(
            kind: MessageBoxKind.success,
            text: 'Deposit successful.',
          ),
        ),
      );

      final textFinder = find.text('Deposit successful.');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style!.color, AppColors.success);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.successBg);
      expect(
        decoration.border,
        Border.all(color: AppColors.success, width: 1.0),
      );
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppSpacing.radiusControl),
      );
    });

    testWidgets('preserves minimum height in none state without text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWidget(const MessageBox(kind: MessageBoxKind.none, text: '')),
      );

      final size = tester.getSize(find.byType(MessageBox));
      expect(size.height, AppSpacing.messageMinHeight);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('wraps message in Semantics with liveRegion: true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWidget(
          const MessageBox(
            kind: MessageBoxKind.error,
            text: 'Accessible error alert',
          ),
        ),
      );

      final semanticsFinder = find.descendant(
        of: find.byType(MessageBox),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.liveRegion == true,
        ),
      );
      expect(semanticsFinder, findsOneWidget);
    });
  });

  group('BalanceChip', () {
    testWidgets('renders supplied text and lavenderMist styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWidget(const BalanceChip(text: 'Available balance \u20B15,000.00')),
      );

      expect(find.text('Available balance \u20B15,000.00'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.lavenderMist);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppSpacing.radiusControl),
      );
      expect(
        container.padding,
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp12,
          vertical: AppSpacing.sp8,
        ),
      );
    });
  });
}
