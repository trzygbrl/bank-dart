import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/ui/theme.dart';
import 'package:simple_bank_flutter/ui/widgets/view_page.dart';

void main() {
  group('ViewPage', () {
    testWidgets('scrollable page scrolls a child taller than the window', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 300);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: ViewPage(child: SizedBox(width: 100, height: 1000)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      final ScrollableState scrollable = tester.state(find.byType(Scrollable));
      expect(scrollable.position.pixels, greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('non-scrollable page gives its child a bounded height', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const Key fillKey = Key('fill');
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          home: const Scaffold(
            body: ViewPage(
              scrollable: false,
              child: Column(
                children: [
                  Text('Header'),
                  Expanded(child: SizedBox.expand(key: fillKey)),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(tester.getSize(find.byKey(fillKey)).height, greaterThan(0));
    });
  });
}
