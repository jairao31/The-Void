import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/duration_utils.dart';
import '../../domain/providers/session_provider.dart';
import '../../domain/providers/score_provider.dart';
import '../../domain/services/thought_service.dart';
import '../../domain/services/score_service.dart';
import '../../shared/widgets/app_button.dart';

class PostSessionScreen extends ConsumerStatefulWidget {
  const PostSessionScreen({super.key});

  @override
  ConsumerState<PostSessionScreen> createState() => _PostSessionScreenState();
}

class _PostSessionScreenState extends ConsumerState<PostSessionScreen> {
  final _controller = TextEditingController();
  int _countdown = 60;
  Timer? _countdownTimer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _refreshScore();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _refreshScore() async {
    final score = await ref.read(scoreServiceProvider).getCurrentScore();
    ref.read(currentScoreProvider.notifier).state = score;
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final result = ref.read(completedSessionResultProvider);
    final text = _controller.text.trim();

    if (result != null && text.isNotEmpty) {
      await ref.read(thoughtServiceProvider).saveThought(
            result.sessionId,
            text,
          );
    }

    _clearAndGoHome();
  }

  void _skip() => _clearAndGoHome();

  void _clearAndGoHome() {
    ref.read(completedSessionResultProvider.notifier).state = null;
    ref.read(activeSessionIdProvider.notifier).state = null;
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(completedSessionResultProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColorsDark.success : AppColors.success;
    final mutedColor = isDark ? AppColorsDark.textMuted : AppColors.textMuted;

    final minutes = result != null
        ? (result.actualDurationSeconds / 60).toStringAsFixed(0)
        : '0';
    final points = result?.pointsEarned ?? 0;
    final actualSeconds = result?.actualDurationSeconds ?? 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Headline
              Text('$minutes ${AppStrings.postTitle}',
                  style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.xs),
              Text(AppStrings.postSubtitle,
                  style: AppTextStyles.body(context)),

              const SizedBox(height: AppSpacing.xxl),

              // Stats row
              Row(
                children: [
                  _StatPill(
                    label: AppStrings.postTimeLabel,
                    value: formatDuration(actualSeconds),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatPill(
                    label: AppStrings.postPointsLabel,
                    value: '+$points',
                    valueColor: successColor,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Thought input header
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(AppStrings.postThoughtQ,
                      style: AppTextStyles.screenTitle(context)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(AppStrings.postThoughtOpt,
                      style: AppTextStyles.label(context)),
                ],
              ),

              // 60-second countdown (cosmetic only)
              if (_countdown > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('$_countdown ${AppStrings.postTimerSuffix}',
                    style: AppTextStyles.label(context)
                        .copyWith(color: mutedColor)),
              ],

              const SizedBox(height: AppSpacing.md),

              // Thought text field
              TextField(
                controller: _controller,
                maxLines: 4,
                maxLength: 500,
                style: AppTextStyles.body(context),
                decoration: InputDecoration(
                  hintText: AppStrings.postPlaceholder,
                  hintStyle: AppTextStyles.body(context).copyWith(
                    color: isDark
                        ? AppColorsDark.textHint
                        : AppColors.textHint,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColorsDark.borderMedium
                          : AppColors.borderMedium,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColorsDark.borderMedium
                          : AppColors.borderMedium,
                    ),
                  ),
                  counterStyle: AppTextStyles.label(context),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                label: AppStrings.postSave,
                onPressed: _isSaving ? null : _save,
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: _skip,
                  child: Text(AppStrings.postSkip,
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

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatPill({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColorsDark.bgSecondary : AppColors.bgSecondary;
    final border = isDark ? AppColorsDark.borderLight : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label(context)),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.monoValue(context).copyWith(
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
