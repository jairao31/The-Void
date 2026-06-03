# The Void — Frontend Specification Document
# Document 5 of 5
# Version 1.0 | June 2026

---

## DESIGN REFERENCE

**⚠️ MANDATORY: Before writing any UI code, open and study `design_reference.html`.**

This file contains the complete visual design system for The Void — all screens rendered in both light and dark mode, with exact colours, typography, component states, and layout. Every screen described in this document has a corresponding rendered mockup in that file.

The design reference is the source of truth for visual decisions. If anything in this document conflicts with the design reference HTML file, the design reference wins.

**Tabs in design_reference.html:**
- Design tokens — colour palette, typography specimens, component library
- Onboarding — all 4 screens
- Session flow — all 6 session screens
- Core screens — home, harvest, progress, weekly report
- Settings & auth — settings (2 states), sign in, backup password

Use the theme toggle (☀️ 🌙 ⚙️) in the top right to preview both light and dark modes.

---

## COLOUR PALETTE

### Light mode tokens

```dart
// lib/core/constants/app_colors.dart

class AppColors {
  // ── Backgrounds ──────────────────────────────────
  static const Color bgPage        = Color(0xFFF4F2EE); // page/scaffold background
  static const Color bgPrimary     = Color(0xFFFAFAF8); // cards, phone bg
  static const Color bgSecondary   = Color(0xFFF4F2EE); // card inner surfaces
  static const Color bgTertiary    = Color(0xFFEDEAE3); // deepest surface, callouts
  static const Color bgVoid        = Color(0xFFFFFFFF); // void session screen ONLY

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1C1B18); // headings, key values
  static const Color textSecondary = Color(0xFF6B6760); // body text
  static const Color textMuted     = Color(0xFFA8A39A); // labels, metadata
  static const Color textHint      = Color(0xFFC8C3BB); // placeholders, ghost text

  // ── Borders ──────────────────────────────────────
  static const Color borderLight   = Color(0xFFE8E4DC); // card borders, dividers
  static const Color borderMedium  = Color(0xFFD4CFC5); // phone frame, inputs
  static const Color borderStrong  = Color(0xFFB8B2A7); // callout left-border

  // ── Semantic ─────────────────────────────────────
  static const Color success       = Color(0xFF3B6D11); // +pts change, score up
  static const Color successBg     = Color(0xFFEAF3DE); // success pill bg
  static const Color successBorder = Color(0xFFC0DD97); // signed-in banner border
  static const Color danger        = Color(0xFFA32D2D); // delete row text
  static const Color dangerBg      = Color(0xFFFCEBEB); // danger pill bg

  // ── Void session ─────────────────────────────────
  static const Color pulseRing     = Color(0xFFE8E4DC); // outer ring of pulse
  static const Color pulseCore     = Color(0xFFD4CFC5); // inner dot of pulse

  // ── No other colours exist in the UI ─────────────
  // No blue. No purple. No orange. No gradients. No shadows.
}
```

### Dark mode tokens

```dart
class AppColorsDark {
  static const Color bgPage        = Color(0xFF111110);
  static const Color bgPrimary     = Color(0xFF1A1916);
  static const Color bgSecondary   = Color(0xFF222120);
  static const Color bgTertiary    = Color(0xFF2A2927);
  static const Color bgVoid        = Color(0xFF0D0D0C);

  static const Color textPrimary   = Color(0xFFF0EDE6);
  static const Color textSecondary = Color(0xFFA8A39A);
  static const Color textMuted     = Color(0xFF6B6760);
  static const Color textHint      = Color(0xFF4A4845);

  static const Color borderLight   = Color(0xFF2E2D2A);
  static const Color borderMedium  = Color(0xFF3A3835);
  static const Color borderStrong  = Color(0xFF4A4845);

  static const Color success       = Color(0xFF7BC144); // lighter in dark
  static const Color successBg     = Color(0xFF1A2E10);
  static const Color successBorder = Color(0xFF2D4D1C);
  static const Color danger        = Color(0xFFE24B4A);
  static const Color dangerBg      = Color(0xFF2D1010);

  static const Color pulseRing     = Color(0xFF2E2D2A);
  static const Color pulseCore     = Color(0xFF3A3835);
}
```

### ThemeData implementation

```dart
// lib/core/theme/app_theme.dart

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.bgPage,
  cardColor: AppColors.bgPrimary,
  dividerColor: AppColors.borderLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.textPrimary,
    surface: AppColors.bgPrimary,
    background: AppColors.bgPage,
  ),
  // All text theme entries use AppTextStyles
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColorsDark.bgPage,
  cardColor: AppColorsDark.bgPrimary,
  dividerColor: AppColorsDark.borderLight,
  colorScheme: const ColorScheme.dark(
    primary: AppColorsDark.textPrimary,
    surface: AppColorsDark.bgPrimary,
    background: AppColorsDark.bgPage,
  ),
);
```

---

## TYPOGRAPHY

Three fonts, three purposes. No exceptions.

| Font | Import | Used for |
|---|---|---|
| DM Serif Display | `GoogleFonts.dmSerifDisplay()` | All headings, score number, screen titles |
| DM Sans | `GoogleFonts.dmSans()` | All body text, button labels, descriptions |
| DM Mono | `GoogleFonts.dmMono()` | All metadata, timestamps, labels, tags, monospace values |

```dart
// lib/core/constants/app_text_styles.dart

class AppTextStyles {

  // ── Display / Headings (DM Serif Display) ─────────
  static TextStyle heroHeadline(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 28, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.25,
    );

  static TextStyle screenTitle(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 20, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.2,
    );

  static TextStyle scoreHero(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 46, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.0,
    );

  static TextStyle cardTitle(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 18, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
    );

  // ── Body (DM Sans) ────────────────────────────────
  static TextStyle body(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 13, fontWeight: FontWeight.w400,
      color: _secondary(context), height: 1.7,
    );

  static TextStyle bodyMedium(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: _secondary(context), height: 1.6,
    );

  static TextStyle buttonLabel(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: _onPrimary(context),
    );

  static TextStyle buttonGhost(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w400,
      color: _secondary(context),
    );

  static TextStyle buttonText(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 10, fontWeight: FontWeight.w400,
      color: _muted(context),
    );

  static TextStyle thoughtText(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: _secondary(context), height: 1.5,
    );

  // ── Mono / Labels (DM Mono) ───────────────────────
  static TextStyle label(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 9, fontWeight: FontWeight.w400,
      color: _muted(context),
      letterSpacing: 0.08,
    );

  static TextStyle labelUppercase(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 8, fontWeight: FontWeight.w400,
      color: _muted(context),
      letterSpacing: 0.09,
    ).copyWith(inherit: false);

  static TextStyle metadata(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 10, fontWeight: FontWeight.w400,
      color: _muted(context), letterSpacing: 0.04,
    );

  static TextStyle monoValue(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: _primary(context),
    );

  // ── Void session specific ─────────────────────────
  static TextStyle voidLabel(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 9, fontWeight: FontWeight.w400,
      color: _hint(context), letterSpacing: 0.06, height: 2.0,
    );

  static TextStyle countdownNum(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 76, fontWeight: FontWeight.w400,
      color: _primary(context).withOpacity(0.12),
      height: 1.0,
    );

  // ── Helpers ───────────────────────────────────────
  static Color _primary(BuildContext context) =>
    Theme.of(context).colorScheme.primary;
  static Color _secondary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textSecondary : AppColorsDark.textSecondary;
  static Color _muted(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textMuted : AppColorsDark.textMuted;
  static Color _hint(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textHint : AppColorsDark.textHint;
  static Color _onPrimary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.bgPrimary : AppColorsDark.bgPage;
}
```

---

## SPACING & LAYOUT

```dart
// lib/core/constants/app_spacing.dart

class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;   // screen horizontal padding
  static const double xxl  = 24.0;
  static const double xxxl = 32.0;
}

class AppRadius {
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double pill = 100.0;
}
```

**Screen padding rule:** Every screen uses `horizontal: AppSpacing.xl` (20px) padding on left and right. No screen has content touching the edge.

**Card padding:** 13–16px all sides. Use `AppSpacing.lg` (16px) for standard cards.

**Stack spacing:** Use `SizedBox(height: AppSpacing.sm/md/lg)` between elements — never use `Padding` for vertical gaps between siblings.

---

## COMPONENT STYLES

### Primary Button

```dart
// Full width. Black background. White text. 52px height.
Container(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primary(context), // black in light, cream in dark
      foregroundColor: _onPrimary(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    onPressed: onPressed,
    child: Text(label, style: AppTextStyles.buttonLabel(context)),
  ),
)
```

### Ghost Button

```dart
// Full width. Transparent. Border. 48px height.
Container(
  width: double.infinity,
  height: 48,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
      foregroundColor: _secondary(context),
      side: BorderSide(color: _borderMedium(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      elevation: 0,
    ),
    onPressed: onPressed,
    child: Text(label, style: AppTextStyles.buttonGhost(context)),
  ),
)
```

### Text Button (for "Skip", "end", "← Back")

```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: _muted(context),
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
  onPressed: onPressed,
  child: Text(label, style: AppTextStyles.buttonText(context)),
)
```

### Standard Card

```dart
Container(
  decoration: BoxDecoration(
    color: _bgPrimary(context),
    border: Border.all(color: _borderLight(context), width: 1),
    borderRadius: BorderRadius.circular(AppRadius.lg),
  ),
  padding: const EdgeInsets.all(AppSpacing.lg),
  child: child,
)
```

### Filter Pill (unselected)

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  decoration: BoxDecoration(
    border: Border.all(color: _borderMedium(context)),
    borderRadius: BorderRadius.circular(AppRadius.pill),
  ),
  child: Text(label, style: AppTextStyles.label(context)),
)
```

### Filter Pill (selected)

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  decoration: BoxDecoration(
    color: _primary(context),
    borderRadius: BorderRadius.circular(AppRadius.pill),
  ),
  child: Text(label, style: AppTextStyles.label(context)
    .copyWith(color: _onPrimary(context))),
)
```

### Thought Entry Card

```dart
Container(
  decoration: BoxDecoration(
    color: _bgPrimary(context),
    border: Border.all(color: _borderLight(context)),
    borderRadius: BorderRadius.circular(AppRadius.md),
  ),
  padding: const EdgeInsets.all(AppSpacing.md),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dateString, style: AppTextStyles.metadata(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: _bgSecondary(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(durationString, style: AppTextStyles.metadata(context)),
          ),
        ],
      ),
      SizedBox(height: AppSpacing.sm),
      Text(thought.content, style: AppTextStyles.thoughtText(context)),
      if (thought.tag != null) ...[
        SizedBox(height: AppSpacing.sm),
        Text('# ${thought.tag}', style: AppTextStyles.metadata(context)),
      ],
    ],
  ),
)
```

### Bottom Tab Bar (4 tabs)

Tabs: Home (⌂), Harvest (✦), Progress (↗), Settings (⚙)

```dart
// Custom bottom nav — no Material BottomNavigationBar
// Sits at bottom of each shell screen
Container(
  decoration: BoxDecoration(
    border: Border(top: BorderSide(color: _borderLight(context), width: 0.5)),
  ),
  padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: tabs.map((tab) => _buildTabItem(tab)).toList(),
  ),
)
```

### Pulse Circle (void session)

```dart
// Animated with AnimationController — 4 second loop
// Scale: 1.0 → 1.08, Opacity: 0.4 → 0.85, curve: Curves.easeInOut
AnimatedBuilder(
  animation: _animation,
  builder: (context, child) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Opacity(
        opacity: _opacityAnimation.value,
        child: Container(
          width: 76, height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _pulseRing(context), width: 1),
          ),
          child: Center(
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pulseCore(context).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  },
)
```

### Theme Selector (settings)

3-column grid of cards: ☀️ Light, 🌙 Dark, ⚙️ System.
Selected state: border uses `_borderStrong(context)`.
Unselected: border uses `_borderLight(context)`.

### Toggle

Use Flutter's `Switch` widget with custom colours:
```dart
Switch(
  value: isOn,
  onChanged: onChanged,
  activeColor: _primary(context),
  inactiveThumbColor: _bgPrimary(context),
  inactiveTrackColor: _borderMedium(context),
  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
)
```

---

## SCREEN SPECIFICATIONS

See `design_reference.html` for visual reference of every screen. Specifications below define behaviour and exact copy.

### All user-facing strings

**CRITICAL: No string is hardcoded in widget files. Every string lives in `app_strings.dart`.**

```dart
// lib/core/constants/app_strings.dart

class AppStrings {

  // ── Onboarding ───────────────────────────────────
  static const obPage1StepLabel    = 'The problem';
  static const obPage1Headline     = "You haven't been truly bored in years.";
  static const obPage1Body         = "Every idle moment — a queue, a lift, a pause in conversation — you reach for your phone. Not because there's anything there. Just because stillness feels wrong now.";
  static const obPage1Callout      = '"The average person touches their phone 2,617 times a day. Boredom never gets a chance."';
  static const obPage1CTA          = "That's uncomfortably true →";
  static const obSkip              = 'Skip intro';
  static const obBack              = '← Back';

  static const obPage2StepLabel    = 'The science';
  static const obPage2Headline     = 'Boredom is where your best thinking happens.';
  static const obPage2Body         = "Neuroscientists call it the Default Mode Network — the brain state active when you're doing nothing. That's where creativity, self-knowledge, and clarity live. Smartphones switched it off.";
  static const obPage2Callout      = '"Einstein, Darwin, Newton — all famously bored men with nowhere to be and nothing to do."';
  static const obPage2CTA          = 'So what does this app do? →';

  static const obPage3StepLabel    = 'The Void';
  static const obPage3Headline     = "The Void does nothing. That's the whole point.";
  static const obPage3Body         = "Set a timer. The screen goes blank. No content, no music, no guidance — just you and whatever your mind does with the silence. Afterwards log what surfaced. Over time, your tolerance for stillness grows.";
  static const obPage3Callout      = '"Not meditation. Not mindfulness. The Void is the old, forgotten art of having nothing to do."';
  static const obPage3CTA          = 'Take me into The Void →';

  static const obPage4StepLabel    = 'One last thing';
  static const obPage4Headline     = 'Two small asks before we begin.';
  static const obPage4Notif        = 'Notifications';
  static const obPage4NotifSub     = "One quiet nudge a day, at a random time.";
  static const obPage4NotifBadge   = 'optional';
  static const obPage4Focus        = 'Focus mode';
  static const obPage4FocusSub     = "We'll prompt you to silence the phone before each session. Emergency calls still get through.";
  static const obPage4FocusBadge   = 'optional';
  static const obPage4Privacy      = 'Your data stays yours';
  static const obPage4PrivacySub   = "Stored on your device. Never read, sold, or used to train anything.";
  static const obPage4PrivacyBadge = 'always';
  static const obPage4CTA          = "Let's begin my first session";

  // ── Home ─────────────────────────────────────────
  static const homeGreetingMorning   = 'Good morning.';
  static const homeGreetingAfternoon = 'Good afternoon.';
  static const homeGreetingEvening   = 'Good evening.';
  static const homeSubline           = 'You have nothing to do right now.';
  static const homeScoreLabel        = 'Stillness score';
  static const homeScoreStart        = 'Your journey starts now.';
  static const homeCTA               = 'Enter The Void';
  static const homeRecentTitle       = 'Recent thoughts';
  static const homeRecentEmpty       = 'Your first session is waiting.';
  static const homeNudgeBanner       = 'Your harvest lives only on this phone. Back it up?';
  static const homeNudgeCTA          = 'Back up';

  // ── Duration picker ───────────────────────────────
  static const durTitle        = 'How long can you give yourself?';
  static const durSubtitle     = 'Start small. 2 minutes of real stillness beats 30 of fidgeting.';
  static const durCustomLabel  = 'Custom';
  static const durRecord       = 'Your record is'; // + X min + '. Try to beat it.'
  static const durCTA          = 'Enter The Void —'; // + X minutes + ' →'

  // ── Quiet prompt ──────────────────────────────────
  static const quietHeadline   = 'The world will wait'; // + X + ' minutes.'
  static const quietSub        = "Silence the phone so nothing pulls you back before you're ready.";
  static const quietEmergency  = 'Emergency calls still get through.';
  static const quietYes        = 'Yes, go quiet';
  static const quietSkip       = "Skip — I'll manage";

  // ── Countdown ────────────────────────────────────
  static const countdownLabel  = 'settling in';
  static const countdownHint   = 'put the phone face up and set it down';

  // ── Void session ─────────────────────────────────
  static const voidEnd         = 'end';
  static const voidLine1       = 'nothing is happening';
  static const voidLine2       = "that's the point";
  static const voidQuietOn     = 'quiet mode on';
  static const voidHint        = 'resist the urge to check the time';
  static const voidEndTitle    = 'End the session?';
  static const voidEndBody     = "You've been still for"; // + X min. + "You'll get partial credit."
  static const voidEndKeep     = 'Keep going';
  static const voidEndConfirm  = 'End session';

  // ── Post session ─────────────────────────────────
  static const postTitle       = 'minutes of nothing.'; // X + this
  static const postSubtitle    = 'Your mind was working the whole time.';
  static const postTimeLabel   = 'time in void';
  static const postPointsLabel = 'tolerance pts';
  static const postThoughtQ    = 'What did your mind do?';
  static const postThoughtOpt  = '(optional)';
  static const postPlaceholder = 'An idea, a memory, something random…';
  static const postTimerSuffix = 'seconds remaining';
  static const postSave        = 'Save & finish';
  static const postSkip        = 'Nothing came up — skip';

  // ── Interrupted ──────────────────────────────────
  static const intTitle        = 'You came back early.';
  static const intBody         = "That's okay. The urge to check is exactly what you're training against.";
  static const intDuration     = 'You lasted'; // X min Y sec + 'of your' + Z min + 'session.'
  static const intCreditLabel  = 'Partial credit';
  static const intCreditNote   = 'pts if completed'; // X +
  static const intLog          = 'Log what pulled me back';
  static const intRetry        = 'Try again —'; // + X + ' minutes'

  // ── Harvest ───────────────────────────────────────
  static const harvTitle       = 'Your harvest.';
  static const harvSubtitle    = 'What your idle mind produced.';
  static const harvSearch      = 'Search your thoughts…';
  static const harvEmpty       = "Your first session is waiting. When it happens, this is where your thoughts will live.";
  static const harvNoResults   = 'Nothing found. Try a different word.';
  static const harvTagAll      = 'All';
  static const harvTagIdeas    = 'Ideas';
  static const harvTagPeople   = 'People';
  static const harvTagMemories = 'Memories';
  static const harvTagQuest    = 'Questions';

  // ── Progress ─────────────────────────────────────
  static const progTitle       = 'Your progress.';
  static const progSubtitle    = 'Every session makes this number grow.';
  static const progScoreLabel  = 'Stillness score';
  static const progChartTitle  = 'Daily sessions — last 7 days';
  static const progMilestones  = 'Milestones';

  // ── Weekly report ─────────────────────────────────
  static const repTitle        = 'Your stillness report.';
  static const repShare        = 'Share your report';
  static const repBestThought  = 'Best idle thought this week';

  // ── Settings ─────────────────────────────────────
  static const setTitle            = 'Settings.';
  static const setAppearance       = 'Appearance';
  static const setTheme            = 'Theme';
  static const setThemeLight       = 'Light';
  static const setThemeDark        = 'Dark';
  static const setThemeSystem      = 'System';
  static const setBackup           = 'Backup & restore';
  static const setBackupAction     = 'Back up my data';
  static const setRestore          = 'Restore from backup';
  static const setSignOut          = 'Sign out';
  static const setNotifications    = 'Notifications';
  static const setNowNotif         = 'Daily "Now."';
  static const setSundayReport     = 'Sunday report';
  static const setNotifTime        = 'Notification time';
  static const setNotifTimeValue   = 'Random (recommended)';
  static const setData             = 'Data';
  static const setDelete           = 'Delete all my data';
  static const setAbout            = 'About';
  static const setPrivacy          = 'Privacy policy';
  static const setWhatIsVoid       = 'What is The Void?';
  static const setVersion          = 'Version';
  static const setNotSignedIn      = 'Not signed in — sign in to back up your thoughts';
  static const setSignedInPrefix   = 'Signed in — ';
  static const setLastBackup       = 'Last: '; // + date/time
  static const setSignInFirst      = 'sign in first';
  static const setNotifDisabled    = 'Enable in phone settings';

  // ── Auth ─────────────────────────────────────────
  static const authTitle       = 'Keep your thoughts safe.';
  static const authSubtitle    = "Sign in to back up your harvest. Your thoughts stay encrypted — we can never read them.";
  static const authGoogle      = 'Continue with Google';
  static const authEmailCTA    = 'Continue with email';
  static const authEmailHint   = 'your@email.com';
  static const authEmailSent   = 'Check your email for a sign-in link.';
  static const authFooter      = "We only use your account to store your encrypted backup. Nothing else.";

  static const backupPwTitle   = 'Set a backup password.';
  static const backupPwBody    = "This encrypts your backup before it leaves your phone. We don't store this password — if you forget it, your backup cannot be recovered.";
  static const backupPwNew     = 'New password';
  static const backupPwConfirm = 'Confirm password';
  static const backupPwWarning = 'Write this down somewhere safe. Not even we can recover it if you forget.';
  static const backupPwCTA     = 'Set password & back up';

  // ── Notifications ────────────────────────────────
  static const notifNowBody    = 'Now.';
  static const notifReportBody = 'Your weekly stillness report is ready.';

  // ── Errors ───────────────────────────────────────
  static const errGeneric      = 'Something went wrong. Please try again.';
  static const errNoInternet   = 'No connection. Please check your internet and try again.';
  static const errSignIn       = 'Sign-in failed. Please try again.';
  static const errWrongPw      = 'Incorrect password. Please try again.';
  static const errBackupFail   = 'Backup failed. Please try again.';
  static const errRestoreFail  = 'Restore failed. Please check your password and try again.';
  static const errSaveFail     = "Couldn't save. Please try again.";
  static const errNoBackup     = 'No backup found for this account.';
}
```

---

## ANIMATIONS

| Animation | Duration | Curve | Details |
|---|---|---|---|
| Void pulse | 4000ms, infinite | Curves.easeInOut | Scale 1.0→1.08, Opacity 0.4→0.85, both simultaneous, reversed |
| Countdown number | 900ms per number | Curves.easeInOut | Fade in 200ms, hold 500ms, fade out 200ms |
| Session screen entry | 800ms | Curves.easeInOut | FadeTransition from Duration/Quiet screens |
| Score number change | 600ms | Curves.easeOut | CounterAnimation widget — counts up to new value |
| Screen transitions (session) | 400ms | Curves.easeInOut | FadeTransition |
| Tab navigation | Instant | None | No animation between tabs |
| Bottom sheet | Default Flutter | Default | go_router showModalBottomSheet |
| Theme change | 300ms | Auto | MaterialApp handles via theme transition |

---

## SCREEN-BY-SCREEN BEHAVIOUR

Refer to `design_reference.html` for visuals. This section defines behaviour only.

### Home screen
- Greeting changes based on local time: Good morning (5am–11:59am), Good afternoon (12pm–5:59pm), Good evening (6pm–4:59am)
- Score change line: only shown if user has data from previous week. Format: "+X pts from last week" (green if positive) or "Same as last week" (muted)
- If score is 0: show "Your journey starts now." instead of change line
- Quick duration pills pre-select the chosen duration and skip Duration Picker screen
- Recent thoughts: show last 2 thoughts. If none: show muted empty state text only — no card
- Backup nudge banner: shown once, 7 days after install AND after 5+ sessions. Dismissed forever on "×" tap

### Void session screen
- Status bar: hidden
- Navigation bar: hidden
- Screen always on (WakelockPlus or equivalent) during session
- Back gesture: intercepted — shows confirmation bottom sheet
- Physical back (Android): intercepted — shows same confirmation bottom sheet
- "end" button: tap target minimum 44×44px even though text is small
- Quiet mode pill: only shown if user enabled quiet mode for this session

### Post session screen
- 60-second countdown is cosmetic only — input remains available after 60 seconds
- Thought input: single line TextField, max 500 chars, character counter appears at 400+
- "Save & finish" disabled if input is only whitespace

### Harvest screen
- Search: local, real-time, case-insensitive, no debounce needed
- Filter and search can be combined (filter + search within that filter)
- Sort: always newest first, no option to change in V1

### Progress — bar chart
- Y axis: scaled to maximum of the 7 days shown
- If a day has no sessions: bar height = 0 (invisible, label still shows)
- Today's bar: uses `textPrimary` colour. Other days: `borderMedium`
- Day labels: single letter M T W T F S S

### Settings — delete confirmation
- First tap: shows bottom sheet with warning text and two buttons: "Cancel" and "Delete everything"
- Second confirmation: "Delete everything" button shows red, requires second tap within the sheet
- No "type DELETE to confirm" — two taps is sufficient

---

## API & INTEGRATION REFERENCES

### Firebase Auth
- Package: `firebase_auth`
- Email sign-in: `FirebaseAuth.instance.sendSignInLinkToEmail()`
- Google sign-in: `GoogleSignIn().signIn()` → `GoogleAuthProvider.credential()` → `signInWithCredential()`
- Sign out: `FirebaseAuth.instance.signOut()` + `GoogleSignIn().signOut()`
- Auth state: `FirebaseAuth.instance.authStateChanges()` — stream used by `auth_provider.dart`

### Firebase Storage
- Package: `firebase_storage`
- Upload: `FirebaseStorage.instance.ref('backups/{uid}/backup.enc').putData(encryptedBytes)`
- Download: `FirebaseStorage.instance.ref('backups/{uid}/backup.enc').getData()`
- Delete: `FirebaseStorage.instance.ref('backups/{uid}/backup.enc').delete()`
- Max upload size: 5MB (enforced by Storage rules)

### flutter_local_notifications
- iOS permissions: alert + sound (no badge)
- Android channel: `the_void_now` (low importance, no sound)
- Notification ID 1: Daily "Now."
- Notification ID 2: Sunday report
- On notification tap: use `onDidReceiveNotificationResponse` to navigate to correct screen

### share_plus (weekly report)
- Use `screenshot` package to capture `report_share_card.dart` widget as PNG
- Share via `Share.shareXFiles([XFile(imagePath)])`
- Image generated locally on device — no server involved

---

*End of Frontend Specification Document — Document 5 of 5*
*The Void · Version 1.0 · June 2026*
*⚠️ Always reference design_reference.html alongside this document*
