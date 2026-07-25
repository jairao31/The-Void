import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/session_provider.dart';
import '../../shared/widgets/app_button.dart';

class DurationPickerScreen extends ConsumerStatefulWidget {
  const DurationPickerScreen({super.key});

  @override
  ConsumerState<DurationPickerScreen> createState() =>
      _DurationPickerScreenState();
}

class _DurationPickerScreenState extends ConsumerState<DurationPickerScreen> {
  int _selectedSeconds = 300; // default 5 min

  final _gridOptions = [
    (label: '10 sec', seconds: 10),
    (label: '5 min', seconds: 300),
    (label: '10 min', seconds: 600),
    (label: '20 min', seconds: 1200),
  ];

  @override
  Widget build(BuildContext context) {
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
              Text(AppStrings.durTitle,
                  style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.durSubtitle,
                  style: AppTextStyles.body(context)),
              const SizedBox(height: AppSpacing.xxxl),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 2.5,
                children: _gridOptions.map((opt) {
                  final isSelected = _selectedSeconds == opt.seconds;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedSeconds = opt.seconds),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                      alignment: Alignment.center,
                      child: Text(opt.label,
                          style: AppTextStyles.bodyMedium(context)),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              AppButton(
                label:
                    '${AppStrings.durCTA} ${(_selectedSeconds ~/ 60)} minutes →',
                onPressed: () {
                  ref.read(selectedDurationProvider.notifier).state =
                      _selectedSeconds;
                  context.push('/session/quiet');
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
