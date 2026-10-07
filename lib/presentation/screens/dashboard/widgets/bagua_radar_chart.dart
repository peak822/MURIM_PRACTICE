import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:murim_app/core/theme/app_colors.dart';
import 'package:murim_app/core/theme/app_text_styles.dart';

class BaguaRadarChart extends StatelessWidget {
  final Map<String, double> attributes; // {'พลังกาย': 65, 'สติปัญญา': 80, ...}
  final Color primaryColor;

  const BaguaRadarChart({
    super.key,
    required this.attributes,
    this.primaryColor = AppColors.goldPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final keys = attributes.keys.toList();
    final values = attributes.values.toList();

    return AspectRatio(
      aspectRatio: 1.15,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Bagua / Yin-Yang & Trigrams Motif
          CustomPaint(
            size: const Size(260, 260),
            painter: _BaguaBackgroundPainter(primaryColor: primaryColor),
          ),

          // Reactive Radar Chart
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                radarBorderData: BorderSide(
                  color: primaryColor.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                gridBorderData: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 1,
                ),
                tickBorderData: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 0.8,
                ),
                tickCount: 4,
                ticksTextStyle: const TextStyle(
                  color: Colors.transparent, // Clean look
                  fontSize: 10,
                ),
                dataSets: [
                  // 100% Scale Reference Boundary (invisible) so the chart always scales from 0 to 100
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    entryRadius: 0,
                    dataEntries: List.generate(
                      keys.length,
                      (_) => const RadarEntry(value: 100),
                    ),
                  ),
                  RadarDataSet(
                    fillColor: primaryColor.withValues(alpha: 0.25),
                    borderColor: primaryColor,
                    borderWidth: 2.2,
                    entryRadius: 4.5,
                    dataEntries: values.map((val) => RadarEntry(value: val)).toList(),
                  ),
                ],
                getTitle: (index, angle) {
                  if (index >= 0 && index < keys.length) {
                    final key = keys[index];
                    final val = values[index].toInt();
                    return RadarChartTitle(
                      text: '$key\n$val',
                      angle: 0,
                    );
                  }
                  return const RadarChartTitle(text: '');
                },
                titleTextStyle: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGold,
                  height: 1.1,
                ),
                titlePositionPercentageOffset: 0.22,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for background Bagua martial geometry
class _BaguaBackgroundPainter extends CustomPainter {
  final Color primaryColor;

  _BaguaBackgroundPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = AppColors.surfaceLight.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.9, paintCircle);

    // Outer octagonal / hexagonal guide lines
    final paintLine = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final x = center.dx + (radius * 0.88) * math.cos(angle);
      final y = center.dy + (radius * 0.88) * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), paintLine);
    }

    // Inner subtle center core
    final paintCore = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.25, paintCore);
  }

  @override
  bool shouldRepaint(covariant _BaguaBackgroundPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }
}
