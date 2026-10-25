# Simple Bank — Two-Minute Demo

## Before the demo

- Start from a fresh app launch so the balance is ₱5,000.00.
- Keep the app at the standard 1000 × 680 desktop size.
- Have the [`README.md`](README.md) and [`PARITY.md`](PARITY.md) available if
  asked about architecture or Java-Dart parity.

## Script and actions (about 2 minutes)

### 0:00–0:20 — Introduce the app

**Say:** “This is Simple Bank, a desktop banking prototype built with Dart and
Flutter. It starts with one in-memory account at ₱5,000.00. The account is not
saved between launches, and the business logic is separate from the interface.”

**Do:** Point to the Check Balance view, startup caption, and five-item sidebar.

### 0:20–0:45 — Show a valid deposit

**Say:** “A deposit accepts a positive amount, validates the text, updates the
account, and records only a successful transaction.”

**Do:** Open **Deposit Money**, enter `1000`, and submit. Point out the
₱6,000.00 success message, cleared amount field, and updated available balance.

### 0:45–1:10 — Demonstrate withdrawal validation

**Say:** “The same form flow is reused for withdrawals. An overdraft is
rejected without changing the account or adding a history record.”

**Do:** Open **Withdraw Money**, enter `9000`, and submit. Point out the
insufficient-funds message and unchanged ₱6,000.00 balance. Replace it with
`2500.50` and submit; point out the new ₱3,499.50 balance.

### 1:10–1:35 — Show transaction history

**Say:** “History shows successful actions in chronological order, with each
transaction's amount and resulting balance. Failed attempts are excluded.”

**Do:** Open **View Transaction History**. Point to the deposit and withdrawal
rows, their numbered order, and the distinct type colors.

### 1:35–1:50 — Show keyboard navigation and safe exit

**Say:** “Ctrl+1 through Ctrl+5 open the corresponding menu actions. Exit is
confirmed so a mistaken click can be cancelled.”

**Do:** Press **Ctrl+1**, then **Ctrl+5**. Choose **Stay** and confirm the app
remains usable.

### 1:50–2:00 — Close

**Say:** “The project demonstrates integer-centavo money handling, validation,
transaction records, observable state, reusable UI components, and automated
logic and widget tests.”

**Do:** Optionally show the test command `flutter test` and the analysis command
`flutter analyze`.
