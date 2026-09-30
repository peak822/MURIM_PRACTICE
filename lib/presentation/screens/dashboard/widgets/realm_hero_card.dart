import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/data/models/user_stats_model.dart';
import 'package:murim_app/presentation/widgets/qi_bar.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

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
      borderColor: realm.primaryColor.withValues(alpha: 0.6),
      hasGlow: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User & Sect Name
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
                          color: AppColors.goldPrimary.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF0F172A),
                        size: 26,
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
                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.textSecondary),
                  tooltip: 'แก้ไขข้อมูลผู้ฝึกตน',
                ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 18),

          // Realm Title and Stage Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF090E1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: realm.primaryColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: realm.primaryColor.withValues(alpha: 0.15),
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
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: realm.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: realm.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: realm.primaryColor, width: 1),
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

          const SizedBox(height: 16),

          // Realm Description
          Text(
            realm.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // Qi Progress Bar
          QiBar(
            progress: progress,
            currentQi: stats.totalQi,
            maxQi: realm.maxQi,
            height: 14,
            gradient: LinearGradient(
              colors: [realm.primaryColor, realm.primaryColor.withValues(alpha: 0.7)],
            ),
            labelText: 'พลังลมปราณสะสม (Qi)',
          ),

          const SizedBox(height: 10),

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
