import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Title Styles
  static TextStyle get titleLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      );

  // Body Styles
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  // Label Styles
  static TextStyle get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  // Button Styles
  static TextStyle get buttonLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get buttonMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get buttonSmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  // Input Styles
  static TextStyle get inputText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  static TextStyle get inputLabel => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  static TextStyle get inputHint => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  // OTP Field Styles
  static TextStyle get otpField => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  // Link Styles
  static TextStyle get link => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        letterSpacing: 0.1,
      );

  // Caption Styles
  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  // Helper method to get themed text style
  static TextStyle themed(
    BuildContext context, {
    required TextStyle baseStyle,
    Color? lightColor,
    Color? darkColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return baseStyle.copyWith(
      color: isDark ? darkColor : lightColor,
    );
  }

  // Predefined themed styles for common use cases
  static TextStyle titleLargeThemed(BuildContext context) => themed(
        context,
        baseStyle: titleLarge,
        lightColor: AppColors.gray900,
        darkColor: Colors.white,
      );

  static TextStyle titleMediumThemed(BuildContext context) => themed(
        context,
        baseStyle: titleMedium,
        lightColor: AppColors.gray900,
        darkColor: Colors.white,
      );

  static TextStyle bodyLargeThemed(BuildContext context) => themed(
        context,
        baseStyle: bodyLarge,
        lightColor: AppColors.gray600,
        darkColor: Colors.white.withValues(alpha: 0.8),
      );

  static TextStyle bodyMediumThemed(BuildContext context) => themed(
        context,
        baseStyle: bodyMedium,
        lightColor: AppColors.gray600,
        darkColor: Colors.white.withValues(alpha: 0.8),
      );

  static TextStyle buttonPrimaryThemed(BuildContext context) => themed(
        context,
        baseStyle: buttonLarge,
        lightColor: Colors.white,
        darkColor: Colors.white,
      );

  static TextStyle buttonSecondaryThemed(BuildContext context) => themed(
        context,
        baseStyle: buttonMedium,
        lightColor: AppColors.primary,
        darkColor: AppColors.primary,
      );

  static TextStyle linkThemed(BuildContext context) => themed(
        context,
        baseStyle: link,
        lightColor: AppColors.primary,
        darkColor: AppColors.primary,
      );

  static TextStyle captionThemed(BuildContext context) => themed(
        context,
        baseStyle: caption,
        lightColor: AppColors.gray500,
        darkColor: AppColors.gray400,
      );
} 