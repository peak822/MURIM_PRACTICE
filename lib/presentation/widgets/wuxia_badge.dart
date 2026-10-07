import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/cultivation_category.dart';

/// SectSeal / WuxiaBadge
/// Inspired by traditional Bamboo Slips (ป้ายไม้ไผ่) and Cinnabar Seals (ตราประทับสำนัก)
class WuxiaBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool isSolid;

  const WuxiaBadge({
    super.key,
    required this.text,
    this.color = AppColors.goldPrimary,
    this.icon,
    this.isSolid = false,
  });

  factory WuxiaBadge.category(CultivationCategory category) {
    return WuxiaBadge(
      text: category.thaiTitle,
      color: category.color,
      icon: category.icon,
    );
  }

  factory WuxiaBadge.difficulty(int difficulty) {
    Color color;
    String label;
    switch (difficulty) {
      case 1:
        color = AppColors.jadeLight;
        label = 'ระดับต้น';
        break;
      case 2:
        color = AppColors.qiLight;
        label = 'ระดับกลาง';
        break;
      case 3:
        color = AppColors.goldLight;
        label = 'ระดับสูง';
        break;
      case 4:
        color = AppColors.crimsonLight;
        label = 'ระดับเซียน';
        break;
      default:
        color = AppColors.textSecondary;
        label = 'ทั่วไป';
    }

    return WuxiaBadge(
      text: label,
      color: color,
      icon: Icons.shield_outlined,
    );
  }

  factory WuxiaBadge.qiReward(int qi) {
    return WuxiaBadge(
      text: '+$qi Qi',
      color: AppColors.goldLight,
      icon: Icons.bolt_rounded,
      isSolid: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: isSolid ? color.withValues(alpha: 0.18) : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.5, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
