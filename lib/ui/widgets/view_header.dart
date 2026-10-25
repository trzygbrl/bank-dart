import 'package:flutter/material.dart';

import '../theme.dart';

/// Reusable view header displaying a title and subtitle matching PRD §9.3 and §9.4.
///
/// Automatically reserves 24 logical pixels of space below the header.
class ViewHeader extends StatelessWidget {
  /// Creates a [ViewHeader] with the given [title] and [subtitle].
  const ViewHeader({super.key, required this.title, required this.subtitle});

  /// The primary heading displayed using [AppText.viewTitle].
  final String title;

  /// The secondary text displayed beneath the title using [AppText.subtitle].
  final String subtitle;

  /// Builds the title and subtitle with the standard spacing.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sp24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppText.viewTitle),
          Text(subtitle, style: AppText.subtitle),
        ],
      ),
    );
  }
}
