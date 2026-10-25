import 'package:flutter/material.dart';

import '../../logic/bank_account.dart';
import '../../logic/money_util.dart';
import '../theme.dart';
import '../widgets/view_header.dart';
import '../widgets/view_page.dart';

/// Check Balance view (PRD 6.1, 9.5 view 1).
///
/// Shows the current balance on a primary-colored card and a caption below it.
/// Viewing the balance never records a transaction.
class BalanceView extends StatelessWidget {
  /// Creates a [BalanceView] for [account].
  ///
  /// When [showStartupCaption] is true the caption starts with
  /// 'Account initialized.'; otherwise it reads 'Current balance: ...'.
  const BalanceView({
    super.key,
    required this.account,
    required this.showStartupCaption,
  });

  /// The account whose balance is displayed.
  final BankAccount account;

  /// Whether to show the first-display startup caption.
  final bool showStartupCaption;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: account,
      builder: (context, _) {
        final String balanceText = formatMoney(account.balance);
        final String caption = showStartupCaption
            ? 'Account initialized. Current balance: $balanceText'
            : 'Current balance: $balanceText';

        return ViewPage(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const ViewHeader(
                  title: 'Check Balance',
                  subtitle: 'Your account at a glance',
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sp32),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    boxShadow: const [AppShadows.card],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current balance',
                        style: AppText.body.copyWith(color: AppColors.onPrimary),
                      ),
                      const SizedBox(height: AppSpacing.sp8),
                      Text(balanceText, style: AppText.balance),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp16),
                Text(caption, style: AppText.subtitle),
              ],
            ),
          ),
        );
      },
    );
  }
}
