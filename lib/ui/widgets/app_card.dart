import 'package:flutter/material.dart';

import '../theme.dart';

/// Reusable container card matching PRD §9.3 and §9.6.
///
/// Features a white surface background, 12 px rounded corners, a 1 px border,
/// and a soft elevation shadow.
class AppCard extends StatelessWidget {
  /// Creates an [AppCard] displaying [child] with optional [padding].
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.sp24),
  });

  /// The widget below this card in the tree.
  final Widget child;

  /// Empty space to inscribe inside the card boundaries.
  ///
  /// Defaults to 24 logical pixels on all sides (PRD §9.3).
  final EdgeInsetsGeometry padding;

  /// Builds the shared surface card with its border and shadow.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: const [AppShadows.card],
      ),
      child: child,
    );
  }
}
