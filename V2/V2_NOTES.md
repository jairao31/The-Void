# The Void — V2 Planning Notes
# Captured during V1 build planning · June 2026
# Review these before starting V2 development

---

## 1. AUTHENTICATION STRATEGY

### Decision: Progressive Auth (Option C)
Never force sign up to use the core app. Auth is introduced naturally at two trigger points only.

### V1 foundation to build now (even though not needed yet)
- Every new user gets a **device-generated UUID** stored in `flutter_secure_storage`
- This anonymous UUID is the user's identity until they sign up
- When they eventually sign up, UUID maps to Firebase Auth UID seamlessly
- No data is lost during the transition — everything migrates invisibly

```dart
// Store on first launch — V1
final anonymousId = const Uuid().v4();
await secureStorage.write(key: 'anonymous_user_id', value: anonymousId);
```

### Two trigger points for sign up prompt
1. **Day 7 nudge** — after 5+ sessions AND 7+ days since install
   - Soft banner on Home: "Your harvest lives only on this phone. Back it up?"
   - Dismissible. Never shown again once dismissed.
   - Trigger: `sessions_count >= 5 AND days_since_install >= 7`

2. **Premium feature tap** — user taps any V2 premium feature
   - Modal: "This is a premium feature — create a free account to subscribe."
   - One tap: Google or email

### What requires an account

| Feature | V1 | V2 |
|---|---|---|
| Void sessions | No account | No account |
| Harvest archive | No account | No account |
| Stillness score | No account | No account |
| Weekly report share | No account | No account |
| Cloud backup | Optional sign in | Optional sign in |
| Premium subscription | V2 only | Required |
| Multi-device sync | V2 only | Required |
| Advanced insights | V2 only | Required |

### Golden rule
Never ask for an account before the user has completed at least 1 session.
Ideal trigger: 5+ sessions + 1+ logged thought. By then they have something worth protecting.

---

## 2. MONETISATION — SUBSCRIPTION MODEL

### RevenueCat integration (V2)
- Add RevenueCat SDK for subscription management
- Links Firebase Auth UID to RevenueCat customer ID
- Handles both App Store and Google Play billing in one SDK

### Suggested pricing tiers
| Tier | Price | What's included |
|---|---|---|
| Free | $0 | Core sessions, harvest (last 30 days), stillness score, weekly report |
| The Void Pro | $5/mo or $40/yr | Unlimited harvest history, advanced insights, challenges, deeper void modes, priority backup |

### Paywall trigger moments (never interrupt a session)
- Tapping "View full harvest history" (beyond 30 days)
- Tapping "Advanced insights" 
- Tapping "Monthly challenges"
- Tapping "Deeper void modes"

---

## 3. V2 FEATURES BACKLOG

### Premium features (Pro tier)
- [ ] **Full harvest history** — free tier shows last 30 days only
- [ ] **Advanced insights** — patterns in your idle thoughts over time, AI-powered categorisation
- [ ] **Monthly challenges** — structured escalating boredom challenges
- [ ] **Deeper void modes** — ambient soundscapes, guided silence for anxiety, deep focus mode
- [ ] **Multi-device sync** — real-time delta sync (not just blob backup)
- [ ] **Harvest export** — export thoughts as PDF or plain text

### Free but V2
- [ ] **Dark mode** — already designed, just needs to ship with V2
- [ ] **iPad / tablet layout** — separate layout for larger screens
- [ ] **Home screen widget** — stillness score + quick session start
- [ ] **Apple Watch / WearOS** — minimal session start from wrist
- [ ] **iCloud backup option** — alternative to Firebase for iOS-only users
- [ ] **Siri Shortcuts** — "Hey Siri, enter The Void"

### Architecture upgrades for V2
- [ ] Move from blob backup → delta sync (encrypt each session individually)
- [ ] Conflict resolution for multi-device (last-write-wins for sessions, merge for thoughts)
- [ ] Real-time Firestore for subscription state sync
- [ ] Analytics (privacy-preserving, aggregate only — no individual tracking)

---

## 4. REAL-TIME SYNC ARCHITECTURE (V2)

### Problem with V1 blob backup
V1 backs up the entire database as one encrypted file. Works for single device. Breaks for multi-device because:
- Device A backs up → Device B restores → Device A backs up again → Device B's changes are overwritten

### V2 delta sync approach
Each session and thought gets individually encrypted and synced:

```
Firestore structure:
users/{uid}/sessions/{session_uuid} → encrypted session blob
users/{uid}/thoughts/{thought_uuid} → encrypted thought blob  
users/{uid}/scores/{date} → encrypted daily score blob
```

Sync logic:
- On session end → immediately encrypt + push to Firestore
- On app open → pull any new items from Firestore not in local DB
- Conflict: if same UUID exists locally and remotely → keep both, flag for user review

---

## 5. WHAT NOT TO BUILD UNTIL V2 IS FUNDED

Do not build any of these during V1. Wait until you have paying users.

- RevenueCat / subscription paywall
- Multi-device real-time sync
- Social features of any kind  
- iPad / tablet layout
- Dark mode (design exists, hold for V2)
- Home screen widgets
- Apple Watch / WearOS
- Web version
- Admin dashboard
- Push notification personalisation
- AI-powered thought categorisation (use V1 keyword tagger)
- iCloud backup
- Export to PDF / CSV
- Analytics SDK of any kind

---

## 6. V2 SUCCESS METRICS TO TRACK FROM V1

Start logging these anonymously from V1 so you have baseline data for V2:

- Sessions per user per week (local aggregate only, never sent anywhere)
- Average session duration (local only)
- Thought logging rate (% of sessions that produce a logged thought)
- Day 7 retention (are users still opening after a week?)
- Day 30 retention

**How to track without violating privacy promise:**
Store all metrics locally in SQLite. Never send to a server. In V2, when user creates an account and consents, offer to share anonymous aggregate stats to help improve the app. Always opt-in, never opt-out.

---

## 7. V2 TECH STACK ADDITIONS

On top of V1 stack, V2 adds:

| Addition | Purpose | Cost |
|---|---|---|
| RevenueCat SDK | Subscription management | Free up to $2.5k MRR |
| Firestore | Real-time delta sync | ~$25/mo at scale |
| Cloud Functions | Subscription webhooks from RevenueCat | Pay per use |

Estimated V2 monthly infra cost at launch: **~$0–25/mo**
Estimated V2 monthly infra cost at 1,000 paying users: **~$50–75/mo**
At $5/mo × 1,000 users = $5,000 MRR — infra is 1–1.5% of revenue.

---

*End of V2 Notes — Version 1.0*
*The Void · Captured June 2026*
*Review before starting V2 sprint planning*
