import 'package:flutter/foundation.dart';

import 'transaction.dart';
import 'transaction_type.dart';

/// The starting account balance in centavos (₱5,000.00).
const int startingBalanceCentavos = 500000;

/// A single in-memory bank account that notifies listeners on changes.
class BankAccount extends ChangeNotifier {
  int _balanceCentavos = startingBalanceCentavos;
  final List<Transaction> _transactions = [];

  /// The current account balance in centavos.
  int get balance => _balanceCentavos;

  /// An unmodifiable view of the transaction history, in chronological order.
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  /// Deposits [amountCentavos] into the account.
  ///
  /// The UI validates values before calling this method; callers must pass a
  /// positive amount in centavos.
  void deposit(int amountCentavos) {
    _balanceCentavos += amountCentavos;
    _recordTransaction(TransactionType.deposit, amountCentavos);
    notifyListeners();
  }

  /// Withdraws [amountCentavos] from the account.
  ///
  /// Returns `true` when the amount is within the balance, or `false` when it
  /// exceeds the current balance. A failed withdrawal changes nothing.
  bool withdraw(int amountCentavos) {
    if (amountCentavos > _balanceCentavos) {
      return false;
    }
    _balanceCentavos -= amountCentavos;
    _recordTransaction(TransactionType.withdrawal, amountCentavos);
    notifyListeners();
    return true;
  }

  /// Records a transaction after the balance has already been updated.
  /// Appends a record using the balance that resulted from the action.
  void _recordTransaction(TransactionType type, int amountCentavos) {
    _transactions.add(
      Transaction(
        type: type,
        amountCentavos: amountCentavos,
        balanceAfterCentavos: _balanceCentavos,
      ),
    );
  }
}
