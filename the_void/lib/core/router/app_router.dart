import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/harvest/harvest_screen.dart';
import '../../presentation/progress/progress_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/session/duration_picker_screen.dart';
import '../../presentation/session/quiet_prompt_screen.dart';
import '../../presentation/session/countdown_screen.dart';
import '../../presentation/session/void_session_screen.dart';
import '../../presentation/session/post_session_screen.dart';
import '../../presentation/session/interrupted_screen.dart';
import '../../presentation/weekly_report/weekly_report_screen.dart';
import '../../presentation/auth/auth_screen.dart';
import '../../presentation/auth/backup_password_screen.dart';
import '../../shared/widgets/app_tab_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter() => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    final isOnboarding = state.matchedLocation.startsWith('/onboarding');

    if (!onboardingComplete && !isOnboarding) return '/onboarding';
    if (onboardingComplete && isOnboarding) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Shell route — tabs with bottom nav bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppTabBar(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/harvest',
          builder: (context, state) => const HarvestScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // Session flow — full screen, no tab bar
    GoRoute(
      path: '/session/duration',
      builder: (context, state) => const DurationPickerScreen(),
    ),
    GoRoute(
      path: '/session/quiet',
      builder: (context, state) => const QuietPromptScreen(),
    ),
    GoRoute(
      path: '/session/countdown',
      builder: (context, state) => const CountdownScreen(),
    ),
    GoRoute(
      path: '/session/void',
      builder: (context, state) => const VoidSessionScreen(),
    ),
    GoRoute(
      path: '/session/post',
      builder: (context, state) => const PostSessionScreen(),
    ),
    GoRoute(
      path: '/session/interrupted',
      builder: (context, state) => const InterruptedScreen(),
    ),

    GoRoute(
      path: '/report',
      builder: (context, state) => const WeeklyReportScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/auth/backup-password',
      builder: (context, state) => const BackupPasswordScreen(),
    ),
  ],
);

final appRouter = buildRouter();
