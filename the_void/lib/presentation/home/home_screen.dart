import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/score_provider.dart';
import '../../domain/providers/session_provider.dart';
import '../../domain/services/score_service.dart';
import '../../shared/widgets/app_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadScore());
  }

  Future<void> _loadScore() async {
    final score = await ref.read(scoreServiceProvider).getCurrentScore();
    ref.read(currentScoreProvider.notifier).state = score;
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return AppStrings.homeGreetingMorning;
    if (hour >= 12 && hour < 18) return AppStrings.homeGreetingAfternoon;
    return AppStrings.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final score = ref.watch(currentScoreProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text(_greeting(), style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.xs),
              Text(AppStrings.homeSubline, style: AppTextStyles.body(context)),
              const SizedBox(height: AppSpacing.xxxl),

              _ScoreCard(score: score),
              const SizedBox(height: AppSpacing.lg),
              _QuickDurationRow(),
              const SizedBox(height: AppSpacing.lg),

              AppButton(
                label: AppStrings.homeCTA,
                onPressed: () => context.push('/session/duration'),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              Text(AppStrings.homeRecentTitle,
                  style: AppTextStyles.screenTitle(context)),
              const SizedBox(height: AppSpacing.md),
              Text(AppStrings.homeRecentEmpty,
                  style: AppTextStyles.body(context)),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  const _ScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.homeScoreLabel, style: AppTextStyles.label(context)),
        const SizedBox(height: AppSpacing.sm),
        Text('$score', style: AppTextStyles.scoreHero(context)),
        const SizedBox(height: AppSpacing.xs),
        if (score == 0)
          Text(AppStrings.homeScoreStart, style: AppTextStyles.body(context)),
      ],
    );
  }
}

class _QuickDurationRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durations = [
      (label: '10 sec', seconds: 10),
      (label: '5 min', seconds: 300),
      (label: '10 min', seconds: 600),
    ];

    return Row(
      children: durations.map((d) {
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () {
              ref.read(selectedDurationProvider.notifier).state = d.seconds;
              context.push('/session/quiet');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(AppSpacing.xxxl),
              ),
              child: Text(d.label, style: AppTextStyles.label(context)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
