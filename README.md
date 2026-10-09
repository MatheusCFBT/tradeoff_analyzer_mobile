# Tradeoff Analyzer Mobile

[![CI](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/ci.yml/badge.svg)](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/ci.yml)
[![CD](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/cd.yml/badge.svg)](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/cd.yml)

A Flutter application for organizing decisions and weighing their pros and cons.
The project is under development; the current interface is in Portuguese.

## Current Features

1. Define the subject of a decision.
2. Add, edit, and remove supporting and opposing arguments.
3. Review the comparison and revisit earlier steps while preserving entered data.
4. Explicitly choose whether to favor the pros or cons and confirm the decision.
5. View the completion screen and start a new comparison.

The app does not automatically recommend a decision.

## Technology and Architecture

- Flutter and Dart with Material Design widgets.
- MVVM with `ChangeNotifier` and GetIt dependency injection.
- Feature-first organization with separate repositories and data sources.
- Immutable draft models and named routes for the comparison flow.
- Unit and widget tests using `flutter_test`.
- Firebase packages included for future integration; the current decision flow uses local memory.

The application follows View → ViewModel → Repository → DataSource layers.

```text
lib/
├── main.dart                 # Application entry point
├── dependency_injection/     # Central dependency registration
├── data_source/              # Domain data sources
├── features/
│   ├── comparison/
│   │   ├── models/           # Domain data and navigation results
│   │   ├── presentation/     # Screens, widgets, and ViewModels
│   │   └── repositories/     # Data access contracts and implementations
│   └── shared/               # Reusable UI components
└── routers/                  # Global routes and route resolution
```

## Local Development

### Requirements

- Flutter 3.47.1, matching the version configured in CI.
- JDK 17 and the Android SDK for Android builds.
- An Android device or emulator to run the application.

```bash
git clone https://github.com/MatheusCFBT/tradeoff_analyzer_mobile.git
cd tradeoff_analyzer_mobile
flutter pub get --enforce-lockfile
```

### Android Configuration

The Android build uses the Google Services plugin and requires
`android/app/google-services.json`. A real Firebase configuration must match
the Android application ID `com.example.tradeoff_analyzer_mobile`.

For local validation without a real Firebase project, copy the example
configuration if you do not already have a local configuration:

```bash
cp .github/firebase/google-services.example.json android/app/google-services.json
flutter run
```

The example does not connect to a real Firebase project. The local configuration
file is excluded from version control. Do not commit credentials or real Firebase
configuration files.

### Validation

```bash
dart format lib test
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --release
```

The APK is generated at `build/app/outputs/flutter-apk/app-release.apk`.

## CI and Releases

| Workflow | Triggers | Responsibility |
| --- | --- | --- |
| [CI](.github/workflows/ci.yml) | Pull requests targeting `main`, pushes to `main`, manual runs, and reusable workflow calls | Formatting, analysis, tests, security checks, and Android build |
| [CD](.github/workflows/cd.yml) | Tags matching `v*`, validated as stable `vX.Y.Z` versions | Version validation, reusable CI, and APK publication |

CI validates workflows with actionlint, scans Dart dependencies in `pubspec.lock`
with OSV-Scanner, and checks Dart code against a configured Semgrep rule for
unsafe TLS certificate handling. These scans do not cover every vulnerability
class or all transitive native dependencies. The Android build depends on the
quality and security checks passing. Coverage, security reports, and APKs are
uploaded as workflow artifacts.

Validation builds use the example Firebase configuration, including fork pull
requests. Release builds require the repository secret `GOOGLE_SERVICES_JSON`
with the real Android Firebase configuration. Publication uses `GITHUB_TOKEN`.

### Release Process

The application version uses `X.Y.Z+N` in `pubspec.yaml`. Once the corresponding
commit is part of the history of `origin/main`, a matching stable tag such as
`v1.0.0` triggers CD. Prerelease tags are not accepted.

CD reuses CI and assigns the build number from the calling workflow's run number.
After validation succeeds, it publishes `app-release.apk` with generated release
notes to [GitHub Releases](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/releases).

The APK uses debug signing and is intended for testing. Signing keys may change
between runs, requiring reinstallation. Production signing and app store
publishing are not configured. The automated build pipeline currently covers
Android only.

## Contributing

Read the [Contributing Guide](.github/CONTRIBUTING.md) for setup, architecture,
TDD, and validation requirements. Pull requests must link a related work item,
use descriptive commit messages, and include updated screenshots when screens
change. Contributors must review the final diff and ensure applicable builds
and tests pass.

Please follow the [Code of Conduct](.github/CODE_OF_CONDUCT.md).

## Security

Report vulnerabilities privately following the [Security Policy](SECURITY.md).
Do not disclose vulnerability details in public issues.

## License

This project is licensed under the [MIT License](LICENSE).
