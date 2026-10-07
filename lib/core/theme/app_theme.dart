import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.goldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldPrimary,
        primaryContainer: AppColors.goldDark,
        secondary: AppColors.jadePrimary,
        secondaryContainer: AppColors.jadeDark,
        tertiary: AppColors.qiPrimary,
        surface: AppColors.surface,
        error: AppColors.crimsonPrimary,
        onPrimary: Color(0xFF090B10),
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.goldLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
        iconTheme: IconThemeData(color: AppColors.goldLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.goldPrimary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: IconThemeData(color: AppColors.goldPrimary, size: 26),
        unselectedIconTheme: IconThemeData(color: AppColors.textMuted, size: 22),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.goldPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11.5,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceCard,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGold, width: 1.2),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.goldPrimary,
        foregroundColor: Color(0xFF090B10),
        elevation: 6,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.borderGold, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 20,
      ),
      textTheme: GoogleFonts.notoSansThaiTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }
}
