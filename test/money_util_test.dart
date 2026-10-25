import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/money_util.dart';

void main() {
  // -----------------------------------------------------------------
  // formatMoney tests
  // -----------------------------------------------------------------
  group('formatMoney', () {
    test('formats zero centavos', () {
      expect(formatMoney(0), '₱0.00');
    });

    test('formats small centavo amount', () {
      expect(formatMoney(5), '₱0.05');
    });

    test('formats one peso exactly', () {
      expect(formatMoney(100), '₱1.00');
    });

    test('formats thousands with comma separator', () {
      expect(formatMoney(500000), '₱5,000.00');
    });

    test('formats millions with comma separators', () {
      expect(formatMoney(123456789), '₱1,234,567.89');
    });

    test('formats maximum amount', () {
      expect(formatMoney(100000000000), '₱1,000,000,000.00');
    });
  });

  // -----------------------------------------------------------------
  // validateAmount — successful cases
  // -----------------------------------------------------------------
  group('validateAmount — valid inputs', () {
    test('whole number converts to centavos', () {
      final r = validateAmount('1000');
      expect(r.isValid, isTrue);
      expect(r.centavos, 100000);
    });

    test('decimal amount converts correctly', () {
      final r = validateAmount('250.75');
      expect(r.isValid, isTrue);
      expect(r.centavos, 25075);
    });

    test('single decimal digit pads to two', () {
      final r = validateAmount('0.5');
      expect(r.isValid, isTrue);
      expect(r.centavos, 50);
    });

    test('leading and trailing whitespace is trimmed', () {
      final r = validateAmount(' 500 ');
      expect(r.isValid, isTrue);
      expect(r.centavos, 50000);
    });
  });

  // -----------------------------------------------------------------
  // validateAmount — must-be-positive errors
  // -----------------------------------------------------------------
  group('validateAmount — must be positive', () {
    test('zero is rejected', () {
      final r = validateAmount('0');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, mustBePositiveMessage);
    });

    test('zero with decimals is rejected', () {
      final r = validateAmount('0.00');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, mustBePositiveMessage);
    });

    test('negative zero is rejected', () {
      final r = validateAmount('-0');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, mustBePositiveMessage);
    });

    test('negative amount is rejected', () {
      final r = validateAmount('-50');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, mustBePositiveMessage);
    });
  });

  // -----------------------------------------------------------------
  // validateAmount — invalid-number errors
  // -----------------------------------------------------------------
  group('validateAmount — invalid number', () {
    test('alphabetic input', () {
      final r = validateAmount('abc');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('empty string', () {
      final r = validateAmount('');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('scientific notation', () {
      final r = validateAmount('1e3');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('leading dot without whole part', () {
      final r = validateAmount('.5');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('trailing dot without fractional part', () {
      final r = validateAmount('5.');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('commas in number', () {
      final r = validateAmount('1,000');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });

    test('null input', () {
      final r = validateAmount(null);
      expect(r.isValid, isFalse);
      expect(r.errorMessage, invalidNumberMessage);
    });
  });

  // -----------------------------------------------------------------
  // validateAmount — max two decimals error
  // -----------------------------------------------------------------
  group('validateAmount — max two decimals', () {
    test('three decimal places rejected', () {
      final r = validateAmount('10.999');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, maxTwoDecimalsMessage);
    });
  });

  // -----------------------------------------------------------------
  // validateAmount — too large error
  // -----------------------------------------------------------------
  group('validateAmount — too large', () {
    test('11-digit whole pesos rejected', () {
      final r = validateAmount('99999999999');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, tooLargeMessage);
    });
  });

  // -----------------------------------------------------------------
  // Edge cases
  // -----------------------------------------------------------------
  group('validateAmount — edge cases', () {
    test('leading zeros in a valid amount', () {
      final r = validateAmount('0005.5');
      expect(r.isValid, isTrue);
      expect(r.centavos, 550);
    });

    test('zero represented with leading zeros', () {
      final r = validateAmount('000.00');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, mustBePositiveMessage);
    });

    test('maximum supported amount is accepted', () {
      final r = validateAmount('1000000000.00');
      expect(r.isValid, isTrue);
      expect(r.centavos, 100000000000);
    });

    test('one centavo over maximum is rejected', () {
      final r = validateAmount('1000000000.01');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, tooLargeMessage);
    });

    test('whole-pesos digit length over 10 is rejected', () {
      final r = validateAmount('10000000001');
      expect(r.isValid, isFalse);
      expect(r.errorMessage, tooLargeMessage);
    });

    test(
      'negative amount with more than two decimals returns must-be-positive',
      () {
        // Validation order: step 3 (positive check) comes before step 4 (decimals).
        final r = validateAmount('-1.234');
        expect(r.isValid, isFalse);
        expect(r.errorMessage, mustBePositiveMessage);
      },
    );

    test('extremely long numeric string returns error without throwing', () {
      final longNumber = '9' * 100;
      final r = validateAmount(longNumber);
      expect(r.isValid, isFalse);
      // Should hit the too-large check (digit length > 10).
      expect(r.errorMessage, tooLargeMessage);
    });

    test('malformed input never throws', () {
      // A grab-bag of edge-case inputs that must all produce AmountResults.
      final inputs = [
        '',
        ' ',
        '  \t  ',
        '.',
        '-',
        '--5',
        '1.2.3',
        'NaN',
        'Infinity',
        '-Infinity',
        '₱500',
      ];
      for (final input in inputs) {
        final r = validateAmount(input);
        expect(
          r,
          isA<AmountResult>(),
          reason: 'validateAmount("$input") must return an AmountResult',
        );
        expect(
          r.isValid,
          isFalse,
          reason: 'validateAmount("$input") should be invalid',
        );
      }
    });
  });
}
