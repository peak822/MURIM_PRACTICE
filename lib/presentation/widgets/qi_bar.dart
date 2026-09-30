import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class QiBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int currentQi;
  final int maxQi;
  final double height;
  final LinearGradient? gradient;
  final bool showLabels;
  final String? labelText;

  const QiBar({
    super.key,
    required this.progress,
    this.currentQi = 0,
    this.maxQi = 100,
    this.height = 12,
    this.gradient,
    this.showLabels = true,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final fillGradient = gradient ?? AppColors.goldGradient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelText ?? 'ความก้าวหน้าลมปราณ',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$currentQi / $maxQi Qi (${(clampedProgress * 100).toInt()}%)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1D),
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Stack(
            children: [
              // Progress Fill
              FractionallySizedBox(
                widthFactor: clampedProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: fillGradient,
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: fillGradient.colors.first.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
