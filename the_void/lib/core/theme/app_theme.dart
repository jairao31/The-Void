import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgPage,
    cardColor: AppColors.bgPrimary,
    dividerColor: AppColors.borderLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.textPrimary,
      surface: AppColors.bgPrimary,
      background: AppColors.bgPage,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.bgPage,
    cardColor: AppColorsDark.bgPrimary,
    dividerColor: AppColorsDark.borderLight,
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.textPrimary,
      surface: AppColorsDark.bgPrimary,
      background: AppColorsDark.bgPage,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );
}
