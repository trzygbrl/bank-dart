import 'package:flutter/material.dart';

import 'ui/home_page.dart';
import 'ui/theme.dart';

void main() {
  runApp(const SimpleBankApp());
}

/// Root application widget for Simple Bank.
class SimpleBankApp extends StatelessWidget {
  /// Creates the root [SimpleBankApp] widget.
  const SimpleBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Bank',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}
