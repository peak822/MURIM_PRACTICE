import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/body_cultivation_calculator.dart';
import '../../../data/models/body_cultivation_models.dart';
import '../../providers/body_cultivation_provider.dart';
import '../../providers/cultivation_provider.dart';
import '../../widgets/wuxia_button.dart';
import '../../widgets/wuxia_card.dart';
import 'active_session_screen.dart';
import 'exercise_library_screen.dart';

class BodyCultivationScreen extends StatelessWidget {
  const BodyCultivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BodyCultivationProvider, CultivationProvider>(
      builder: (context, bodyProvider, cultProvider, _) {
        final bodyXp = cultProvider.stats.bodyXp;
        final currentRealm = BodyCultivationCalculator.getBodyRealm(bodyXp);
        final realmProgress = BodyCultivationCalculator.getBodyRealmProgress(bodyXp);
        final templates = bodyProvider.templates;
        final records = bodyProvider.records;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Realm Hero Card
                    _buildRealmHeroCard(context, currentRealm, realmProgress, bodyXp),
                    const SizedBox(height: 18),

                    // Recommended Routine Hero Banner
                    if (templates.isNotEmpty) ...[
                      _buildRecommendedRoutineBanner(context, bodyProvider, templates.first, currentRealm),
                      const SizedBox(height: 20),
                    ],

                    // Standard Routines Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.fitness_center, color: AppColors.crimsonLight, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'รูทีนฝึกฝนกายามาตรฐาน',
                              style: AppTextStyles.heading2.copyWith(fontSize: 17),
                            ),
                          ],
                        ),
                        Text(
                          '${templates.length} รูทีน',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Templates List
                    ...templates.map((tpl) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTemplateCard(context, bodyProvider, tpl),
                        )),
                    const SizedBox(height: 14),

                    // Quick Codex Banner
                    _buildCodexBanner(context),
                    const SizedBox(height: 24),

                    // Training History Log
                    _buildTrainingHistorySection(context, bodyProvider, records),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRealmHeroCard(
    BuildContext context,
    BodyRealm realm,
    double progress,
    int bodyXp,
  ) {
    return WuxiaCard(
      borderColor: AppColors.categoryBody.withValues(alpha: 0.6),
      hasGlow: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.crimsonPrimary.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.crimsonLight, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.crimsonLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            realm.thaiName,
                            style: const TextStyle(
                              color: AppColors.goldLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.crimsonPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.crimsonLight.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'ขั้นที่ ${realm.level} / 5',
                              style: const TextStyle(
                                color: AppColors.crimsonLight,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        realm.englishName,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.menu_book, color: AppColors.goldLight),
                tooltip: 'เปิดคลังคัมภีร์ท่วงท่า',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ExerciseLibraryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Lore Description
          Text(
            realm.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'พละกำลังกายสะสม: $bodyXp XP',
                style: const TextStyle(
                  color: AppColors.textGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                realm.maxBodyXp >= 999999 ? 'ขอบเขตสูงสุด' : 'เป้าหมาย: ${realm.maxBodyXp} XP',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.crimsonLight),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedRoutineBanner(
    BuildContext context,
    BodyCultivationProvider bodyProvider,
    TrainingSessionTemplate template,
    BodyRealm realm,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.crimsonPrimary.withValues(alpha: 0.25),
            AppColors.surfaceElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.crimsonPrimary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.crimsonPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '⭐ รูทีนแนะนำประจำวัน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${template.estimatedMinutes} นาที',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            template.murimTitle,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            template.title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            template.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          WuxiaButton(
            text: 'เริ่มฝึกฝนรูทีนนี้ (${template.exerciseIds.length} ท่วงท่า)',
            icon: Icons.play_arrow_rounded,
            isFullWidth: true,
            onPressed: () => _startRoutine(context, bodyProvider, template),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    BodyCultivationProvider bodyProvider,
    TrainingSessionTemplate template,
  ) {
    return WuxiaCard(
      padding: const EdgeInsets.all(14),
      borderColor: AppColors.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.sports_martial_arts_rounded,
              color: AppColors.goldPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      template.murimTitle,
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  template.title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '~${template.estimatedMinutes} นาที',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.format_list_bulleted, color: AppColors.textMuted, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${template.exerciseIds.length} ท่า',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _startRoutine(context, bodyProvider, template),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceLight,
              foregroundColor: AppColors.goldLight,
              side: const BorderSide(color: AppColors.goldDark),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text('เริ่มฝึก', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCodexBanner(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ExerciseLibraryScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGold.withValues(alpha: 0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.auto_stories, color: AppColors.goldLight, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'คัมภีร์รวบรวม 18 ท่วงท่ากายา',
                    style: TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ค้นหาท่วงท่า ท่าเริ่มต้น ลมหายใจ และสายการพัฒนายาก-ง่าย',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingHistorySection(
    BuildContext context,
    BodyCultivationProvider provider,
    List<TrainingRecord> records,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_edu_rounded, color: AppColors.goldPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              'บันทึกการฝึกฝนกายาที่ผ่านมา',
              style: AppTextStyles.heading2.copyWith(fontSize: 17),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (records.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(Icons.sports_martial_arts, size: 40, color: AppColors.textMuted),
                SizedBox(height: 10),
                Text(
                  'ยังไม่มีประวัติการฝึกฝนกายา',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '“จงเริ่มก้าวแรกในการหลอมรวมเส้นเอ็นและสร้างกายาวชิระ”',
                  style: TextStyle(color: AppColors.textGold, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length.clamp(0, 10),
            itemBuilder: (context, index) {
              final rec = records[index];
              final dateStr = DateFormat('dd MMM yyyy • HH:mm').format(rec.completedAt);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: WuxiaCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  borderColor: AppColors.border,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.crimsonPrimary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: AppColors.crimsonLight, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec.sessionTitle,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+${rec.earnedBodyXp} Body XP',
                            style: const TextStyle(
                              color: AppColors.crimsonLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '+${rec.earnedQi} Qi • ${rec.durationMinutes} นาที',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _startRoutine(
    BuildContext context,
    BodyCultivationProvider provider,
    TrainingSessionTemplate template,
  ) {
    provider.startSession(template);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ActiveSessionScreen(),
      ),
    );
  }
}
