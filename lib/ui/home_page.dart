import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../logic/bank_account.dart';
import 'nav_item.dart';
import 'theme.dart';
import 'views/balance_view.dart';
import 'views/deposit_view.dart';
import 'views/withdraw_view.dart';
import 'widgets/view_page.dart';
import 'views/history_view.dart';

/// Available application views for Simple Bank.
enum AppView {
  /// Check Balance view.
  balance,

  /// Deposit Money view.
  deposit,

  /// Withdraw Money view.
  withdraw,

  /// View Transaction History view.
  history,
}

/// Main desktop application shell for Simple Bank.
///
/// Contains the sidebar navigation, content area with placeholder views,
/// and exit confirmation dialog handling.
class HomePage extends StatefulWidget {
  /// Creates the [HomePage] widget.
  const HomePage({
    super.key,
    this.onExit,
  });

  /// Optional exit callback used for testing termination behavior safely.
  ///
  /// When null in production, [confirmExit] delegates to [exit] from `dart:io`.
  final void Function(int code)? onExit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BankAccount _account;
  AppView _selectedView = AppView.balance;
  bool _isExitDialogOpen = false;

  /// True until the user first leaves the Check Balance view. While true the
  /// balance caption reads 'Account initialized. Current balance: ...'.
  bool _startupCaptionPending = true;

  // Window Close Button Note (PRD §9.7 UI-12 / Task D-06):
  // We register an AppLifecycleListener with onExitRequested to attempt to intercept
  // native desktop application exit requests (such as clicking the window close button)
  // using standard Flutter SDK APIs without adding third-party packages.
  // Platform limitation: On desktop platforms (specifically Windows desktop runner),
  // native WM_CLOSE window-close messages may terminate the process directly or bypass
  // Flutter framework exit hooks unless window-management packages are integrated.
  // The sidebar Exit item (confirmExit) provides the reliable, fully-tested exit flow.
  late final AppLifecycleListener _lifecycleListener;

  /// Exposes the bank account owned by this page for inspection or view integration.
  BankAccount get account => _account;

  @override
  void initState() {
    super.initState();
    _account = BankAccount();
    _lifecycleListener = AppLifecycleListener(
      onExitRequested: _handleExitRequested,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _account.dispose();
    super.dispose();
  }

  /// Switches the active view and updates the selected navigation item.
  void showView(AppView view) {
    if (_selectedView != view) {
      setState(() {
        if (_selectedView == AppView.balance) {
          _startupCaptionPending = false;
        }
        _selectedView = view;
      });
    }
  }

  /// Navigation handler for Item 1: Check Balance.
  void handleCheckBalance() {
    showView(AppView.balance);
  }

  /// Navigation handler for Item 2: Deposit Money.
  ///
  /// Navigation only. The real deposit action is `DepositView.handleDeposit`.
  void openDeposit() {
    showView(AppView.deposit);
  }

  /// Navigation handler for Item 3: Withdraw Money.
  ///
  /// Navigation only. The real withdraw action is `WithdrawView.handleWithdraw`.
  void openWithdraw() {
    showView(AppView.withdraw);
  }

  /// Navigation handler for Item 4: View Transaction History.
  void handleViewHistory() {
    showView(AppView.history);
  }

  /// Displays the modal exit confirmation dialog and returns true if confirmed.
  Future<bool> _showExitConfirmationDialog() async {
    if (!mounted) {
      return false;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exit Simple Bank'),
          content: const Text(
            'Thank you for banking with us. Are you sure you want to exit?',
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Stay'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Shows the exit confirmation dialog and terminates the application if confirmed.
  Future<void> confirmExit() async {
    if (_isExitDialogOpen) {
      return;
    }
    _isExitDialogOpen = true;

    try {
      final shouldExit = await _showExitConfirmationDialog();
      if (shouldExit) {
        if (widget.onExit != null) {
          widget.onExit!(0);
        } else {
          exit(0);
        }
      }
    } finally {
      _isExitDialogOpen = false;
    }
  }

  /// Intercepts native application exit requests on platforms where supported.
  Future<AppExitResponse> _handleExitRequested() async {
    if (_isExitDialogOpen) {
      return AppExitResponse.cancel;
    }
    _isExitDialogOpen = true;

    try {
      final shouldExit = await _showExitConfirmationDialog();
      return shouldExit ? AppExitResponse.exit : AppExitResponse.cancel;
    } finally {
      _isExitDialogOpen = false;
    }
  }

  /// Builds the content for the selected view. One branch per view; each view
  /// owns its own padding and scrolling through [ViewPage].
  Widget _buildView() {
    return switch (_selectedView) {
      AppView.balance => BalanceView(
        account: _account,
        showStartupCaption: _startupCaptionPending,
      ),
      AppView.deposit => DepositView(account: _account),
      AppView.withdraw => WithdrawView(account: _account),
      AppView.history => HistoryView(account: _account), // Replaced placeholder
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar: 240 px fixed width
          Container(
            width: AppSpacing.sidebarWidth,
            color: AppColors.primaryDark,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.sp24,
                              AppSpacing.sp32,
                              AppSpacing.sp24,
                              AppSpacing.sp24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Simple Bank',
                                  style: AppText.brand,
                                ),
                                const SizedBox(height: AppSpacing.sp4),
                                const Text(
                                  'Personal Banking',
                                  style: TextStyle(
                                    color: AppColors.navText,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          NavItem(
                            number: 1,
                            label: 'Check Balance',
                            selected: _selectedView == AppView.balance,
                            onTap: handleCheckBalance,
                          ),
                          NavItem(
                            number: 2,
                            label: 'Deposit Money',
                            selected: _selectedView == AppView.deposit,
                            onTap: openDeposit,
                          ),
                          NavItem(
                            number: 3,
                            label: 'Withdraw Money',
                            selected: _selectedView == AppView.withdraw,
                            onTap: openWithdraw,
                          ),
                          NavItem(
                            number: 4,
                            label: 'View Transaction History',
                            selected: _selectedView == AppView.history,
                            onTap: handleViewHistory,
                          ),
                          const Spacer(),
                          const Divider(
                            color: AppColors.border,
                            height: 1.0,
                            thickness: 1.0,
                          ),
                          const SizedBox(height: AppSpacing.sp8),
                          NavItem(
                            number: 5,
                            label: 'Exit',
                            selected: false,
                            onTap: confirmExit,
                          ),
                          const SizedBox(height: AppSpacing.sp16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Content area: each view applies its own padding and scrolling.
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _buildView(),
            ),
          ),
        ],
      ),
    );
  }
}
