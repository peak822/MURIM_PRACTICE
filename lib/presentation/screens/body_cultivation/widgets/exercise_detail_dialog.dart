import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/body_cultivation_models.dart';
import '../../../../data/datasources/exercise_database.dart';
import '../../../widgets/wuxia_button.dart';
import '../../../widgets/wuxia_card.dart';

class ExerciseDetailDialog extends StatelessWidget {
  final Exercise exercise;
  final void Function(Exercise exercise)? onStartTraining;

  const ExerciseDetailDialog({
    super.key,
    required this.exercise,
    this.onStartTraining,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.goldPrimary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                border: const Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.crimsonPrimary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.crimsonPrimary.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                exercise.category.thaiLabel,
                                style: const TextStyle(
                                  color: AppColors.crimsonLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                exercise.difficulty.thaiLabel,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          exercise.murimName,
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats (Sets, Reps, Rest, Equipment)
                    Row(
                      children: [
                        _buildQuickStat(
                          icon: Icons.repeat,
                          label: 'แนะนำ',
                          value: '${exercise.defaultSets} เซ็ต',
                        ),
                        const SizedBox(width: 8),
                        _buildQuickStat(
                          icon: Icons.fitness_center,
                          label: 'จำนวน',
                          value: exercise.defaultDurationSeconds > 0
                              ? '${exercise.defaultDurationSeconds} วิ'
                              : '${exercise.defaultReps} ครั้ง',
                        ),
                        const SizedBox(width: 8),
                        _buildQuickStat(
                          icon: Icons.timer_outlined,
                          label: 'เวลาพัก',
                          value: '${exercise.defaultRestSeconds} วิ',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Equipment Needed
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.build_outlined, color: AppColors.textGold, size: 16),
                          const SizedBox(width: 8),
                          const Text(
                            'อุปกรณ์ที่ใช้: ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              exercise.equipment,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Target Muscles
                    const Text(
                      'กล้ามเนื้อมัดเป้าหมาย (Target Muscles)',
                      style: TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: exercise.targetMuscles.map((muscle) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '#$muscle',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Instructions
                    _buildSection(
                      title: '1. ท่าเริ่มต้น (Starting Position)',
                      content: exercise.startingPosition,
                      icon: Icons.accessibility_new_rounded,
                      color: AppColors.qiLight,
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: '2. วิธีปฏิบัติและการเคลื่อนไหว (Movement)',
                      content: exercise.movementInstruction,
                      icon: Icons.directions_run_rounded,
                      color: AppColors.goldLight,
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: '3. การกำหนดลมหายใจ (Breathing Guidance)',
                      content: exercise.breathingInstruction,
                      icon: Icons.air_rounded,
                      color: AppColors.jadeLight,
                    ),
                    const SizedBox(height: 16),

                    // Safety Notes Alert
                    if (exercise.safetyNotes.isNotEmpty) ...[
                      WuxiaCard(
                        padding: const EdgeInsets.all(12),
                        borderColor: AppColors.crimsonPrimary.withValues(alpha: 0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.security, color: AppColors.crimsonLight, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'ข้อควรระวังเพื่อความปลอดภัย (Safety Tips)',
                                  style: TextStyle(
                                    color: AppColors.crimsonLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...exercise.safetyNotes.map((note) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppColors.crimsonLight)),
                                      Expanded(
                                        child: Text(
                                          note,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Common Mistakes
                    if (exercise.commonMistakes.isNotEmpty) ...[
                      WuxiaCard(
                        padding: const EdgeInsets.all(12),
                        borderColor: AppColors.mindPrimary.withValues(alpha: 0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColors.mindLight, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'ข้อผิดพลาดที่พบบ่อย (Common Mistakes)',
                                  style: TextStyle(
                                    color: AppColors.mindLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...exercise.commonMistakes.map((mistake) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppColors.mindLight)),
                                      Expanded(
                                        child: Text(
                                          mistake,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Variation Connections
                    if (exercise.easierVariationId != null || exercise.harderVariationId != null) ...[
                      const Text(
                        'สายการพัฒนาท่วงท่า (Progression & Regression)',
                        style: TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (exercise.easierVariationId != null)
                            Expanded(
                              child: _buildVariationButton(
                                context,
                                variationId: exercise.easierVariationId!,
                                isEasier: true,
                              ),
                            ),
                          if (exercise.easierVariationId != null && exercise.harderVariationId != null)
                            const SizedBox(width: 8),
                          if (exercise.harderVariationId != null)
                            Expanded(
                              child: _buildVariationButton(
                                context,
                                variationId: exercise.harderVariationId!,
                                isEasier: false,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(16),
              child: WuxiaButton(
                text: 'เริ่มฝึกฝนท่านี้ทันที',
                icon: Icons.play_arrow_rounded,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onStartTraining?.call(exercise);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 12),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 21),
          child: Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariationButton(
    BuildContext context, {
    required String variationId,
    required bool isEasier,
  }) {
    final target = ExerciseDatabase.defaultExercises.firstWhere(
      (e) => e.id == variationId,
      orElse: () => exercise,
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (ctx) => ExerciseDetailDialog(
            exercise: target,
            onStartTraining: onStartTraining,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEasier ? AppColors.qiPrimary.withValues(alpha: 0.5) : AppColors.crimsonPrimary.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEasier ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isEasier ? AppColors.qiLight : AppColors.crimsonLight,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  isEasier ? 'ท่าง่ายลง (Regression)' : 'ท่ายากขึ้น (Progression)',
                  style: TextStyle(
                    color: isEasier ? AppColors.qiLight : AppColors.crimsonLight,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              target.murimName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
