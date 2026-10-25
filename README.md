# Simple Bank (Dart, Flutter)

Desktop banking app with a lavender and mint cream GUI.
Requirements: docs/PRD.md. Build plan: docs/ROADMAP.md. Progress: docs/STATE.md.
Group: <group name>. Members: <names>.

## Development Setup and Commands

### Check the Flutter SDK

```bash
flutter --version
flutter doctor
```

The `flutter --version` command reports the installed Flutter and Dart SDK versions. The `flutter doctor` command checks the local development environment, dependencies, and available toolchains.

### Analyze the project

```bash
flutter analyze
```

This command statically checks the Dart and Flutter source code for reported issues, warnings, and lint rules.

### Run the tests

```bash
flutter test
```

This command executes the project's automated tests.

### Run the desktop application

Provide the applicable command for the developer's operating system:

```bash
flutter run -d windows
```

```bash
flutter run -d macos
```

```bash
flutter run -d linux
```

Developers should use the command corresponding to their operating system and configured desktop toolchain (for example, `flutter run -d windows` on Windows).

## Window Close Button Support (UI-12)

As specified in PRD §9.7 (UI-12) and Task D-06, window-close interception via Flutter's `AppLifecycleListener.onExitRequested` is implemented on a best-effort basis using Flutter SDK APIs without third-party window-management packages. On desktop platforms (such as Windows), native window-close events may bypass Flutter framework exit hooks depending on the embedder implementation. Reliable exit confirmation with the required modal dialog is fully supported via the sidebar "Exit" menu item.

