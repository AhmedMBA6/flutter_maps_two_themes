import 'package:flutter/material.dart';

class UnifiedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final bool isFormContainer;
  final bool isCardContainer;
  final bool isTransparent;

  const UnifiedContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.width,
    this.height,
    this.isFormContainer = false,
    this.isCardContainer = false,
    this.isTransparent = false,
  });

  // Named constructors for specific use cases
  const UnifiedContainer.form({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding = const EdgeInsets.all(32),
    double borderRadius = 16,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    double? width,
    double? height,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          boxShadow: boxShadow,
          width: width,
          height: height,
          isFormContainer: true,
        );

  const UnifiedContainer.card({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
    double? width,
    double? height,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          boxShadow: boxShadow,
          width: width,
          height: height,
          isCardContainer: true,
        );

  const UnifiedContainer.transparent({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
    Color? borderColor,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
    double? width,
    double? height,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          borderRadius: borderRadius,
          borderColor: borderColor,
          borderWidth: borderWidth,
          boxShadow: boxShadow,
          width: width,
          height: height,
          isTransparent: true,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine background color based on type and theme
    Color? finalBackgroundColor;
    if (isTransparent) {
      finalBackgroundColor = Colors.transparent;
    } else if (backgroundColor != null) {
      finalBackgroundColor = backgroundColor;
    } else if (isFormContainer) {
      finalBackgroundColor = theme.cardColor;
    } else if (isCardContainer) {
      finalBackgroundColor = theme.cardColor;
    } else {
      finalBackgroundColor = theme.cardColor;
    }

    // Determine border color based on type and theme
    Color? finalBorderColor;
    if (borderColor != null) {
      finalBorderColor = borderColor;
    } else if (isCardContainer) {
      finalBorderColor = colorScheme.outlineVariant;
    } else {
      finalBorderColor = null; // No border for form containers by default
    }

    // Determine box shadow based on type and theme
    List<BoxShadow>? finalBoxShadow;
    if (boxShadow != null) {
      finalBoxShadow = boxShadow;
    } else if (isFormContainer) {
      finalBoxShadow = [
        BoxShadow(
          color: colorScheme.shadow.withValues(
            alpha: isDark ? 0.3 : 0.08,
          ),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
    } else if (isCardContainer) {
      finalBoxShadow = [
        BoxShadow(
          color: colorScheme.shadow.withValues(
            alpha: isDark ? 0.18 : 0.06,
          ),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: finalBorderColor != null
            ? Border.all(color: finalBorderColor, width: borderWidth)
            : null,
        boxShadow: finalBoxShadow,
      ),
      child: child,
    );
  }
}

// Convenience classes for backward compatibility
class FormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;

  const FormContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.borderRadius = 16,
    this.backgroundColor,
    this.boxShadow,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedContainer.form(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      boxShadow: boxShadow,
      width: width,
      height: height,
      child: child,
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedContainer.card(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      boxShadow: boxShadow,
      width: width,
      height: height,
      child: child,
    );
  }
} 