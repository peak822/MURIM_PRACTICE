import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/cultivation_realm.dart';
import '../providers/cultivation_provider.dart';
import 'wuxia_button.dart';

/// BreakthroughDialog
/// An imperial breakthrough ceremony modal when advancing cultivation realm.
/// Includes a Tribulation Reflection (Epiphany Form) to record real-world realizations.
class BreakthroughDialog extends StatefulWidget {
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
  State<BreakthroughDialog> createState() => _BreakthroughDialogState();
}

class _BreakthroughDialogState extends State<BreakthroughDialog> {
  late final TextEditingController _reflectionController;
  bool _showReflectionInput = false;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController();
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _handleAccept() {
    final note = _reflectionController.text.trim();
    if (note.isNotEmpty) {
      context.read<CultivationProvider>().recordBreakthroughEpiphany(note);
    }
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final realm = widget.realm;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(26),
        constraints: const BoxConstraints(maxWidth: 480),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Golden Talisman Emblem
                Container(
                  width: 78,
                  height: 78,
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
                      size: 40,
                      color: realm.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  '⚡ ทะลวงด่านสำเร็จ ⚡',
                  style: AppTextStyles.manuscriptHeading.copyWith(
                    fontSize: 20,
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
                const SizedBox(height: 16),

                // Realm Name Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Breakthrough Quote
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Epiphany Reflection Form Toggle / Input
                if (!_showReflectionInput)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showReflectionInput = true;
                      });
                    },
                    icon: const Icon(Icons.history_edu_rounded, size: 16, color: AppColors.goldLight),
                    label: Text(
                      '+ จารึกความรู้แจ้งแห่งเต๋า (บันทึกบทเรียน)',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.goldLight),
                    ),
                  )
                else ...[
                  TextField(
                    controller: _reflectionController,
                    maxLines: 2,
                    maxLength: 140,
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'บันทึกสิ่งที่คุณได้เรียนรู้หรือบรรลุในขั้นนี้...',
                      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.edit_note_rounded, color: AppColors.goldPrimary, size: 20),
                      fillColor: AppColors.surface.withValues(alpha: 0.8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.borderGold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                const SizedBox(height: 12),

                // Action Button
                WuxiaButton(
                  text: 'น้อมรับพลังและบำเพ็ญเพียรต่อ',
                  icon: Icons.check_circle_outline_rounded,
                  style: WuxiaButtonStyle.gold,
                  isFullWidth: true,
                  onPressed: _handleAccept,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
