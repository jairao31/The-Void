import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
              Text(AppStrings.progTitle,
                  style: AppTextStyles.screenTitle(context)),
              const SizedBox(height: AppSpacing.xs),
              Text(AppStrings.progSubtitle,
                  style: AppTextStyles.body(context)),
            ],
          ),
        ),
      ),
    );
  }
}
