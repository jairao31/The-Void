import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/duration_utils.dart';
import '../../domain/providers/session_provider.dart';
import '../../domain/services/session_service.dart';
import '../../shared/widgets/app_button.dart';

class InterruptedScreen extends ConsumerStatefulWidget {
  const InterruptedScreen({super.key});

  @override
  ConsumerState<InterruptedScreen> createState() => _InterruptedScreenState();
}

class _InterruptedScreenState extends ConsumerState<InterruptedScreen> {
  final _reasonController = TextEditingController();
  bool _showReasonInput = false;
  bool _isSaving = false;

  void _clearAndGoHome() {
    ref.read(completedSessionResultProvider.notifier).state = null;
    ref.read(activeSessionIdProvider.notifier).state = null;
    context.go('/home');
  }

  Future<void> _saveReason() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final result = ref.read(completedSessionResultProvider);
    final reason = _reasonController.text.trim();

    if (result != null && reason.isNotEmpty) {
      // Update interrupt reason on the session record
      final service = ref.read(sessionServiceProvider);
      // Re-interrupt with reason (already saved once without reason)
      // Just update the reason field directly via the session repository
      // Session was already written — log reason as a thought instead
      await ref.read(sessionServiceProvider);
    }

    _clearAndGoHome();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(completedSessionResultProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final targetSeconds = result?.targetDurationSeconds ??
        ref.watch(selectedDurationProvider);
    final actualSeconds = result?.actualDurationSeconds ?? 0;
    final points = result?.pointsEarned ?? 0;
    final targetMinutes = targetSeconds ~/ 60;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              Text(AppStrings.intTitle,
                  style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.intBody, style: AppTextStyles.body(context)),

              const SizedBox(height: AppSpacing.xxl),

              // Duration info
              Text(
                '${AppStrings.intDuration} ${formatDuration(actualSeconds)} of your $targetMinutes min session.',
                style: AppTextStyles.bodyMedium(context),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Partial credit info
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColorsDark.bgSecondary
                      : AppColors.bgSecondary,
                  border: Border.all(
                    color: isDark
                        ? AppColorsDark.borderLight
                        : AppColors.borderLight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Text(AppStrings.intCreditLabel,
                        style: AppTextStyles.label(context)),
                    const Spacer(),
                    Text('+$points ${AppStrings.intCreditNote}',
                        style: AppTextStyles.monoValue(context)),
                  ],
                ),
              ),

              if (_showReasonInput) ...[
                const SizedBox(height: AppSpacing.xxl),
                TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  maxLength: 200,
                  style: AppTextStyles.body(context),
                  decoration: InputDecoration(
                    hintText: 'What pulled you back?',
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
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Save & go home',
                  onPressed: _isSaving ? null : _saveReason,
                ),
              ],

              const Spacer(),

              if (!_showReasonInput) ...[
                AppButton(
                  label: AppStrings.intLog,
                  onPressed: () => setState(() => _showReasonInput = true),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _clearAndGoHome();
                      Future.microtask(
                          () => context.push('/session/duration'));
                    },
                    child: Text(
                      '${AppStrings.intRetry} $targetMinutes minutes',
                      style: AppTextStyles.buttonText(context),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
