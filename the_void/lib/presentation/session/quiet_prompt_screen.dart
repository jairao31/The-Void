import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/session_provider.dart';
import '../../shared/widgets/app_button.dart';

// Tracks whether quiet mode was enabled for this session
final quietModeEnabledProvider = StateProvider<bool>((ref) => false);

class QuietPromptScreen extends ConsumerWidget {
  const QuietPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durationSeconds = ref.watch(selectedDurationProvider);
    final minutes = durationSeconds ~/ 60;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text('← Back', style: AppTextStyles.buttonText(context)),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                '${AppStrings.quietHeadline} $minutes minutes.',
                style: AppTextStyles.heroHeadline(context),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(AppStrings.quietSub, style: AppTextStyles.body(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.quietEmergency,
                  style: AppTextStyles.body(context)),
              const Spacer(),
              AppButton(
                label: AppStrings.quietYes,
                onPressed: () {
                  ref.read(quietModeEnabledProvider.notifier).state = true;
                  context.push('/session/countdown');
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: () {
                    ref.read(quietModeEnabledProvider.notifier).state = false;
                    context.push('/session/countdown');
                  },
                  child: Text(AppStrings.quietSkip,
                      style: AppTextStyles.buttonText(context)),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
