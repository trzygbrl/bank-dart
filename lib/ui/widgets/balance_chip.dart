import 'package:flutter/material.dart';

import '../theme.dart';

/// Reusable chip displaying balance or secondary status information.
///
/// Styled with [AppColors.lavenderMist] background, 8 px corner radius,
/// and [AppText.body] text matching PRD §9.2, §9.3, and §9.5.
class BalanceChip extends StatelessWidget {
  /// Creates a [BalanceChip] with the specified [text].
  const BalanceChip({super.key, required this.text});

  /// The label displayed inside the chip.
  final String text;

  /// Builds the lavender-mist balance label.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp12,
        vertical: AppSpacing.sp8,
      ),
      decoration: BoxDecoration(
        color: AppColors.lavenderMist,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
      ),
      child: Text(text, style: AppText.body),
    );
  }
}
