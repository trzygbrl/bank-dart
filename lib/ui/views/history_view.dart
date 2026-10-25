import 'package:flutter/material.dart';

import '../../logic/bank_account.dart';
import '../../logic/money_util.dart';
import '../../logic/transaction.dart';
import '../../logic/transaction_type.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
import '../widgets/view_header.dart';

/// Transaction History view (PRD 6.6, 9.5 view 4).
class HistoryView extends StatelessWidget {
  /// Creates a [HistoryView] for [account].
  const HistoryView({super.key, required this.account});

  /// The account whose history is displayed.
  final BankAccount account;

  /// Builds the empty state or a fixed-header, scrollable transaction table.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: account,
      builder: (context, _) {
        final transactions = account.transactions;

        // Bypassing ViewPage to avoid SingleChildScrollView layout crashes.
        // This ensures the page height is fixed and ONLY the ListView scrolls,
        // satisfying PRD TC-23 (header stays visible while rows scroll).
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.sp32),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ViewHeader(
                    title: 'Transaction History',
                    subtitle: 'All successful deposits and withdrawals',
                  ),
                  Expanded(
                    child: AppCard(
                      child: transactions.isEmpty
                          ? Center(
                              child: Text(
                                'No transactions yet.',
                                style: AppText.subtitle,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${transactions.length} transaction(s)',
                                  style: AppText.subtitle,
                                ),
                                const SizedBox(height: AppSpacing.sp16),
                                _buildTableHeader(),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                      return _buildTableRow(
                                        index,
                                        transactions[index],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the fixed table header above the independently scrolling rows.
  Widget _buildTableHeader() {
    return Container(
      height: 40,
      color: AppColors.lavender,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'No.',
              style: AppText.bodyBold.copyWith(color: AppColors.primaryDeep),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Type',
              style: AppText.bodyBold.copyWith(color: AppColors.primaryDeep),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Amount',
              textAlign: TextAlign.right,
              style: AppText.bodyBold.copyWith(color: AppColors.primaryDeep),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Balance After',
              textAlign: TextAlign.right,
              style: AppText.bodyBold.copyWith(color: AppColors.primaryDeep),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds one numbered row using the transaction's saved values.
  Widget _buildTableRow(int index, Transaction tx) {
    // Alternating rows: even = surface, odd = lavenderMist
    final bool isEven = index.isEven;
    final bool isDeposit = tx.type == TransactionType.deposit;

    return Container(
      height: 40,
      color: isEven ? AppColors.surface : AppColors.lavenderMist,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp16),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('${index + 1}', style: AppText.body)),
          Expanded(
            flex: 2,
            child: Text(
              isDeposit ? 'Deposit' : 'Withdrawal',
              style: AppText.bodyBold.copyWith(
                color: isDeposit ? AppColors.success : AppColors.withdrawal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatMoney(tx.amountCentavos),
              textAlign: TextAlign.right,
              style: AppText.body,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatMoney(tx.balanceAfterCentavos),
              textAlign: TextAlign.right,
              style: AppText.body,
            ),
          ),
        ],
      ),
    );
  }
}
