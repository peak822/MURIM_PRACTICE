import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/providers/mission_provider.dart';
import 'package:murim_app/presentation/widgets/breakthrough_dialog.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';
import 'widgets/add_mission_dialog.dart';
import 'widgets/category_tab_bar.dart';
import 'widgets/mission_card.dart';

/// MissionsScreen / หอเทียบภารกิจสำนัก (Sect Mission Board)
class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  void _openAddMissionDialog(BuildContext context, {Mission? missionToEdit}) {
    final missionProvider = context.read<MissionProvider>();

    AddMissionDialog.show(
      context,
      initialMission: missionToEdit,
      onSave: ({
        required String title,
        required String description,
        required CultivationCategory category,
        required int difficulty,
        required int estimatedMinutes,
        required bool isDaily,
      }) {
        if (missionToEdit != null) {
          final updated = missionToEdit.copyWith(
            title: title,
            description: description,
            category: category,
            difficulty: difficulty,
            estimatedMinutes: estimatedMinutes,
            isDaily: isDaily,
          );
          missionProvider.updateMission(updated);
        } else {
          missionProvider.createMission(
            title: title,
            description: description,
            category: category,
            difficulty: difficulty,
            estimatedMinutes: estimatedMinutes,
            isDaily: isDaily,
          );
        }
      },
    );
  }

  void _confirmDeleteMission(BuildContext context, Mission mission) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ละทิ้งเทียบภารกิจ?'),
        content: Text('คุณต้องการลบเทียบ "${mission.title}" ออกจากสำนักหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
          ),
          WuxiaButton(
            text: 'ลบเทียบ',
            height: 36,
            style: WuxiaButtonStyle.crimson,
            onPressed: () {
              context.read<MissionProvider>().deleteMission(mission.id);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missionProvider = context.watch<MissionProvider>();
    final cultivationProvider = context.read<CultivationProvider>();
    final missions = missionProvider.filteredMissions;

    final Map<CultivationCategory, int> counts = {
      for (var cat in CultivationCategory.values)
        cat: missionProvider.countByCategory(cat),
    };

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'หอเทียบภารกิจสำนัก',
                              style: AppTextStyles.heading1.copyWith(
                                color: AppColors.goldLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'รับเทียบภารกิจเพื่อสะสมปราณ Qi และฝึกปรือสเตตัสวรยุทธ์',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        WuxiaButton(
                          text: isDesktop ? 'ออกเทียบภารกิจ' : 'ออกเทียบ',
                          icon: Icons.add_rounded,
                          style: WuxiaButtonStyle.gold,
                          onPressed: () => _openAddMissionDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search & Status Filter Row
                    Row(
                      children: [
                        // Search Box
                        Expanded(
                          child: TextField(
                            onChanged: (val) => missionProvider.setSearchQuery(val),
                            style: const TextStyle(fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: 'ค้นหาเทียบภารกิจสำนัก...',
                              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                              filled: true,
                              fillColor: AppColors.surfaceLight.withValues(alpha: 0.28),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.goldPrimary, width: 1.2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Status Filter (All, Pending, Done)
                        Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStatusSegment(
                                label: 'ทั้งหมด',
                                isSelected: missionProvider.statusFilter == MissionStatusFilter.all,
                                onTap: () => missionProvider.setStatusFilter(MissionStatusFilter.all),
                              ),
                              _buildStatusSegment(
                                label: 'ค้างอยู่ (${missionProvider.pendingCount})',
                                isSelected: missionProvider.statusFilter == MissionStatusFilter.pending,
                                onTap: () => missionProvider.setStatusFilter(MissionStatusFilter.pending),
                              ),
                              _buildStatusSegment(
                                label: 'สำเร็จแล้ว (${missionProvider.completedCount})',
                                isSelected: missionProvider.statusFilter == MissionStatusFilter.completed,
                                onTap: () => missionProvider.setStatusFilter(MissionStatusFilter.completed),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Category Tabs
                    CategoryTabBar(
                      selectedCategory: missionProvider.selectedCategory,
                      onCategorySelected: (cat) => missionProvider.setCategoryFilter(cat),
                      counts: counts,
                    ),
                    const SizedBox(height: 16),

                    // Missions List
                    Expanded(
                      child: missions.isEmpty
                          ? _buildEmptyState(context)
                          : ListView.separated(
                              itemCount: missions.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final mission = missions[index];
                                return MissionCard(
                                  mission: mission,
                                  onToggle: () async {
                                    final result = await missionProvider.toggleMission(
                                      mission.id,
                                      cultivationProvider,
                                    );
                                    if (result.wasCompleted) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(Icons.bolt_rounded, color: AppColors.goldLight),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'สำเร็จภารกิจ! ได้รับ +${result.gainedQi} Qi',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );

                                        if (result.hasBreakthrough && cultivationProvider.latestBreakthroughRealm != null) {
                                          final realm = cultivationProvider.latestBreakthroughRealm!;
                                          cultivationProvider.clearBreakthroughNotice();
                                          BreakthroughDialog.show(context, realm);
                                        }
                                      }
                                    }
                                  },
                                  onEdit: () => _openAddMissionDialog(context, missionToEdit: mission),
                                  onDelete: () => _confirmDeleteMission(context, mission),
                                );
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

  Widget _buildStatusSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF090B10) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight.withValues(alpha: 0.4),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Icon(
                Icons.history_edu_rounded,
                size: 36,
                color: AppColors.goldPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'กระดานเทียบภารกิจว่างเปล่า',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ออกเทียบภารกิจใหม่เพื่อเริ่มต้นฝึกปรือลมปราณ',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 18),
          WuxiaButton(
            text: 'ออกเทียบภารกิจแรก',
            icon: Icons.add_rounded,
            style: WuxiaButtonStyle.gold,
            onPressed: () => _openAddMissionDialog(context),
          ),
        ],
      ),
    );
  }
}
