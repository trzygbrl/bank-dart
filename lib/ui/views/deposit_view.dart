import 'package:flutter/material.dart';

import '../../logic/bank_account.dart';
import '../../logic/money_util.dart';
import 'amount_form_view.dart';

/// Deposit Money view (PRD 6.3, 9.5 view 2).
class DepositView extends StatelessWidget {
  /// Creates a [DepositView] for [account].
  const DepositView({super.key, required this.account});

  /// The account that receives deposits.
  final BankAccount account;

  /// Deposits an already-validated [centavos] amount (PRD section 8).
  AmountFormOutcome handleDeposit(int centavos) {
    account.deposit(centavos);
    return AmountFormOutcome.success(
      'Deposit successful. New balance: ${formatMoney(account.balance)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AmountFormView(
      account: account,
      title: 'Deposit Money',
      subtitle: 'Add funds to your account',
      cardTitle: 'Deposit details',
      fieldSemanticsLabel: 'Amount to deposit',
      submitLabel: 'Deposit',
      onSubmit: handleDeposit,
    );
  }
}
