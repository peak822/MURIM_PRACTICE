import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings (Martial / Wuxia Style)
  static TextStyle get realmTitle => GoogleFonts.cinzel(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.goldLight,
    letterSpacing: 1.2,
  );

  static TextStyle get heading1 => GoogleFonts.notoSansThai(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => GoogleFonts.notoSansThai(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body & Subtitles
  static TextStyle get bodyLarge => GoogleFonts.notoSansThai(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.notoSansThai(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.notoSansThai(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );

  // Badges & Labels
  static TextStyle get martialBadge => GoogleFonts.cinzel(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.goldPrimary,
    letterSpacing: 0.8,
  );

  static TextStyle get qiCounter => GoogleFonts.cinzel(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.qiLight,
  );

  static TextStyle get scrollScript => GoogleFonts.notoSerifThai(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    color: AppColors.parchment,
  );
}
