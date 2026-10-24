import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_bank_flutter/main.dart' as app;

void main() {
  testWidgets('App displays Setup OK with correct title and disabled debug banner', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Setup OK'), findsOneWidget);

    final MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Simple Bank');
    expect(materialApp.debugShowCheckedModeBanner, isFalse);
  });
}
