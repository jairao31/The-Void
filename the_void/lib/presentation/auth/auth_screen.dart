import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
              Text(AppStrings.authTitle,
                  style: AppTextStyles.heroHeadline(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.authSubtitle,
                  style: AppTextStyles.body(context)),
              const Spacer(),
              AppButton(
                label: AppStrings.authGoogle,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: AppStrings.authEmailCTA,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Text(AppStrings.authFooter,
                    style: AppTextStyles.body(context),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
