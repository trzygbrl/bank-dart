/// The two kinds of banking transaction.
enum TransactionType {
  deposit('Deposit'),
  withdrawal('Withdrawal');

  /// Human-readable label for display.
  final String label;

  const TransactionType(this.label);
}
