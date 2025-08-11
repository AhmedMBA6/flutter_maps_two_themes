import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';

class ResendCodeSection extends StatelessWidget {
  final int timer;
  final VoidCallback onResendCode;
  final bool isResending; // Add resending state

  const ResendCodeSection({
    super.key,
    required this.timer,
    required this.onResendCode,
    this.isResending = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return timer > 0
        ? Text(
            'Resend code in 0:${timer.toString().padLeft(2, '0')}',
            style: AppTextStyles.bodyMediumThemed(context),
          )
        : GestureDetector(
            onTap: isResending ? null : onResendCode, // Disable when resending
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isResending) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                  const SizedBox(width: 6),
                  Text(
                    isResending ? 'Sending...' : 'Resend Code',
                    style: AppTextStyles.buttonSecondaryThemed(context).copyWith(
                      color: isResending ? AppColors.gray500 : null,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
} 