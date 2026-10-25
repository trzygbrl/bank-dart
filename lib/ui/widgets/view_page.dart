import 'package:flutter/material.dart';

import '../theme.dart';

/// Standard page wrapper for every view in the content area.
///
/// Applies the 32 px content padding. When [scrollable] is true (the default)
/// the content is top-left aligned and scrolls vertically if it is taller than
/// the window. When [scrollable] is false the child receives the bounded
/// available width and height, so it can use `Expanded` (for example the
/// Transaction History table, which scrolls its own rows).
class ViewPage extends StatelessWidget {
  /// Creates a [ViewPage] around [child].
  const ViewPage({
    super.key,
    required this.child,
    this.scrollable = true,
  });

  /// The view content.
  final Widget child;

  /// Whether the page scrolls vertically as a whole.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (!scrollable) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.sp32),
        child: child,
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.sp32),
      child: Align(
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }
}
