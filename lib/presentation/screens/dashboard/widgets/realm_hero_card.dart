import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/data/models/user_stats_model.dart';
import 'package:murim_app/presentation/widgets/qi_bar.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

/// RealmHeroCard
/// Styled like an Imperial Cultivation Scroll (คัมภีร์บำเพ็ญตนแห่งสำนัก)
class RealmHeroCard extends StatelessWidget {
  final UserStats stats;
  final VoidCallback? onEditProfile;

  const RealmHeroCard({
    super.key,
    required this.stats,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final realm = stats.currentRealm;
    final progress = stats.realmProgress;

    return WuxiaCard(
      borderColor: realm.primaryColor.withValues(alpha: 0.5),
      hasGlow: true,
      showCornerAccents: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Disciple & Sect Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldPrimary.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF090B10),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stats.userName,
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 13,
                            color: AppColors.goldLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            stats.sectName,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (onEditProfile != null)
                IconButton(
                  onPressed: onEditProfile,
                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.textSecondary, size: 22),
                  tooltip: 'แก้ไขข้อมูลจอมยุทธ์',
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),

          // Realm Title and Stage Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0F18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: realm.primaryColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: realm.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.military_tech_rounded,
                    color: realm.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ขอบเขตพลังยุทธภพ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        realm.fullThaiTitle,
                        style: AppTextStyles.heading2.copyWith(
                          color: realm.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: realm.primaryColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: realm.primaryColor.withValues(alpha: 0.5), width: 0.9),
                  ),
                  child: Text(
                    'ขั้น ${realm.level}/20',
                    style: TextStyle(
                      color: realm.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Realm Description
          Text(
            realm.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // Qi Progress Bar
          QiBar(
            progress: progress,
            currentQi: stats.totalQi,
            maxQi: realm.maxQi,
            height: 12,
            gradient: LinearGradient(
              colors: [realm.primaryColor, realm.primaryColor.withValues(alpha: 0.6)],
            ),
            labelText: 'พลังลมปราณสะสม (Qi)',
          ),

          const SizedBox(height: 8),

          // Qi remaining info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ต้องการอีก ${stats.qiNeededForNextRealm} Qi เพื่อทะลวงด่าน',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.goldLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'รวม ${stats.totalQi} Qi',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.qiLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
