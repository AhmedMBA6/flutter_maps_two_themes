import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;

  const IconContainer({
    super.key,
    required this.icon,
    this.size = 80,
    this.iconSize = 44,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 20,
    this.boxShadow,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor ?? colorScheme.primary,
          size: iconSize,
        ),
      ),
    );
  }
} 