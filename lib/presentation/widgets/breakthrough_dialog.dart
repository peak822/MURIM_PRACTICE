import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/cultivation_realm.dart';
import 'wuxia_button.dart';

/// BreakthroughDialog
/// An imperial breakthrough ceremony modal when advancing cultivation realm.
class BreakthroughDialog extends StatelessWidget {
  final CultivationRealm realm;
  final VoidCallback onDismiss;

  const BreakthroughDialog({
    super.key,
    required this.realm,
    required this.onDismiss,
  });

  static Future<void> show(BuildContext context, CultivationRealm realm) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Breakthrough',
      barrierColor: Colors.black.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, anim1, anim2) {
        return BreakthroughDialog(
          realm: realm,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 460),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          gradient: AppColors.scrollCardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: realm.primaryColor.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: realm.primaryColor.withValues(alpha: 0.25),
              blurRadius: 30,
              spreadRadius: 2,
            ),
            const BoxShadow(
              color: Color(0x90000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Golden Talisman Emblem
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      realm.primaryColor.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(color: realm.primaryColor, width: 1.8),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 42,
                    color: realm.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                '⚡ ทะลวงด่านสำเร็จ ⚡',
                style: AppTextStyles.manuscriptHeading.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: realm.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ก้าวข้ามขีดจำกัดเดิม บรรลุสู่ขอบเขตยุทธภพใหม่',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              // Realm Name Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: realm.primaryColor.withValues(alpha: 0.35), width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      realm.fullThaiTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading2.copyWith(
                        color: realm.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      realm.fullEnglishTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.martialBadge.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Breakthrough Quote
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Text(
                  '“${realm.breakthroughQuote}”',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.scrollScript.copyWith(
                    color: AppColors.textGold,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Button
              WuxiaButton(
                text: 'น้อมรับพลังและบำเพ็ญเพียรต่อ',
                icon: Icons.check_circle_outline_rounded,
                style: WuxiaButtonStyle.gold,
                isFullWidth: true,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
