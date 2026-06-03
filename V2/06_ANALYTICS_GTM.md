# The Void — Analytics & Go-To-Market Document
# Document 6 of 7 — V2 PLANNING DOCUMENT
# ⚠️ This document is for V2. Do not implement anything here during V1 build.
# Version 1.0 | June 2026

---

## IMPORTANT NOTE

V1 ships with zero analytics. No tracking SDK. No event logging. No user behaviour data collected.
This is a deliberate product decision tied to the privacy promise made to users in onboarding.

V2 introduces privacy-preserving, opt-in analytics only — after users have consented.
Everything in this document applies to V2 and beyond.

---

## ANALYTICS STACK

### Tool: PostHog (self-hosted or cloud)

**Why PostHog over alternatives:**
- Open source — can be self-hosted for maximum privacy control
- No data sold to third parties
- EU-hosted option available (GDPR-friendly)
- Free up to 1 million events/month on cloud
- Does not conflict with The Void's privacy story if disclosed honestly

**Alternatives considered and rejected:**
- Google Analytics / Firebase Analytics — Google profits from data; contradicts brand
- Mixpanel — third-party data sharing concerns
- Amplitude — pricing; same concerns at scale

**Implementation:**
- PostHog Flutter SDK: `posthog_flutter`
- Only initialised after user explicitly opts in (see Consent section below)
- All events are anonymous by default — no PII in event properties
- User ID: hashed anonymous UUID only, never email or Firebase UID

### Consent mechanism

Analytics is opt-in. Not opt-out.

Shown once in Settings → About → "Help improve The Void":
```
"Share anonymous usage stats to help us improve the app.
No thoughts, sessions, or personal data are ever included.
You can turn this off at any time."
[ Enable anonymous analytics ] [ No thanks ]
```

If user says no: PostHog is never initialised. Ever.
If user says yes: PostHog initialises with anonymous ID only.
Preference stored in SharedPreferences as `analytics_opted_in: bool`.

---

## EVENTS TO TRACK

### Naming convention
All events: `snake_case`. All properties: `snake_case`. No PII in any property ever.

### Core session events

| Event | When fired | Properties |
|---|---|---|
| `session_started` | User enters void screen | `duration_target_seconds`, `quiet_mode_enabled` |
| `session_completed` | Session hits target | `duration_seconds`, `quiet_mode_enabled`, `points_earned` |
| `session_interrupted` | User ends early | `duration_seconds`, `target_seconds`, `has_interrupt_reason` |
| `thought_logged` | User saves a thought | `tag` (idea/people/memory/question/null), `has_content: true` |
| `thought_skipped` | User taps skip | — |

### Onboarding events

| Event | When fired | Properties |
|---|---|---|
| `onboarding_started` | Page 1 shown | — |
| `onboarding_page_viewed` | Each page shown | `page_number` (1–4) |
| `onboarding_skipped` | Skip tapped | `skipped_on_page` |
| `onboarding_completed` | Page 4 CTA tapped | `notification_permission_granted` |

### Engagement events

| Event | When fired | Properties |
|---|---|---|
| `app_opened` | App foregrounds | `days_since_install`, `session_count_lifetime` |
| `milestone_unlocked` | Milestone check passes | `milestone_key` |
| `weekly_report_viewed` | Report screen opened | `week_number` |
| `weekly_report_shared` | Share sheet opened | — |
| `harvest_searched` | User types in search | — (no search terms) |
| `harvest_filtered` | Filter pill tapped | `filter_tag` |

### Backup & auth events (V2)

| Event | When fired | Properties |
|---|---|---|
| `backup_initiated` | User taps Back up | `is_first_backup` |
| `backup_completed` | Upload succeeds | `backup_size_kb` |
| `backup_failed` | Upload fails | `error_type` (no_internet/auth/unknown) |
| `signup_started` | Auth screen shown | `trigger` (backup/premium) |
| `signup_completed` | Auth succeeds | `method` (google/email) |

### Subscription events (V2 premium)

| Event | When fired | Properties |
|---|---|---|
| `paywall_shown` | Paywall screen shown | `trigger_feature` |
| `subscription_started` | Purchase completes | `plan` (monthly/annual), `price` |
| `subscription_cancelled` | RevenueCat webhook | `plan`, `days_subscribed` |
| `subscription_renewed` | RevenueCat webhook | `plan` |

### What is NEVER tracked
- Thought content (even hashed)
- Session duration beyond rounded buckets
- Location data
- Device identifiers beyond hashed anonymous UUID
- Email addresses
- Any personally identifiable information

---

## KEY FUNNELS TO TRACK

### 1. Onboarding funnel
```
App installed
  → Onboarding page 1 viewed         (100% baseline)
  → Onboarding page 2 viewed          (target: >80%)
  → Onboarding page 3 viewed          (target: >75%)
  → Onboarding page 4 viewed          (target: >70%)
  → Onboarding completed              (target: >65%)
  → First session started             (target: >50%)
  → First session completed           (target: >35%)
  → First thought logged              (target: >20%)
```

**Drop-off to watch:** Page 1 → Page 2. If people bail here the headline isn't landing.

### 2. Core engagement funnel (weekly)
```
User opens app
  → Taps Enter The Void              (target: >60% of opens)
  → Reaches void session screen      (target: >90% of above)
  → Completes session                (target: >65% of above)
  → Logs a thought                   (target: >40% of completions)
```

### 3. Retention funnel
```
Day 1 install
  → Day 3 return                     (target: >40%)
  → Day 7 return                     (target: >25%)
  → Day 14 return                    (target: >18%)
  → Day 30 return                    (target: >12%)
```

### 4. Backup adoption funnel (V2)
```
Day 7 nudge shown
  → Nudge tapped                     (target: >25%)
  → Auth screen completed            (target: >70% of above)
  → Backup password set              (target: >80% of above)
  → First backup completed           (target: >90% of above)
```

### 5. Subscription funnel (V2)
```
Paywall shown
  → Paywall engaged (scroll/tap)     (target: >40%)
  → Subscription started             (target: >8% of shown)
  → Still subscribed at day 30       (target: >70%)
  → Still subscribed at day 90       (target: >55%)
```

---

## KPIs & SUCCESS METRICS

### V1 targets (first 90 days post-launch)

| KPI | Definition | Target |
|---|---|---|
| Day 1 retention | % users who open app day after install | > 40% |
| Day 7 retention | % users active in week 1 still active week 2 | > 20% |
| Day 30 retention | % users still active after 30 days | > 10% |
| Session completion rate | % sessions that reach target duration | > 60% |
| Thought logging rate | % completed sessions with a logged thought | > 35% |
| Weekly active users | Unique users with ≥1 session in past 7 days | Growing MoM |
| Weekly report share rate | % Sunday actives who share their report | > 15% |
| Avg sessions per active user/week | Among users active that week | > 3 |
| Avg session duration | Mean actual duration across all completions | > 4 min |
| Onboarding completion rate | % installs that complete all 4 pages | > 65% |

### V2 targets (with subscription)

| KPI | Definition | Target |
|---|---|---|
| Free → paid conversion | % users who subscribe within 30 days | > 5% |
| Monthly churn rate | % subscribers who cancel per month | < 8% |
| MRR | Monthly recurring revenue | $500 → $5,000 in year 1 |
| LTV | Average revenue per subscriber over lifetime | > $40 |
| CAC | Cost to acquire one subscriber | < $10 (organic first) |

---

## GO-TO-MARKET STRATEGY

### Phase 1 — Zero budget launch (first 30 days)

**Goal:** 500 downloads, 100 active users, first 10 App Store reviews.

**Channels:**

1. **Press outreach — the story writes itself**
   - Pitch: "I built an app that does nothing and charges for it."
   - Targets: The Verge, Wired, Fast Company, TechCrunch, Product Hunt
   - Angle: counter-intuitive, contrarian, specific to the moment (attention economy burnout)
   - One email per publication. No follow-up spam. Quality over volume.
   - Expected result: 1–2 pickups generates 2,000–10,000 downloads alone

2. **Product Hunt launch**
   - List on a Tuesday or Wednesday (highest traffic days)
   - Prepare: compelling tagline, 3 screenshots, 30-second demo GIF
   - Engage every comment on launch day
   - Target: top 5 product of the day

3. **Twitter/X seeding**
   - Post: "I spent 6 months building an app that does nothing. Here's why." (thread)
   - Show the design process, the naming journey, the philosophy
   - Tag relevant accounts: @naval, productivity/attention economy writers
   - Do NOT pay for promotion. Organic only.

4. **Reddit**
   - Target communities: r/productivity, r/nosurf, r/digitalminimalism, r/Meditation, r/selfimprovement
   - Share as a genuine user, not a marketer
   - Post the Sunday report share card — let users discover it organically

5. **Personal network**
   - Direct message 50 people who would genuinely care about this
   - Ask for honest feedback, not promotion
   - Their organic shares are worth more than any ad

---

### Phase 2 — Content flywheel (days 30–90)

**Goal:** 2,000 downloads, 400 active users, sustainable organic growth.

1. **The Void blog / newsletter**
   - Weekly piece: the science of boredom, the case for idleness, history of doing nothing
   - Topics: "Why Einstein was a terrible employee", "What happened when I did nothing for 30 days"
   - Hosted on a simple site (thevoidapp.com)
   - Each piece ends with: "The Void is an app for this. It does nothing."

2. **Sunday report virality**
   - The weekly report share card is the growth loop
   - Every shared report is a billboard: "47 minutes of nothing. Best week yet."
   - Design the card to include the app name prominently but not obnoxiously

3. **Podcast outreach**
   - Targets: Huberman Lab, Tim Ferriss, Lex Fridman, Hidden Brain, Your Brain at Work
   - Pitch: founder story + the neuroscience angle + the product irony
   - One successful podcast = tens of thousands of downloads

4. **Corporate wellness angle**
   - Cold outreach to 20 progressive companies offering The Void as a team benefit
   - Framing: "Give your team 10 minutes of nothing per day"
   - Price: $8/seat/month (V2 team plan)
   - One company of 50 = $400/mo from a single deal

---

### Phase 3 — Scale (90 days+)

1. **ASO (App Store Optimisation)**
   - Target keywords: "boredom", "digital detox", "screen free", "mindfulness without meditation"
   - A/B test screenshots and app icon
   - Respond to every App Store review within 24 hours

2. **Paid acquisition (only after organic is proven)**
   - Budget: $500/mo to start
   - Channels: Twitter/X and Reddit (audience alignment)
   - Target: users who follow @nosurf, attention economy accounts
   - CAC target: <$5 to free install, <$10 to paying subscriber

---

## POSITIONING & MESSAGING

### One-sentence pitch
"The app that does nothing — and might be the most important one on your phone."

### Who it's for
People who feel overstimulated, under-inspired, and haven't had a genuine idle thought in years. They're not looking for another guided experience. They want permission to stop.

### What makes it different
Every wellness app adds more content. The Void removes it. There is no content. No voice. No music. No guidance. Just a blank screen and whatever your mind does with the silence.

### The three-word brand personality
**Quiet. Honest. Uncompromising.**

### Messaging hierarchy

**Headline:** The app that does nothing.

**Sub-headline:** That's the whole point.

**Body:** Most apps fight for every second of your attention. The Void gives those seconds back. Set a timer. The screen goes blank. Log what surfaces. Watch your capacity for stillness grow.

**Social proof angle:** "I haven't had a new idea in months. Three sessions in, I filled a page."

### What we never say
- "Mindfulness" — too associated with guided content
- "Meditation" — we are not that
- "Wellness" — too broad, too soft
- "Productivity" — wrong frame entirely
- Anything with the word "journey"

---

## COMPETITIVE LANDSCAPE

### 1. Calm
**What they do well:** Beautiful design, massive brand, sleep content, celebrity voices.
**Where they fall short:** Overwhelmingly content-heavy. More stuff to consume, not less.
**How we win:** We are the opposite. No content, no guidance, no voices. Anti-Calm.
**Price:** $69.99/year vs The Void's $40/year (V2).

### 2. Headspace
**What they do well:** Structured meditation courses, corporate contracts, clinical research.
**Where they fall short:** Requires learning. Requires commitment. Still guided.
**How we win:** Zero learning curve. Open app, set timer, done. No technique required.
**Price:** $69.99/year.

### 3. Nomophobes
**What they do well:** Simple concept — put your phone down and do nothing.
**Where they fall short:** Barebones. No harvest. No score. No report. No design quality. No traction.
**How we win:** Everything they ignored — the harvest archive, the stillness score, the weekly report, the design system. Same idea, executed completely.
**Price:** $2.99 one-time.

### 4. Endel
**What they do well:** Generative soundscapes, science-backed, beautiful.
**Where they fall short:** Adds audio. We remove everything including audio.
**How we win:** Different philosophy. They fill silence. We protect it.
**Price:** $49.99/year.

### 5. Forest
**What they do well:** Gamified focus sessions, delightful visual metaphor (growing a tree).
**Where they fall short:** Still gamification — points, trees, streaks. Still stimulation.
**How we win:** No gamification. The only "game" is your own stillness score growing, which happens regardless.
**Price:** $3.99 one-time.

---

## PRICING & MONETISATION MODEL

### V1 — Free, no paywall
All features available to all users. No limits. No gates. Build the user base first.

### V2 — Freemium subscription

**Free tier (always)**
- Unlimited void sessions
- Harvest archive (last 30 days)
- Stillness score
- Weekly report (view only)
- Basic milestones

**The Void Pro — $4.99/month or $39.99/year ($3.33/mo)**
- Full harvest archive (no limit)
- Advanced insights (thought pattern analysis)
- Monthly challenges
- Deeper void modes (ambient silence variants)
- Weekly report sharing as image card
- Priority cloud backup

**Why $4.99:**
- Cheaper than a coffee
- The irony of paying $4.99 to do nothing is shareable
- "I pay $5 a month to stare at a blank screen" is a tweet that markets itself
- Low enough to subscribe on impulse, high enough to be sustainable

**Upgrade triggers (what shows the paywall):**
- Tapping "View full harvest history" (beyond 30 days)
- Tapping "Advanced insights"
- Tapping "Monthly challenges"
- Tapping "Share report" (gentle upsell — not hard gate)

**What is never gated:**
- Core void sessions (the heart of the product)
- Stillness score
- Basic harvest (last 30 days)

---

## LAUNCH CHECKLIST

### 2 weeks before launch
- [ ] App Store listing complete (name, description, screenshots, keywords, age rating)
- [ ] Google Play listing complete
- [ ] App icon final and submitted in all sizes
- [ ] Privacy policy URL live on thevoidapp.com
- [ ] Terms of service URL live on thevoidapp.com
- [ ] Support email set up: support@thevoidapp.com
- [ ] TestFlight beta sent to 20+ testers
- [ ] All critical bugs from beta fixed
- [ ] All App Store screenshots match current build

### 1 week before launch
- [ ] Product Hunt submission drafted (not submitted yet)
- [ ] Press emails drafted and ready to send
- [ ] Twitter/X launch thread written and scheduled
- [ ] Reddit posts drafted for 5 target communities
- [ ] 50 personal messages drafted to send on launch day
- [ ] Landing page (thevoidapp.com) live and tested on mobile

### Launch day
- [ ] Submit to App Store and Google Play (ideally approved before launch day)
- [ ] Send all press emails at 9am
- [ ] Post Product Hunt listing at 12:01am PST
- [ ] Post Twitter thread at 9am
- [ ] Send personal messages
- [ ] Post Reddit threads (natural tone, no spam)
- [ ] Monitor App Store / Play Store for issues
- [ ] Respond to every comment, review, reply throughout the day

### 1 week after launch
- [ ] Respond to every App Store and Play Store review
- [ ] Collect all feedback and triage into: bug / feature request / praise
- [ ] Write a launch retrospective (what worked, what didn't)
- [ ] Plan first update based on feedback

---

*End of Analytics & Go-To-Market Document — Document 6 of 7*
*The Void · V2 Planning · June 2026*
*⚠️ Do not implement analytics in V1 — this is a V2 document*
