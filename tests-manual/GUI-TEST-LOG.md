# Simple Bank GUI Test Log

This matrix maps PRD acceptance tests TC-01 through TC-27 to automated coverage
and desktop checks. Automated status refers to Flutter test coverage, not a
manual OS-window inspection.

| ID | Steps | Expected Result | Status | Test Coverage / Notes |
|---|---|---|---|---|
| TC-01 | Launch the app. | Simple Bank opens on Check Balance with ₱5,000.00 and the startup caption. | Pass (Automated) | `test/widget_test.dart`, `test/balance_view_test.dart`, `test/app_flow_test.dart` |
| TC-02 | Open Deposit, then Check Balance. | Caption reads “Current balance: ₱5,000.00”; history remains empty. | Pass (Automated) | `test/home_page_test.dart`, `test/balance_view_test.dart` |
| TC-03 | Deposit 1000. | Success shows ₱6,000.00, input clears, balance chip and balance view update. | Pass (Automated) | `test/deposit_view_test.dart`, `test/app_flow_test.dart` |
| TC-04 | Deposit 250.75. | Balance increases exactly ₱250.75. | Pass (Automated) | `test/deposit_view_test.dart` |
| TC-05 | Deposit 0. | Positive-amount error; balance unchanged and text retained. | Pass (Automated) | `test/deposit_view_test.dart` |
| TC-06 | Deposit -50. | Positive-amount error; balance unchanged. | Pass (Automated) | `test/deposit_view_test.dart` |
| TC-07 | Deposit abc, blank, 1e3, .5, 5., and 1,000. | Invalid-number error for each input. | Pass (Automated) | `test/deposit_view_test.dart`, `test/money_util_test.dart` |
| TC-08 | Deposit 10.999. | Max-two-decimals error. | Pass (Automated) | `test/deposit_view_test.dart`, `test/money_util_test.dart` |
| TC-09 | Deposit 99999999999. | Too-large error. | Pass (Automated) | `test/deposit_view_test.dart`, `test/money_util_test.dart` |
| TC-10 | Deposit ` 500 ` with surrounding spaces. | Input is trimmed and accepted as 500. | Pass (Automated) | `test/deposit_view_test.dart`, `test/money_util_test.dart` |
| TC-11 | Withdraw 2000 from a fresh account. | Success shows a balance of ₱3,000.00. | Pass (Automated) | `test/withdraw_view_test.dart` |
| TC-12 | Withdraw 5000 from a fresh account. | Withdrawal succeeds and balance becomes ₱0.00. | Pass (Automated) | `test/withdraw_view_test.dart`, `test/bank_account_test.dart` |
| TC-13 | Withdraw 5000.01 from a fresh account. | Insufficient-funds error; balance and history are unchanged. | Pass (Automated) | `test/withdraw_view_test.dart`, `test/app_flow_test.dart` |
| TC-14 | Withdraw 0, -1, and abc. | Matching positive-amount or invalid-number errors. | Pass (Automated) | `test/withdraw_view_test.dart`, `test/money_util_test.dart` |
| TC-15 | Open History without transactions. | “No transactions yet.” appears and no transaction table is shown. | Pass (Automated) | `test/app_flow_test.dart` |
| TC-16 | Deposit 3000, withdraw 2500.50, attempt invalid/overdraft transactions, then open History. | Only the two successful transactions appear, in order, with correct post-transaction balances. | Pass (Automated) | Dedicated TC-16 flow in `test/app_flow_test.dart` |
| TC-17 | Perform at least 8 actions while switching views. | App remains usable; displayed balances remain consistent. | TO CHECK | Manually repeat deposit, withdrawal, invalid input, and view switching in a desktop run; compare balance and history after each action. Automated flow coverage is in `test/app_flow_test.dart`. |
| TC-18 | Select Exit, then Stay. | Confirmation appears; Stay closes it without changing the account or closing the app. | Pass (Automated) | `test/home_page_test.dart`, `test/app_flow_test.dart` |
| TC-19 | Select Exit, then Exit. | App closes. | Pass (Automated) | `test/home_page_test.dart` verifies the injected exit callback; actual desktop process closure is platform-level and not launched by widget tests. |
| TC-20 | Press Enter in the amount field after entering a valid amount. | Same result as pressing Deposit or Withdraw. | Pass (Automated) | `test/deposit_view_test.dart`, `test/withdraw_view_test.dart` |
| TC-21 | Press Ctrl+1 through Ctrl+5. | Each matching view opens; Ctrl+5 opens Exit confirmation. | Pass (Automated) | `test/home_page_test.dart` |
| TC-22 | Enter an invalid amount, then edit the field. | Inline error disappears while editing. | Pass (Automated) | `test/deposit_view_test.dart`, `test/withdraw_view_test.dart` |
| TC-23 | Add 60 transactions and open History. | Rows scroll smoothly, header remains visible, and there is no lag. | TO CHECK | Generate at least 60 successful transactions in the desktop app and inspect scrolling performance and header behavior. |
| TC-24 | Compare every screen with PRD §9.2–§9.6. | Palette, sizes, typography, alignment, and wording match; no default toolkit colors appear. | TO CHECK | Inspect all four screens at 1000 × 680; use `SCREENSHOTS.md` and `PARITY.md` as checklists. |
| TC-25 | Resize the Flutter window to 860 px wide (and Java to its minimum size). | No clipped or overlapping controls. | TO CHECK | Automated width checks are in `test/home_page_test.dart`; manually resize the native desktop window and visually inspect all four views. |
| TC-26 | Click the native window close button (X). | Java shows Exit confirmation; Flutter shows it where supported or follows its documented limitation. | TO CHECK | Verify on a desktop build; Flutter close interception is documented as best effort. |
| TC-27 | Tab through Deposit view. | Focus follows Amount field → Deposit → Clear, with a visible focus ring. | TO CHECK | `test/widgets_test.dart` and `test/nav_item_test.dart` cover component styling/focus semantics; manually verify the integrated tab sequence and visible focus ring in the desktop app. |

## Execution record

| Check | Command | Result |
|---|---|---|
| Baseline analysis | `flutter analyze` | Pass; no issues reported. |
| Baseline suite | `flutter test` | Pass; all 100 tests passed before D-12 additions. |
| D-12 integration flow | `flutter test test/app_flow_test.dart` | Pass; 2 tests passed. |
| Final analysis | `flutter analyze` | Pass; 0 issues reported. |
| Final suite | `flutter test` | Pass; all 102 tests passed. |

The items marked **TO CHECK** require a human to interact with a native desktop
window or judge visual appearance/performance; widget tests alone do not certify
those conditions.
