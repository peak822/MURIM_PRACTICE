import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds & Surfaces (Ink Slate theme)
  static const Color background = Color(0xFF080C14);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFF1E293B);
  static const Color surfaceCard = Color(0xFF131D33);
  static const Color surfaceOverlay = Color(0xCC080C14);

  // Primary: Imperial Gold & Jade
  static const Color goldPrimary = Color(0xFFF59E0B);
  static const Color goldLight = Color(0xFFFCD34D);
  static const Color goldDark = Color(0xFFB45309);
  static const Color goldAccent = Color(0xFFFFE082);

  // Jade Green (Spiritual & Health)
  static const Color jadePrimary = Color(0xFF10B981);
  static const Color jadeLight = Color(0xFF34D399);
  static const Color jadeDark = Color(0xFF047857);
  static const Color jadeAura = Color(0x3310B981);

  // Qi Cyan (Spiritual Energy & Focus)
  static const Color qiPrimary = Color(0xFF06B6D4);
  static const Color qiLight = Color(0xFF67E8F9);
  static const Color qiDark = Color(0xFF0E7490);
  static const Color qiGlow = Color(0x4006B6D4);

  // Crimson Blade / Martial Vigor
  static const Color crimsonPrimary = Color(0xFFE11D48);
  static const Color crimsonLight = Color(0xFFFDA4AF);
  static const Color crimsonDark = Color(0xFF9F1239);

  // Mind Purple / Insight & Wisdom
  static const Color mindPrimary = Color(0xFF8B5CF6);
  static const Color mindLight = Color(0xFFC4B5FD);
  static const Color mindDark = Color(0xFF6D28D9);

  // Ancient Parchment / Scroll Tint
  static const Color parchment = Color(0xFFF7EED3);
  static const Color parchmentDark = Color(0xFFD6C7A1);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textGold = Color(0xFFFDE68A);

  // Borders & Accents
  static const Color border = Color(0xFF334155);
  static const Color borderGlow = Color(0x55F59E0B);
  static const Color divider = Color(0xFF1E293B);

  // Category Colors
  static const Color categoryBody = Color(0xFFE11D48); // Body Refining (พลังกาย)
  static const Color categoryMind = Color(0xFF8B5CF6); // Mind Cultivation (ปัญญา)
  static const Color categoryMartial = Color(0xFF06B6D4); // Martial Arts (วรยุทธ์)
  static const Color categorySpiritual = Color(0xFF10B981); // Spiritual / Qi (ลมปราณ)

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient jadeGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF10B981), Color(0xFF047857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qiGradient = LinearGradient(
    colors: [Color(0xFF67E8F9), Color(0xFF06B6D4), Color(0xFF0E7490)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF131D33), Color(0xFF0E1626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF080C14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
