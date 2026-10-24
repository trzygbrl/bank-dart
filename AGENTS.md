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