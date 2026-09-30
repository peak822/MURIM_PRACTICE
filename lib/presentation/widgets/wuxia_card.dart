import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WuxiaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool hasGlow;
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
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.border;
    final bg = backgroundColor ?? AppColors.surfaceCard;

    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 1.2),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (borderColor ?? AppColors.goldPrimary).withValues(alpha: 0.18),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.goldPrimary.withValues(alpha: 0.15),
          highlightColor: AppColors.goldPrimary.withValues(alpha: 0.08),
          child: content,
        ),
      );
    }

    return content;
  }
}
