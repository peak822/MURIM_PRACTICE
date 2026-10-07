import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:murim_app/core/constants/app_constants.dart';
import 'package:murim_app/core/services/backup_service.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/data/datasources/hive_storage_service.dart';
import 'package:murim_app/data/models/daoist_title.dart';
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
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: WuxiaCard(
              borderColor: AppColors.goldPrimary,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_pin_rounded, color: AppColors.goldLight, size: 22),
                      const SizedBox(width: 8),
                      Text('แก้ไขข้อมูลจอมยุทธ์', style: AppTextStyles.heading2),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    maxLength: 40,
                    decoration: const InputDecoration(
                      labelText: 'นามฉายาจอมยุทธ์',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.goldLight),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: sectController,
                    maxLength: 40,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อสำนัก / พรรค',
                      prefixIcon: Icon(Icons.shield_outlined, color: AppColors.jadeLight),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      const SizedBox(width: 12),
                      WuxiaButton(
                        text: 'บันทึกจารึก',
                        style: WuxiaButtonStyle.gold,
                        height: 42,
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTitlesDialog(BuildContext context) {
    final cultivation = context.read<CultivationProvider>();
    final stats = cultivation.stats;
    final allTitles = DaoistTitleRegistry.allTitles;

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: WuxiaCard(
              borderColor: AppColors.goldPrimary,
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: AppColors.goldLight, size: 24),
                      const SizedBox(width: 8),
                      Text('ฉายาจอมยุทธ์แห่งเต๋า', style: AppTextStyles.heading2),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ปลดล็อกตามวินัยและการบำเพ็ญเพียร เลือกสวมใส่เพื่อประดับหัวคัมภีร์',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: allTitles.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final title = allTitles[index];
                        final isUnlocked = title.isUnlocked(stats);
                        final isEquipped = stats.equippedTitleId == title.id;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isEquipped
                                ? AppColors.goldPrimary.withValues(alpha: 0.15)
                                : AppColors.surfaceLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isEquipped
                                  ? AppColors.goldPrimary
                                  : isUnlocked
                                      ? AppColors.border
                                      : AppColors.border.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isUnlocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
                                size: 20,
                                color: isEquipped
                                    ? AppColors.goldLight
                                    : isUnlocked
                                        ? AppColors.jadeLight
                                        : AppColors.textMuted,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          title.name,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.bold,
                                            color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                                          ),
                                        ),
                                        if (isEquipped) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.goldPrimary,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'สวมใส่อยู่',
                                              style: TextStyle(fontSize: 9.5, color: Color(0xFF090B10), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      title.description,
                                      style: TextStyle(fontSize: 11, color: isUnlocked ? AppColors.textSecondary : AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              if (isUnlocked)
                                WuxiaButton(
                                  text: isEquipped ? 'ปลดออก' : 'สวมใส่',
                                  height: 32,
                                  style: isEquipped ? WuxiaButtonStyle.outline : WuxiaButtonStyle.gold,
                                  onPressed: () {
                                    cultivation.equipTitle(isEquipped ? null : title.id);
                                    Navigator.pop(ctx);
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('ปิด', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    final storage = HiveStorageService();
    final jsonString = BackupService.exportStorageToJson(storage);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: WuxiaCard(
            borderColor: AppColors.goldPrimary,
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_download_outlined, color: AppColors.goldLight, size: 24),
                    const SizedBox(width: 8),
                    Text('ส่งออกข้อมูลคัมภีร์ (JSON Export)', style: AppTextStyles.heading2),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'คัดลอกข้อความ JSON ด้านล่างนี้เพื่อนำไปเก็บรักษาหรือกู้คืนในเครื่องอื่น',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07090F),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      jsonString,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('ปิด', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 10),
                    WuxiaButton(
                      text: 'คัดลอก JSON',
                      icon: Icons.copy_rounded,
                      style: WuxiaButtonStyle.gold,
                      height: 38,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: jsonString));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('คัดลอกข้อมูลสำรองลงคลิปบอร์ดแล้ว')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: WuxiaCard(
            borderColor: AppColors.qiPrimary,
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, color: AppColors.qiLight, size: 24),
                    const SizedBox(width: 8),
                    Text('กู้คืนข้อมูลคัมภีร์ (JSON Restore)', style: AppTextStyles.heading2),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'วางข้อความ JSON สำรองเพื่อกู้คืนสเตตัส ภารกิจ และประวัติทั้งหมด',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  maxLines: 7,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'วางโค้ด JSON สำรองที่นี่...',
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    fillColor: const Color(0xFF07090F),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 10),
                    WuxiaButton(
                      text: 'ยืนยันการกู้คืน',
                      style: WuxiaButtonStyle.jade,
                      height: 38,
                      onPressed: () async {
                        final rawText = controller.text.trim();
                        final storage = HiveStorageService();
                        final messenger = ScaffoldMessenger.of(context);
                        final cultivation = context.read<CultivationProvider>();
                        final missionProvider = context.read<MissionProvider>();
                        final nav = Navigator.of(ctx);

                        final success = await BackupService.restoreJsonToStorage(
                          storage: storage,
                          jsonString: rawText,
                        );

                        if (success) {
                          await cultivation.loadStats();
                          await missionProvider.loadMissions();
                          nav.pop();
                          messenger.showSnackBar(
                            const SnackBar(content: Text('กู้คืนข้อมูลสำเร็จเรียบร้อยแล้ว')),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('กู้คืนไม่สำเร็จ: โครงสร้าง JSON ไม่ถูกต้องหรือเสียหาย'),
                              backgroundColor: AppColors.crimsonPrimary,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: WuxiaCard(
            borderColor: AppColors.crimsonPrimary,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.crimsonLight, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'รีเซ็ตข้อมูลการบำเพ็ญทั้งหมด?',
                      style: AppTextStyles.heading2.copyWith(color: AppColors.crimsonLight),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'การดำเนินการนี้จะลบภารกิจทั้งหมด สเตตัสวรยุทธ์ และบันทึกประวัติการบำเพ็ญกลับสู่จุดเริ่มต้น ไม่สามารถกู้คืนได้',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    WuxiaButton(
                      text: 'ยืนยันการรีเซ็ต',
                      height: 40,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cultivation = context.watch<CultivationProvider>();
    final settings = context.watch<SettingsProvider>();
    final equippedTitle = DaoistTitleRegistry.getTitleById(cultivation.stats.equippedTitleId);

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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.goldPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.settings_suggest_rounded, color: AppColors.goldLight, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'การตั้งค่าและข้อมูลสำนัก (Settings)',
                                style: AppTextStyles.heading1.copyWith(
                                  color: AppColors.goldLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'จัดการข้อมูลจอมยุทธ์ การตอบสนองระบบ และการดูแลรักษาข้อมูล',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Profile Card (Sect Identity Tablet)
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shield_rounded, color: AppColors.goldPrimary, size: 20),
                                  const SizedBox(width: 8),
                                  Text('ข้อมูลจารึกผู้ฝึกตน', style: AppTextStyles.heading3),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.goldLight, size: 20),
                                tooltip: 'แก้ไขข้อมูล',
                                onPressed: () => _showEditProfileDialog(context),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.goldPrimary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_pin_rounded, color: AppColors.goldPrimary, size: 22),
                            ),
                            title: const Text('นามฉายาจอมยุทธ์', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                            subtitle: Text(
                              cultivation.stats.userName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.qiPrimary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.castle_rounded, color: AppColors.qiLight, size: 22),
                            ),
                            title: const Text('สังกัดพรรค / สำนัก', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                            subtitle: Text(
                              cultivation.stats.sectName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.goldPrimary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.workspace_premium_rounded, color: AppColors.goldLight, size: 22),
                            ),
                            title: const Text('ฉายาจอมยุทธ์ที่สวมใส่', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                            subtitle: Text(
                              equippedTitle?.name ?? 'ยังไม่ได้เลือกสวมใส่',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: equippedTitle != null ? AppColors.goldLight : AppColors.textMuted,
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () => _showTitlesDialog(context),
                              child: const Text('เปลี่ยนฉายา', style: TextStyle(color: AppColors.goldLight, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Backup & Restore Card
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.cloud_sync_rounded, color: AppColors.goldPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text('สำรองและกู้คืนม้วนคัมภีร์ (Backup & Restore)', style: AppTextStyles.heading3),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ส่งออกและนำเข้าข้อมูลการบำเพ็ญทั้งหมดในรูปแบบไฟล์ JSON ออฟไลน์',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const Divider(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: WuxiaButton(
                                  text: 'ส่งออกข้อมูล (Export)',
                                  icon: Icons.file_download_outlined,
                                  style: WuxiaButtonStyle.gold,
                                  height: 40,
                                  onPressed: () => _showExportDialog(context),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: WuxiaButton(
                                  text: 'กู้คืนข้อมูล (Restore)',
                                  icon: Icons.file_upload_outlined,
                                  style: WuxiaButtonStyle.jade,
                                  height: 40,
                                  onPressed: () => _showImportDialog(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // App Preferences
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.tune_rounded, color: AppColors.goldPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text('การตั้งค่าระบบ (Preferences)', style: AppTextStyles.heading3),
                            ],
                          ),
                          const Divider(height: 16),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.volume_up_rounded, color: AppColors.goldLight),
                            title: const Text('เสียงเอฟเฟกต์การทะลวงด่าน'),
                            subtitle: const Text('เล่นเสียงเมื่อทำภารกิจสำเร็จหรือเลื่อนขั้นขอบเขต', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            value: settings.soundEnabled,
                            activeTrackColor: AppColors.goldPrimary,
                            onChanged: (val) => settings.toggleSound(val),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.vibration_rounded, color: AppColors.jadeLight),
                            title: const Text('การสั่นเตือน Haptic Feedback'),
                            subtitle: const Text('สั่นตอบสนองเมื่อกดปุ่มและเช็กภารกิจ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            value: settings.hapticEnabled,
                            activeTrackColor: AppColors.jadePrimary,
                            onChanged: (val) => settings.toggleHaptic(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // About App / Portfolio Info
                    WuxiaCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.menu_book_rounded, color: AppColors.goldPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text('เกี่ยวกับโครงการ (Project Info)', style: AppTextStyles.heading3),
                            ],
                          ),
                          const Divider(height: 16),
                          _buildInfoRow('แอปพลิเคชัน', AppConstants.appName),
                          _buildInfoRow('แนวคิดหลัก', 'Gamified Study & Habit Tracker ในธีมกำลังภายใน (Murim Wuxia)'),
                          _buildInfoRow('สถาปัตยกรรม', 'Flutter + Provider + Hive (Offline-First Local Storage)'),
                          _buildInfoRow('กราฟยันต์แปดทิศ', 'Reactive Radar Chart (fl_chart) อัปเดตแบบเรียลไทม์'),
                          _buildInfoRow('การรองรับ', 'Android Mobile & Windows Desktop Cross-Platform'),
                          _buildInfoRow('เวอร์ชันระบบ', AppConstants.appVersion),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Danger Zone
                    WuxiaCard(
                      borderColor: AppColors.crimsonPrimary.withValues(alpha: 0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.gavel_rounded, color: AppColors.crimsonLight, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'จัดการข้อมูลความปลอดภัย (Danger Zone)',
                                style: AppTextStyles.heading3.copyWith(color: AppColors.crimsonLight),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ข้อมูลทั้งหมดถูกจัดเก็บไว้ในฐานข้อมูลเครื่องของคุณแบบ Offline-first',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
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
            width: 140,
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
