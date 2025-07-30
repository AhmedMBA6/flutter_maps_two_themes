import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';

class VerifyCodeButton extends StatelessWidget {
  final bool isEnabled;
  final bool isVerifying;
  final VoidCallback onVerifyCode;

  const VerifyCodeButton({
    super.key,
    required this.isEnabled,
    required this.isVerifying,
    required this.onVerifyCode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isEnabled ? onVerifyCode : null,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(isDark),
            const SizedBox(width: 8),
            _buildText(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    if (isVerifying) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? Colors.black : Colors.white,
          ),
        ),
      );
    }

    return Icon(
      Icons.check,
      size: 20,
      color: isEnabled
          ? (isDark ? Colors.black : Colors.white)
          : (isDark ? AppColors.gray800 : AppColors.gray100),
    );
  }

  Widget _buildText(bool isDark) {
    return Text(
      isVerifying ? "Verifying..." : "Verify Code",
      style: AppTextStyles.buttonLarge.copyWith(
        color: isEnabled
            ? (isDark ? Colors.black : Colors.white)
            : (isDark ? AppColors.gray800 : AppColors.gray100),
      ),
    );
  }
} 