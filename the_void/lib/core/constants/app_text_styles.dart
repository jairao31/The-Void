import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {

  // ── Display / Headings (DM Serif Display) ─────────
  static TextStyle heroHeadline(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 28, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.25,
    );

  static TextStyle screenTitle(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 20, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.2,
    );

  static TextStyle scoreHero(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 46, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
      height: 1.0,
    );

  static TextStyle cardTitle(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 18, fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
    );

  // ── Body (DM Sans) ────────────────────────────────
  static TextStyle body(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 13, fontWeight: FontWeight.w400,
      color: _secondary(context), height: 1.7,
    );

  static TextStyle bodyMedium(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: _secondary(context), height: 1.6,
    );

  static TextStyle buttonLabel(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: _onPrimary(context),
    );

  static TextStyle buttonGhost(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w400,
      color: _secondary(context),
    );

  static TextStyle buttonText(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 10, fontWeight: FontWeight.w400,
      color: _muted(context),
    );

  static TextStyle thoughtText(BuildContext context) =>
    GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: _secondary(context), height: 1.5,
    );

  // ── Mono / Labels (DM Mono) ───────────────────────
  static TextStyle label(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 9, fontWeight: FontWeight.w400,
      color: _muted(context),
      letterSpacing: 0.08,
    );

  static TextStyle labelUppercase(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 8, fontWeight: FontWeight.w400,
      color: _muted(context),
      letterSpacing: 0.09,
    ).copyWith(inherit: false);

  static TextStyle metadata(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 10, fontWeight: FontWeight.w400,
      color: _muted(context), letterSpacing: 0.04,
    );

  static TextStyle monoValue(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: _primary(context),
    );

  // ── Void session specific ─────────────────────────
  static TextStyle voidLabel(BuildContext context) =>
    GoogleFonts.dmMono(
      fontSize: 9, fontWeight: FontWeight.w400,
      color: _hint(context), letterSpacing: 0.06, height: 2.0,
    );

  static TextStyle countdownNum(BuildContext context) =>
    GoogleFonts.dmSerifDisplay(
      fontSize: 76, fontWeight: FontWeight.w400,
      color: _primary(context).withOpacity(0.12),
      height: 1.0,
    );

  // ── Helpers ───────────────────────────────────────
  static Color _primary(BuildContext context) =>
    Theme.of(context).colorScheme.primary;

  static Color _secondary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textSecondary : AppColorsDark.textSecondary;

  static Color _muted(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textMuted : AppColorsDark.textMuted;

  static Color _hint(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.textHint : AppColorsDark.textHint;

  static Color _onPrimary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
      ? AppColors.bgPrimary : AppColorsDark.bgPage;
}
