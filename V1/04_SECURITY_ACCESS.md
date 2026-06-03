# The Void — Security & Access Document
# Document 4 of 5
# Version 1.0 | June 2026

---

## AUTHENTICATION METHOD

### Core app — no authentication required
The Void works 100% without any account, login, or authentication. A user can complete their entire V1 experience — sessions, harvest, score, report, settings — without ever creating an account.

### Optional authentication — for backup only
Authentication is introduced at one point only: when the user taps "Back up my data" in Settings.

**Sign-in methods supported:**
1. **Google Sign-In** — via `google_sign_in` package + Firebase Auth. One tap if Google account is already on device.
2. **Passwordless email (magic link)** — via Firebase Auth email link. User enters email → Firebase sends a sign-in link → user taps link → signed in. No password to remember.

**What Firebase stores:**
- Email address (for email sign-in) or Google account email
- Firebase UID (auto-generated)
- Sign-in tokens (managed by Firebase SDK, stored in device keychain)

**What we store:**
- Anonymous UUID — generated on first launch, stored in `flutter_secure_storage`. This UUID exists before any auth and continues to be used after.
- Firebase UID — stored by Firebase SDK automatically in secure keychain.

### Anonymous user identity
Every user gets an anonymous UUID on first launch:

```dart
// On first launch — before any sign-in
Future<void> initAnonymousId() async {
  final existing = await secureStorage.read(key: 'anonymous_user_id');
  if (existing == null) {
    final uuid = const Uuid().v4();
    await secureStorage.write(key: 'anonymous_user_id', value: uuid);
    await prefs.setString('install_date', DateTime.now().toIso8601String());
  }
}
```

This UUID is used as the local user identifier throughout V1. When the user signs up, their Firebase UID is linked to this UUID for V2 migration purposes.

---

## USER ROLES & PERMISSIONS

### V1 has one user type: the user themselves

There are no admin accounts, no moderators, no roles of any kind in V1. Every user only ever sees and touches their own data.

| Action | Anonymous user | Signed-in user |
|---|---|---|
| Start a void session | ✅ Yes | ✅ Yes |
| Log an idle thought | ✅ Yes | ✅ Yes |
| View harvest archive | ✅ Yes | ✅ Yes |
| View stillness score | ✅ Yes | ✅ Yes |
| View progress + milestones | ✅ Yes | ✅ Yes |
| View weekly report | ✅ Yes | ✅ Yes |
| Share weekly report | ✅ Yes | ✅ Yes |
| Change theme | ✅ Yes | ✅ Yes |
| Change notification settings | ✅ Yes | ✅ Yes |
| Back up data | ❌ No — sign in first | ✅ Yes |
| Restore data | ❌ No — sign in first | ✅ Yes |
| Delete all data | ✅ Yes (local only) | ✅ Yes (local + cloud) |

---

## FIREBASE STORAGE SECURITY RULES

These rules must be applied in the Firebase Console before the app ships. Copy exactly.

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Backup files — users can only access their own
    match /backups/{userId}/{allPaths=**} {
      allow read: if request.auth != null
        && request.auth.uid == userId;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024; // max 5MB per backup
      allow delete: if request.auth != null
        && request.auth.uid == userId;
    }

    // Deny everything else
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

**What these rules enforce:**
- A user can only read, write, or delete files in their own `backups/{uid}/` folder
- No user can access another user's backup
- Maximum backup file size: 5MB (user data is ~100–200KB in practice)
- No other paths are accessible — ever

---

## DATA PRIVACY RULES — NON-NEGOTIABLE

These are not just good practices — they are promises made to users in the onboarding screen and privacy policy. Violating them breaks trust permanently.

### Rules for all code:

1. **Thought content never leaves the device unencrypted.** The only time thought content touches the network is inside an AES-256 encrypted binary blob uploaded to Firebase Storage. Even then, only the user can decrypt it.

2. **No analytics SDK of any kind.** No Firebase Analytics, no Mixpanel, no Amplitude, no Crashlytics, no Datadog, no Sentry. Zero. Any SDK that could potentially read user behaviour is excluded.

3. **No third-party advertising SDK.** No AdMob, no Facebook SDK, no anything that profiles users.

4. **No logging of user content.** Backend logs must never contain thought text, session content, or any personally identifiable user data.

5. **Local data never syncs to a server in plaintext.** Ever.

---

## ERROR HANDLING — COMPLETE

Every error state in the app must be handled explicitly. No silent failures. No empty screens.

### Session errors

| Error | Cause | Handling |
|---|---|---|
| App backgrounded mid-session | User switches apps | Timer continues via Stopwatch. On foreground return: show elapsed time, continue session normally. |
| App killed mid-session | OS kills the process | On next launch: check for incomplete session in DB (ended_at IS NULL). Show: "Looks like your last session was interrupted. Want to log it?" Two options: log it (goes to interrupted screen) or dismiss. |
| Phone call during session | Incoming call | OS handles. If quiet mode enabled: call is silenced (OS default). App does nothing. When call ends and user returns: session continues. |
| System time change | User manually changes clock | Use monotonic `Stopwatch()` not wall clock for timing. System time change has no effect on elapsed time. |
| Session duration = 0 | Timer bug | Guard: if actualDurationSeconds < 10, treat as abandoned — do not write to DB, do not award points. |

### Backup errors

| Error | User-facing message | Action |
|---|---|---|
| No internet connection | "No connection. Your thoughts are safe on your phone." | Dismiss. Do not retry automatically — wait for user to try again. |
| Firebase Auth failure | "Sign-in failed. Please try again." | Show retry button. Log error to console (not to any external service). |
| Wrong backup password on restore | "Incorrect password. Please try again." | Show retry. After 5 failed attempts: show "Forgot your password?" with explanation that it cannot be recovered. |
| Backup file corrupted | "This backup appears to be damaged. Please try creating a new backup." | Cannot recover corrupted backup. Offer to start fresh. |
| Firebase Storage quota exceeded | "Backup failed. Please try again later." | Unlikely (5GB free tier, ~200KB per backup). Log warning. |
| Restore on device with existing data | "This will replace all data on this device. This cannot be undone." | Two-step confirmation required before proceeding. |

### Notification errors

| Error | Handling |
|---|---|
| Notification permission denied | Core app continues normally. Settings shows notification toggle grayed out with label "Enable in phone settings". Never nag. |
| Notification scheduling fails | Silently retry on next app open. Log to console. Never show error to user. |

### Auth errors

| Firebase error code | User-facing message |
|---|---|
| `user-not-found` | "No account found with that email." |
| `invalid-email` | "Please enter a valid email address." |
| `too-many-requests` | "Too many attempts. Please wait a moment and try again." |
| `network-request-failed` | "No connection. Please check your internet and try again." |
| `invalid-action-code` | "This sign-in link has expired. Please request a new one." |
| Any other error | "Something went wrong. Please try again." |

### Database errors

| Error | Handling |
|---|---|
| drift write failure | Retry once. If second failure: show generic error toast "Couldn't save. Please try again." Do not lose data. |
| drift read failure | Show empty state with "Something went wrong. Try restarting the app." |
| Database file corruption | Extremely rare. Show: "Your local data appears to be damaged. You can restore from a backup if you have one, or start fresh." Offer both options. |

### General UI error rules
- Every async operation shows a loading state while in progress
- Every error shows a human-readable message — never a raw exception or error code
- Errors are toasts (brief, bottom of screen) for minor issues, full screens for critical issues
- Never show a blank screen — always show either content, an empty state, or an error

---

## EDGE CASES — COMPLETE

### Onboarding
| Edge case | Handling |
|---|---|
| User force-quits during onboarding | `onboarding_complete` is only written on the last screen's CTA tap. App reopens to where they left off (page 1 — no progress tracking within onboarding). |
| User skips onboarding | `onboarding_complete` is written immediately on Skip tap. User goes to Home. Onboarding never shown again. |
| User taps back on page 1 | Nothing — back is not available on page 1. |

### Session
| Edge case | Handling |
|---|---|
| User taps "Enter The Void" twice fast | Debounce the button. Disable for 300ms after first tap. |
| User tries to start session with 0 duration | Custom slider minimum is 1 minute. Grid minimum is 2 minutes. Cannot reach 0. |
| Session ends while phone is locked | Haptic still fires (if supported). Post session screen shown when user unlocks. |
| Two sessions started simultaneously | Impossible — session button disabled once session starts. Back gesture shows confirmation sheet. |
| Thought input exceeds 500 chars | Counter shown at 400 chars ("100 remaining"). Input blocked at 500. Show: "That's enough — the best thoughts are short." |
| Thought input is only whitespace | Trim on save. If empty after trim: treat as "skip" automatically. |

### Harvest
| Edge case | Handling |
|---|---|
| Search returns no results | Show: "Nothing found. Try a different word." |
| Filter returns no results | Show: "No [tag] thoughts yet. They'll appear here after your next session." |
| Harvest is empty (new user) | Show: "Your first session is waiting. When it happens, this is where your thoughts will live." |

### Progress
| Edge case | Handling |
|---|---|
| All stats are zero (brand new user) | Score shows 0 with label "Just starting". Bar chart shows empty bars. Milestones show all locked. No change line shown. |
| Personal record is broken | Milestone check runs immediately. Haptic feedback. Score updates. |
| Score reaches 200+ | Label changes to "The still mind". No cap on score itself. |

### Backup
| Edge case | Handling |
|---|---|
| User loses backup password | Cannot recover. Show clear warning at set time. After 5 wrong attempts show: "This password cannot be recovered. You can create a new backup with a new password — this will overwrite the old one." |
| User changes phone with no backup | Data is gone. App opens fresh. Onboarding shows again. This is the intended behaviour — communicated in onboarding and day-7 nudge. |
| Backup during active session | Prevent — disable backup option during active session. |
| Restore while sessions are actively running | Impossible — session must be ended before settings are accessible. |

### Theme
| Edge case | Handling |
|---|---|
| System theme changes while app is open | `theme_provider` listens to `MediaQuery.platformBrightnessOf` — updates live. |
| User sets theme then clears app data | Theme resets to 'system'. Acceptable. |

### Notifications
| Edge case | Handling |
|---|---|
| User taps "Now." notification while in a session | Opens app, shows session in progress. Does not interrupt. |
| User taps Sunday report notification | Opens directly to Weekly Report screen. |
| Multiple "Now." scheduled by bug | Only ever schedule one. On app open, cancel all notifications with ID 1 before re-scheduling. |
| User disables notifications mid-week | Immediately cancel all scheduled notifications. Clear scheduled state. |

---

## SENSITIVE DATA HANDLING SUMMARY

| Data type | Stored | Transmitted | Encrypted |
|---|---|---|---|
| Idle thoughts | Local SQLite | Only in backup blob | Yes (AES-256) |
| Session logs | Local SQLite | Only in backup blob | Yes (AES-256) |
| Stillness score | Local SQLite | Only in backup blob | Yes (AES-256) |
| Anonymous UUID | flutter_secure_storage | Never | OS-level |
| Email address | Firebase Auth (their servers) | Yes (Firebase) | Yes (Firebase TLS) |
| Firebase UID | Firebase Auth (their servers) | Yes (Firebase) | Yes (Firebase TLS) |
| Backup password | Never stored anywhere | Never | N/A — never stored |
| Backup password hash | flutter_secure_storage (for local verify only) | Never | OS-level |
| Backup blob | Firebase Storage | Yes (on backup/restore) | Yes (AES-256 before upload) |
| Theme preference | SharedPreferences | Never | No (not sensitive) |
| Notification settings | SharedPreferences | Never | No (not sensitive) |

---

*End of Security & Access Document — Document 4 of 5*
*The Void · Version 1.0 · June 2026*
