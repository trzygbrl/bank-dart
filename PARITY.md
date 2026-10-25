# Java and Dart Parity Verification

The Java (Swing) reference column is populated from PRD §§9.2–9.5, §10, §13,
and §15 for teammate cross-review. Dart values are recorded from the current
Flutter implementation and PRD-aligned behavior. Verify Java source/screenshots
against the reference before recording parity as manually confirmed.

## Navigation and view headings

| Surface | Java (Swing, PRD reference) | Dart (Flutter implementation) |
|---|---|---|
| Menu order | 1 Check Balance; 2 Deposit Money; 3 Withdraw Money; 4 View Transaction History; 5 Exit | 1 Check Balance; 2 Deposit Money; 3 Withdraw Money; 4 View Transaction History; 5 Exit |
| Check Balance | Title: Check Balance; subtitle: Your account at a glance | Title: Check Balance; subtitle: Your account at a glance |
| Deposit Money | Title: Deposit Money; subtitle: Add funds to your account | Title: Deposit Money; subtitle: Add funds to your account |
| Withdraw Money | Title: Withdraw Money; subtitle: Take funds from your account | Title: Withdraw Money; subtitle: Take funds from your account |
| Transaction History | Title: Transaction History; subtitle: All successful deposits and withdrawals | Title: Transaction History; subtitle: All successful deposits and withdrawals |
| Exit dialog | Exit Simple Bank; Thank you for banking with us. Are you sure you want to exit?; buttons Exit and Stay | Exit Simple Bank; Thank you for banking with us. Are you sure you want to exit?; buttons Exit and Stay |

## Section 10 messages

| Situation | Java (Swing, PRD exact text) | Dart (Flutter exact text) |
|---|---|---|
| Window title | Simple Bank | Simple Bank |
| Startup caption | Account initialized. Current balance: {bal} | Account initialized. Current balance: {bal} |
| Later balance caption | Current balance: {bal} | Current balance: {bal} |
| Invalid number | Invalid input. Please enter a numeric amount (e.g., 500 or 250.75). | Invalid input. Please enter a numeric amount (e.g., 500 or 250.75). |
| Must be positive | Amount must be greater than zero. | Amount must be greater than zero. |
| Max two decimals | Amount can have at most 2 decimal places. | Amount can have at most 2 decimal places. |
| Too large | Amount is too large. The maximum per transaction is ₱1,000,000,000.00. | Amount is too large. The maximum per transaction is ₱1,000,000,000.00. |
| Insufficient funds | Insufficient funds. Your balance is {bal}; you cannot withdraw {amt}. | Insufficient funds. Your balance is {bal}; you cannot withdraw {amt}. |
| Deposit success | Deposit successful. New balance: {bal} | Deposit successful. New balance: {bal} |
| Withdrawal success | Withdrawal successful. New balance: {bal} | Withdrawal successful. New balance: {bal} |
| Empty history | No transactions yet. | No transactions yet. |

## Palette tokens

Hex values below are the PRD values and the Dart constants in `lib/ui/theme.dart`.
Cross-check the Java palette implementation against the same reference values.

| Token | Java (Swing, PRD hex) | Dart (Flutter token) |
|---|---:|---:|
| `primary` | `#5B4B8A` | `#5B4B8A` (`AppColors.primary`) |
| `primaryDark` | `#433670` | `#433670` (`AppColors.primaryDark`) |
| `primaryDeep` | `#2E2552` | `#2E2552` (`AppColors.primaryDeep`) |
| `lavender` | `#E9E4F7` | `#E9E4F7` (`AppColors.lavender`) |
| `lavenderMist` | `#F3F0FA` | `#F3F0FA` (`AppColors.lavenderMist`) |
| `background` | `#F5FFFA` | `#F5FFFA` (`AppColors.background`) |
| `surface` | `#FFFFFF` | `#FFFFFF` (`AppColors.surface`) |
| `mint` | `#BFE8D4` | `#BFE8D4` (`AppColors.mint`) |
| `success` | `#2E7D5B` | `#2E7D5B` (`AppColors.success`) |
| `successBg` | `#E3F5EC` | `#E3F5EC` (`AppColors.successBg`) |
| `error` | `#B3261E` | `#B3261E` (`AppColors.error`) |
| `errorBg` | `#FDECEA` | `#FDECEA` (`AppColors.errorBg`) |
| `withdrawal` | `#A8324A` | `#A8324A` (`AppColors.withdrawal`) |
| `textPrimary` | `#2B2540` | `#2B2540` (`AppColors.textPrimary`) |
| `textMuted` | `#6B6585` | `#6B6585` (`AppColors.textMuted`) |
| `border` | `#D9D3EC` | `#D9D3EC` (`AppColors.border`) |
| `onPrimary` | `#FFFFFF` | `#FFFFFF` (`AppColors.onPrimary`) |
| `navText` | `#E4DEF5` | `#E4DEF5` (`AppColors.navText`) |

## Spacing, sizing, and data conventions

| Property | Java (Swing, PRD reference) | Dart (Flutter implementation) |
|---|---|---|
| Default window | 1000 × 680 px | 1000 × 680 px target; Flutter native default sizing is platform-managed |
| Minimum/responsive width | Minimum 860 px | No overflow at 860 px or more; below that content scrolls |
| Sidebar | Fixed 240 px | `AppSpacing.sidebarWidth`: 240 px |
| Typography | Brand 22 px bold; sidebar caption at least 14 px per PRD §9.1; view title 24 px bold; card title 18 px semibold; body/subtitle 14 px; balance 40 px bold | Brand 22 px bold; sidebar caption 14 px (`HomePage`); `AppText.viewTitle`: 24 px bold; `AppText.cardTitle`: 18 px semibold; body/subtitle 14 px; `AppText.balance`: 40 px bold |
| Content padding | 32 px | `AppSpacing.sp32`: 32 px |
| Form card maximum width | 720 px, left aligned | 720 px, left aligned |
| Buttons | 44 px high; 8 px radius | `AppSpacing.buttonHeight`: 44 px; `AppSpacing.radiusControl`: 8 px |
| Amount input | 44 px high; 8 px radius | `AppSpacing.fieldHeight`: 44 px; `AppSpacing.radiusControl`: 8 px |
| Sidebar item | 48 px high | `AppSpacing.navItemHeight`: 48 px |
| History header and rows | 40 px high | 40 px high (`AppSpacing.tableRowHeight` for row token) |
| Card radius | 12 px | `AppSpacing.radiusCard`: 12 px |
| Transaction columns | No., Type, Amount, Balance After | No., Type, Amount, Balance After |
| Column alignment | Left, left, right, right | Left, left, right, right |
| Money storage | Integer centavos | Integer centavos (`int`) |
| Initial balance | 500000 centavos (₱5,000.00) | `startingBalanceCentavos`: 500000 centavos (₱5,000.00) |
| Transaction maximum | ₱1,000,000,000.00 | `maxAmountCentavos`: 100000000000 centavos |

## Known allowed platform differences

Per PRD §13, native font rendering, scrollbar/dialog chrome, title-bar appearance,
Flutter minimum-window-size enforcement, and native close-button interception
may differ. Flutter window-close interception is documented in code as best
effort; the sidebar Exit action remains the reliable required flow.
