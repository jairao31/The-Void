import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/home');
  }

  Future<void> _skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/home');
  }

  void _next() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(AppStrings.obBack,
                          style: AppTextStyles.buttonText(context)),
                    )
                  else
                    const SizedBox(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(AppStrings.obSkip,
                        style: AppTextStyles.buttonText(context)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: const [
                  _OnboardingPage1(),
                  _OnboardingPage2(),
                  _OnboardingPage3(),
                  _OnboardingPage4(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.obPage1StepLabel,
              style: AppTextStyles.label(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage1Headline,
              style: AppTextStyles.heroHeadline(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage1Body, style: AppTextStyles.body(context)),
          const SizedBox(height: AppSpacing.xxl),
          Text(AppStrings.obPage1Callout,
              style: AppTextStyles.thoughtText(context)),
        ],
      ),
    );
  }
}

class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.obPage2StepLabel,
              style: AppTextStyles.label(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage2Headline,
              style: AppTextStyles.heroHeadline(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage2Body, style: AppTextStyles.body(context)),
          const SizedBox(height: AppSpacing.xxl),
          Text(AppStrings.obPage2Callout,
              style: AppTextStyles.thoughtText(context)),
        ],
      ),
    );
  }
}

class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.obPage3StepLabel,
              style: AppTextStyles.label(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage3Headline,
              style: AppTextStyles.heroHeadline(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage3Body, style: AppTextStyles.body(context)),
          const SizedBox(height: AppSpacing.xxl),
          Text(AppStrings.obPage3Callout,
              style: AppTextStyles.thoughtText(context)),
        ],
      ),
    );
  }
}

class _OnboardingPage4 extends StatelessWidget {
  const _OnboardingPage4();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.obPage4StepLabel,
              style: AppTextStyles.label(context)),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.obPage4Headline,
              style: AppTextStyles.heroHeadline(context)),
          const SizedBox(height: AppSpacing.xxl),
          _PermissionRow(
            title: AppStrings.obPage4Notif,
            subtitle: AppStrings.obPage4NotifSub,
            badge: AppStrings.obPage4NotifBadge,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PermissionRow(
            title: AppStrings.obPage4Focus,
            subtitle: AppStrings.obPage4FocusSub,
            badge: AppStrings.obPage4FocusBadge,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PermissionRow(
            title: AppStrings.obPage4Privacy,
            subtitle: AppStrings.obPage4PrivacySub,
            badge: AppStrings.obPage4PrivacyBadge,
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;

  const _PermissionRow({
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles.bodyMedium(context)),
            const SizedBox(width: AppSpacing.sm),
            Text(badge, style: AppTextStyles.label(context)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: AppTextStyles.body(context)),
      ],
    );
  }
}
