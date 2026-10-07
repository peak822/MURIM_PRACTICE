import 'package:flutter/material.dart';

/// Refined Murim & Wuxia Palette
/// Inspired by Ink Painting, Ancient Manuscripts, Dragon Jade, Imperial Gold, and Cinnabar Seals.
class AppColors {
  AppColors._();

  // --- Backgrounds & Ink Surfaces (Xuan Paper & Dark Lacquer) ---
  static const Color background = Color(0xFF090B10); // Deep Ink Black
  static const Color surface = Color(0xFF0F131C); // Lacquered Slate
  static const Color surfaceCard = Color(0xFF141A26); // Dark Scroll Paper
  static const Color surfaceElevated = Color(0xFF1B2333); // Elevated Ink Stone
  static const Color surfaceLight = Color(0xFF222C40); // Soft Charcoal Tint
  static const Color surfaceOverlay = Color(0xDD090B10); // Modal Veil

  // --- Imperial Silk & Antique Gold (ความสูงส่ง / บรรลุธรรม) ---
  static const Color goldPrimary = Color(0xFFE5B842); // Antique Imperial Gold
  static const Color goldLight = Color(0xFFF7D978); // Luminous Qi Gold
  static const Color goldDark = Color(0xFF9E771D); // Deep Bronze Gold
  static const Color goldAccent = Color(0xFFFFE89E); // Gold Leaf Shimmer
  static const Color goldAura = Color(0x28E5B842); // Subtle Golden Halo

  // --- Dragon Jade (หยกมังกร / พลังชีวิตและจิตวิญญาณ) ---
  static const Color jadePrimary = Color(0xFF2E9E74); // Imperial Green Jade
  static const Color jadeLight = Color(0xFF57CC99); // Polished Jade Sheen
  static const Color jadeDark = Color(0xFF145C41); // Deep River Jade
  static const Color jadeAura = Color(0x252E9E74); // Jade Qi Mist

  // --- Heavenly Qi Cyan (ปราณฟ้า / พลังบริสุทธิ์) ---
  static const Color qiPrimary = Color(0xFF2BA4B8); // Azure Qi Stream
  static const Color qiLight = Color(0xFF6ED4E5); // Pure Spiritual Mist
  static const Color qiDark = Color(0xFF136472); // Deep Ocean Vitality
  static const Color qiGlow = Color(0x302BA4B8); // Qi Aura Glow

  // --- Cinnabar Crimson & Seal Ink (ตราประทับชาด / พลังกายาวรยุทธ์) ---
  static const Color crimsonPrimary = Color(0xFFC7384A); // Cinnabar Seal Red
  static const Color crimsonLight = Color(0xFFE86071); // Martial Vigor Crimson
  static const Color crimsonDark = Color(0xFF7A1C27); // Dried Iron Blood

  // --- Ancient Wisdom & Mind Purple (ปัญญา / ญาณหยั่งรู้) ---
  static const Color mindPrimary = Color(0xFF8B68D9); // Daoist Violet
  static const Color mindLight = Color(0xFFBCA6F2); // Subtle Mind Glow
  static const Color mindDark = Color(0xFF4C308A); // Deep Meditation Purple

  // --- Ancient Parchment & Bamboo (คัมภีร์โบราณ / ป้ายไม้ไผ่) ---
  static const Color parchment = Color(0xFFEDE3D0); // Aged Calligraphy Paper
  static const Color parchmentDark = Color(0xFFC4B69C); // Weathered Bamboo Roll
  static const Color parchmentLight = Color(0xFFFAF6EE); // Pure Rice Paper
  static const Color woodBorder = Color(0xFF4A3E35); // Sandalwood Trim

  // --- Text Hierarchy ---
  static const Color textPrimary = Color(0xFFF3F5F9); // Crisp Rice-paper White
  static const Color textSecondary = Color(0xFFA8B4C8); // Muted Cloud Gray
  static const Color textMuted = Color(0xFF6B7A94); // Faded Ink Gray
  static const Color textGold = Color(0xFFF7D978); // Illuminated Script Gold
  static const Color textParchment = Color(0xFFEDE3D0); // Manuscript Text

  // --- Borders, Carvings & Dividers ---
  static const Color border = Color(0xFF263248); // Subtle Inscribed Border
  static const Color borderLight = Color(0xFF3B4D6E); // Highlight Inscription
  static const Color borderGold = Color(0x66E5B842); // Gold Filigree Trim
  static const Color borderGlow = Color(0x33E5B842); // Golden Border Aura
  static const Color borderJade = Color(0x552E9E74); // Jade Band Border
  static const Color divider = Color(0xFF1C2433); // Faded Ink Line

  // --- Category Accent Mapping ---
  static const Color categoryBody = Color(0xFFC7384A); // Body Refining (กายา)
  static const Color categoryMind = Color(0xFF8B68D9); // Mind & Wisdom (ปัญญา)
  static const Color categoryMartial = Color(0xFF2BA4B8); // Martial Arts (วรยุทธ์)
  static const Color categorySpiritual = Color(0xFF2E9E74); // Spiritual Qi (สมาธิปราณ)

  // --- Noble Gradients ---
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF7D978), Color(0xFFE5B842), Color(0xFF9E771D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient jadeGradient = LinearGradient(
    colors: [Color(0xFF57CC99), Color(0xFF2E9E74), Color(0xFF145C41)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qiGradient = LinearGradient(
    colors: [Color(0xFF6ED4E5), Color(0xFF2BA4B8), Color(0xFF136472)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient crimsonGradient = LinearGradient(
    colors: [Color(0xFFE86071), Color(0xFFC7384A), Color(0xFF7A1C27)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient scrollCardGradient = LinearGradient(
    colors: [Color(0xFF161E2E), Color(0xFF111724)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroScrollGradient = LinearGradient(
    colors: [Color(0xFF1E283D), Color(0xFF141B2A), Color(0xFF0C101A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
