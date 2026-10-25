import 'package:flutter/material.dart';

import '../../logic/bank_account.dart';
import '../../logic/money_util.dart';
import 'amount_form_view.dart';

/// Withdraw Money view (PRD 6.4, 9.5 view 3).
class WithdrawView extends StatelessWidget {
  /// Creates a [WithdrawView] for [account].
  const WithdrawView({super.key, required this.account});

  /// The account that funds are withdrawn from.
  final BankAccount account;

  /// Withdraws an already-validated [centavos] amount (PRD section 8).
  ///
  /// Returns an error outcome, changing nothing, when the amount is more than
  /// the current balance.
  AmountFormOutcome handleWithdraw(int centavos) {
    final int balanceBefore = account.balance;
    if (!account.withdraw(centavos)) {
      return AmountFormOutcome.error(
        'Insufficient funds. Your balance is ${formatMoney(balanceBefore)}; '
        'you cannot withdraw ${formatMoney(centavos)}.',
      );
    }
    return AmountFormOutcome.success(
      'Withdrawal successful. New balance: ${formatMoney(account.balance)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AmountFormView(
      account: account,
      title: 'Withdraw Money',
      subtitle: 'Take funds from your account',
      cardTitle: 'Withdrawal details',
      fieldSemanticsLabel: 'Amount to withdraw',
      submitLabel: 'Withdraw',
      onSubmit: handleWithdraw,
    );
  }
}
