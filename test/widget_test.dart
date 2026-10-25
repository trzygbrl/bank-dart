import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/main.dart' as app;
import 'package:simple_bank_flutter/ui/home_page.dart';
import 'package:simple_bank_flutter/ui/nav_item.dart';
import 'package:simple_bank_flutter/ui/widgets/view_header.dart';

void main() {
  testWidgets(
    'App launches with title, disabled debug banner, and HomePage on Check Balance view',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final MaterialApp materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.title, 'Simple Bank');
      expect(materialApp.debugShowCheckedModeBanner, isFalse);

      // Verify HomePage is present
      expect(find.byType(HomePage), findsOneWidget);

      // Verify sidebar branding
      expect(find.text('Simple Bank'), findsOneWidget);
      expect(find.text('Personal Banking'), findsOneWidget);

      // Verify all 5 navigation items are present
      expect(find.byType(NavItem), findsNWidgets(5));
      expect(find.widgetWithText(NavItem, 'Check Balance'), findsOneWidget);
      expect(find.widgetWithText(NavItem, 'Deposit Money'), findsOneWidget);
      expect(find.widgetWithText(NavItem, 'Withdraw Money'), findsOneWidget);
      expect(
        find.widgetWithText(NavItem, 'View Transaction History'),
        findsOneWidget,
      );
      expect(find.widgetWithText(NavItem, 'Exit'), findsOneWidget);

      // Verify initially on Check Balance placeholder view
      expect(find.byType(ViewHeader), findsOneWidget);
      expect(
        find.widgetWithText(ViewHeader, 'Check Balance'),
        findsOneWidget,
      );
      expect(find.text('Your account at a glance'), findsOneWidget);
    },
  );
}
