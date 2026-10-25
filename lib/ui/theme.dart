import 'package:flutter/material.dart';

/// Centralized design tokens and theme configuration for Simple Bank.
///
/// Follows the design specifications in PRD §9.2, §9.3, and §9.6.

/// Color palette tokens defined in PRD §9.2.
class AppColors {
  AppColors._();

  /// Deep Lavender: Primary buttons, balance card, selected sidebar item, focus rings.
  static const Color primary = Color(0xFF5B4B8A);

  /// Sidebar background, pressed buttons.
  static const Color primaryDark = Color(0xFF433670);

  /// Window title text on lavender, high-emphasis headings.
  static const Color primaryDeep = Color(0xFF2E2552);

  /// Table header background, chips, hover states, selected tints.
  static const Color lavender = Color(0xFFE9E4F7);

  /// Alternate table rows, input hover background, balance chips.
  static const Color lavenderMist = Color(0xFFF3F0FA);

  /// Mint Cream: Content area background.
  static const Color background = Color(0xFFF5FFFA);

  /// Cards, inputs, dialogs.
  static const Color surface = Color(0xFFFFFFFF);

  /// Selected-item accent bar, success tint accents.
  static const Color mint = Color(0xFFBFE8D4);

  /// Success text, deposit labels.
  static const Color success = Color(0xFF2E7D5B);

  /// Success message background.
  static const Color successBg = Color(0xFFE3F5EC);

  /// Error text.
  static const Color error = Color(0xFFB3261E);

  /// Error message background.
  static const Color errorBg = Color(0xFFFDECEA);

  /// Withdrawal labels in the history table.
  static const Color withdrawal = Color(0xFFA8324A);

  /// Main text.
  static const Color textPrimary = Color(0xFF2B2540);

  /// Secondary text, hints.
  static const Color textMuted = Color(0xFF6B6585);

  /// Card and input borders, dividers.
  static const Color border = Color(0xFFD9D3EC);

  /// Text on primary and primaryDark.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Unselected sidebar text.
  static const Color navText = Color(0xFFE4DEF5);

  /// Card soft shadow approximating 10% black opacity (PRD §9.3).
  static const Color cardShadow = Color(0x1A000000);
}

/// Spacing, radius, and sizing tokens defined in PRD §9.3 and §9.4.
class AppSpacing {
  AppSpacing._();

  // Spacing scale
  static const double sp4 = 4.0;
  static const double sp8 = 8.0;
  static const double sp12 = 12.0;
  static const double sp16 = 16.0;
  static const double sp24 = 24.0;
  static const double sp32 = 32.0;

  // Corner radii
  static const double radiusCard = 12.0;
  static const double radiusControl = 8.0;

  // Heights
  static const double buttonHeight = 44.0;
  static const double fieldHeight = 44.0;
  static const double navItemHeight = 48.0;
  static const double tableRowHeight = 40.0;
  static const double messageMinHeight = 48.0;

  // Layout
  static const double sidebarWidth = 240.0;
}

/// Typography tokens defined in PRD §9.3.
///
/// Uses the platform default font family without bundled custom fonts.
class AppText {
  AppText._();

  /// Brand name in sidebar: 22 px, bold, onPrimary (PRD §9.3).
  static TextStyle get brand => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  /// View title: 24 px, bold, primaryDeep (PRD §9.3).
  static TextStyle get viewTitle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDeep,
  );

  /// View subtitle: 14 px, regular, textMuted (PRD §9.3).
  static TextStyle get subtitle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );

  /// Card title: 18 px, semibold, textPrimary (PRD §9.3).
  static TextStyle get cardTitle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Body and labels: 14 px, regular, textPrimary (PRD §9.3).
  static TextStyle get body => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Body bold: 14 px, bold, textPrimary (PRD §9.3).
  static TextStyle get bodyBold => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Balance figure: 40 px, bold, onPrimary (PRD §9.3).
  static TextStyle get balance => const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}

/// Centralized elevation and shadow definitions (PRD §9.3).
class AppShadows {
  AppShadows._();

  /// Soft card shadow approximating 10% black, blur 12, offset (0, 2) (PRD §9.3).
  static const BoxShadow card = BoxShadow(
    color: AppColors.cardShadow,
    blurRadius: 12.0,
    offset: Offset(0.0, 2.0),
  );
}

/// Builds the centralized Material 3 [ThemeData] for Simple Bank.
ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    scaffoldBackgroundColor: AppColors.background,
    focusColor: AppColors.lavender,
    highlightColor: AppColors.lavenderMist,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.lavender,
      onPrimaryContainer: AppColors.primaryDeep,
      secondary: AppColors.mint,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.lavenderMist,
      onSecondaryContainer: AppColors.primaryDeep,
      tertiary: AppColors.success,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.successBg,
      onTertiaryContainer: AppColors.success,
      error: AppColors.error,
      onError: AppColors.surface,
      errorContainer: AppColors.errorBg,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textMuted,
      outline: AppColors.border,
      outlineVariant: AppColors.lavender,
      shadow: AppColors.textPrimary,
      scrim: AppColors.textPrimary,
      inverseSurface: AppColors.primaryDeep,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.lavender,
      surfaceTint: AppColors.primary,
      surfaceDim: AppColors.lavenderMist,
      surfaceBright: AppColors.surface,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.lavenderMist,
      surfaceContainerHighest: AppColors.lavender,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryDark;
          }
          if (states.contains(WidgetState.hovered)) {
            return Color.lerp(AppColors.primary, AppColors.surface, 0.10);
          }
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          return AppColors.onPrimary;
        }),
        minimumSize: const WidgetStatePropertyAll(
          Size(0, AppSpacing.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.lavender;
          }
          return AppColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          return AppColors.primary;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          return const BorderSide(color: AppColors.primary, width: 1.0);
        }),
        minimumSize: const WidgetStatePropertyAll(
          Size(0, AppSpacing.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: 10.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        borderSide: const BorderSide(color: AppColors.error, width: 2.0),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.dragged)) {
          return AppColors.primary;
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.border;
        }
        return AppColors.lavender;
      }),
      trackColor: const WidgetStatePropertyAll(AppColors.lavenderMist),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1.0,
      space: 1.0,
    ),
  );
}
