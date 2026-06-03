# The Void — Product Requirements Document (PRD)
# Document 1 of 5
# Version 1.0 | June 2026

---

## PROBLEM STATEMENT

Modern smartphones have made boredom functionally extinct. The average person touches their phone 2,617 times a day. Every idle moment — a queue, a lift, a pause in conversation — is immediately filled with a notification, a scroll, a stimulus. The brain never gets a chance to rest.

This matters because neuroscientists have identified a brain network called the Default Mode Network (DMN) — the mental state active when we are doing nothing. The DMN is where creativity, empathy, memory consolidation, and self-knowledge live. It is the origin of every insight, every breakthrough, every moment of genuine self-understanding. Smartphones have switched it off.

The result is a generation that is perpetually stimulated and perpetually understimulated. People feel busy but not creative. Connected but not understood. Productive but not fulfilled. They have lost the ability to sit with themselves — and most don't even know it.

No app has tried to solve this. Every wellness app adds more content, more guidance, more features. The Void is the first app built around the radical act of doing nothing.

---

## TARGET USERS

### Primary user — The Overstimulated Professional (25–40)

**Who they are:**
Knowledge workers, creatives, freelancers, and entrepreneurs who feel constantly busy but rarely satisfied. They've read about mindfulness, downloaded Calm or Headspace, used it twice, and deleted it. They don't want another guided meditation. They want something simpler and more honest.

**What they want:**
- A genuine break from stimulation — not a rebranded version of it
- To feel like their idle time is valuable, not wasted
- Something that works without requiring effort or learning

**What frustrates them:**
- Apps that require them to "do" something to relax
- Guided voices telling them how to breathe
- Streaks that guilt them for missing a day
- Privacy policies that harvest their most private thoughts

**Tech comfort:** High. They will understand "local-first" and "encrypted backup" as selling points, not obstacles.

### Secondary user — The Burnt-Out Creative (22–35)

Writers, designers, musicians, and makers who feel their creativity has dried up. They've heard that boredom is the origin of ideas but have never had the space to test it. They're looking for a structured way to let their mind wander.

**What they want:**
- A place where their idle thoughts are captured and valued
- Evidence that doing nothing is productive
- Something they can point to and say "this is where my ideas come from"

### Who this app is NOT for:
- People looking for guided meditation (use Headspace/Calm)
- People looking for sleep aids (use Calm)
- People looking for productivity tools (use Todoist/Notion)
- Children or teenagers (adult experience, adult themes of mortality and stillness)

---

## PRODUCT VISION

The Void is the first app built around the philosophy that doing nothing is the most productive thing you can do. It is not a meditation app, not a mindfulness app, and not a wellness platform. It is a container for silence — and a harvest system for what that silence produces.

**One line:** The app that does nothing. That's the whole point.

**North star:** In 3 years, The Void is the app people point to when asked where their best ideas come from.

---

## CORE FEATURES — MVP (V1)

### F1 — Void Session (MUST HAVE)
The core experience. User sets a duration, the screen goes completely blank, a single pulsing circle provides the only visual feedback. No timer visible. No progress bar. No guidance. Session ends with gentle haptic feedback.

### F2 — Quiet Mode Prompt (MUST HAVE)
Before every session, the app prompts the user to enable Focus/Do Not Disturb mode. This is a guide, not a force — the app opens the phone's native settings. The user chooses. Emergency calls still get through via OS default.

### F3 — Idle Thought Catcher (MUST HAVE)
After every session, user gets 60 seconds (non-blocking nudge) to log one thought — an idea, memory, question, or observation. Single text input, max 500 characters. Optional. Auto-tagged by local keyword algorithm.

### F4 — Stillness Score (MUST HAVE)
A single growing number that tracks the user's capacity for stillness over time. Calculated from session duration, completion rate, and quiet mode usage. Never decreases. Displayed as the centrepiece of the home screen.

### F5 — Harvest Archive (MUST HAVE)
A searchable, filterable archive of all logged idle thoughts. Filters: All, Ideas, People, Memories, Questions. Search is local full-text. Most recent first. Each entry shows date, session duration, thought text, and auto-tag.

### F6 — Progress Screen (MUST HAVE)
Shows the stillness score, a 7-day bar chart of session minutes, lifetime stats (total sessions, total void time, personal record, thoughts harvested), and a milestone system.

### F7 — Milestones (MUST HAVE)
10 milestones that unlock based on usage behaviour. Shown on the Progress screen. Completed milestones show a check and date. Locked milestones show a progress bar. Never send notifications about milestones.

### F8 — Weekly Report (MUST HAVE)
Every Sunday the app generates a beautiful, shareable report card: total void time, sessions, score, thoughts harvested, longest session, score vs last week, and the best idle thought of the week. Shareable as an image card via native share sheet. Generated entirely on device.

### F9 — Onboarding Flow (MUST HAVE)
4-screen onboarding shown exactly once on first launch. Screens: The Problem, The Science, The App, Permissions. Skippable from screen 1. Never shown again after completion.

### F10 — Notifications (MUST HAVE)
Two notification types only:
1. Daily "Now." — one notification per day at a random time between 8am and 9pm. Body text is only the word "Now." — nothing else.
2. Sunday report — every Sunday at 9:00am: "Your weekly stillness report is ready."

### F11 — Encrypted Cloud Backup (MUST HAVE)
Optional. User creates account (email or Google), sets a backup password, data is AES-256 encrypted on device before upload to Firebase Storage. We cannot read backup contents. Restore on new device by signing in and entering backup password.

### F12 — Theme Support (MUST HAVE)
Light mode, dark mode, and system-based. Selectable in settings. All screens fully designed for both modes. See design_reference.html for full colour tokens.

### F13 — Settings (MUST HAVE)
Sections: Appearance (theme), Backup & Restore, Notifications, Data (delete all), About (privacy policy, what is The Void, version number).

---

## APP FLOW — COMPLETE USER JOURNEY

### First Launch Flow
```
App opens
  → Onboarding Screen 1 (The Problem)
  → Onboarding Screen 2 (The Science)
  → Onboarding Screen 3 (The App)
  → Onboarding Screen 4 (Permissions)
    → Request notification permission
  → Home Screen
```

### Returning User Flow
```
App opens
  → Home Screen (shows score, recent thoughts, quick duration pills)
```

### Session Flow (full)
```
Home Screen
  → Tap "Enter The Void" OR tap a quick duration pill
    → If "Enter The Void": Duration Picker Screen
        → Select duration (2, 5, 10, 20 min grid OR custom slider)
        → Tap "Enter The Void — X minutes →"
    → If quick pill: skip Duration Picker, pre-select that duration
  → Quiet Prompt Screen
      → "Yes, go quiet" → opens phone Focus/DND settings → user enables → returns to app → proceed
      → "Skip — I'll manage" → proceed directly
  → Countdown Screen (3 seconds, no back button)
  → Void Session Screen (active)
      → Session runs silently in background via Stopwatch
      → Single pulsing circle, two lines of muted text, "end" button top right
      → User taps "end" → Confirmation bottom sheet
          → "Keep going" → return to session
          → "End session" → Interrupted Session Screen
      → Back gesture / physical back → same confirmation bottom sheet
      → Session completes naturally (timer hits target)
          → Gentle haptic: HapticFeedback.lightImpact()
          → Fade to Post Session Screen
  → Post Session Screen
      → Shows duration + points earned
      → Optional thought input (60 second nudge, non-blocking)
      → "Save & finish" → write to DB → navigate Home
      → "Nothing came up — skip" → write session to DB → navigate Home
  → Interrupted Session Screen (if ended early)
      → Shows time lasted, partial credit
      → "Log what pulled me back" → text input → save → Home
      → "Try again" → back to Duration Picker with same duration pre-selected
```

### Backup Flow
```
Settings → "Back up my data"
  → If not signed in:
      → Auth Screen
          → "Continue with Google" → Google OAuth → Firebase Auth
          → "Continue with email" → email OTP → Firebase Auth
      → Backup Password Screen
          → Enter password + confirm
          → Warning shown: unrecoverable if forgotten
          → "Set password & back up"
  → If already signed in:
      → Backup Password Screen (if first backup)
      → OR: backup runs silently (subsequent backups)
  → Export DB as JSON → encrypt AES-256 → upload to Firebase Storage
  → Settings shows "Last backup: [date/time]"
```

### Restore Flow
```
Settings → "Restore from backup" (only visible when signed in)
  → Warning: "This will replace all data on this device"
  → Two-step confirmation
  → Enter backup password
  → Download encrypted blob → decrypt → import to drift DB
  → App reloads with restored data
```

### Delete All Data Flow
```
Settings → "Delete all my data" (red)
  → Bottom sheet warning: "This cannot be undone"
  → Second confirmation: type "delete" or tap confirm twice
  → Wipe local SQLite DB
  → Delete Firebase Storage backup (if exists)
  → Delete Firebase Auth account (if exists)
  → Return to Onboarding (fresh state)
```

---

## SUCCESS METRICS

### V1 Launch Metrics (first 90 days)
| Metric | Target |
|---|---|
| Day 1 retention | > 40% |
| Day 7 retention | > 20% |
| Day 30 retention | > 10% |
| Avg sessions per active user per week | > 3 |
| % of sessions with a logged thought | > 35% |
| Avg session duration | > 4 minutes |
| Weekly report share rate | > 15% of Sunday active users |
| Backup enablement rate | > 20% of users after 7 days |

### Qualitative signals
- App Store review sentiment (target: 4.5+ stars)
- "Where did this idea come from?" social mentions
- Press coverage without paid outreach

---

## OUT OF SCOPE FOR V1

The following are explicitly NOT in V1. Do not build them:

- Subscription / paywall of any kind
- Social features (following, sharing within app, leaderboards)
- Multi-device real-time sync (backup only)
- iPad / tablet layout
- Dark mode (designed but shipped in V2 — see V2_NOTES.md) 
  → **CORRECTION: Dark mode IS in V1 — see frontend spec**
- Home screen widgets
- Apple Watch / WearOS
- Web version
- Admin dashboard
- AI-powered thought categorisation (use local keyword tagger)
- iCloud backup
- Export to PDF / CSV
- Any analytics or tracking SDK

---

*End of PRD — Document 1 of 5*
*The Void · Version 1.0 · June 2026*
