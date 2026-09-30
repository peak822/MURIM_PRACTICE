import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/date_formatter.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/presentation/widgets/wuxia_badge.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = mission.category.color;
    final isCompleted = mission.isCompleted;

    return Opacity(
      opacity: isCompleted ? 0.65 : 1.0,
      child: WuxiaCard(
        borderColor: isCompleted
            ? AppColors.border
            : categoryColor.withValues(alpha: 0.35),
        backgroundColor: isCompleted
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.surfaceCard,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox with Qi Aura
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.jadePrimary
                        : AppColors.surfaceLight,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.jadeLight
                          : AppColors.border,
                      width: 1.8,
                    ),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: AppColors.jadePrimary.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      WuxiaBadge.category(mission.category),
                      WuxiaBadge.difficulty(mission.difficulty),
                      WuxiaBadge.qiReward(mission.xpReward),
                      if (mission.isDaily)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.goldPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ประจำวัน',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Mission Title
                  Text(
                    mission.title,
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),

                  // Description if any
                  if (mission.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      mission.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isCompleted ? AppColors.textMuted : AppColors.textSecondary,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Meta Row: Duration, Created / Completed date
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${mission.estimatedMinutes} นาที',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted && mission.completedAt != null
                            ? 'สำเร็จ: ${DateFormatter.formatRelativeDate(mission.completedAt!)}'
                            : 'สร้าง: ${DateFormatter.formatShortDate(mission.createdAt)}',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 20),
              color: AppColors.surfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18, color: AppColors.goldLight),
                      SizedBox(width: 8),
                      Text('แก้ไขเทียบภารกิจ', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.crimsonLight),
                      SizedBox(width: 8),
                      Text('ละทิ้งภารกิจ', style: TextStyle(fontSize: 13, color: AppColors.crimsonLight)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
