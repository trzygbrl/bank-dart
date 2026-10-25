/// Money formatting and amount-validation utilities.
///
/// This file is pure Dart — it must not import package:flutter.
library;

/// The Philippine peso sign (₱).
const String currencySymbol = '\u20B1';

/// Maximum allowed amount in centavos (₱1,000,000,000.00).
const int maxAmountCentavos = 100000000000;

// ---------------------------------------------------------------------------
// Error-message constants — exact wording from PRD Section 10.
// ---------------------------------------------------------------------------

/// Shown when the input is not a valid numeric format.
const String invalidNumberMessage =
    'Invalid input. Please enter a numeric amount (e.g., 500 or 250.75).';

/// Shown when the parsed amount is zero or negative.
const String mustBePositiveMessage = 'Amount must be greater than zero.';

/// Shown when more than two decimal places are provided.
const String maxTwoDecimalsMessage =
    'Amount can have at most 2 decimal places.';

/// Shown when the amount exceeds the per-transaction limit.
const String tooLargeMessage =
    'Amount is too large. The maximum per transaction is '
    '\u20B11,000,000,000.00.';

// ---------------------------------------------------------------------------
// AmountResult
// ---------------------------------------------------------------------------

/// Holds either a validated centavo amount or an error message.
class AmountResult {
  /// The validated amount in centavos, or `null` on error.
  final int? centavos;

  /// The validation error message, or `null` on success.
  final String? errorMessage;

  const AmountResult._(this.centavos, this.errorMessage);

  /// Creates a successful result containing [centavos].
  factory AmountResult.ok(int centavos) => AmountResult._(centavos, null);

  /// Creates an error result containing [message].
  factory AmountResult.error(String message) => AmountResult._(null, message);

  /// `true` when the result carries a valid centavo amount.
  bool get isValid => centavos != null;
}

// ---------------------------------------------------------------------------
// formatMoney
// ---------------------------------------------------------------------------

/// Formats [centavos] as a peso string with comma thousands separators and
/// exactly two decimal digits.
///
/// Examples:
/// - `0`            → `₱0.00`
/// - `5`            → `₱0.05`
/// - `500000`       → `₱5,000.00`
/// - `123456789`    → `₱1,234,567.89`
/// - `100000000000` → `₱1,000,000,000.00`
String formatMoney(int centavos) {
  final int wholePesos = centavos ~/ 100;
  final int fraction = centavos % 100;

  // Build the whole-pesos string with comma grouping.
  final String digits = wholePesos.toString();
  final StringBuffer buf = StringBuffer();

  // Insert commas every three digits from the right.
  final int len = digits.length;
  for (int i = 0; i < len; i++) {
    if (i > 0 && (len - i) % 3 == 0) {
      buf.write(',');
    }
    buf.write(digits[i]);
  }

  final String fractionStr = fraction.toString().padLeft(2, '0');
  return '$currencySymbol$buf.$fractionStr';
}

// ---------------------------------------------------------------------------
// validateAmount
// ---------------------------------------------------------------------------

/// Validates user input and converts it to centavos.
///
/// Follows PRD Section 6.5, steps 1–5, in the prescribed order.
/// Never throws for any input.
AmountResult validateAmount(String? text) {
  // Step 1 — Normalize input.
  final String trimmed = (text ?? '').trim();

  // Step 2 — Validate numeric syntax.
  //   Pattern: optional minus, one-or-more digits, optionally a dot + digits.
  final RegExp syntax = RegExp(r'^-?[0-9]+(\.[0-9]+)?$');
  if (!syntax.hasMatch(trimmed)) {
    return AmountResult.error(invalidNumberMessage);
  }

  // Step 3 — Reject zero and negative values.
  final bool isNegative = trimmed.startsWith('-');
  final String unsigned = isNegative ? trimmed.substring(1) : trimmed;

  // Determine if the value is numerically zero by checking all digits.
  final String digitsOnly = unsigned.replaceAll('.', '');
  bool allZeros = true;
  for (int i = 0; i < digitsOnly.length; i++) {
    if (digitsOnly[i] != '0') {
      allZeros = false;
      break;
    }
  }

  if (isNegative || allZeros) {
    return AmountResult.error(mustBePositiveMessage);
  }

  // Step 4 — Enforce decimal precision (at most 2 digits after the dot).
  final int dotIndex = unsigned.indexOf('.');
  if (dotIndex != -1) {
    final int decimals = unsigned.length - dotIndex - 1;
    if (decimals > 2) {
      return AmountResult.error(maxTwoDecimalsMessage);
    }
  }

  // Step 5 — Enforce the maximum amount.
  //   Split into whole and fractional parts.
  final List<String> parts = unsigned.split('.');
  String wholePart = parts[0];

  // Remove leading zeros for length check.
  String normalizedWhole = wholePart.replaceFirst(RegExp(r'^0+'), '');
  if (normalizedWhole.isEmpty) normalizedWhole = '0';

  if (normalizedWhole.length > 10) {
    return AmountResult.error(tooLargeMessage);
  }

  // Parse whole pesos safely.
  final int? wholePesos = int.tryParse(wholePart);
  if (wholePesos == null) {
    return AmountResult.error(invalidNumberMessage);
  }

  // Parse the fractional part (pad or truncate to exactly 2 digits).
  int fraction = 0;
  if (parts.length == 2) {
    String fracStr = parts[1];
    // Pad to 2 digits on the right (e.g. '5' → '50').
    fracStr = fracStr.padRight(2, '0');
    final int? parsed = int.tryParse(fracStr);
    if (parsed == null) {
      return AmountResult.error(invalidNumberMessage);
    }
    fraction = parsed;
  }

  final int totalCentavos = wholePesos * 100 + fraction;

  if (totalCentavos > maxAmountCentavos) {
    return AmountResult.error(tooLargeMessage);
  }

  return AmountResult.ok(totalCentavos);
}
