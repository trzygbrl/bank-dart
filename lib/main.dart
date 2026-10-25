// Simple Bank Desktop App (Flutter / Dart)
// Group: Not provided
// Members: Not provided

import 'package:flutter/material.dart';

import 'ui/home_page.dart';
import 'ui/theme.dart';

/// Starts the Simple Bank desktop application.
void main() {
  runApp(const SimpleBankApp());
}

/// Root application widget for Simple Bank.
class SimpleBankApp extends StatelessWidget {
  /// Creates the root [SimpleBankApp] widget.
  const SimpleBankApp({super.key});

  /// Builds the themed Material application and its home page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimplyBank',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}
