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

/// DashboardScreen / หอฝึกตน (Cultivation Pagoda)
class DashboardScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMissions;
  final VoidCallback? onNavigateToBodyCultivation;
  final VoidCallback? onNavigateToMeditation;

  const DashboardScreen({
    super.key,
    this.onNavigateToMissions,
    this.onNavigateToBodyCultivation,
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
              const Icon(Icons.brush_rounded, color: AppColors.goldPrimary, size: 20),
              const SizedBox(width: 8),
              Text('จารึกข้อมูลจอมยุทธ์', style: AppTextStyles.heading2),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'นามฉายาจอมยุทธ์',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sectController,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'สังกัดสำนัก / พรรค',
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
              text: 'จารึก',
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
                        // Martial Manuscript Quote Banner
                        _buildQuoteBanner(),
                        const SizedBox(height: 16),

                        if (isDesktop)
                          // Desktop 2-column layout
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left column: Imperial Scroll & Stats
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    RealmHeroCard(
                                      stats: stats,
                                      onEditProfile: () => _showEditProfileDialog(context),
                                    ),
                                    const SizedBox(height: 16),
                                    DailyStreakCard(stats: stats),
                                    const SizedBox(height: 16),
                                    StatProgressCard(stats: stats),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Right column: Bagua Radar Chart & Quick Actions
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    _buildRadarChartCard(attributes, stats.currentRealm.primaryColor),
                                    const SizedBox(height: 16),
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
                              const SizedBox(height: 14),
                              DailyStreakCard(stats: stats),
                              const SizedBox(height: 14),
                              _buildRadarChartCard(attributes, stats.currentRealm.primaryColor),
                              const SizedBox(height: 14),
                              StatProgressCard(stats: stats),
                              const SizedBox(height: 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldDark.withValues(alpha: 0.35), width: 0.9),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_stories_rounded,
            color: AppColors.goldLight,
            size: 18,
          ),
          const SizedBox(width: 10),
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
      borderColor: primaryColor.withValues(alpha: 0.35),
      hasGlow: true,
      showCornerAccents: true,
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
                    size: 19,
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
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Reactive Bagua',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'กราฟใยแมงมุมแสดงสมดุลพลัง 6 ด้าน อัปเดตทันทีเมื่อบ่มเพาะสำเร็จ',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 10),
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
                size: 19,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: WuxiaButton(
                  text: 'ภารกิจ ($pendingCount)',
                  icon: Icons.checklist_rounded,
                  style: WuxiaButtonStyle.gold,
                  onPressed: widget.onNavigateToMissions,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WuxiaButton(
                  text: 'บ่มเพาะกาย',
                  icon: Icons.fitness_center_rounded,
                  style: WuxiaButtonStyle.crimson,
                  onPressed: widget.onNavigateToBodyCultivation,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WuxiaButton(
                  text: 'สมาธิ',
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
