import 'package:flutter/material.dart';

import '../../logic/bank_account.dart';
import '../../logic/money_util.dart';
import '../theme.dart';
import '../widgets/amount_field.dart';
import '../widgets/app_card.dart';
import '../widgets/balance_chip.dart';
import '../widgets/message_box.dart';
import '../widgets/view_header.dart';
import '../widgets/view_page.dart';

/// Result of the account action run by an [AmountFormView].
class AmountFormOutcome {
  /// The action worked; [message] is shown in the success box.
  const AmountFormOutcome.success(this.message) : isSuccess = true;

  /// The action was refused; [message] is shown in the error box.
  const AmountFormOutcome.error(this.message) : isSuccess = false;

  /// Whether the action succeeded.
  final bool isSuccess;

  /// Text shown to the user.
  final String message;
}

/// Shared form used by the Deposit and Withdraw views (PRD 9.5 views 2 and 3).
///
/// It reads and validates the amount (PRD 6.5), then hands the validated
/// centavo amount to [onSubmit], which performs the account action.
class AmountFormView extends StatefulWidget {
  /// Creates an [AmountFormView].
  const AmountFormView({
    super.key,
    required this.account,
    required this.title,
    required this.subtitle,
    required this.cardTitle,
    required this.fieldSemanticsLabel,
    required this.submitLabel,
    required this.onSubmit,
  });

  /// The account shown in the available-balance chip.
  final BankAccount account;

  /// View header title.
  final String title;

  /// View header subtitle.
  final String subtitle;

  /// Title at the top of the card.
  final String cardTitle;

  /// Accessible label of the amount field.
  final String fieldSemanticsLabel;

  /// Label of the primary button.
  final String submitLabel;

  /// Runs the account action for an already-validated amount in centavos.
  final AmountFormOutcome Function(int centavos) onSubmit;

  @override
  State<AmountFormView> createState() => _AmountFormViewState();
}

class _AmountFormViewState extends State<AmountFormView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  MessageBoxKind _messageKind = MessageBoxKind.none;
  String _messageText = '';
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectAllText() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _showError(String message) {
    setState(() {
      _messageKind = MessageBoxKind.error;
      _messageText = message;
      _hasError = true;
    });
    _focusNode.requestFocus();
    _selectAllText();
  }

  void _submit() {
    final AmountResult result = validateAmount(_controller.text);
    if (!result.isValid) {
      _showError(result.errorMessage!);
      return;
    }

    final AmountFormOutcome outcome = widget.onSubmit(result.centavos!);
    if (!outcome.isSuccess) {
      _showError(outcome.message);
      return;
    }

    setState(() {
      _controller.clear();
      _messageKind = MessageBoxKind.success;
      _messageText = outcome.message;
      _hasError = false;
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _messageKind = MessageBoxKind.none;
      _messageText = '';
      _hasError = false;
    });
    _focusNode.requestFocus();
  }

  void _onFieldChanged(String _) {
    if (_messageKind != MessageBoxKind.none || _hasError) {
      setState(() {
        _messageKind = MessageBoxKind.none;
        _messageText = '';
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewPage(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ViewHeader(title: widget.title, subtitle: widget.subtitle),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.cardTitle, style: AppText.cardTitle),
                  const SizedBox(height: AppSpacing.sp16),
                  ListenableBuilder(
                    listenable: widget.account,
                    builder: (context, _) => BalanceChip(
                      text:
                          'Available balance ${formatMoney(widget.account.balance)}',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp16),
                  Text('Amount', style: AppText.bodyBold),
                  const SizedBox(height: AppSpacing.sp8),
                  AmountField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hasError: _hasError,
                    semanticsLabel: widget.fieldSemanticsLabel,
                    onChanged: _onFieldChanged,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.sp12),
                  MessageBox(kind: _messageKind, text: _messageText),
                  const SizedBox(height: AppSpacing.sp16),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: _submit,
                        child: Text(widget.submitLabel),
                      ),
                      const SizedBox(width: AppSpacing.sp12),
                      OutlinedButton(
                        onPressed: _clear,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
