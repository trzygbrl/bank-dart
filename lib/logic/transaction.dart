import 'transaction_type.dart';

/// An immutable record of a single banking transaction.
class Transaction {
  /// Whether this was a deposit or withdrawal.
  final TransactionType type;

  /// The transaction amount in centavos.
  final int amountCentavos;

  /// The account balance in centavos after this transaction was applied.
  final int balanceAfterCentavos;

  /// Creates a transaction record.
  const Transaction({
    required this.type,
    required this.amountCentavos,
    required this.balanceAfterCentavos,
  });
}
