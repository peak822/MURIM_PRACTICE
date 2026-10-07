import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum WuxiaButtonStyle {
  gold,     // Imperial Gold Plate
  jade,     // Mountain Jade Tablet
  qi,       // Spiritual Azure Plate
  crimson,  // Cinnabar Red Seal
  outline,  // Parchment / Bronze Border
  subtle,   // Quiet Slate Button
}

class WuxiaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final WuxiaButtonStyle style;
  final bool isFullWidth;
  final double height;
  final bool isLoading;

  const WuxiaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.style = WuxiaButtonStyle.gold,
    this.isFullWidth = false,
    this.height = 46,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    LinearGradient? gradient;
    Color textColor = Colors.black;
    Border? border;
    Color? backgroundColor;

    switch (style) {
      case WuxiaButtonStyle.gold:
        gradient = AppColors.goldGradient;
        textColor = const Color(0xFF090B10);
        break;
      case WuxiaButtonStyle.jade:
        gradient = AppColors.jadeGradient;
        textColor = Colors.white;
        break;
      case WuxiaButtonStyle.qi:
        gradient = AppColors.qiGradient;
        textColor = const Color(0xFF090B10);
        break;
      case WuxiaButtonStyle.crimson:
        gradient = AppColors.crimsonGradient;
        textColor = Colors.white;
        break;
      case WuxiaButtonStyle.outline:
        gradient = null;
        backgroundColor = Colors.transparent;
        textColor = AppColors.goldLight;
        border = Border.all(color: AppColors.goldDark, width: 1.2);
        break;
      case WuxiaButtonStyle.subtle:
        gradient = null;
        backgroundColor = AppColors.surfaceLight;
        textColor = AppColors.textSecondary;
        border = Border.all(color: AppColors.border, width: 1.0);
        break;
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: textColor,
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ],
    );

    return Container(
      height: height,
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
        border: border,
        boxShadow: onPressed != null && style != WuxiaButtonStyle.outline && style != WuxiaButtonStyle.subtle
            ? [
                BoxShadow(
                  color: (gradient?.colors.first ?? AppColors.goldPrimary).withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: content,
          ),
        ),
      ),
    );
  }
}
