import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final TextStyle? labelStyle;

  const FeatureIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.size = 56,
    this.iconSize = 28,
    this.borderRadius = 28,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.2) : bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withValues(alpha: 0.2) 
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon, 
            size: iconSize, 
            color: iconColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: labelStyle ?? textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.gray700,
          ),
        ),
      ],
    );
  }
} 