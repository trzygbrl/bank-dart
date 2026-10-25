import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

/// Reusable navigation item widget used in the Simple Bank sidebar.
///
/// Implements PRD §9.4 (UI-1, UI-2, UI-3, UI-10) and §9.7 (UI-13).
class NavItem extends StatefulWidget {
  /// Creates a styled, accessible navigation item.
  const NavItem({
    super.key,
    required this.number,
    required this.label,
    required this.selected,
    this.onTap,
    this.focusNode,
  });

  /// Navigation item number displayed inside the badge.
  final int number;

  /// Navigation item label text.
  final String label;

  /// Whether the navigation item is currently selected.
  final bool selected;

  /// Callback invoked when the navigation item is tapped or activated.
  final VoidCallback? onTap;

  /// Optional [FocusNode] for controlling or asserting on focus state.
  final FocusNode? focusNode;

  @override
  State<NavItem> createState() => _NavItemState();
}

/// Tracks hover and keyboard focus feedback for [NavItem].
class _NavItemState extends State<NavItem> {
  bool _isHovered = false;
  bool _isFocused = false;

  void _handleTap() {
    widget.onTap?.call();
  }

  /// Builds the accessible item with selected, hover, and focus feedback.
  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.selected
        ? AppColors.onPrimary
        : AppColors.navText;
    final Color badgeBgColor = widget.selected
        ? Colors.white.withValues(alpha: 0.20)
        : Colors.white.withValues(alpha: 0.10);
    final Color badgeTextColor = widget.selected
        ? AppColors.onPrimary
        : AppColors.navText;

    Color backgroundColor = Colors.transparent;
    if (widget.selected) {
      backgroundColor = AppColors.primary;
      if (_isHovered) {
        backgroundColor = Color.lerp(AppColors.primary, Colors.white, 0.10)!;
      }
    } else if (_isHovered) {
      backgroundColor = Colors.white.withValues(alpha: 0.08);
    }

    return Semantics(
      button: true,
      label: widget.label,
      selected: widget.selected,
      enabled: widget.onTap != null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        enabled: widget.onTap != null,
        mouseCursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onFocusChange: (value) {
          if (_isFocused != value) {
            setState(() {
              _isFocused = value;
            });
          }
        },
        onShowFocusHighlight: (value) {
          if (_isFocused != value) {
            setState(() {
              _isFocused = value;
            });
          }
        },
        onShowHoverHighlight: (value) {
          if (_isHovered != value) {
            setState(() {
              _isHovered = value;
            });
          }
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleTap();
              return null;
            },
          ),
        },
        child: MouseRegion(
          onEnter: (_) {
            if (!_isHovered) {
              setState(() {
                _isHovered = true;
              });
            }
          },
          onExit: (_) {
            if (_isHovered) {
              setState(() {
                _isHovered = false;
              });
            }
          },
          child: GestureDetector(
            onTap: widget.onTap != null ? _handleTap : null,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: AppSpacing.navItemHeight,
              child: Stack(
                children: [
                  // Background fill
                  Container(color: backgroundColor),
                  // Left mint indicator bar (4 px wide)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4.0,
                    child: Container(
                      color: widget.selected
                          ? AppColors.mint
                          : Colors.transparent,
                    ),
                  ),
                  // Content (vertically centered)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Number badge
                          Container(
                            width: 24.0,
                            height: 24.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.sp4,
                              ),
                            ),
                            child: Text(
                              '${widget.number}',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: badgeTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sp12),
                          // Label
                          Expanded(
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: widget.selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Visible focus ring
                  if (_isFocused)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lavender,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
