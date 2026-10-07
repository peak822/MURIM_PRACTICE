import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// MurimPanel / WuxiaCard
/// An elegant martial arts panel with subtle corner filigree, layered ink gradient, and fine border.
class WuxiaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool hasGlow;
  final bool showCornerAccents;
  final double borderRadius;

  const WuxiaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderColor,
    this.backgroundColor,
    this.onTap,
    this.hasGlow = false,
    this.showCornerAccents = false,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.border;
    final bg = backgroundColor ?? AppColors.surfaceCard;

    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        gradient: backgroundColor == null ? AppColors.scrollCardGradient : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 1.0),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (borderColor ?? AppColors.goldPrimary).withValues(alpha: 0.12),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
                const BoxShadow(
                  color: Color(0x60000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x45000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Optional subtle Chinese traditional corner brackets
          if (showCornerAccents)
            Positioned.fill(
              child: CustomPaint(
                painter: _CornerBracketPainter(
                  color: (borderColor ?? AppColors.goldPrimary).withValues(alpha: 0.4),
                  bracketLength: 10,
                  strokeWidth: 1.2,
                ),
              ),
            ),
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.goldPrimary.withValues(alpha: 0.12),
          highlightColor: AppColors.goldPrimary.withValues(alpha: 0.05),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Custom painter for traditional Chinese corner brackets (ลายมุมกรอบคัมภีร์)
class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double bracketLength;
  final double strokeWidth;

  _CornerBracketPainter({
    required this.color,
    this.bracketLength = 10,
    this.strokeWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const offset = 4.0;
    final w = size.width;
    final h = size.height;

    // Top-Left
    canvas.drawLine(const Offset(offset, offset + 8), const Offset(offset, offset), paint);
    canvas.drawLine(const Offset(offset, offset), const Offset(offset + 8, offset), paint);

    // Top-Right
    canvas.drawLine(Offset(w - offset - 8, offset), Offset(w - offset, offset), paint);
    canvas.drawLine(Offset(w - offset, offset), Offset(w - offset, offset + 8), paint);

    // Bottom-Left
    canvas.drawLine(Offset(offset, h - offset - 8), Offset(offset, h - offset), paint);
    canvas.drawLine(Offset(offset, h - offset), Offset(offset + 8, h - offset), paint);

    // Bottom-Right
    canvas.drawLine(Offset(w - offset - 8, h - offset), Offset(w - offset, h - offset), paint);
    canvas.drawLine(Offset(w - offset, h - offset), Offset(w - offset, h - offset - 8), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
