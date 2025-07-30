import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';

class ResendCodeSection extends StatelessWidget {
  final int timer;
  final VoidCallback onResendCode;

  const ResendCodeSection({
    super.key,
    required this.timer,
    required this.onResendCode,
  });

  @override
  Widget build(BuildContext context) {
    return timer > 0
        ? Text(
            'Resend code in 0:${timer.toString().padLeft(2, '0')}',
            style: AppTextStyles.bodyMediumThemed(context),
          )
        : GestureDetector(
            onTap: onResendCode,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Resend Code',
                    style: AppTextStyles.buttonSecondaryThemed(context),
                  ),
                ],
              ),
            ),
          );
  }
} 