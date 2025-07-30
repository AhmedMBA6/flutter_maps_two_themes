import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = true,
    this.icon,
    this.height = 52,
    this.borderRadius = 12,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: Size.fromHeight(height!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
          )
        : OutlinedButton.styleFrom(
            backgroundColor: theme.cardColor,
            foregroundColor: colorScheme.onSurface,
            side: BorderSide(
              color: isDark ? Colors.white24 : colorScheme.outline,
              width: 1.5,
            ),
            minimumSize: Size.fromHeight(height!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
          );

    final buttonTextColor = isPrimary
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white : Colors.black);

    final buttonTextStyle = (textStyle ?? textTheme.labelLarge)?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: buttonTextColor,
    );

    final button = isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(text, style: buttonTextStyle),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(text, style: buttonTextStyle),
              ],
            ),
          );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isFullWidth = true,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isPrimary: true,
      isFullWidth: isFullWidth,
      icon: icon,
      height: height,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isFullWidth = true,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isPrimary: false,
      isFullWidth: isFullWidth,
      icon: icon,
      height: height,
    );
  }
} 