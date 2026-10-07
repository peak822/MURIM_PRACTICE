import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// QiProgressBar / QiBar
/// Styled like a Cultivation Meridian Vessel (เส้นชีพจรลมปราณ) with fluid gradient & Qi node.
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
    this.height = 10,
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
                labelText ?? 'ชีพจรลมปราณสะสม (Qi)',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$currentQi ',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                    ),
                    TextSpan(
                      text: '/ $maxQi Qi  (${(clampedProgress * 100).toInt()}%)',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
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
            color: const Color(0xFF090C12),
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
                        color: fillGradient.colors.first.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 0.5,
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
