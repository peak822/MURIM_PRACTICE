import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/date_formatter.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/cultivation_log.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/widgets/wuxia_badge.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

class ChronicleScreen extends StatelessWidget {
  const ChronicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cultivation = context.watch<CultivationProvider>();
    final logs = cultivation.logs;
    final stats = cultivation.stats;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'หอบันทึกคัมภีร์ยุทธภพ (Hall of Records)',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ประวัติการบำเพ็ญเพียร การทำภารกิจ และการทะลวงด่านยุทธภพ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 20),

                    // Quick Stats Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryMetric(
                            icon: Icons.bolt_rounded,
                            color: AppColors.goldLight,
                            title: 'ปราณ Qi ทั้งหมด',
                            value: '${stats.totalQi}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryMetric(
                            icon: Icons.task_alt_rounded,
                            color: AppColors.jadeLight,
                            title: 'ภารกิจสำเร็จ',
                            value: '${stats.completedMissionsCount}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryMetric(
                            icon: Icons.self_improvement_rounded,
                            color: AppColors.qiLight,
                            title: 'เวลาปิดด่าน',
                            value: '${stats.meditationMinutes} น.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Timeline Title
                    Row(
                      children: [
                        const Icon(Icons.history_rounded, color: AppColors.goldPrimary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'บันทึกเหตุการณ์การฝึกฝน (${logs.length} รายการ)',
                          style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Timeline list
                    Expanded(
                      child: logs.isEmpty
                          ? Center(
                              child: Text(
                                'ยังไม่มีบันทึกการฝึกตน เริ่มทำภารกิจเพื่อจารึกประวัติศาสตร์!',
                                style: AppTextStyles.bodyMedium,
                              ),
                            )
                          : ListView.separated(
                              itemCount: logs.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return _buildLogCard(log);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryMetric({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return WuxiaCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(CultivationLog log) {
    final isBreakthrough = log.type == CultivationLogType.realmBreakthrough;
    final isMeditation = log.type == CultivationLogType.meditationCompleted;

    Color iconColor;
    IconData iconData;

    if (isBreakthrough) {
      iconColor = AppColors.goldPrimary;
      iconData = Icons.auto_awesome_rounded;
    } else if (isMeditation) {
      iconColor = AppColors.qiLight;
      iconData = Icons.self_improvement_rounded;
    } else {
      iconColor = log.category?.color ?? AppColors.jadeLight;
      iconData = log.category?.icon ?? Icons.check_circle_outline_rounded;
    }

    return WuxiaCard(
      borderColor: isBreakthrough ? AppColors.goldPrimary.withValues(alpha: 0.5) : AppColors.border,
      hasGlow: isBreakthrough,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        log.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isBreakthrough ? AppColors.goldLight : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      DateFormatter.formatRelativeDate(log.timestamp),
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isBreakthrough ? AppColors.textGold : AppColors.textSecondary,
                  ),
                ),
                if (log.category != null || log.qiGained > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (log.category != null) ...[
                        WuxiaBadge.category(log.category!),
                        const SizedBox(width: 6),
                      ],
                      if (log.qiGained > 0)
                        WuxiaBadge.qiReward(log.qiGained),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
