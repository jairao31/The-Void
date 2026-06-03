# The Void

> *The app that does nothing. That's the whole point.*

A local-first mobile app for iOS and Android that helps you reclaim the lost art of doing nothing. Set a timer. The screen goes blank. No content, no music, no guidance — just you and whatever your idle mind does with the silence.

---

## What is this?

Most apps fight for every second of your attention. The Void gives those seconds back.

Neuroscientists call it the Default Mode Network — the brain state active when you're doing nothing. It's where creativity, self-knowledge, and clarity live. Smartphones switched it off. The Void switches it back on.

- **Set a timer** — 2 minutes to 60. Start small.
- **Enter The Void** — screen goes blank. No timer visible. Just a single pulsing circle.
- **Log what surfaced** — an idea, a memory, a question. Or nothing. That's fine too.
- **Watch your stillness score grow** — the only number that matters in the app.

---

## Tech stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (iOS + Android) |
| Local database | SQLite via drift ORM |
| Encryption | AES-256 + PBKDF2 |
| Auth | Firebase Auth (email + Google) |
| Cloud backup | Firebase Storage (encrypted blobs only) |
| Backend | Python 3.11 + FastAPI |
| Hosting | Render free tier |
| Notifications | Firebase Cloud Messaging |

**Monthly infra cost: $0** until significant scale.

---

## Project structure

```
the_void/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── core/
│   │   ├── constants/         # Colors, text styles, spacing, strings
│   │   ├── theme/             # App theme (light + dark)
│   │   ├── router/            # go_router navigation
│   │   └── utils/             # Date, duration, encryption helpers
│   ├── data/
│   │   ├── database/          # drift schema + generated files
│   │   ├── repositories/      # CRUD for sessions, thoughts, scores, backup
│   │   └── models/            # Data models
│   ├── domain/
│   │   ├── services/          # Business logic — sessions, scores, backup, notifications
│   │   └── providers/         # Riverpod state providers
│   ├── presentation/
│   │   ├── onboarding/        # 4-screen onboarding flow
│   │   ├── home/              # Home screen
│   │   ├── session/           # Full session flow (6 screens)
│   │   ├── harvest/           # Thought archive
│   │   ├── progress/          # Score + stats + milestones
│   │   ├── weekly_report/     # Sunday report + share card
│   │   ├── settings/          # Settings + backup + theme
│   │   └── auth/              # Sign in (backup only)
│   └── shared/
│       └── widgets/           # Reusable components
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   └── routers/
├── assets/
│   ├── fonts/
│   └── icons/
├── test/
├── pubspec.yaml
└── README.md
```

---

## Getting started

### Prerequisites

- Flutter SDK (latest stable) — [install guide](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Xcode 15+ (for iOS)
- Android Studio / Android SDK (for Android)
- Python 3.11+ (for backend)
- Firebase account — [console.firebase.google.com](https://console.firebase.google.com)

### 1. Clone the repo

```bash
git clone https://github.com/yourname/the-void.git
cd the-void
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Set up Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure — connects to your Firebase project
flutterfire configure --project=the-void
```

This generates `lib/firebase_options.dart` automatically.

In the Firebase console:
- **Authentication** → Enable Email/Password (passwordless) + Google
- **Storage** → Apply the security rules from `firebase_storage.rules`
- **iOS app** → Download `GoogleService-Info.plist` → place in `ios/Runner/`
- **Android app** → Download `google-services.json` → place in `android/app/`

### 4. Generate drift database files

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
# iOS simulator
flutter run -d ios

# Android emulator
flutter run -d android

# Physical device
flutter run -d <device-id>
```

### 6. Run the backend (optional for MVP)

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

---

## Firebase Storage rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /backups/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

---

## Environment variables

Create a `.env` file in `/backend`:

```env
# Backend only — Flutter uses Firebase directly
APP_ENV=development
APP_VERSION=1.0.0
```

No API keys live in the Flutter codebase — Firebase credentials are handled via `GoogleService-Info.plist` (iOS) and `google-services.json` (Android), both gitignored.

---

## Privacy

The Void is built around a single privacy promise:

> **Your thoughts are stored on your device. We never read them, sell them, or train on them. Ever.**

How we keep it:

- All user data (sessions, thoughts, scores) lives in SQLite on the device
- No analytics SDK of any kind
- Cloud backup is opt-in and encrypted client-side with AES-256 before upload
- The encryption key never leaves the device
- Even we cannot read backup contents
- Deleting your account wipes everything — local + cloud — with no recovery

---

## Architecture decisions

| Decision | Choice | Why |
|---|---|---|
| Local-first data | SQLite + drift | Works offline, instant reads, no server cost |
| State management | Riverpod | Compile-safe, testable, no boilerplate |
| Navigation | go_router | Deep linking ready, type-safe routes |
| Auth | Firebase Auth | Official Flutter SDK, Google Sign-In in one line |
| Cloud backup | Firebase Storage | 5GB free, per-user buckets, never pauses |
| Backup encryption | AES-256 + PBKDF2 | Client-side zero-knowledge — we cannot read it |
| Backend | FastAPI | Lightweight, async, minimal for MVP needs |

---

## Build order

Build in this order — each weekend produces something runnable:

| Weekend | Deliverable |
|---|---|
| 1 | Flutter setup, Firebase init, drift schema, folder structure |
| 2 | Full session flow — duration, quiet prompt, countdown, void, post-session |
| 3 | Score algorithm, DB writes, interrupted session handling |
| 4 | Home screen, tab bar, harvest archive |
| 5 | Progress screen, score card, bar chart, milestones |
| 6 | Onboarding flow, notification scheduling |
| 7 | Auth screen, backup/restore, Firebase Storage |
| 8 | Weekly report, share card generation |
| 9 | Settings, delete data, dark mode, polish |
| 10 | Testing, edge cases, App Store / Play Store submission |

---

## Key design decisions

**No timer visible during a session.**
The moment you show a timer, users watch it. The entire point is to stop watching. The timer runs in the background; the screen shows only a pulsing circle and the words "nothing is happening / that's the point."

**Partial credit for interrupted sessions.**
Users who end early aren't punished — they get partial stillness points and an invitation to log what pulled them back. That data becomes the most valuable thing in the app over time.

**The score never decreases.**
Stillness is a practice, not a performance. Missing a day doesn't undo progress. The score only ever goes up — slowly, meaningfully.

**Sign up is never required.**
The core app works 100% offline, forever, without an account. Sign up is only introduced when the user wants to back up their data. By that point they have something worth protecting — and that's when they say yes.

---

## V2 roadmap

See `V2_NOTES.md` for the full V2 plan including:

- Progressive auth and subscription model (RevenueCat)
- Premium features (advanced insights, challenges, deeper void modes)
- Multi-device real-time sync (delta sync architecture)
- Home screen widgets, Apple Watch, iPad layout
- Full feature backlog with priority order

---

## Contributing

This is a solo weekend project. If you've found a bug or have a suggestion, open an issue.

---

## License

MIT — do whatever you want with it. If The Void helps someone be still for two minutes, that's enough.

---

*The Void — Version 1.0.0*
*Built on weekends. Shipped with intention.*
