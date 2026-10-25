import 'package:flutter/material.dart';

import 'ui/theme.dart';
import 'ui/widgets/amount_field.dart';
import 'ui/widgets/app_card.dart';
import 'ui/widgets/balance_chip.dart';
import 'ui/widgets/message_box.dart';
import 'ui/widgets/view_header.dart';

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
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.sp32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: const WidgetDemoScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Temporary demo screen showcasing Task D-05 reusable styled widgets.
class WidgetDemoScreen extends StatefulWidget {
  /// Creates the [WidgetDemoScreen].
  const WidgetDemoScreen({super.key});

  @override
  State<WidgetDemoScreen> createState() => _WidgetDemoScreenState();
}

class _WidgetDemoScreenState extends State<WidgetDemoScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _hasError = false;
  String _errorMessage =
      'Invalid input. Please enter a numeric amount (e.g., 500 or 250.75).';
  String _successMessage = 'Deposit successful. New balance: \u20B16,000.00';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit([String? _]) {
    setState(() {
      final text = _controller.text.trim();
      if (text.isEmpty) {
        _hasError = true;
        _errorMessage =
            'Invalid input. Please enter a numeric amount (e.g., 500 or 250.75).';
      } else {
        _hasError = false;
        _successMessage = 'Action submitted for \u20B1$text.';
      }
    });
  }

  void _handleClear() {
    setState(() {
      _controller.clear();
      _hasError = false;
      _errorMessage = 'Field cleared.';
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ViewHeader(
            title: 'Widget Demo',
            subtitle: 'Preview and interaction testing for Task D-05 widgets.',
          ),
          const BalanceChip(
            text: 'Available balance \u20B15,000.00',
          ),
          const SizedBox(height: AppSpacing.sp16),
          AmountField(
            controller: _controller,
            focusNode: _focusNode,
            hasError: _hasError,
            semanticsLabel: 'Amount to deposit',
            hintText: '0.00',
            onChanged: (value) {
              if (_hasError) {
                setState(() {
                  _hasError = false;
                });
              }
            },
            onSubmitted: _handleSubmit,
          ),
          const SizedBox(height: AppSpacing.sp16),
          Row(
            children: [
              FilledButton(
                onPressed: _handleSubmit,
                child: const Text('Submit'),
              ),
              const SizedBox(width: AppSpacing.sp8),
              OutlinedButton(
                onPressed: _handleClear,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sp16),
          MessageBox(
            kind: MessageBoxKind.error,
            text: _errorMessage,
          ),
          const SizedBox(height: AppSpacing.sp8),
          MessageBox(
            kind: MessageBoxKind.success,
            text: _successMessage,
          ),
        ],
      ),
    );
  }
}
