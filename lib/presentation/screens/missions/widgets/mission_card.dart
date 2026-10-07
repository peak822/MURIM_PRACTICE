import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/date_formatter.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/presentation/widgets/wuxia_badge.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

/// MissionCard
/// Styled like a Sect Mission Scroll Decree (เทียบภารกิจสำนัก)
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
      opacity: isCompleted ? 0.62 : 1.0,
      child: WuxiaCard(
        borderColor: isCompleted
            ? AppColors.border
            : categoryColor.withValues(alpha: 0.35),
        backgroundColor: isCompleted
            ? AppColors.surfaceLight.withValues(alpha: 0.18)
            : AppColors.surfaceCard,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox with Qi Aura
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.jadePrimary
                        : AppColors.surfaceLight,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.jadeLight
                          : AppColors.borderLight,
                      width: 1.6,
                    ),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: AppColors.jadePrimary.withValues(alpha: 0.45),
                              blurRadius: 7,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 13),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 5,
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
                            color: AppColors.goldPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3), width: 0.8),
                          ),
                          child: Text(
                            'ประจำวัน',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Mission Title
                  Text(
                    mission.title,
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),

                  // Description if any
                  if (mission.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      mission.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isCompleted ? AppColors.textMuted : AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 7),

                  // Meta Row: Duration, Created / Completed date
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 12.5, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${mission.estimatedMinutes} นาที',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today_outlined, size: 11.5, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted && mission.completedAt != null
                            ? 'สำเร็จ: ${DateFormatter.formatRelativeDate(mission.completedAt!)}'
                            : 'ออกเทียบ: ${DateFormatter.formatShortDate(mission.createdAt)}',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 19),
              color: AppColors.surfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                      Icon(Icons.edit_outlined, size: 16, color: AppColors.goldLight),
                      SizedBox(width: 8),
                      Text('แก้ไขเทียบภารกิจ', style: TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.crimsonLight),
                      SizedBox(width: 8),
                      Text('ละทิ้งเทียบภารกิจ', style: TextStyle(fontSize: 12.5, color: AppColors.crimsonLight)),
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
