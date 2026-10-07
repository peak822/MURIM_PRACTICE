import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/body_cultivation_models.dart';
import '../../../widgets/wuxia_button.dart';
import '../../../widgets/wuxia_card.dart';

class SessionSummaryDialog extends StatefulWidget {
  final TrainingRecord record;
  final VoidCallback onDismiss;

  const SessionSummaryDialog({
    super.key,
    required this.record,
    required this.onDismiss,
  });

  @override
  State<SessionSummaryDialog> createState() => _SessionSummaryDialogState();
}

class _SessionSummaryDialogState extends State<SessionSummaryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.goldPrimary.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldPrimary.withValues(alpha: 0.25),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Banner with Seal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.crimsonPrimary.withValues(alpha: 0.35),
                      AppColors.surfaceElevated,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.crimsonPrimary.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.goldPrimary,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: AppColors.goldLight,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'สำเร็จการฝึกฝนกายา!',
                      style: TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.record.sessionTitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Rewards Grid
                    Row(
                      children: [
                        Expanded(
                          child: WuxiaCard(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                            borderColor: AppColors.categoryBody.withValues(alpha: 0.5),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.whatshot, color: AppColors.crimsonLight, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      'พลังกายา (Body XP)',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '+${widget.record.earnedBodyXp}',
                                  style: const TextStyle(
                                    color: AppColors.crimsonLight,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: WuxiaCard(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                            borderColor: AppColors.qiPrimary.withValues(alpha: 0.5),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome, color: AppColors.qiLight, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      'ลมปราณ (Qi)',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '+${widget.record.earnedQi}',
                                  style: const TextStyle(
                                    color: AppColors.qiLight,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Metrics
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric(
                            icon: Icons.timer_outlined,
                            label: 'เวลาฝึกฝน',
                            value: '${widget.record.durationMinutes} นาที',
                          ),
                          Container(
                            height: 28,
                            width: 1,
                            color: AppColors.border,
                          ),
                          _buildMetric(
                            icon: Icons.check_circle_outline,
                            label: 'เซ็ตที่สำเร็จ',
                            value: '${widget.record.totalSetsCompleted} เซ็ต',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quote / Lore
                    const Text(
                      '“กายาที่แข็งแกร่งดั่งภูผา คือภาชนะรองรับลมปราณอันไร้ที่สิ้นสุด”',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGold,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Finish Action Button
                    WuxiaButton(
                      text: 'น้อมรับพลังปราณและปิดด่าน',
                      icon: Icons.done_all,
                      isFullWidth: true,
                      onPressed: widget.onDismiss,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
