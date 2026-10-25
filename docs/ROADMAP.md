# Roadmap: Simple Bank Desktop App in Dart (Flutter GUI)

Builds the **Simple Bank Desktop App (GUI)** described in `PRD_Simple_Bank_GUI.md` (the single source of truth) with **Dart 3 and Flutter 3 (desktop)**, using a professional lavender and mint cream design. Thirteen tasks, each with a prompt-generation prompt.

---

## How to use this roadmap

### What you need

- `PRD_Simple_Bank_GUI.md` (v2.0), open or copied to text.
- **Prompt-Generator AI:** any AI chat assistant. It writes prompts but never the app code.
- **Coding agent:** an AI that edits files and runs commands in your project folder (for example Claude Code, Cursor, or GitHub Copilot agent mode).
- The Flutter SDK 3.x (it includes Dart 3). Run `flutter doctor` and make sure at least one desktop target (Windows, macOS, or Linux) shows a green check. Git is recommended.
- If a desktop toolchain cannot be installed, you may run the app in Chrome with `flutter run -d chrome` as a fallback. Tell your instructor, because window behavior differs slightly.

> **Before Task D-01, complete the Setup guide below:** install the tools (Part A) and set up the GitHub repository (Part B). The PRD lives in the repository at `docs/PRD.md`, so your coding agent can read it at any time.

### The pipeline for every task

1. **Read the task** in this roadmap and copy its **Prompt-generation prompt**.
2. **Paste it into the Prompt-Generator AI.** It replies with a finished coding-agent prompt in one code block, plus a 3-item checklist.
3. **Review the generated prompt** with its checklist. It must contain the exact hex colors, sizes, wording, and function names from the PRD, the file paths, the constraints, and acceptance criteria. If something is missing, tell the Prompt-Generator what to add.
4. **Paste the generated prompt into the coding agent** and let it work.
5. **Verify** against the task's Done-when list by running `flutter analyze`, `flutter test`, and `flutter run`, and by looking at the window yourself.
6. **Commit and open a pull request** from your task branch (see Setup guide, Part B8), get one teammate to review it, merge it, and make sure `docs/STATE.md` was updated.

If the result fails a check, paste the exact error, or describe or screenshot what looks wrong, back into the coding agent and ask for a fix. Do not move to the next task until the current one passes.

### One-time setup: start the Prompt-Generator session

Open a new chat with the Prompt-Generator AI and paste this once, with the full PRD at the end:

```text
You are the Prompt-Generator for my group's coding project. You do NOT write the application code yourself. Your only job is to write high-quality prompts that I will paste into a separate AI coding agent.

Project: a desktop banking app with a professional GUI, written in Dart 3 with Flutter 3 (Material 3, desktop target). It is built from the PRD pasted below. The PRD is the single source of truth: exact messages, hex colors, sizes, validation order, function names, and data design all come from it.

Rules for every prompt you write:
1. The prompt must be self-contained. The coding agent has not seen our chat, so put the needed PRD details inside the prompt (exact message text, hex colors, pixel sizes, function names, rules).
2. Start with a one-line role and goal. Then give context, the files to create or edit, step-by-step instructions, constraints, acceptance criteria, and a short Do-not list.
3. Constraints that always apply: Flutter 3.x and Dart 3.x, NO packages from pub.dev (only the Flutter SDK and flutter_test), the repository root is the project (package name simple_bank_flutter) with code in lib/, null safety, Dart style (lowerCamelCase, final and const where possible), money stored as int centavos, the peso sign written as the escape '\u20B1' in one constant, no underscores in number literals (Dart does not allow them, write 100000000000), logic files must NOT import package:flutter, state is shared with ChangeNotifier (no Provider, Riverpod, or Bloc), do not change code unrelated to the task, do not add features that are not in the PRD.
4. Begin the prompt by telling the agent to read AGENTS.md, docs/PRD.md (name the sections the task needs), and docs/STATE.md in the repository, and to update docs/STATE.md at the end. Still copy the exact messages, hex codes, and sizes into the prompt. End the prompt by asking the agent to report: files changed, how to analyze, test, and run, what it tested, and to describe what the window looks like.
5. Reply with ONLY the finished prompt inside one code block, followed by a 3-item checklist of what I should verify before pasting it.
6. If something is missing, ask me up to 3 short questions before writing the prompt.

Reply with the single word Ready and wait for my first task.

PRD:
[PASTE THE FULL PRD HERE]
```

### Project State Note

The coding agent starts fresh each time, but it can read the repository (`AGENTS.md`, `docs/PRD.md`, `docs/STATE.md`). The Prompt-Generator AI cannot, so it needs the note pasted in. Keep the note in `docs/STATE.md` (the agent updates it at the end of every task and it is merged with the task's pull request). Before each task, copy the current content of `docs/STATE.md` and paste it at the TOP of the task's prompt-generation prompt. The note format is:

```text
PROJECT STATE (after Task D-__)
- Files in lib/ and test/: (list them)
- Classes and their public members now: (name and signature of each)
- Theme tokens and shared widgets that exist now: (list)
- Known problems or deviations from the PRD: (list or none)
- Analyze: flutter analyze    Test: flutter test
- Run command: flutter run -d windows   (or macos / linux)
```

### Rules of thumb

- Do tasks in order. Each one builds on the previous.
- One task per coding-agent prompt. Do not combine tasks.
- Always look at the real window after UI tasks (D-04 to D-11). Compare it to PRD section 9, not just "it runs".
- Keep the Java app's screenshots (`docs/screens/`) nearby for the parity check in D-12.
- If the Prompt-Generator drifts from the PRD, remind it: "The PRD is the single source of truth."
- If you split work among teammates: do D-01 to D-06 together, then give D-07 to D-10 to different people on separate Git branches (each view is its own file, so merges are easy; only `home_page.dart` is shared).

### Troubleshooting

| Problem | Fix |
|---|---|
| `flutter run -d windows` says no device | Run `flutter config --enable-windows-desktop` (or macos/linux) then `flutter create --platforms=windows .` inside the project |
| The app looks like default Material purple | The theme is not applied. Check that `MaterialApp(theme: buildTheme())` is used and no widget sets its own default colors |
| Peso sign shows as a box | Use the escape `'\u20B1'`. If the platform font lacks it, report it in the README and test another desktop platform |
| Layout overflow stripes (yellow and black) | Ask the agent to wrap the content in a scroll view and use `Expanded` and `ConstrainedBox` correctly |

---

## Setup guide (do this before Task D-01)

### Part A: Install and verify Flutter and Dart (every member)

Flutter includes Dart. **Do not install Dart separately.** Use the same Flutter stable release on every computer (agree on it, and write the output of `flutter --version` in the README).

**1. Install the Flutter SDK and its desktop requirements.** Follow the official guide at docs.flutter.dev (Install → choose your OS → Desktop), summarized here:

| Your system | Steps |
|---|---|
| Windows | Download the Flutter SDK zip and extract it to `C:\src\flutter` (not inside Program Files). Add `C:\src\flutter\bin` to your PATH. Install **Visual Studio 2022 Community** (the full IDE, not VS Code) with the **Desktop development with C++** workload. Turn on **Developer Mode** (Settings → Privacy & security → For developers) |
| macOS | `brew install --cask flutter` (or the SDK zip). Install **Xcode** from the App Store, then run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`, `sudo xcodebuild -runFirstLaunch`, and `sudo xcodebuild -license`. Install CocoaPods: `brew install cocoapods` |
| Linux (Ubuntu or Debian) | `sudo snap install flutter --classic` (or the SDK tarball). Then `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev` |

**2. Verify** in a new terminal:

```bash
flutter --version
dart --version
flutter doctor -v
```

`flutter doctor` must show a green check for **Flutter** and for your desktop platform (**Windows (desktop)**, **macOS (desktop)**, or **Linux (desktop)**). Warnings about Android or iOS can be ignored. Fix anything marked with a red X for your desktop platform; the doctor output tells you what to install.

If your platform is missing, enable it, then run doctor again:

```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
flutter devices
```

`flutter devices` should list your operating system as a device (for example `Windows (desktop)`).

**3. Smoke test the toolchain** (outside the project, in any temporary folder) so setup problems are found early:

```bash
flutter create smoke_test_app
cd smoke_test_app
flutter run -d windows
```

(use `-d macos` or `-d linux`). The default counter app should open in a window. Close it and delete the `smoke_test_app` folder.

**4. Fallback if desktop tooling cannot be installed on your computer:** `flutter run -d chrome` runs the app in the browser. Tell your instructor, because window behavior differs slightly.

**5. Install Git** and set your identity (once per computer):

| System | Install Git |
|---|---|
| Windows | `winget install Git.Git` (then reopen the terminal) |
| macOS | `xcode-select --install` or `brew install git` |
| Linux | `sudo apt install git` |

```bash
git --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

Use the same email as your GitHub account. On Windows also run `git config --global core.autocrlf true`; on macOS and Linux run `git config --global core.autocrlf input`.

**6. Choose an editor.**

- **VS Code:** install the **Flutter** extension (it installs the Dart extension too). Open the Command Palette and run **Flutter: Run Flutter Doctor**.
- **Android Studio or IntelliJ IDEA:** install the **Flutter** plugin.

You can run every command in this roadmap from a terminal.

**7. Set up your coding agent** (Claude Code, Cursor, GitHub Copilot agent mode, or similar) following its own installation guide, and sign in. Always open it **at the repository root**.

**8. Create a GitHub account** if you do not have one, and turn on two-factor authentication.

### Setup checklist

- [ ] `flutter --version` and `dart --version` work and match your teammates' Flutter version
- [ ] `flutter doctor -v` shows green for Flutter and your desktop platform
- [ ] The smoke test app opened in a window
- [ ] `git --version` works and your name and email are configured
- [ ] Your GitHub account is created and you accepted the repository invitation (Part B)
- [ ] You can open a terminal at the repository root and start your coding agent there

### Part B: Set up the GitHub repository (team collaboration)

This project uses **two separate repositories**, one per language. This roadmap uses **simple-bank-dart**. The other language has its own repository (simple-bank-java) and its own roadmap. Both repositories hold an identical copy of the PRD.

#### B1. Roles

| Role | Who | Does |
|---|---|---|
| **Repo Owner** | One member | Creates the repository, invites everyone, seeds the first files (B4), sets branch protection (B6) |
| **Members** | Everyone else (and the owner) | Each takes tasks, works on a branch, opens pull requests, reviews others' work |

#### B2. Create the repository (Repo Owner)

1. Sign in at github.com and click **New repository** (the green button, or the + menu).
2. Repository name: **simple-bank-dart**. Visibility: **Private** (or Public if your instructor needs to see it without an invite).
3. Leave **Add a README**, **.gitignore**, and **license** all **unchecked** (we add our own, so the first push has no conflicts).
4. Click **Create repository** and copy its HTTPS URL, for example `https://github.com/<owner>/simple-bank-dart.git`.

#### B3. Invite teammates (Repo Owner)

1. Repository **Settings** → **Collaborators** (or **Collaborators and teams**) → **Add people**.
2. Enter each member's GitHub username or email and choose the **Write** role.
3. Each member accepts the invitation from the email or from github.com/notifications. Until they accept, they cannot push.
4. Also add your instructor as a collaborator (Read) if they requested it.

#### B4. Seed the repository with the PRD, roadmap, and agent instructions (Repo Owner)

Do this once, before any coding task, so the coding agent can read the PRD at any time.

```bash
git clone https://github.com/<owner>/simple-bank-dart.git
cd simple-bank-dart
mkdir docs
```

Copy the files into the repository, **renaming** them:

| Copy this file | To this path |
|---|---|
| `PRD_Simple_Bank_GUI.md` | `docs/PRD.md` |
| `ROADMAP_Dart_Flutter_GUI.md` | `docs/ROADMAP.md` |

Then create these files at the repository root:

**`AGENTS.md`**

```markdown
# Agent instructions: Simple Bank (Dart and Flutter)

## Always do this first
1. Read docs/PRD.md. It is the single source of truth. If a prompt and the PRD disagree, the PRD wins: stop and tell the user about the conflict.
2. Read docs/STATE.md to see what already exists.
3. Do ONLY the task in the prompt. Do not add features or files outside it.

## Project facts
- Dart 3 and Flutter 3 (Material 3), desktop target. Package name: simple_bank_flutter.
- NO packages from pub.dev. Only the Flutter SDK and flutter_test. State sharing uses ChangeNotifier only.
- Code is in lib/ (logic in lib/logic/, UI in lib/ui/), tests in test/.
- Analyze: flutter analyze    Test: flutter test    Run: flutter run -d windows (or macos, linux)
- Money is stored as int centavos. The peso sign comes only from the constant '\u20B1'.
- Dart does not allow underscores in number literals (write 100000000000).
- Logic files (lib/logic/) must not import package:flutter (except foundation.dart for ChangeNotifier).
- Colors, sizes, and wording come from PRD sections 9 and 10. Use the tokens in lib/ui/theme.dart; never hard-code a color.

## Rules
- Do not edit docs/PRD.md or docs/ROADMAP.md.
- Do not commit, push, switch branches, or rewrite Git history. The user does that.
- Run flutter analyze and flutter test and make them clean before reporting.
- At the end, update docs/STATE.md (files, classes and public members, known deviations).
- Report: files changed, how you tested, and anything that deviates from the PRD.
```

**`CLAUDE.md`** (Claude Code reads this name; other agents such as Cursor, Copilot, and Codex read AGENTS.md)

```markdown
Read and follow AGENTS.md in this repository.
```

**`.gitignore`**

```text
# Dart and Flutter build output
.dart_tool/
build/
.flutter-plugins
.flutter-plugins-dependencies

# IDE and OS
.idea/
*.iml
.vscode/
.DS_Store
Thumbs.db

# Note: flutter create adds more entries. Merge them, do not replace this file.
```

**`.gitattributes`** (keeps line endings consistent between Windows, macOS, and Linux members)

```text
* text=auto
*.dart text eol=lf
*.md text eol=lf
```

**`README.md`**

```markdown
# Simple Bank (Dart, Flutter)

Desktop banking app with a lavender and mint cream GUI.
Requirements: docs/PRD.md. Build plan: docs/ROADMAP.md. Progress: docs/STATE.md.
Group: <group name>. Members: <names>.
```

**`docs/STATE.md`**

```text
PROJECT STATE (before Task D-01)
- Files: docs/PRD.md, docs/ROADMAP.md, AGENTS.md, CLAUDE.md, README.md, .gitignore, .gitattributes
- Known problems or deviations from the PRD: none
```

Commit and push to `main`:

```bash
git add .
git commit -m "chore: add PRD, roadmap, agent instructions"
git push -u origin main
```

> **Keep the two PRD copies identical.** If the PRD ever changes, update `docs/PRD.md` in BOTH repositories through pull requests on the same day, and note the change in the README. Never edit the PRD in only one repository.

#### B5. Everyone clones the repository (each member)

```bash
git clone https://github.com/<owner>/simple-bank-dart.git
cd simple-bank-dart
```

The first push asks you to sign in: Git for Windows and macOS open a browser window (Git Credential Manager). Alternatively install the GitHub CLI and run `gh auth login`. Never put passwords or tokens inside repository files.

#### B6. Protect the main branch (Repo Owner)

`main` must always build and run. In **Settings** → **Rules** → **Rulesets** → **New branch ruleset** (or **Branches** → **Add branch protection rule** on older layouts):

- Target: the default branch (`main`).
- Turn on **Require a pull request before merging** and set **required approvals** to **1**.
- Turn on **Block force pushes** and **Restrict deletions**.

If GitHub says this feature is unavailable for private repositories on a free plan, either make the repository public or follow the same rules by agreement (nobody pushes directly to `main`).

#### B7. Create one issue per task (Repo Owner)

Issues let the team see who owns which task. In the web UI, create 13 issues titled like `D-05: Reusable styled components`, with the body `Follow docs/ROADMAP.md, Task D-05`. Assign each to one member. A faster way, with the GitHub CLI installed (run it in Git Bash, macOS, or Linux):

```bash
gh label create task --color 5B4B8A
while IFS='|' read -r id title; do
  gh issue create --title "$id: $title" --body "Follow docs/ROADMAP.md, Task $id." --label task
done <<'EOF'
D-01|Project setup and skeleton
D-02|Logic model: Transaction, TransactionType, BankAccount
D-03|money_util (formatMoney, validateAmount) and unit tests
D-04|Theme (colors, typography, component themes)
D-05|Reusable styled widgets
D-06|Home page, sidebar, view switching, Exit dialog
D-07|Check Balance view
D-08|Deposit view
D-09|Withdraw view
D-10|Transaction History view
D-11|Keyboard, accessibility, resize, polish
D-12|Full test pass and Java parity
D-13|Cleanup, README, demo prep
EOF
```

Optionally add a **Project** board (Projects tab → New project → Board) with columns To do, In progress, In review, Done, and add the issues to it.

#### B8. The workflow for every task (each member)

1. **Claim** the issue (assign yourself). Only one person per task.
2. **Update and branch** from `main`:

```bash
git switch main
git pull
git switch -c task/D-05-components
```

3. **Run the pipeline** from the "How to use this roadmap" section (Prompt-Generator AI → coding agent) while your branch is checked out.
4. **Check the result yourself**: build, run, test, and look at the window (the task's Done-when list).
5. **Review the changes** before committing, then commit and push:

```bash
git status
git diff
git add -A
git commit -m "D-05: add reusable styled components"
git push -u origin task/D-05-components
```

6. **Open a pull request** on GitHub (click **Compare & pull request**). Title `D-05: ...`, description: what you built and how you checked it, plus `Closes #<issue number>`. Request a reviewer.
7. **Review (a different member):** check out the branch (`git fetch` then `git switch task/D-05-components`), build, run, check the Done-when list, compare with the PRD, then **Approve**.
8. **Merge** with **Squash and merge**, then **delete the branch**. Make sure `docs/STATE.md` was updated in the pull request.
9. **Everyone:** `git switch main` and `git pull` before starting the next task.

Commit message format: `D-<number>: <short description>` (for example `D-08: add deposit view`). Branch names: `task/D-<number>-<short-name>`.

#### B9. Working with coding agents in a team

- Start the agent with your **task branch** checked out, with the terminal opened at the repository root. The agent reads `AGENTS.md`, `docs/PRD.md`, and `docs/STATE.md` from the repository (your generated prompt tells it to).
- The agent edits files only. **You** run `git add`, `git commit`, and `git push` after reviewing the diff. Never let an agent commit to `main`, rewrite history, or force-push.
- Never paste passwords, tokens, or personal data into prompts or files.
- If the agent changes `docs/PRD.md`, undo it (`git checkout -- docs/PRD.md`). The PRD changes only by team decision.
- Update the **Project State Note** by keeping it in `docs/STATE.md`: the agent updates it at the end of each task, and you paste its latest content into the Prompt-Generator before the next task.

#### B10. Avoiding merge conflicts

- The tasks in the roadmap are ordered. Do D-01 to D-06 one after another (pairs are fine), merging each before starting the next.
- After D-06 is merged, D-07 to D-10 can run in parallel on different branches. Each view is its own file; only the shared home screen file may conflict.
- Pull `main` into your branch often (`git pull origin main`), keep pull requests small, and resolve any conflict in your IDE, keeping both sides' intent. Ask the other author if unsure.

#### B11. Final submission

When D-13 is merged: confirm `main` builds and the tests pass on a fresh clone, then tag the release:

```bash
git switch main
git pull
git tag v1.0
git push origin v1.0
```

Share the repository link (and add your instructor as a collaborator if the repository is private).

---

## Task list at a glance

| Task | What gets built | PRD sections |
|---|---|---|
| D-01 | Project setup and skeleton | 5 |
| D-02 | Logic model: Transaction, TransactionType, BankAccount | 6.1, 7, 8 |
| D-03 | money_util (formatMoney, validateAmount) and unit tests | 6.5, 7 |
| D-04 | Theme (colors, typography, component themes) | 9.2, 9.3 |
| D-05 | Reusable styled widgets | 9.3, 9.6 |
| D-06 | Home page, sidebar, view switching, Exit dialog | 6.2, 9.4, 9.5 |
| D-07 | Check Balance view | 6.1, 9.5 |
| D-08 | Deposit view | 6.3, 6.5, 9.5 |
| D-09 | Withdraw view | 6.4, 6.5, 9.5 |
| D-10 | Transaction History view | 6.6, 9.5 |
| D-11 | Keyboard, accessibility, resize, polish | 9.6, 9.7 |
| D-12 | Full test pass and Java parity | 12, 13 |
| D-13 | Cleanup, README, demo prep | 11, 14 |

---

## Tasks

### Task D-01: Project setup and skeleton

**Goal:** A Flutter desktop project that runs and opens an empty window. **Depends on:** nothing. **PRD refs:** section 5.

**Prompt-generation prompt:**

```text
TASK D-01: Project setup and skeleton.
Write a coding-agent prompt that sets up the Flutter project for our banking app.
The agent must: confirm flutter --version shows Flutter 3.x with Dart 3.x and that flutter doctor lists a desktop target; run flutter create --platforms=windows,macos,linux --project-name simple_bank_flutter . INSIDE the repository root (the repository already contains docs/PRD.md, docs/ROADMAP.md, AGENTS.md, CLAUDE.md, README.md, .gitignore, and .gitattributes: none of them may be lost or overwritten, and the generated .gitignore entries must be MERGED into the existing .gitignore) (the group may keep only the platforms it uses); update docs/STATE.md using the Project State Note format; remove the generated counter demo so that lib/main.dart contains a main function that calls runApp with a MaterialApp titled 'Simple Bank' (debugShowCheckedModeBanner false) whose home is a Scaffold with one centered Text 'Setup OK'; delete or replace the default test/widget_test.dart so that flutter test passes; extend the existing README.md (keep its content) with how to check the SDK (flutter --version, flutter doctor), analyze (flutter analyze), test (flutter test), and run (flutter run -d windows, or macos or linux).
Do NOT add any package to pubspec.yaml.
Acceptance criteria: flutter analyze reports no issues, flutter test passes, and flutter run opens a desktop window showing Setup OK.
Do not add banking logic or theming yet.
```

**Done when:** the desktop window opens with Setup OK; analyze and test are clean; the work is on branch task/D-01-setup and merged into main through a pull request.

### Task D-02: Logic model (Transaction, TransactionType, BankAccount)

**Goal:** The account and history work with no GUI at all. **Depends on:** D-01. **PRD refs:** 6.1, 7, 8.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-02: Logic model.
Write a coding-agent prompt that creates these files in lib/logic/ (none may import package:flutter, except foundation.dart for ChangeNotifier in bank_account.dart):
1. transaction_type.dart: enhanced enum TransactionType { deposit('Deposit'), withdrawal('Withdrawal') } with a final String label.
2. transaction.dart: class Transaction with final fields TransactionType type, int amountCentavos, int balanceAfterCentavos and a const constructor with named required parameters.
3. bank_account.dart: const int startingBalanceCentavos = 500000; class BankAccount extends ChangeNotifier with a private int _balanceCentavos initialized to the starting balance and a private final List<Transaction> _transactions; getters int get balance and List<Transaction> get transactions (returns List.unmodifiable); void deposit(int amountCentavos) (adds to the balance, calls _recordTransaction(TransactionType.deposit, amount), then notifyListeners()); bool withdraw(int amountCentavos) (returns false and changes NOTHING if the amount is greater than the balance, otherwise subtracts, records a withdrawal, notifyListeners(), returns true); private void _recordTransaction(TransactionType type, int amountCentavos) (creates a Transaction using the CURRENT balance as balanceAfter and adds it, so it must be called AFTER the balance changes).
Callers pass only already-validated positive amounts; the class does not validate text.
Add test/bank_account_test.dart (flutter_test) covering: starting balance 500000; deposit 100000 then withdraw 200000 gives balance 400000 and two records with balanceAfter 600000 and 400000; withdraw of 99999999 returns false and leaves balance and history unchanged; withdrawing exactly the balance gives 0; transactions list cannot be modified from outside.
Acceptance criteria: flutter analyze is clean and flutter test passes.
Do not write formatting, validation, or UI code.
```

**Done when:** tests pass.

### Task D-03: money_util and unit tests

**Goal:** Money text and amount validation, tested without a window. **Depends on:** D-02. **PRD refs:** 6.5, 7, 10.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-03: money_util and unit tests.
Write a coding-agent prompt that creates lib/logic/money_util.dart (no package:flutter imports) with:
1. const String currencySymbol = '\u20B1'; const int maxAmountCentavos = 100000000000; and the message constants from PRD section 10 (invalidNumberMessage, mustBePositiveMessage, maxTwoDecimalsMessage, tooLargeMessage).
2. class AmountResult with final int? centavos and final String? errorMessage, factory constructors AmountResult.ok(int) and AmountResult.error(String), and a getter bool get isValid.
3. String formatMoney(int centavos): currencySymbol + whole pesos with comma thousands separators + '.' + exactly 2 decimals. Build the comma grouping yourself with a LOOP over the digit string (insert a comma every 3 digits from the right). Do not use the intl package or NumberFormat. Use padLeft(2, '0') for the cents.
4. AmountResult validateAmount(String? text): apply PRD section 6.5 steps 1 to 5 IN ORDER: (1) trim (treat null as empty); (2) must match optional minus, one or more digits, optionally a dot plus one or more digits (RegExp.hasMatch on the whole text), else the invalid-number error; (3) negative or zero (including -0 and 0.00) gives the must-be-positive error; (4) more than 2 digits after the dot gives the max-two-decimals error; (5) whole-pesos part (leading zeros stripped) longer than 10 digits, or value above maxAmountCentavos, gives the too-large error; then convert to centavos WITHOUT double: split on the dot, int.tryParse on the whole part (null means invalid-number error), fraction padded on the right to 2 digits, whole * 100 + fraction. It must never throw for any input.
Add test/money_util_test.dart covering: formatMoney for 0, 5, 100, 500000, 123456789, 100000000000 (expect peso sign plus 0.00, 0.05, 1.00, 5,000.00, 1,234,567.89, 1,000,000,000.00); validateAmount for '1000' (100000), '250.75' (25075), '0.5' (50), ' 500 ' (50000), '0', '0.00', '-0', '-50' (must-be-positive error), 'abc', '', '1e3', '.5', '5.', '1,000' (invalid-number error), '10.999' (decimals error), '99999999999' (too large), null (invalid-number error).
Acceptance criteria: flutter analyze is clean and flutter test passes.
Do not write UI code.
```

**Done when:** all unit tests pass (this covers PRD TC-28).

### Task D-04: Theme (colors, typography, component themes)

**Goal:** One place that holds every design value, applied app-wide. **Depends on:** D-03. **PRD refs:** 9.2, 9.3.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-04: Theme.
Write a coding-agent prompt that creates lib/ui/theme.dart:
1. class AppColors (private constructor) with static const Color values copied EXACTLY from PRD 9.2: primary 0xFF5B4B8A, primaryDark 0xFF433670, primaryDeep 0xFF2E2552, lavender 0xFFE9E4F7, lavenderMist 0xFFF3F0FA, background 0xFFF5FFFA, surface 0xFFFFFFFF, mint 0xFFBFE8D4, success 0xFF2E7D5B, successBg 0xFFE3F5EC, error 0xFFB3261E, errorBg 0xFFFDECEA, withdrawal 0xFFA8324A, textPrimary 0xFF2B2540, textMuted 0xFF6B6585, border 0xFFD9D3EC, onPrimary 0xFFFFFFFF, navText 0xFFE4DEF5.
2. class AppSpacing with static const doubles sp4, sp8, sp16, sp24, sp32; radii radiusCard = 12 and radiusControl = 8; heights buttonHeight = 44, fieldHeight = 44, navItemHeight = 48, tableRowHeight = 40; sidebarWidth = 240.
3. class AppText with static TextStyle getters for brand (22 bold), viewTitle (24 bold, primaryDeep), subtitle (14, textMuted), cardTitle (18 w600), body (14, textPrimary), bodyBold (14 bold), balance (40 bold, onPrimary). Use the platform default font family (do not bundle fonts).
4. ThemeData buildTheme(): useMaterial3 true; a full ColorScheme.light built from the tokens (primary, onPrimary, secondary mint, surface, error, outline border, etc.) so NO default Material purple remains; scaffoldBackgroundColor background; filledButtonTheme (primary fill, onPrimary text, radius 8, minimum height 44, pressed primaryDark, hover about 10% white blend); outlinedButtonTheme (surface fill, 1 px primary border, primary text, radius 8, height 44, hover lavender); inputDecorationTheme (filled surface, 1 px border, radius 8, focused border 2 px primary, error border error color); dialogTheme (surface, radius 12); scrollbarTheme and dividerTheme in the palette; focusColor and highlight colors in lavender tones; visualDensity standard.
5. Update lib/main.dart to use theme: buildTheme(), and show the Setup OK text on the mint cream background.
Acceptance criteria: flutter analyze is clean; window background is mint cream (#F5FFFA); every hex value matches the PRD.
Do not build any widgets or views yet.
```

**Done when:** the empty window is mint cream; you compared each hex value to PRD 9.2.

### Task D-05: Reusable styled widgets

**Goal:** Cards, field, message box, and header that every view will reuse. **Depends on:** D-04. **PRD refs:** 9.3, 9.6 (UI-6 to UI-9).

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-05: Reusable styled widgets.
Write a coding-agent prompt that creates these widgets in lib/ui/widgets/, all using the tokens from theme.dart (no hard-coded colors, no default Material look visible):
1. app_card.dart: AppCard(child, padding default 24): a Container with surface fill, radius 12, 1 px border color, and a soft shadow (about 10% black, blurRadius 12, offset (0, 2)).
2. view_header.dart: ViewHeader(title, subtitle): title in AppText.viewTitle above subtitle in AppText.subtitle, 24 px below it.
3. amount_field.dart: AmountField with a TextEditingController and FocusNode passed in, a bool hasError, a semanticsLabel, hint text '0.00', and a prefixText of the peso sign constant (currencySymbol) shown inside the field; height 44; the error state paints the border in the error color; an onChanged callback and an onSubmitted callback.
4. message_box.dart: a sealed or enum-based MessageBox(kind: none/error/success, text): error = errorBg fill, error text, 1 px border of the same hue; success = successBg fill, success text; radius 8; padding 12; wraps text; it ALWAYS reserves the same minimum height (about 48 px) even when kind is none (render an invisible box), so layouts do not jump. Wrap it in Semantics with liveRegion true.
5. balance_chip.dart: BalanceChip(text): lavenderMist fill, radius 8 (or pill), body text, padding 8 by 12, used for 'Available balance ...'.
Create a TEMP demo screen in main.dart showing one AppCard with a ViewHeader, an AmountField, a FilledButton, an OutlinedButton, an error MessageBox, a success MessageBox, and a BalanceChip so the look can be checked.
Acceptance criteria: flutter analyze is clean; the demo matches PRD 9.6 (buttons, focus border, messages); hover and focus states work.
Do not build the sidebar or views yet.
```

**Done when:** the demo window matches PRD 9.6; you saw hover and focus states.

### Task D-06: Home page, sidebar, view switching, and Exit dialog

**Goal:** The app shell with a working menu. **Depends on:** D-05. **PRD refs:** 6.2 (FR-B1 to FR-B3), 9.4, 9.5 (Exit dialog), UI-1 to UI-5, UI-10, UI-12.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-06: Home page, sidebar, view switching, Exit dialog.
Write a coding-agent prompt that creates the app shell:
1. lib/ui/nav_item.dart: NavItem(number, label, selected, onTap) widget: 48 px tall, a small rounded number badge and a label, navText color. Hover paints a translucent white tint. Selected state paints a primary fill, onPrimary text, and a 4 px mint bar on the left edge. Focusable with a visible focus ring, activates with Enter or Space.
2. lib/ui/home_page.dart: StatefulWidget HomePage that owns one BankAccount (created in initState, disposed in dispose). Layout: a Row with a 240 px sidebar (primaryDark background) and an Expanded content area (background mint cream, padding 32, wrapped in a vertical scroll view so small windows scroll instead of overflowing). Sidebar top: 'Simple Bank' (AppText.brand) and caption 'Personal Banking' (navText, 12 px). Then NavItems in this exact order: 1 Check Balance, 2 Deposit Money, 3 Withdraw Money, 4 View Transaction History; then a Spacer, a thin divider, and NavItem 5 Exit at the bottom. The content area shows one of four placeholder views (a ViewHeader with the title and subtitle from PRD 9.5) selected by an enum AppView { balance, deposit, withdraw, history }, kept with IndexedStack or a switch.
3. Methods in the home page state: void showView(AppView view) (setState; updates the highlighted item), void handleCheckBalance(), handleDeposit(), handleWithdraw(), handleViewHistory() (each just calls showView for now), and Future<void> confirmExit().
4. confirmExit(): showDialog with an AlertDialog titled 'Exit Simple Bank', message 'Thank you for banking with us. Are you sure you want to exit?', and two buttons: OutlinedButton 'Stay' (closes the dialog) and FilledButton 'Exit' (calls exit(0) from dart:io). Esc and clicking outside behave like Stay. NavItem 5 never shows as selected.
5. Window close button (UI-12, best effort): register an AppLifecycleListener with onExitRequested that shows the same confirm dialog and returns AppExitResponse.cancel when the user chooses Stay, or AppExitResponse.exit when they choose Exit. Dispose the listener. If this does not intercept the close button on the team's platform, add a comment and a README note instead of using any package.
6. main.dart: runApp(MaterialApp(title: 'Simple Bank', theme: buildTheme(), debugShowCheckedModeBanner: false, home: HomePage())). The first view shown is balance. Remove the D-05 TEMP demo.
Acceptance criteria: clicking items 1 to 4 switches the placeholder and moves the highlight; clicking 5 shows the dialog; Stay keeps the app open; Exit closes it; layout matches PRD 9.4.
Do not build the real views yet.
```

**Done when:** TC-18 and TC-19 pass; the shell matches the wireframe in PRD 9.4; TC-26 is either passing or documented.

### Task D-07: Check Balance view

**Goal:** The first screen: balance card and caption. **Depends on:** D-06. **PRD refs:** 6.1 (FR-A1, FR-A2), FR-B4, 9.5 view 1, section 10.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-07: Check Balance view.
Write a coding-agent prompt that creates lib/ui/views/balance_view.dart and uses it in HomePage in place of the balance placeholder:
1. BalanceView(account, showStartupCaption) is a widget that rebuilds when the account changes (use ListenableBuilder with the account).
2. Layout from PRD 9.5 view 1: ViewHeader ('Check Balance', 'Your account at a glance'); below it a balance card (primary fill, radius 12, padding 32) containing the label 'Current balance' (14 px, navText) and the balance text (AppText.balance) from formatMoney(account.balance); below the card a muted caption line (textMuted, 14 px).
3. Caption behavior: the FIRST time the view is shown (right after app start) it reads exactly 'Account initialized. Current balance: ' + formatted balance. Every later time it is opened through handleCheckBalance() it reads 'Current balance: ' + formatted balance. HomePage keeps a bool field (for example _startupCaptionPending) that handleCheckBalance() sets to false after the first display.
4. No transaction record is created by viewing the balance.
Acceptance criteria: at launch the card shows the peso sign and 5,000.00 with the startup caption; opening another view and coming back shows 'Current balance: ...'.
Do not change other views.
```

**Done when:** TC-01 and TC-02 pass.

### Task D-08: Deposit view

**Goal:** Deposit form with validation and inline messages. **Depends on:** D-07. **PRD refs:** 6.3, 6.5, 9.5 view 2, UI-9.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-08: Deposit view.
Write a coding-agent prompt that creates lib/ui/views/deposit_view.dart and uses it in HomePage in place of the deposit placeholder:
1. DepositView(account) is a StatefulWidget with a TextEditingController, a FocusNode, a message state (kind and text) and a hasError flag; it rebuilds when the account changes (ListenableBuilder).
2. Layout from PRD 9.5 view 2: ViewHeader ('Deposit Money', 'Add funds to your account'); one AppCard containing top to bottom: card title 'Deposit details'; BalanceChip 'Available balance ' + formatted balance; label 'Amount'; AmountField (semantics label 'Amount to deposit'); MessageBox; a Row with FilledButton 'Deposit' and OutlinedButton 'Clear'. Content max width about 720 px, left-aligned.
3. void handleDeposit(): call validateAmount(controller.text); if invalid set the error message and hasError, then request focus and select all text in the field, and return; if valid call account.deposit(result.centavos!), clear the field, set success message 'Deposit successful. New balance: ' + formatMoney(account.balance), and clear hasError.
4. Clear button: empties the field, clears the message, clears hasError, focuses the field. Any edit in the field (onChanged) clears the message and hasError. Pressing Enter in the field (onSubmitted) calls handleDeposit(). When the user switches away and returns, the message is cleared (for example by keying the view or clearing in didUpdateWidget).
Acceptance criteria: deposit 1000 gives 'Deposit successful. New balance: ' + peso sign + 6,000.00 and the field clears; 0, -50, abc, blank, 1e3, .5, 5., 1,000, 10.999, 99999999999 each show the exact PRD error and change nothing; ' 500 ' works; each success adds one history record.
Add test/deposit_view_test.dart (widget test) that pumps the app, opens Deposit, enters 1000, taps Deposit, and expects the success text; and enters 0 and expects the must-be-positive text.
Do not change the validation rules or other views.
```

**Done when:** PRD tests TC-03 to TC-10, TC-17, TC-20, TC-22 pass for deposit; the widget test passes.

### Task D-09: Withdraw view

**Goal:** Withdraw form with the insufficient-funds rule. **Depends on:** D-08. **PRD refs:** 6.4, 6.5, 9.5 view 3.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-09: Withdraw view.
Write a coding-agent prompt that creates lib/ui/views/withdraw_view.dart as a sibling of DepositView (same structure, styling, and behavior for Enter, Clear, and edit-clears-message) and uses it in HomePage in place of the withdraw placeholder:
1. Header 'Withdraw Money' / 'Take funds from your account'; card title 'Withdrawal details'; chip 'Available balance ...'; label 'Amount'; AmountField with semantics label 'Amount to withdraw'; MessageBox; buttons FilledButton 'Withdraw' and OutlinedButton 'Clear'.
2. void handleWithdraw(): validateAmount first (same errors as deposit). If valid, call account.withdraw(centavos). If it returns false show the error 'Insufficient funds. Your balance is ' + formatMoney(balance) + '; you cannot withdraw ' + formatMoney(amount) + '.' with the error state, change nothing, and keep the field text. If it returns true clear the field and show the success message 'Withdrawal successful. New balance: ' + formatMoney(balance).
3. Withdrawing exactly the whole balance must work and leave 0.00.
Avoid duplicating large blocks of code: if DepositView and WithdrawView share most of their layout, extract a shared AmountFormView widget (taking title, subtitle, card title, button label, semantics label, and an onSubmit callback that returns a message) that both use, then re-run the Deposit tests.
Add test/withdraw_view_test.dart (widget test): withdraw 2000 from the starting balance expects the success text with 3,000.00; withdraw 5000.01 expects the insufficient-funds text.
Acceptance criteria: from 5,000.00, withdraw 2000 gives 3,000.00; withdraw 5000 gives 0.00; withdraw 5000.01 shows the insufficient-funds message with balance and history unchanged; 0, -1, abc show the same errors as deposit.
Do not change the validation rules.
```

**Done when:** PRD tests TC-11 to TC-14 pass; Deposit tests still pass after any refactor.

### Task D-10: Transaction History view

**Goal:** Styled table with empty state. **Depends on:** D-09. **PRD refs:** 6.6, 9.5 view 4.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-10: Transaction History view.
Write a coding-agent prompt that creates lib/ui/views/history_view.dart and uses it in HomePage in place of the history placeholder:
1. HistoryView(account) rebuilds when the account changes (ListenableBuilder).
2. Layout from PRD 9.5 view 4: ViewHeader ('Transaction History', 'All successful deposits and withdrawals'); one AppCard containing a caption '{n} transaction(s)' (textMuted) and the table.
3. If account.transactions is empty show only centered text 'No transactions yet.' (textMuted) instead of the table.
4. Table built from plain widgets (do not use DataTable): a fixed header row (lavender background, bold primaryDeep text, 40 px tall, columns 'No.', 'Type', 'Amount', 'Balance After' using Expanded or fixed flex widths so they align with the rows) above a scrollable ListView whose children are built with a for loop (collection-for or a loop that fills a List<Widget>) over the transactions: row number = index + 1, type label, formatMoney(amountCentavos), formatMoney(balanceAfterCentavos). Rows are 40 px tall, alternate surface and lavenderMist, with a 1 px border line under each row; No. and Type are left-aligned, Amount and Balance After right-aligned, 12 px horizontal padding; Type text is colored success for Deposit and withdrawal color for Withdrawal. The header stays visible while rows scroll (the list fills the remaining card height; give the card a bounded height via Expanded or a ConstrainedBox).
Add test/history_view_test.dart (widget test): empty state text appears with no transactions; after a deposit of 3000 and a withdrawal of 2500.50 the two rows appear in order with the expected text.
Acceptance criteria: with no transactions it shows 'No transactions yet.'; after a deposit of 3000 and a withdrawal of 2500.50 it shows two rows in order with correct Balance After values; failed attempts do not appear; 60 transactions scroll smoothly with the header visible.
Do not change other views.
```

**Done when:** TC-15, TC-16, TC-23 pass.

### Task D-11: Keyboard, accessibility, resize, and polish

**Goal:** The app feels finished and is usable without a mouse. **Depends on:** D-10. **PRD refs:** 9.3 to 9.7 (UI-5, UI-9 to UI-13).

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-11: Keyboard, accessibility, resize, polish.
Write a coding-agent prompt that polishes the Flutter app without changing behavior:
1. Keyboard shortcuts: Ctrl+1 to Ctrl+5 open Check Balance, Deposit, Withdraw, History, and the Exit dialog, using CallbackShortcuts (and optionally Cmd on macOS) wrapped around the home page content with a Focus widget that has autofocus.
2. Focus: when Deposit or Withdraw opens, the amount field gets focus; Tab order follows the visual order (field, primary button, Clear) using FocusTraversalGroup with OrderedTraversalPolicy if needed; NavItems show a visible focus ring.
3. Accessibility: add Semantics labels to NavItems (selected state included), buttons, fields, the table (header and rows), and the message box (liveRegion).
4. Resize: verify no overflow at widths of 860 px and up and that below that the content scrolls; content cards have a max width of about 720 px (left-aligned) on wide windows; the History card fills the available height.
5. Visual audit against PRD 9.2 to 9.6: find any widget that still shows a default Material color (focus overlays, ripples, dialog buttons, scrollbars, text selection handles and cursor) and theme it with palette colors. Verify all text is at least 14 px except the 12 px brand caption.
6. Run flutter analyze and flutter test.
Acceptance criteria: PRD tests TC-20 to TC-27 pass; the app can be used entirely from the keyboard.
Do not add features or change messages.
```

**Done when:** TC-20 to TC-25 and TC-27 pass; you tried the app without touching the mouse.

### Task D-12: Full test pass and Java parity

**Goal:** Prove every acceptance test and match the Java app. **Depends on:** D-11. **PRD refs:** sections 12 and 13.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-12: Full test pass and Java parity.
Write a coding-agent prompt that makes the agent:
1. Run flutter analyze and flutter test and confirm everything passes.
2. Create tests-manual/GUI-TEST-LOG.md: a table of PRD tests TC-01 to TC-27 with columns ID, steps, expected, result (Pass/Fail), notes. The agent cannot click, so it leaves Result as 'TO CHECK' for tests that need a person, and marks tests that are already covered by automated unit or widget tests (name the test file).
3. Add one end-to-end widget test (test/app_flow_test.dart) that pumps the whole app and runs this flow: open Deposit and deposit 1000; open Withdraw, first try an overdraft (an amount above the balance of 6,000.00, for example 9000) expecting the insufficient-funds text, then withdraw 2500.50; open History and expect exactly the two successful rows with correct Balance After values; open Exit, tap Stay, and expect the app still shows.
4. Create docs/screens/ and a SCREENSHOTS.md listing the four views to capture (balance, deposit with an error shown, withdraw with success shown, history with 5 rows) at about 1000x680, the same scenario as the Java screenshots.
5. PARITY (PRD TC-29): create PARITY.md with a table comparing the Java and Dart apps for: sidebar items and order, view titles and subtitles, every message text in PRD section 10, every hex color, card padding, button heights, table columns and alignment. The agent fills the Dart column from the code; the group fills the Java column from the Java project and notes any difference.
6. Fix any defect it finds with the smallest possible change.
Acceptance criteria: analyze and all tests pass; GUI-TEST-LOG.md and PARITY.md exist.
Do not add features or rewrite working code.
```

**Then you do (by hand):** run TC-01 to TC-27 in the real window, fill the Result column, take the four screenshots, and place them beside the Java screenshots. Any difference you see (other than the allowed ones in PRD section 13) must be fixed in either app.

**Done when:** every row of GUI-TEST-LOG.md is Pass; PARITY.md shows no unexplained differences.

### Task D-13: Cleanup, README, and demo prep

**Goal:** Submission-ready code and documentation. **Depends on:** D-12. **PRD refs:** sections 11 and 14.

**Prompt-generation prompt:**

```text
[Paste Project State Note here]
TASK D-13: Cleanup, README, demo prep.
Write a coding-agent prompt that finishes the Dart project:
1. Remove all TEMP code, unused variables, and unused imports. Run dart format . and flutter analyze and fix everything reported.
2. Add a short doc comment (three slashes) above every class and function (what it does, parameters, return value) and a header comment in lib/main.dart with the project name and a group-name placeholder.
3. Rewrite README.md with: what the app does, requirements, analyze, test, and run steps for each desktop platform, how to build a release app (flutter build windows, flutter build macos, or flutter build linux), the window-close-button note from D-06, the color palette table, and a table that maps each programming concept from PRD section 11 to the exact file and function where it appears.
4. Add DEMO.md with a 2-minute demo script: exact clicks and inputs, and what each one proves (startup balance, valid deposit, zero deposit error, overdraft error, history table, Exit dialog).
Acceptance criteria: flutter analyze reports no issues; flutter test passes; README concept table is accurate.
Do not change behavior, messages, or the design.
```

**Done when:** analyze is clean; tests pass; your group can explain every concept row in the README table.

---

## Final checklist

- All 13 tasks done and committed.
- `flutter analyze` is clean and `flutter test` passes.
- `tests-manual/GUI-TEST-LOG.md` shows every test Pass, and `PARITY.md` shows the Dart app matches the Java app.
- You can point to a loop (comma grouping, history rows), conditionals (`validateAmount`, insufficient funds), arithmetic and comparison operators, user-defined functions, the `List` of `Transaction` objects, and the validation code, as listed in PRD section 11.
- Be ready to explain Java versus Dart differences (Swing components versus Flutter widgets, `record` versus `class`, `ArrayList` versus `List`, event listeners versus `setState` and `ChangeNotifier`).
