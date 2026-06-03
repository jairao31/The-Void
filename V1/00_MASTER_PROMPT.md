# The Void — Master Prompt for Claude Code
# Read this first. Feed this to Claude Code before anything else.

---

## HOW TO USE THESE DOCUMENTS

You have 6 files. Feed them to Claude Code in this order:

1. `00_MASTER_PROMPT.md` — this file (read first, sets the rules)
2. `01_PRD.md` — what we're building and why
3. `02_TECHNICAL_ARCHITECTURE.md` — stack, folder structure, database, algorithms
4. `03_BACKEND_SPEC.md` — every API endpoint, business logic, deployment
5. `04_SECURITY_ACCESS.md` — auth, permissions, error handling, edge cases
6. `05_FRONTEND_SPEC.md` — colours, typography, components, all screen copy
7. `design_reference.html` — open this in a browser alongside the docs

---

## THE PROMPT — COPY THIS EXACTLY INTO CLAUDE CODE

```
You are about to build "The Void" — a Flutter mobile app for iOS and Android.

Before writing a single line of code, read all of the following documents completely. Do not skim. Every decision about architecture, naming, design, copy, behaviour, and edge cases has already been made and documented. Your job is to build — not to decide.

Documents provided:
- 01_PRD.md — product requirements, user flow, feature list
- 02_TECHNICAL_ARCHITECTURE.md — tech stack, folder structure, database schema, algorithms
- 03_BACKEND_SPEC.md — FastAPI backend, all endpoints, deployment
- 04_SECURITY_ACCESS.md — authentication, permissions, error handling, every edge case
- 05_FRONTEND_SPEC.md — colours, typography, all components, all user-facing strings
- design_reference.html — open this in a browser to see every screen visually

Rules you must follow without exception:

1. NEVER assume anything. If a decision has been documented, use it. If something is not documented, ask before proceeding.

2. NEVER hardcode any user-facing string in a widget. Every string lives in lib/core/constants/app_strings.dart. If you need a new string not already in app_strings.dart, add it there first, then reference it.

3. NEVER use a colour value directly in a widget. All colours come from AppColors / AppColorsDark accessed via Theme.of(context). No hardcoded hex values in widget files.

4. NEVER add a package that is not in the approved package list in 02_TECHNICAL_ARCHITECTURE.md. If you think a package is needed that is not listed, stop and ask.

5. NEVER build features marked "Out of scope for V1" in 01_PRD.md. Not even partially. Not as a placeholder. Do not build them.

6. ALWAYS match the visual design in design_reference.html exactly. Use the theme toggle in the top right of that file to check both light and dark modes. Every screen must work correctly in both.

7. ALWAYS follow the folder structure in 02_TECHNICAL_ARCHITECTURE.md exactly. No new folders. No renamed folders. Every file goes where it is documented to go.

8. ALWAYS use Riverpod for state management. No setState except for local UI state (e.g. which pill is selected). No Provider. No Bloc.

9. ALWAYS use go_router for navigation. No Navigator.push. No Navigator.pop except inside go_router's own builders.

10. NEVER log user data. No thought content, no session content, no email addresses in any log statement. Ever.

Build order — follow this exactly, weekend by weekend:

Weekend 1: Project setup
- Create Flutter project named "the_void"
- Set up folder structure exactly as in 02_TECHNICAL_ARCHITECTURE.md
- Install all packages from pubspec.yaml in 02_TECHNICAL_ARCHITECTURE.md
- Configure Firebase using FlutterFire CLI
- Create AppColors, AppColorsDark, AppTextStyles, AppSpacing, AppRadius
- Create AppStrings with all strings from 05_FRONTEND_SPEC.md
- Set up drift database with all 4 tables from 02_TECHNICAL_ARCHITECTURE.md
- Run build_runner to generate drift files
- Set up go_router with all routes from 02_TECHNICAL_ARCHITECTURE.md
- Set up Riverpod ProviderScope in main.dart
- Verify app launches on both iOS and Android simulator with no errors

Weekend 2: Core session flow
- Build DurationPickerScreen
- Build QuietPromptScreen (with Focus/DND settings deep link)
- Build CountdownScreen (3 seconds, no back, fade entry)
- Build VoidSessionScreen (blank screen, pulse circle, background timer via Stopwatch)
- Build PostSessionScreen (thought input, score display)
- Build InterruptedScreen (partial credit, log reason)
- Wire session_service.dart with full score calculation algorithm
- Write all sessions and thoughts to drift database
- Verify full session loop works end to end

Weekend 3: Home screen + harvest
- Build HomeScreen with score card, quick pills, recent thoughts
- Build HarvestScreen with search, filters, thought cards
- Build stillness_score_card.dart with animated counter on score change
- Wire Riverpod providers for sessions, thoughts, scores
- Verify score updates correctly after every session
- Verify thought auto-tagging works correctly
- Implement backup nudge banner (shown after day 7 + 5 sessions)

Weekend 4: Progress + weekly report
- Build ProgressScreen with score card, bar chart, stats grid, milestones
- Implement all 10 milestone unlock checks in score_service.dart
- Build WeeklyReportScreen with stats, progress bars, best thought
- Implement share card generation using screenshot package
- Implement share via share_plus

Weekend 5: Onboarding + notifications
- Build all 4 onboarding screens with correct copy from AppStrings
- Implement onboarding_complete flag in SharedPreferences
- Implement go_router redirect logic (onboarding vs home)
- Set up flutter_local_notifications
- Implement daily "Now." notification (random time, 8am–9pm)
- Implement Sunday report notification (9am weekly)
- Request notification permission on onboarding page 4

Weekend 6: Auth + backup
- Build AuthScreen (Google Sign-In + passwordless email)
- Build BackupPasswordScreen
- Implement backup_service.dart (AES-256 encrypt → Firebase Storage upload)
- Implement restore flow (download → decrypt → drift import)
- Implement delete all data (local + cloud)
- Test backup → restore → verify data matches exactly

Weekend 7: Settings + theme + polish
- Build SettingsScreen with all sections
- Implement theme selector (light / dark / system)
- Implement theme_provider.dart with SharedPreferences persistence
- Apply dark mode to every single screen — verify using design_reference.html dark mode toggle
- Polish animations — pulse circle, countdown, score counter
- Fix all edge cases from 04_SECURITY_ACCESS.md

Weekend 8: FastAPI backend
- Build FastAPI project in /backend folder
- Implement GET /health endpoint
- Implement POST /report/generate endpoint
- Deploy to Render using render.yaml
- Test from Flutter app

Weekend 9: Testing + edge cases
- Test every edge case in 04_SECURITY_ACCESS.md
- Test on iPhone SE (small screen)
- Test on iPhone 15 Pro Max (large screen)
- Test on Android small screen
- Test with no internet connection — verify all local features work
- Test app kill mid-session — verify recovery flow
- Test backup → new device restore flow end to end
- Test delete all data — verify local + cloud both cleared

Weekend 10: App Store prep
- Generate all app icon sizes
- Configure splash screen
- Write App Store description (in 01_PRD.md — App Store Metadata section)
- Final build for TestFlight (iOS) and internal testing (Android)
- Verify bundle ID matches Firebase config

Start with Weekend 1. Do not proceed to Weekend 2 until Weekend 1 compiles and runs on both simulators with zero errors.

Ask me before making any decision not covered in the documents.
```

---

## WHAT TO DO IF CLAUDE CODE GETS STUCK

If Claude Code asks a question not covered in the documents, answer it and then add the answer to the relevant document so it's captured permanently.

If Claude Code makes a decision you didn't sanction — especially around packages, folder structure, or features — correct it immediately and remind it of Rule 4 and Rule 7.

If Claude Code adds a feature not in the PRD — stop it. Ask it to remove it completely before continuing.

---

## DOCUMENT SUMMARY

| Doc | Lines | Key contents |
|---|---|---|
| 01_PRD.md | 247 | Problem, users, vision, 13 features, complete app flow, success metrics |
| 02_TECHNICAL_ARCHITECTURE.md | 613 | Full stack, folder map, 4 DB tables, score algorithm, tagger, encryption, routes, notifications |
| 03_BACKEND_SPEC.md | 403 | 2 endpoints, business logic, caching, logging, render.yaml, complete main.py |
| 04_SECURITY_ACCESS.md | 259 | Auth flow, Firebase rules, privacy rules, full error handling, 40+ edge cases |
| 05_FRONTEND_SPEC.md | 808 | Light + dark tokens, 3 fonts, all components with code, all strings, animation specs |
| design_reference.html | 1235 | All 16 screens in light + dark mode, interactive theme toggle |
| **Total** | **3565** | **Every decision made. Nothing left to assume.** |

---

*The Void · Master Prompt · June 2026*
*Build with intention. Ship with confidence.*
