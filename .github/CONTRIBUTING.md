# Contributing to Tradeoff Analyzer Mobile

Contributions to code, tests, documentation, and bug reports are welcome.
Please follow our [Code of Conduct](CODE_OF_CONDUCT.md) and the contribution
guidelines below before making changes.

## Before You Start

- Search existing issues and pull requests to avoid duplicate work.
- Open or identify a related issue, task, or work item before submitting a pull request.
- Discuss substantial architectural changes with the maintainer before implementing them.
- Keep each contribution focused on a single problem or improvement.

For bug reports, include the affected version, platform, steps to reproduce,
and expected and actual behavior. For feature requests, describe the problem
and the proposed improvement.

Report security vulnerabilities privately rather than through public issues.
See the [Security Policy](../SECURITY.md).

## Local Setup

Use the Flutter version configured in `.github/workflows/ci.yml`.
Android builds also require JDK 17 and the Android SDK.
See the [README](../README.md) for setup details.

1. Fork the repository and clone your fork.
2. Create a branch for your contribution, such as `fix/preserve-comparison-state`.
3. Install dependencies:

   ```bash
   flutter pub get --enforce-lockfile
   ```

Android builds require `android/app/google-services.json`. For build validation
without a real Firebase project, copy the example configuration if you do not
already have a local configuration:

```bash
cp .github/firebase/google-services.example.json android/app/google-services.json
```

The example does not connect to a real Firebase project. Do not commit real
Firebase configuration files, credentials, or personal data.

## Implementation Guidelines

- Preserve the feature-first structure and the View → ViewModel → Repository → DataSource layers.
- Keep data access out of widgets and register dependencies through GetIt.
- Use `ChangeNotifier` ViewModels for reactive presentation state and result models for asynchronous success and failure outcomes.
- Use `I` prefixes for interfaces, `Impl` suffixes for implementations, and `App` prefixes for shared widgets.
- Every class representing data must end in `Model`, including domain models, drafts, route arguments, and navigation results. Model files must end in `_model.dart`; result variants may share the base model file.
- Widgets, services, routers, enums, and ViewModels retain their own naming conventions.
- Place reusable widgets in `lib/features/shared/widgets/` and use the `comparison` feature as the architectural reference.
- Keep changes at the root cause and avoid unrelated refactoring.
- Use clear names and small, focused components rather than explanatory comments that compensate for unclear structure.
- Keep sensitive configuration out of version control and define any new environment variables explicitly.

## Navigation

- Prefer `Navigator.pushNamed()` to open screens and `Navigator.pop()` to return.
- Keep global routes in `AppRoutes` and comparison routes and argument validation in `ComparisonRoutes`. `AppRouter` delegates to the feature router and handles unknown routes or invalid arguments.
- Preserve the incoming `RouteSettings`, including route names and arguments, when creating routes.
- Require a nonempty decision theme. Pass immutable `ComparisonDraftModel` data between flow steps, never ViewModels. Direct entry to the pros and cons screens may also accept a theme string.
- Create each step's ViewModel through GetIt and dispose it when the step exits. Return updates through `ComparisonNavigationResultModel`, including system back navigation through `PopScope`.
- Preserve pros and cons when navigating backward and reopening steps. A new comparison starts with empty lists.
- Review edits return to existing steps in the navigation stack; direct entry opens the corresponding step with the current data.
- Decision confirmation requires an explicit selection of pros or cons, without an automatic recommendation.
- Save completed decisions through ViewModel → Repository → local DataSource. The local singleton retains only the latest completion in memory during the session.
- Completion removes earlier comparison steps while retaining the start screen. Starting a new comparison removes the completion screen and opens an empty theme step; the previous saved result remains until the next confirmation.
- Avoid navigation-only forwarding methods, unnecessary callbacks, and global Navigator keys when the screen context is sufficient.
- Cover route arguments, return values, and state preservation with real widget navigation tests.

## Tests and Validation

Behavior changes and bug fixes must follow test-driven development:

1. Write a test that demonstrates the intended behavior or reproduces the bug.
2. Run that specific test and confirm it fails for the expected reason.
3. Implement the smallest change needed to make it pass.
4. Run the test again, then run the relevant test suite.

Prefer widget tests for visible UI behavior, interactions, validation, and
navigation. Test affected forms and scrollable screens on small viewports and
with the keyboard open where applicable. Use real routers and ViewModels when
practical, and reset GetIt and viewport changes between tests.

Every new or behaviorally changed screen must include widget tests for essential
content, implemented states, interactions, validation, and applicable navigation.
Organize tests by feature and screen, keeping route and full-flow tests separate
from shared component tests. Do not add test-only methods to production code or
assert on mocks when observable behavior can be tested directly. Characterization
tests may pass immediately; bug fixes must first demonstrate the failure.

## CI and Release Changes

- Keep CI validation and CD publication separate. Reuse CI from CD instead of duplicating checks or build commands.
- Use maintained actions pinned to commit SHAs with version comments, and pin container versions.
- Keep Flutter, Java, Gradle, and Android Gradle Plugin versions compatible; do not bypass compatibility checks.
- Validation builds use the example Firebase configuration. Release builds require the real configuration through the `GOOGLE_SERVICES_JSON` secret, whose contents must never be printed or committed.
- Release tags must use stable `vX.Y.Z` versions matching `pubspec.yaml` and point to a commit in the history of `origin/main`.
- Grant workflow permissions only where needed. The current pipeline builds Android APKs with debug signing for testing; production signing and store distribution are not configured.
- Adding iOS requires a macOS job in reusable CI and corresponding delivery changes.
- Do not claim a pipeline is operational without confirming a complete run. Document checks that could not be performed.

## Required Local Checks

Before submitting code changes, run:

```bash
dart format lib test
flutter analyze --fatal-infos
flutter test --coverage
```

Review any formatting changes. The code must compile without errors and all
unit and widget tests must pass. Documentation-only contributions do not require
an application build or test run; state that in the pull request.

## Commits and Pull Requests

Use descriptive commit messages that explain the change, for example:

```text
Fix comparison arguments being lost when returning from review
Add widget coverage for decision confirmation
Document local Android build setup
```

Submit your pull request against `main` and complete the
[pull request template](pull_request_template.md). Include:

- A linked work item and a clear explanation of the change.
- The validation commands run and their results, including any limitations.
- Updated screenshots of every screen affected by UI changes.
- Confirmation that you extensively reviewed the final diff, including additions and deletions.

Required CI checks must pass before merging. Respond to review feedback and
update tests and screenshots when subsequent changes affect them.
