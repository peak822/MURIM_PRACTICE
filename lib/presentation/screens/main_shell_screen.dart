import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'chronicle/chronicle_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'meditation/meditation_screen.dart';
import 'missions/missions_screen.dart';
import 'settings/settings_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cultivation = context.watch<CultivationProvider>();
    final stats = cultivation.stats;
    final realm = stats.currentRealm;

    final screens = [
      DashboardScreen(
        onNavigateToMissions: () => _onTabSelected(1),
        onNavigateToMeditation: () => _onTabSelected(2),
      ),
      const MissionsScreen(),
      const MeditationScreen(),
      const ChronicleScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 850;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Row(
              children: [
                // Martial Yin-Yang / Dragon Jade Emblem
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldPrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    size: 18,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'MURIM TRACKER',
                  style: AppTextStyles.realmTitle.copyWith(
                    fontSize: 17,
                    letterSpacing: 1.5,
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: realm.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: realm.primaryColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      realm.fullThaiTitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: realm.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              // Qi Pill Counter
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGold),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldPrimary.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 16, color: AppColors.goldPrimary),
                    const SizedBox(width: 4),
                    Text(
                      '${stats.totalQi} Qi',
                      style: AppTextStyles.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak Flame
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.crimsonPrimary.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.goldPrimary),
                    const SizedBox(width: 4),
                    Text(
                      '${stats.currentStreak} วัน',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isDesktop
              ? Row(
                  children: [
                    // Desktop Navigation Rail with bamboo scroll tablet aesthetic
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: _onTabSelected,
                      labelType: NavigationRailLabelType.all,
                      minWidth: 92,
                      backgroundColor: AppColors.surface,
                      indicatorColor: AppColors.goldPrimary.withValues(alpha: 0.2),
                      selectedIconTheme: const IconThemeData(color: AppColors.goldLight, size: 24),
                      unselectedIconTheme: const IconThemeData(color: AppColors.textMuted, size: 22),
                      selectedLabelTextStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.goldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelTextStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'สำนักฝึกตน',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.goldLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard_outlined),
                          selectedIcon: Icon(Icons.dashboard_rounded),
                          label: Text('หอฝึกตน'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.checklist_outlined),
                          selectedIcon: Icon(Icons.checklist_rounded),
                          label: Text('เทียบภารกิจ'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.self_improvement_outlined),
                          selectedIcon: Icon(Icons.self_improvement_rounded),
                          label: Text('ปิดด่านสมาธิ'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.history_edu_outlined),
                          selectedIcon: Icon(Icons.history_edu_rounded),
                          label: Text('บันทึกคัมภีร์'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings_rounded),
                          label: Text('สำนัก/ตั้งค่า'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1, color: AppColors.divider),
                    // Main Screen Body with IndexedStack to preserve state across tab switching
                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex,
                        children: screens,
                      ),
                    ),
                  ],
                )
              : IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
          bottomNavigationBar: isDesktop
              ? null
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.borderGold.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: _onTabSelected,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: AppColors.surface,
                    selectedItemColor: AppColors.goldLight,
                    unselectedItemColor: AppColors.textMuted,
                    selectedFontSize: 11,
                    unselectedFontSize: 11,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard_rounded),
                        label: 'หอฝึกตน',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.checklist_rounded),
                        label: 'เทียบภารกิจ',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.self_improvement_rounded),
                        label: 'ปิดด่านสมาธิ',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history_edu_rounded),
                        label: 'บันทึกคัมภีร์',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings_rounded),
                        label: 'ตั้งค่า',
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
