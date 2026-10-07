import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/cultivation_calculator.dart';
import 'package:murim_app/data/models/user_stats_model.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

/// DailyStreakCard
/// Styled like a Meridian Fire Talisman (ยันต์เพลิงมังกรฝึกตนต่อเนื่อง)
class DailyStreakCard extends StatelessWidget {
  final UserStats stats;

  const DailyStreakCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final bonusMultiplier = CultivationCalculator.getStreakBonusMultiplier(stats.currentStreak);
    final bonusPercent = ((bonusMultiplier - 1.0) * 100).toInt();

    return WuxiaCard(
      borderColor: AppColors.goldDark.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Dragon Fire Talisman Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldPrimary.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.7), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldPrimary.withValues(alpha: 0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.goldPrimary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Streak info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${stats.currentStreak}',
                      style: AppTextStyles.qiCounter.copyWith(
                        color: AppColors.goldLight,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'วันฝึกตนต่อเนื่อง',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  bonusPercent > 0
                      ? '⚡ ได้รับโบนัสปราณ Qi +$bonusPercent% จากความสม่ำเสมอ'
                      : 'ฝึกฝนต่อเนื่องทุกวันเพื่อรับโบนัส Qi สูงสุด +30%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: bonusPercent > 0 ? AppColors.goldLight : AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Longest streak badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'สถิติสูงสุด',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                '${stats.longestStreak} วัน',
                style: const TextStyle(
                  color: AppColors.qiLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
