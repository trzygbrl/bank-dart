# Simple Bank

Simple Bank is a desktop banking prototype built with Dart 3 and Flutter 3
(Material 3). It models one in-memory account, initialized to **₱5,000.00**,
and provides balance, deposit, withdrawal, transaction-history, and exit
confirmation views in a lavender and mint cream interface.

The app is an educational prototype: it has no login, persistence, database,
network access, or real financial services. Account state resets whenever the
app is restarted.

> **Team details:** Group and member names were not supplied in the project
> files. Replace the `Not provided` values in `lib/main.dart` with the actual
> group and member names before submission.

## Requirements

- Flutter 3.x with Dart 3.x.
- Windows, macOS, or Linux desktop development support enabled in Flutter.
- No runtime third-party packages. Flutter SDK provides the application
  framework; `flutter_test` and Flutter's lint package support development.

Check the local SDK and desktop toolchain:

```shell
flutter --version
flutter doctor
```

## Run and validate

Resolve the Flutter SDK dependencies:

```shell
flutter pub get
```

Run the desktop target for the current operating system:

```shell
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

Run static analysis and the complete test suite:

```shell
flutter analyze
flutter test
```

Run the full-app integration widget tests by themselves:

```shell
flutter test test/app_flow_test.dart
```

## Using the app

The left sidebar offers these options in order:

1. **Check Balance** — view the current balance.
2. **Deposit Money** — enter a positive amount and choose Deposit.
3. **Withdraw Money** — enter a positive amount not exceeding the balance and
   choose Withdraw.
4. **View Transaction History** — review successful transactions in order.
5. **Exit** — open a confirmation dialog; choose Stay to return to the app or
   Exit to close it.

Use **Ctrl+1** through **Ctrl+5** for the same menu actions. In the amount
field, **Enter** submits the current deposit or withdrawal. Invalid values
produce inline errors and do not alter the balance or history. The amount
format requires digits, optionally followed by a dot and one or two decimal
digits; accepted transactions are limited to ₱1,000,000,000.00.

## Architecture

| Location | Responsibility |
|---|---|
| `lib/main.dart` | Application entry point, Material app, and theme initialization. |
| `lib/logic/money_util.dart` | Peso formatting, currency/limit constants, and pure amount validation. |
| `lib/logic/bank_account.dart` | In-memory account balance and observable transaction history. |
| `lib/logic/transaction.dart` and `transaction_type.dart` | Immutable transaction data and its display type. |
| `lib/ui/home_page.dart` | Shared account owner, sidebar navigation, keyboard shortcuts, and exit flow. |
| `lib/ui/views/` | Balance, deposit, withdrawal, and transaction-history screens. |
| `lib/ui/widgets/` | Shared form, card, header, message, balance-chip, and amount-field components. |
| `lib/ui/theme.dart` | Central palette, typography, spacing, sizing, and Material 3 theme. |
| `test/` | Unit and widget tests, including end-to-end banking flows. |

Business logic stays in `lib/logic/`; it does not depend on UI widgets. The UI
observes the single `BankAccount` through Flutter's `ChangeNotifier` and
`ListenableBuilder`. Money is held as integer centavos to avoid decimal
rounding.

## Required programming concepts (PRD §11)

| Concept | Example in this project |
|---|---|
| Variables and data types | `BankAccount._balanceCentavos` is an `int`; form text is `String`; transaction categories use `TransactionType`; validation returns `AmountResult`. |
| Arithmetic operators | `BankAccount.deposit` adds centavos; `withdraw` subtracts; `formatMoney` divides/remainders into pesos and centavos; `validateAmount` converts pesos to centavos. |
| Comparison operators | `validateAmount` checks positivity, precision, and maximum amount; `BankAccount.withdraw` compares amount with balance. |
| Conditional statements | Validation error branches, insufficient-funds handling, empty-history rendering, and the `AppView` switch in `_HomePageState._buildView`. |
| Loops | `formatMoney` inserts thousands separators; `validateAmount` scans digits; `HistoryView` builds a scrolling row for each transaction. |
| User-defined functions | Examples: `formatMoney`, `validateAmount`, `deposit`, `withdraw`, `showView`, `handleCheckBalance`, `openDeposit`, `openWithdraw`, `handleViewHistory`, `confirmExit`, `handleDeposit`, `handleWithdraw`, `buildTheme`, and widget `build` methods. |
| Record data structure | `BankAccount` stores a `List<Transaction>` in chronological order and exposes an unmodifiable copy. |
| Input validation and error handling | `validateAmount` returns an error result instead of throwing; `int.tryParse` guards numeric conversion; form errors appear inline; Exit requires confirmation. |

## Design and accessibility

The interface uses the palette and dimensions in PRD §9. The sidebar is 240 px
wide, the content uses 32 px padding, form cards are constrained to 720 px, and
buttons, fields, and history rows use the specified sizing tokens. Screens are
tested without overflow at the minimum supported width of 860 px.

The UI includes semantic labels for amount fields and navigation items,
keyboard shortcuts, Enter-to-submit, focus and hover feedback, and inline
success/error messages. See [`docs/PRD.md`](docs/PRD.md) for exact wording and
requirements.

## Tests and verification documentation

- `test/money_util_test.dart` and `test/bank_account_test.dart` cover logic.
- `test/*_view_test.dart` and `test/widgets_test.dart` cover UI components and
  banking views.
- `test/home_page_test.dart` and `test/app_flow_test.dart` cover navigation,
  shortcuts, dialogs, and multi-action account behavior.
- [`tests-manual/GUI-TEST-LOG.md`](tests-manual/GUI-TEST-LOG.md) maps PRD
  acceptance checks to automated tests and remaining manual desktop checks.
- [`SCREENSHOTS.md`](SCREENSHOTS.md) describes the four canonical UI captures.
- [`PARITY.md`](PARITY.md) provides a Java Swing and Dart Flutter comparison.
- [`DEMO.md`](DEMO.md) contains the two-minute presentation script.

## Known platform note

The sidebar Exit flow reliably displays the confirmation dialog. Interception
of the native window close button uses Flutter's `AppLifecycleListener` and is
best effort; some desktop embedders may bypass the Flutter exit hook. This
limitation is documented in the implementation and allowed by PRD §9.7 UI-12.

## Project documents

- [`docs/PRD.md`](docs/PRD.md) — requirements and acceptance criteria.
- [`docs/ROADMAP.md`](docs/ROADMAP.md) — implementation plan.
- [`docs/STATE.md`](docs/STATE.md) — current implementation and verification state.
