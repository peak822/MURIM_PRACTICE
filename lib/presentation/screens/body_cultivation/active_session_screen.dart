import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/body_cultivation_models.dart';
import '../../providers/body_cultivation_provider.dart';
import '../../providers/cultivation_provider.dart';
import '../../widgets/wuxia_button.dart';
import '../../widgets/wuxia_card.dart';
import 'widgets/session_summary_dialog.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BodyCultivationProvider, CultivationProvider>(
      builder: (context, bodyProvider, cultProvider, _) {
        if (!bodyProvider.isSessionActive) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              title: const Text('โหมดบ่มเพาะกาย'),
            ),
            body: const Center(
              child: Text(
                'ไม่มีการฝึกฝนที่กำลังดำเนินอยู่',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final exercise = bodyProvider.currentExercise;
        final currentSet = bodyProvider.completedSetsInCurrentExercise + 1;
        final totalSets = exercise.defaultSets;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldLeave = await _showExitConfirmDialog(context, bodyProvider);
            if (shouldLeave == true && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () async {
                  final shouldLeave = await _showExitConfirmDialog(context, bodyProvider);
                  if (shouldLeave == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bodyProvider.currentTemplate?.murimTitle ?? 'การบ่มเพาะกายา',
                    style: const TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ท่าที่ ${bodyProvider.currentExerciseIndex + 1} จาก ${bodyProvider.sessionExercises.length}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.qiLight, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(bodyProvider.sessionDurationSeconds),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: bodyProvider.overallSessionProgress,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldPrimary),
                  minHeight: 4,
                ),
              ),
            ),
            body: bodyProvider.isResting
                ? _buildRestTimerView(context, bodyProvider)
                : _buildActiveExerciseView(context, bodyProvider, exercise, currentSet, totalSets, cultProvider),
          ),
        );
      },
    );
  }

  Widget _buildRestTimerView(BuildContext context, BodyCultivationProvider provider) {
    final nextExerciseName = provider.currentExercise.murimName;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.qiPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.qiPrimary.withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.air, color: AppColors.qiLight, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'พักฟื้นฟูลมปราณ (Rest & Breathe)',
                    style: TextStyle(
                      color: AppColors.qiLight,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Big Circular Countdown Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: provider.maxRestTime > 0
                        ? provider.restTimeRemaining / provider.maxRestTime
                        : 0.0,
                    strokeWidth: 10,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.qiLight),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${provider.restTimeRemaining}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'วินาที',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Breathing Guidance
            const Text(
              '“หายใจเข้าลึกทางจมูก... ผ่อนออกช้าๆ ทางปาก ปรับสมดุลชีพจร”',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGold,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 28),

            // Next Exercise Sneak Peek
            WuxiaCard(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              borderColor: AppColors.borderGold.withValues(alpha: 0.3),
              child: Row(
                children: [
                  const Icon(Icons.fitness_center, color: AppColors.goldLight, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ท่าต่อไป / เซ็ตถัดไป:',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          nextExerciseName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Adjust Rest Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => provider.adjustRestTime(-15),
                  icon: const Icon(Icons.remove, size: 16),
                  label: const Text('-15 วิ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => provider.adjustRestTime(15),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('+15 วิ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Skip Rest
            WuxiaButton(
              text: 'ข้ามเวลาพัก (พร้อมฝึกต่อ)',
              icon: Icons.play_arrow_rounded,
              isFullWidth: true,
              onPressed: () => provider.skipRest(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveExerciseView(
    BuildContext context,
    BodyCultivationProvider provider,
    Exercise exercise,
    int currentSet,
    int totalSets,
    CultivationProvider cultProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Exercise Name & Tags Card
          WuxiaCard(
            borderColor: AppColors.goldPrimary.withValues(alpha: 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.crimsonPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
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
                const SizedBox(height: 12),
                Text(
                  exercise.murimName,
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // Target Muscles Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exercise.targetMuscles.map((muscle) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '#$muscle',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Variation Switchers
                if (exercise.easierVariationId != null || exercise.harderVariationId != null) ...[
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (exercise.easierVariationId != null)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              final success = provider.switchToEasierVariation();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('สลับเป็นท่าง่ายลงเรียบร้อย'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_downward, color: AppColors.qiLight, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'ปรับเป็นท่าง่ายลง',
                                    style: TextStyle(
                                      color: AppColors.qiLight,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (exercise.easierVariationId != null && exercise.harderVariationId != null)
                        const SizedBox(width: 8),
                      if (exercise.harderVariationId != null)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              final success = provider.switchToHarderVariation();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('สลับเป็นท่ายากขึ้นเรียบร้อย'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_upward, color: AppColors.crimsonLight, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'ปรับเป็นท่ายากขึ้น',
                                    style: TextStyle(
                                      color: AppColors.crimsonLight,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Target Hub (Reps or Timed)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surfaceElevated, AppColors.surfaceCard],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                // Set Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.repeat_rounded, color: AppColors.goldPrimary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'เซ็ตที่ $currentSet จาก $totalSets เซ็ต',
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Reps / Duration Target
                if (exercise.defaultDurationSeconds > 0) ...[
                  // Timed Exercise
                  Text(
                    provider.isTimedExerciseRunning
                        ? '${provider.timedExerciseRemaining} วิ'
                        : '${exercise.defaultDurationSeconds} วินาที',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => provider.startTimedExercise(),
                    icon: Icon(
                      provider.isTimedExerciseRunning ? Icons.pause : Icons.play_arrow,
                      color: AppColors.qiLight,
                    ),
                    label: Text(
                      provider.isTimedExerciseRunning ? 'กำลังจับเวลา' : 'เริ่มนับเวลาค้างท่า',
                      style: const TextStyle(color: AppColors.qiLight),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.qiPrimary),
                    ),
                  ),
                ] else ...[
                  // Rep-based Exercise
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${exercise.defaultReps}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'ครั้ง',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // Complete Set Button
                WuxiaButton(
                  text: currentSet >= totalSets &&
                          provider.currentExerciseIndex >= provider.sessionExercises.length - 1
                      ? 'สำเร็จการฝึกฝนทั้งรูทีน!'
                      : 'สำเร็จเซ็ตที่ $currentSet (เข้าสู่การพัก)',
                  icon: Icons.check_circle_rounded,
                  isFullWidth: true,
                  onPressed: () async {
                    final isLastSetOfSession = currentSet >= totalSets &&
                        provider.currentExerciseIndex >= provider.sessionExercises.length - 1;

                    provider.completeSet();

                    if (isLastSetOfSession) {
                      await _finishAndShowSummary(context, provider, cultProvider);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Step Instructions & Cues
          _buildInstructionCard(
            title: 'ท่วงท่าและวิธีปฏิบัติ',
            icon: Icons.directions_run_rounded,
            color: AppColors.goldLight,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCueItem('ท่าเริ่มต้น:', exercise.startingPosition),
                const SizedBox(height: 8),
                _buildCueItem('การเคลื่อนไหว:', exercise.movementInstruction),
                const SizedBox(height: 8),
                _buildCueItem('การควบคุมลมหายใจ:', exercise.breathingInstruction),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Safety Notes Card
          if (exercise.safetyNotes.isNotEmpty)
            _buildInstructionCard(
              title: 'ข้อควรระวังเพื่อความปลอดภัย',
              icon: Icons.health_and_safety_outlined,
              color: AppColors.crimsonLight,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercise.safetyNotes
                    .map((note) => Padding(
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
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 20),

          // Navigation Bar for Exercises
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: provider.currentExerciseIndex > 0 ? () => provider.previousExercise() : null,
                icon: const Icon(Icons.chevron_left, size: 20),
                label: const Text('ท่าก่อนหน้า'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await _finishAndShowSummary(context, provider, cultProvider);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.goldPrimary,
                  side: const BorderSide(color: AppColors.goldPrimary),
                ),
                child: const Text('จบลำดับการฝึก'),
              ),
              TextButton.icon(
                onPressed: provider.currentExerciseIndex < provider.sessionExercises.length - 1
                    ? () => provider.nextExercise()
                    : null,
                icon: const Icon(Icons.chevron_right, size: 20),
                label: const Text('ท่าถัดไป'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInstructionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return WuxiaCard(
      padding: const EdgeInsets.all(14),
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _buildCueItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.goldLight,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Future<void> _finishAndShowSummary(
    BuildContext context,
    BodyCultivationProvider bodyProvider,
    CultivationProvider cultProvider,
  ) async {
    final record = await bodyProvider.finishSession();
    if (record == null) return;

    // Credit stats in CultivationProvider
    await cultProvider.recordBodyTrainingSession(
      earnedQi: record.earnedQi,
      earnedBodyXp: record.earnedBodyXp,
    );

    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => SessionSummaryDialog(
          record: record,
          onDismiss: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  Future<bool?> _showExitConfirmDialog(BuildContext context, BodyCultivationProvider provider) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text(
          'ยุติการฝึกฝนกายาก่อนกำหนด?',
          style: TextStyle(color: AppColors.goldLight, fontSize: 16),
        ),
        content: const Text(
          'ความก้าวหน้าในรอบนี้จะไม่ถูกบันทึก ท่านแน่ใจหรือไม่ที่จะออกจากด่านฝึกฝน?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('ฝึกฝนต่อ', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.cancelSession();
              Navigator.of(ctx).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimsonPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('ยืนยันออกจากด่าน'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
