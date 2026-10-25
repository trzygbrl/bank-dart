import 'package:flutter/material.dart';

import 'ui/theme.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Simple Bank',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const Scaffold(body: Center(child: Text('Setup OK'))),
    ),
  );
}
