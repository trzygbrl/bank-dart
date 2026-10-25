import 'package:flutter/material.dart';

import '../../logic/money_util.dart';
import '../theme.dart';

/// Reusable input field for entering monetary amounts matching PRD §9.3, §9.6, and §9.7.
///
/// Has a fixed height of 44 logical pixels, displays the [currencySymbol] as a prefix,
/// supports change and submission callbacks, and adjusts borders based on [hasError]
/// and keyboard focus.
class AmountField extends StatelessWidget {
  /// Creates an [AmountField] configured for monetary amount input.
  const AmountField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.semanticsLabel,
    this.hintText = '0.00',
    this.onChanged,
    this.onSubmitted,
  });

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Manages keyboard focus for the input field.
  final FocusNode focusNode;

  /// Whether the field is currently in an error state.
  ///
  /// When `true`, displays an error-colored border.
  final bool hasError;

  /// Accessible label for screen readers and assistive technology.
  final String semanticsLabel;

  /// Text displayed when the input field is empty.
  final String hintText;

  /// Called when the user alters the text in the field.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. by pressing Enter).
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final borderSide = hasError
        ? const BorderSide(color: AppColors.error, width: 1.0)
        : const BorderSide(color: AppColors.border, width: 1.0);
    final focusedBorderSide = hasError
        ? const BorderSide(color: AppColors.error, width: 2.0)
        : const BorderSide(color: AppColors.primary, width: 2.0);

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
      borderSide: borderSide,
    );
    final focusedInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
      borderSide: focusedBorderSide,
    );

    return Semantics(
      label: semanticsLabel,
      textField: true,
      child: SizedBox(
        height: AppSpacing.fieldHeight,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          style: AppText.body,
          cursorColor: AppColors.primary,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppText.subtitle,
            prefixText: currencySymbol,
            prefixStyle: AppText.body,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
          ),
        ),
      ),
    );
  }
}
