import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
          foregroundColor: isDark ? AppColorsDark.bgPage : AppColors.bgPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(label, style: AppTextStyles.buttonLabel(context)),
      ),
    );
  }
}

class AppGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppGhostButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
          side: BorderSide(
            color: isDark ? AppColorsDark.borderMedium : AppColors.borderMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label, style: AppTextStyles.buttonGhost(context)),
      ),
    );
  }
}
