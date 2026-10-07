import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Murim Typography System
/// Pairs ancient engraved serif titles (Cinzel & Noto Serif Thai) with crisp readable body fonts (Noto Sans Thai)
class AppTextStyles {
  AppTextStyles._();

  // --- Dynamic Builders ---
  static TextStyle cinzel({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.cinzel(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle notoSerifThai({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
  }) => GoogleFonts.notoSerifThai(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
    fontStyle: fontStyle,
  );

  static TextStyle notoSansThai({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.notoSansThai(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );

  // --- Grand Realm & Hero Titles (Cinzel - Noble Engraved Feel) ---
  static TextStyle get realmTitle => GoogleFonts.cinzel(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.goldLight,
    letterSpacing: 1.4,
  );

  static TextStyle get sectBanner => GoogleFonts.cinzel(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.goldPrimary,
    letterSpacing: 1.1,
  );

  static TextStyle get qiCounter => GoogleFonts.cinzel(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.qiLight,
    letterSpacing: 0.8,
  );

  // --- Manuscript & Decree Headings (Noto Serif Thai) ---
  static TextStyle get manuscriptHeading => GoogleFonts.notoSerifThai(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle get scrollScript => GoogleFonts.notoSerifThai(
    fontSize: 13.5,
    fontStyle: FontStyle.italic,
    color: AppColors.textGold,
    height: 1.4,
  );

  // --- Standard Modern Functional Headings (Noto Sans Thai) ---
  static TextStyle get heading1 => GoogleFonts.notoSansThai(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static TextStyle get heading2 => GoogleFonts.notoSansThai(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => GoogleFonts.notoSansThai(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- Body & Secondary Text (Noto Sans Thai for Maximum Readability) ---
  static TextStyle get bodyLarge => GoogleFonts.notoSansThai(
    fontSize: 14.5,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static TextStyle get bodyMedium => GoogleFonts.notoSansThai(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get bodySmall => GoogleFonts.notoSansThai(
    fontSize: 11.5,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );

  // --- Badges, Seals & Labels ---
  static TextStyle get martialBadge => GoogleFonts.cinzel(
    fontSize: 11.5,
    fontWeight: FontWeight.bold,
    color: AppColors.goldPrimary,
    letterSpacing: 0.6,
  );

  static TextStyle get sealLabel => GoogleFonts.notoSansThai(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );
}
