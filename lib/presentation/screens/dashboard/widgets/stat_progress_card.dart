import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/cultivation_calculator.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/user_stats_model.dart';
import 'package:murim_app/presentation/widgets/qi_bar.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

class StatProgressCard extends StatelessWidget {
  final UserStats stats;

  const StatProgressCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return WuxiaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_tree_rounded,
                color: AppColors.goldPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ความก้าวหน้า 4 สายวิชา',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildStatRow(
            category: CultivationCategory.body,
            xp: stats.bodyXp,
          ),
          const SizedBox(height: 12),

          _buildStatRow(
            category: CultivationCategory.mind,
            xp: stats.mindXp,
          ),
          const SizedBox(height: 12),

          _buildStatRow(
            category: CultivationCategory.martial,
            xp: stats.martialXp,
          ),
          const SizedBox(height: 12),

          _buildStatRow(
            category: CultivationCategory.spiritual,
            xp: stats.spiritualXp + (stats.meditationMinutes * 2),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required CultivationCategory category,
    required int xp,
  }) {
    final level = CultivationCalculator.getStatLevel(xp);
    final progress = CultivationCalculator.getStatLevelProgress(xp);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: category.color.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(category.icon, size: 18, color: category.color),
                  const SizedBox(width: 8),
                  Text(
                    category.thaiTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Lv. $level',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: category.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          QiBar(
            progress: progress,
            height: 6,
            showLabels: false,
            gradient: LinearGradient(
              colors: [category.color, category.color.withValues(alpha: 0.6)],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.description,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                '$xp XP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: category.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
