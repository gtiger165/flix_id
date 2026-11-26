# Flix ID

Flix ID is a movie ticket booking mobile app built with Flutter. It lets users browse movies from [The Movie Database (TMDB)](https://www.themoviedb.org/), sign in with Firebase Authentication, pick a showtime and seats, and pay for tickets using an in-app wallet balance. The UI is tailored for an Indonesian audience, with localized theater names, `IDR` currency formatting, and Bahasa Indonesia-flavored copy.

> **Note:** This is a learning/demo project ("clone" app). It uses a committed Firebase project and a hardcoded TMDB access token for demonstration purposes.

## Features

- **Authentication** — email/password registration and login via Firebase Auth; optional profile photo picked from the gallery and uploaded to Firebase Storage.
- **Home** — time-based greeting, wallet balance shortcut, promotional banners, and horizontal "Now Playing" / "Upcoming" movie carousels powered by TMDB.
- **Movie detail** — backdrop, runtime, genres, rating, overview, and cast list.
- **Booking flow** — theater/date/time selection → interactive seat picker (2 blocks of 18 seats, 8 randomly reserved) → price breakdown → "Pay Now".
- **Wallet** — member card with balance, top-up (+IDR 100,000), and recent transaction history.
- **Tickets** — list of upcoming, paid bookings sorted by watching time.
- **Profile** — user info, wallet shortcut, and logout (several menu items are UI-only placeholders).

## Tech Stack

| Category | Technology |
| --- | --- |
| Framework | Flutter 3.22.0 (pinned via [FVM](https://fvm.app/)), Dart 3, Material 3 |
| State management | Riverpod with code generation (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) |
| Routing | `go_router` (declarative navigation) |
| Backend | Firebase — Authentication, Cloud Firestore, Storage (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`) |
| HTTP client | `dio` (TMDB REST API) |
| Models / serialization | Freezed, `json_serializable` |
| UI helpers | `google_fonts` (Poppins), `intl` (IDR formatting), `flutter_easyloading`, `image_picker` |
| Testing | `flutter_test`, `test`, `mocktail` |
| Tooling | `build_runner`, `freezed`, `riverpod_lint` + `custom_lint`, `flutter_lints` |

## Architecture

The codebase follows a clean-architecture-inspired, layered structure under `lib/`:

```
lib/
├── data/              # Repository interfaces + implementations
│   ├── repositories/  # Abstract contracts (Authentication, MovieRepository, ...)
│   ├── TMDB/          # Movie data source (Dio + TMDB API)
│   ├── firebase/      # Auth, Firestore, Storage implementations
│   └── dummies/       # Fake implementations used in tests
├── domain/            # Framework-independent business layer
│   ├── entities/      # Freezed immutable models + Result<T> sealed class
│   └── usecases/      # One class per action, implementing UseCase<R, P>
└── presentation/      # UI + state
    ├── pages/         # Feature screens and their widget-builder helpers
    ├── providers/     # Riverpod providers (DI, use cases, feature state, router)
    ├── widgets/       # Reusable presentational widgets
    ├── extensions/    # BuildContext and int formatting helpers
    └── misc/          # Colors, spacing helpers, constants
```

Key patterns:

- **Repository pattern** — data sources are abstracted behind repository interfaces; concrete implementations are injected through Riverpod providers.
- **Use cases** — each user action (`Login`, `TopUp`, `CreateTransaction`, etc.) is a single-responsibility class that calls repositories.
- **`Result<T>`** — a hand-rolled sealed class (`Success<T>` / `Failed<T>`) propagates errors across all layers instead of throwing exceptions; the UI consumes it with Dart 3 pattern-matching `switch` expressions.
- **Riverpod code generation** — `@riverpod` / `@Riverpod(keepAlive: true)` annotations generate providers for DI, use cases, and notifiers such as `userDataProvider`, `transactionDataProvider`, and the movie list providers. Generated `*.g.dart` / `*.freezed.dart` files are committed.
- **Declarative routing** — `go_router` with named routes (`/login`, `/register`, `/main`, `/detail`, `/time-booking`, `/seat-booking`, `/booking-confirmation`, `/wallet`); the main shell uses a `PageView` + custom bottom navigation.
- **Theming** — dark Material 3 theme seeded with saffron (`#F4C95D`) on a dark background (`#1F1D2B`), using the Poppins typeface.

## Getting Started

### Prerequisites

- [Flutter 3.22.0](https://docs.flutter.dev/get-started/install) (the repo pins this version via FVM — see `.fvm/fvm_config.json`)
- [FVM](https://fvm.app/) (recommended) or a matching local Flutter/Dart SDK
- An Android/iOS device or emulator (other platforms are not supported by the current Firebase configuration)
- Network access to Firebase and TMDB

> The declared SDK constraint in `pubspec.yaml` is `>=3.0.0 <3.4.1`; using the pinned Flutter 3.22.0 toolchain avoids incompatibility issues.

### Installation

```bash
git clone https://github.com/gtiger165/flix_id.git
cd flix_id

# Use the pinned Flutter version
fvm use 3.22.0

# Install dependencies
fvm flutter pub get

# Generate Freezed / json_serializable / Riverpod code
fvm dart run build_runner build --delete-conflicting-outputs
```

### Running

```bash
# Launch the app on a connected device/emulator
fvm flutter run

# Build a release APK / iOS app
fvm flutter build apk
fvm flutter build ios
```

### Analyzing and testing

```bash
fvm flutter analyze   # includes riverpod_lint via custom_lint
fvm flutter test      # note: test/widget_test.dart is a stale template test
```

The meaningful tests live in `test/data/` (TMDB repository + dummy repositories).

## Configuration

The app ships with committed configuration for the demo Firebase project `clone-flix-id` and a hardcoded TMDB bearer token in `lib/data/TMDB/tmdb_movie_repository.dart`. To use your own backends:

1. Create a Firebase project, enable **Email/Password** authentication, **Cloud Firestore**, and **Storage**.
2. Run `flutterfire configure` to regenerate `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`.
3. Replace the TMDB access token in `tmdb_movie_repository.dart` and update the TMDB image base URLs used across the UI if needed.
4. Ensure Firestore has `users` and `transactions` collections and that Storage rules allow authenticated image uploads.

> Web, macOS, Windows, and Linux platform folders exist, but `DefaultFirebaseOptions.currentPlatform` throws `UnsupportedError` for those platforms — the app currently targets Android and iOS only.

## App Usage Flow

1. **Register / Login** — create an account (optionally with a profile photo) or sign in.
2. **Browse** — pick a movie from the "Now Playing" or "Upcoming" carousels and open its detail page.
3. **Book** — choose a theater, date, and time, then select seats and confirm the price breakdown.
4. **Pay** — tap "Pay Now" to create the transaction and deduct the wallet balance (top up from the wallet page if needed).
5. **Track** — view purchased tickets on the Tickets tab and transaction history in the wallet.

## Known Limitations

- The home search bar, "Forgot Password?", and most profile menu items are UI placeholders with no behavior wired up.
- Theater list, showtimes, seat availability, ticket price (IDR 25,000), admin fee (IDR 3,000), and top-up amount (IDR 100,000) are hardcoded demo values.
- Authentication is handled with per-screen listeners rather than router-level redirects.
- Payment writes the transaction and updates the balance in separate operations (not an atomic Firestore batch).
- API credentials are committed in source; move them to secure configuration for any production use.
- `test/widget_test.dart` is the untouched Flutter counter template and will fail; rely on the tests in `test/data/`.

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Riverpod documentation](https://riverpod.dev/)
- [go_router documentation](https://pub.dev/packages/go_router)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [TMDB API](https://developer.themoviedb.org/docs)
