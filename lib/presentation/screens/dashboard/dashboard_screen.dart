import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/constants/app_constants.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/providers/mission_provider.dart';
import 'package:murim_app/presentation/widgets/breakthrough_dialog.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';
import 'widgets/bagua_radar_chart.dart';
import 'widgets/daily_streak_card.dart';
import 'widgets/realm_hero_card.dart';
import 'widgets/stat_progress_card.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMissions;
  final VoidCallback? onNavigateToMeditation;

  const DashboardScreen({
    super.key,
    this.onNavigateToMissions,
    this.onNavigateToMeditation,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBreakthrough();
    });
  }

  void _checkBreakthrough() {
    final cultivation = context.read<CultivationProvider>();
    if (cultivation.latestBreakthroughRealm != null) {
      final realm = cultivation.latestBreakthroughRealm!;
      cultivation.clearBreakthroughNotice();
      BreakthroughDialog.show(context, realm);
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final cultivation = context.read<CultivationProvider>();
    final nameController = TextEditingController(text: cultivation.stats.userName);
    final sectController = TextEditingController(text: cultivation.stats.sectName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.brush_rounded, color: AppColors.goldPrimary),
              const SizedBox(width: 8),
              Text('แก้ไขข้อมูลจอมยุทธ์', style: AppTextStyles.heading2),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'นามฉายาจอมยุทธ์',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: sectController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อสำนัก / พรรค',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shield_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
            ),
            WuxiaButton(
              text: 'บันทึก',
              height: 38,
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  cultivation.updateProfile(
                    userName: nameController.text.trim(),
                    sectName: sectController.text.trim(),
                  );
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CultivationProvider>(
      builder: (context, cultivation, child) {
        // Listen for new breakthroughs
        if (cultivation.latestBreakthroughRealm != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkBreakthrough();
          });
        }

        final stats = cultivation.stats;
        final attributes = cultivation.radarAttributes;

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Martial Quote Banner
                        _buildQuoteBanner(),
                        const SizedBox(height: 18),

                        if (isDesktop)
                          // Desktop 2-column layout
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left column: Realm Hero & Stats
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    RealmHeroCard(
                                      stats: stats,
                                      onEditProfile: () => _showEditProfileDialog(context),
                                    ),
                                    const SizedBox(height: 18),
                                    DailyStreakCard(stats: stats),
                                    const SizedBox(height: 18),
                                    StatProgressCard(stats: stats),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Right column: Bagua Radar Chart & Quick Actions
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    _buildRadarChartCard(attributes, stats.currentRealm.primaryColor),
                                    const SizedBox(height: 18),
                                    _buildQuickActionsCard(context),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          // Mobile / Tablet 1-column layout
                          Column(
                            children: [
                              RealmHeroCard(
                                stats: stats,
                                onEditProfile: () => _showEditProfileDialog(context),
                              ),
                              const SizedBox(height: 18),
                              DailyStreakCard(stats: stats),
                              const SizedBox(height: 18),
                              _buildRadarChartCard(attributes, stats.currentRealm.primaryColor),
                              const SizedBox(height: 18),
                              StatProgressCard(stats: stats),
                              const SizedBox(height: 18),
                              _buildQuickActionsCard(context),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQuoteBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_stories_rounded,
            color: AppColors.goldLight,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppConstants.cultivationQuotes.first,
              style: AppTextStyles.scrollScript.copyWith(
                color: AppColors.textGold,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChartCard(Map<String, double> attributes, Color primaryColor) {
    return WuxiaCard(
      borderColor: primaryColor.withValues(alpha: 0.4),
      hasGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.radar_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ยันต์แปดทิศสเตตัสวรยุทธ์',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Reactive Bagua',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'กราฟใยแมงมุมแสดงสมดุลพลัง 6 ด้าน อัปเดตทันทีเมื่อบ่มเพาะสำเร็จ',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          BaguaRadarChart(
            attributes: attributes,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    final missionProvider = context.watch<MissionProvider>();
    final pendingCount = missionProvider.pendingCount;

    return WuxiaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flash_on_rounded,
                color: AppColors.goldPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'เริ่มการฝึกฝนด่วน',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: WuxiaButton(
                  text: 'ทำภารกิจ ($pendingCount)',
                  icon: Icons.checklist_rounded,
                  style: WuxiaButtonStyle.gold,
                  onPressed: widget.onNavigateToMissions,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WuxiaButton(
                  text: 'ปิดด่านสมาธิ',
                  icon: Icons.self_improvement_rounded,
                  style: WuxiaButtonStyle.jade,
                  onPressed: widget.onNavigateToMeditation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
