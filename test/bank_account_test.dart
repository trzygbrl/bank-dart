import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bank_flutter/logic/bank_account.dart';
import 'package:simple_bank_flutter/logic/transaction_type.dart';

void main() {
  group('BankAccount', () {
    test('starts with balance of 500000 and empty history', () {
      final account = BankAccount();
      expect(account.balance, 500000);
      expect(account.transactions, isEmpty);
    });

    test('deposit and withdrawal update balance and record transactions', () {
      final account = BankAccount();

      account.deposit(100000);
      final result = account.withdraw(200000);

      expect(result, isTrue);
      expect(account.balance, 400000);
      expect(account.transactions, hasLength(2));

      final first = account.transactions[0];
      expect(first.type, TransactionType.deposit);
      expect(first.amountCentavos, 100000);
      expect(first.balanceAfterCentavos, 600000);

      final second = account.transactions[1];
      expect(second.type, TransactionType.withdrawal);
      expect(second.amountCentavos, 200000);
      expect(second.balanceAfterCentavos, 400000);
    });

    test('insufficient funds returns false and changes nothing', () {
      final account = BankAccount();

      final result = account.withdraw(99999999);

      expect(result, isFalse);
      expect(account.balance, 500000);
      expect(account.transactions, isEmpty);
    });

    test('exact-balance withdrawal succeeds and leaves zero balance', () {
      final account = BankAccount();

      final result = account.withdraw(500000);

      expect(result, isTrue);
      expect(account.balance, 0);
      expect(account.transactions, hasLength(1));

      final tx = account.transactions[0];
      expect(tx.type, TransactionType.withdrawal);
      expect(tx.amountCentavos, 500000);
      expect(tx.balanceAfterCentavos, 0);
    });

    test('transaction list is read-only and cannot be modified externally', () {
      final account = BankAccount();
      account.deposit(100000);

      final list = account.transactions;
      expect(() => list.add(account.transactions[0]), throwsUnsupportedError);

      // The internal history remains unchanged.
      expect(account.transactions, hasLength(1));
    });
  });
}
