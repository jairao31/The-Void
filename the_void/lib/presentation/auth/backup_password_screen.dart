import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class BackupPasswordScreen extends StatelessWidget {
  const BackupPasswordScreen({super.key});

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
              Text(AppStrings.backupPwTitle,
                  style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.backupPwBody,
                  style: AppTextStyles.body(context)),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.backupPwNew,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.backupPwConfirm,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(AppStrings.backupPwWarning,
                  style: AppTextStyles.body(context)),
              const Spacer(),
              AppButton(
                label: AppStrings.backupPwCTA,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
