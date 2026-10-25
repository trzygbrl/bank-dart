import 'package:flutter/material.dart';

import '../theme.dart';

/// Supported visual kinds for [MessageBox].
enum MessageBoxKind {
  /// Invisible box preserving the 48 logical pixel minimum height.
  none,

  /// Error message box with error background, border, and text.
  error,

  /// Success message box with success background, border, and text.
  success,
}

/// Reusable inline feedback box matching PRD §9.5 and §9.6.
///
/// Supports error, success, and none states. The none state preserves layout
/// stability with an invisible 48 logical pixel height placeholder without
/// announcing stale messages to assistive technology.
class MessageBox extends StatelessWidget {
  /// Creates a [MessageBox] of the given [kind] displaying [text].
  const MessageBox({
    super.key,
    required this.kind,
    required this.text,
  });

  /// The category of message to display.
  final MessageBoxKind kind;

  /// The text message to display.
  final String text;

  @override
  Widget build(BuildContext context) {
    if (kind == MessageBoxKind.none) {
      return const SizedBox(
        width: double.infinity,
        height: AppSpacing.messageMinHeight,
      );
    }

    final Color backgroundColor;
    final Color textColor;
    final Color borderColor;

    switch (kind) {
      case MessageBoxKind.error:
        backgroundColor = AppColors.errorBg;
        textColor = AppColors.error;
        borderColor = AppColors.error;
      case MessageBoxKind.success:
        backgroundColor = AppColors.successBg;
        textColor = AppColors.success;
        borderColor = AppColors.success;
      case MessageBoxKind.none:
        backgroundColor = Colors.transparent;
        textColor = Colors.transparent;
        borderColor = Colors.transparent;
    }

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: AppSpacing.messageMinHeight,
        ),
        padding: const EdgeInsets.all(AppSpacing.sp12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppText.body.copyWith(color: textColor),
        ),
      ),
    );
  }
}
