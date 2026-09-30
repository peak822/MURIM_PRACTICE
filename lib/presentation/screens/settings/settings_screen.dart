import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/constants/app_constants.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/presentation/providers/cultivation_provider.dart';
import 'package:murim_app/presentation/providers/mission_provider.dart';
import 'package:murim_app/presentation/providers/settings_provider.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';
import 'package:murim_app/presentation/widgets/wuxia_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final cultivation = context.read<CultivationProvider>();
    final nameController = TextEditingController(text: cultivation.stats.userName);
    final sectController = TextEditingController(text: cultivation.stats.sectName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลจอมยุทธ์', style: AppTextStyles.heading2),
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

  void _confirmResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('รีเซ็ตข้อมูลการบำเพ็ญทั้งหมด?'),
        content: const Text(
          'การดำเนินการนี้จะลบภารกิจทั้งหมด สเตตัสวรยุทธ์ และบันทึกประวัติกลับสู่จุดเริ่มต้น',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
          ),
          WuxiaButton(
            text: 'ยืนยันการรีเซ็ต',
            height: 38,
            style: WuxiaButtonStyle.crimson,
            onPressed: () async {
              final cultivation = context.read<CultivationProvider>();
              final missionProvider = context.read<MissionProvider>();
              final messenger = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx);

              await cultivation.resetAllProgress();
              await missionProvider.loadMissions();
              
              nav.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('รีเซ็ตข้อมูลเริ่มต้นเรียบร้อยแล้ว')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cultivation = context.watch<CultivationProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'การตั้งค่าและข้อมูลสำนัก (Settings)',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'จัดการข้อมูลส่วนตัว ธีม และการสำรองข้อมูลในเครื่อง',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // Profile Card
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ข้อมูลผู้ฝึกตน', style: AppTextStyles.heading3),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.goldLight, size: 20),
                                onPressed: () => _showEditProfileDialog(context),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.person_pin_rounded, color: AppColors.goldPrimary),
                            title: const Text('ฉายาจอมยุทธ์', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            subtitle: Text(
                              cultivation.stats.userName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.castle_rounded, color: AppColors.qiLight),
                            title: const Text('สังกัดพรรค / สำนัก', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            subtitle: Text(
                              cultivation.stats.sectName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // App Preferences
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('การตั้งค่าระบบ (Preferences)', style: AppTextStyles.heading3),
                          const Divider(height: 16),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.volume_up_rounded, color: AppColors.goldLight),
                            title: const Text('เสียงเอฟเฟกต์การทะลวงด่าน'),
                            subtitle: const Text('เล่นเสียงเมื่อทำภารกิจสำเร็จหรือเลื่อนขั้นขอบเขต', style: TextStyle(fontSize: 12)),
                            value: settings.soundEnabled,
                            activeTrackColor: AppColors.goldPrimary,
                            onChanged: (val) => settings.toggleSound(val),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.vibration_rounded, color: AppColors.jadeLight),
                            title: const Text('การสั่นเตือน Haptic Feedback'),
                            subtitle: const Text('สั่นตอบสนองเมื่อกดปุ่มและเช็กภารกิจ', style: TextStyle(fontSize: 12)),
                            value: settings.hapticEnabled,
                            activeTrackColor: AppColors.jadePrimary,
                            onChanged: (val) => settings.toggleHaptic(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // About App / Portfolio Info
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('เกี่ยวกับโครงการ (Project Info)', style: AppTextStyles.heading3),
                          const Divider(height: 16),
                          _buildInfoRow('แอปพลิเคชัน', AppConstants.appName),
                          _buildInfoRow('แนวคิด', 'Gamified Habit & Study Tracker ในธีมกำลังภายใน (Wuxia)'),
                          _buildInfoRow('สถาปัตยกรรม', 'Flutter + Provider + Hive (Offline-First Local Storage)'),
                          _buildInfoRow('กราฟยันต์แปดทิศ', 'Reactive Radar Chart (fl_chart) อัปเดตแบบเรียลไทม์'),
                          _buildInfoRow('แพลตฟอร์มรองรับ', 'Windows Desktop & Mobile Cross-Platform'),
                          _buildInfoRow('เวอร์ชัน', AppConstants.appVersion),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Danger Zone
                    WuxiaCard(
                      borderColor: AppColors.crimsonPrimary.withValues(alpha: 0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'จัดการข้อมูลความปลอดภัย',
                            style: AppTextStyles.heading3.copyWith(color: AppColors.crimsonLight),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ข้อมูลทั้งหมดจะถูกบันทึกไว้ใน Local Storage ของอุปกรณ์เครื่องนี้',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 14),
                          WuxiaButton(
                            text: 'ล้างข้อมูลและเริ่มต้นใหม่',
                            icon: Icons.refresh_rounded,
                            style: WuxiaButtonStyle.crimson,
                            isFullWidth: true,
                            onPressed: () => _confirmResetData(context),
                          ),
                        ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
