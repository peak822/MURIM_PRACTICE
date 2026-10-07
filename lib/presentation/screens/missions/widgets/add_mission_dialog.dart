import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';
import 'package:murim_app/core/utils/cultivation_calculator.dart';
import 'package:murim_app/data/models/cultivation_category.dart';
import 'package:murim_app/data/models/mission_model.dart';
import 'package:murim_app/presentation/widgets/wuxia_button.dart';

class AddMissionDialog extends StatefulWidget {
  final Mission? initialMission;
  final Function({
    required String title,
    required String description,
    required CultivationCategory category,
    required int difficulty,
    required int estimatedMinutes,
    required bool isDaily,
  }) onSave;

  const AddMissionDialog({
    super.key,
    this.initialMission,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    Mission? initialMission,
    required Function({
      required String title,
      required String description,
      required CultivationCategory category,
      required int difficulty,
      required int estimatedMinutes,
      required bool isDaily,
    }) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AddMissionDialog(
        initialMission: initialMission,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddMissionDialog> createState() => _AddMissionDialogState();
}

class _AddMissionDialogState extends State<AddMissionDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late CultivationCategory _selectedCategory;
  late int _selectedDifficulty;
  late int _estimatedMinutes;
  late bool _isDaily;

  @override
  void initState() {
    super.initState();
    final mission = widget.initialMission;
    _titleController = TextEditingController(text: mission?.title ?? '');
    _descController = TextEditingController(text: mission?.description ?? '');
    _selectedCategory = mission?.category ?? CultivationCategory.mind;
    _selectedDifficulty = mission?.difficulty ?? 1;
    _estimatedMinutes = mission?.estimatedMinutes ?? 25;
    _isDaily = mission?.isDaily ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  int get _calculatedQiPreview => CultivationCalculator.calculateMissionXp(
        difficulty: _selectedDifficulty,
        estimatedMinutes: _estimatedMinutes,
        isDaily: _isDaily,
      );

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialMission != null;

    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.goldDark, width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.goldPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'แก้ไขเทียบภารกิจ' : 'เทียบเชิญภารกิจใหม่ (New Mission)',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Title Input
              TextField(
                controller: _titleController,
                maxLength: 80,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'ชื่อภารกิจฝึกตน *',
                  hintText: 'เช่น อ่านตำรา AI 1 บท หรือ วิดพื้น 30 ครั้ง',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  filled: true,
                  counterStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  fillColor: AppColors.surfaceLight.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Description Input
              TextField(
                controller: _descController,
                maxLength: 200,
                maxLines: 2,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'คำอธิบาย / เคล็ดวิชา (ทางเลือก)',
                  hintText: 'บันทึกเป้าหมายหรือรายละเอียดเพิ่มเติม...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  filled: true,
                  counterStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  fillColor: AppColors.surfaceLight.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Category Selector
              Text('สายวิชาการฝึกฝน', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CultivationCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                        const SizedBox(width: 6),
                        Text(cat.thaiTitle),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: cat.color,
                    backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.4),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? cat.color : AppColors.border,
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Difficulty Level
              Text('ระดับความท้าทาย', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [1, 2, 3, 4].map((diff) {
                  final isSelected = _selectedDifficulty == diff;
                  String label;
                  switch (diff) {
                    case 1:
                      label = 'ต่ำ (Lv.1)';
                      break;
                    case 2:
                      label = 'กลาง (Lv.2)';
                      break;
                    case 3:
                      label = 'สูง (Lv.3)';
                      break;
                    case 4:
                      label = 'เซียน (Lv.4)';
                      break;
                    default:
                      label = '';
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => setState(() => _selectedDifficulty = diff),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.goldPrimary.withValues(alpha: 0.25)
                                : AppColors.surfaceLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.goldPrimary : AppColors.border,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.goldLight : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Duration Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('เวลาที่คาดว่าจะใช้', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    '$_estimatedMinutes นาที',
                    style: const TextStyle(
                      color: AppColors.qiLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _estimatedMinutes.toDouble(),
                min: 5,
                max: 180,
                divisions: 35,
                activeColor: AppColors.qiPrimary,
                inactiveColor: AppColors.surfaceLight,
                onChanged: (val) {
                  setState(() => _estimatedMinutes = val.toInt());
                },
              ),

              // Daily Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'ภารกิจประจำวัน (ทำซ้ำได้ทุกวัน)',
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
                value: _isDaily,
                activeColor: AppColors.goldPrimary,
                checkColor: Colors.black,
                onChanged: (val) {
                  setState(() => _isDaily = val ?? false);
                },
              ),

              const SizedBox(height: 12),

              // Qi Reward Preview Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.goldPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.goldPrimary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'พลังปราณที่จะได้รับเมื่อสำเร็จ:',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGold),
                        ),
                      ],
                    ),
                    Text(
                      '+$_calculatedQiPreview Qi',
                      style: AppTextStyles.qiCounter.copyWith(
                        fontSize: 16,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  WuxiaButton(
                    text: isEditing ? 'บันทึกการแก้ไข' : 'สร้างเทียบภารกิจ',
                    icon: Icons.check_rounded,
                    style: WuxiaButtonStyle.gold,
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('กรุณาระบุชื่อภารกิจ')),
                        );
                        return;
                      }

                      widget.onSave(
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        category: _selectedCategory,
                        difficulty: _selectedDifficulty,
                        estimatedMinutes: _estimatedMinutes,
                        isDaily: _isDaily,
                      );

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
