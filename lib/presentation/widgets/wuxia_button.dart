import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum WuxiaButtonStyle {
  gold,
  jade,
  qi,
  crimson,
  outline,
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
    this.height = 48,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    LinearGradient? gradient;
    Color textColor = Colors.black;
    Border? border;

    switch (style) {
      case WuxiaButtonStyle.gold:
        gradient = AppColors.goldGradient;
        textColor = const Color(0xFF0F172A);
        break;
      case WuxiaButtonStyle.jade:
        gradient = AppColors.jadeGradient;
        textColor = Colors.white;
        break;
      case WuxiaButtonStyle.qi:
        gradient = AppColors.qiGradient;
        textColor = const Color(0xFF080C14);
        break;
      case WuxiaButtonStyle.crimson:
        gradient = const LinearGradient(
          colors: [AppColors.crimsonLight, AppColors.crimsonPrimary, AppColors.crimsonDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        textColor = Colors.white;
        break;
      case WuxiaButtonStyle.outline:
        gradient = null;
        textColor = AppColors.goldLight;
        border = Border.all(color: AppColors.goldPrimary, width: 1.2);
        break;
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: textColor,
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );

    return Container(
      height: height,
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: border,
        boxShadow: onPressed != null && style != WuxiaButtonStyle.outline
            ? [
                BoxShadow(
                  color: (gradient?.colors.first ?? AppColors.goldPrimary).withValues(alpha: 0.3),
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: content,
          ),
        ),
      ),
    );
  }
}
