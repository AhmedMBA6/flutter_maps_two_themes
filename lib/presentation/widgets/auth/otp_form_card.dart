import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/unified_container.dart';
import 'custom_otp_field.dart';
import 'verify_code_button.dart';
import 'resend_code_section.dart';
import 'otp_error_message.dart';

class OtpFormCard extends StatelessWidget {
  final TextEditingController otpController;
  final bool isButtonEnabled;
  final bool isVerifying;
  final int timer;
  final bool hasError;
  final String? errorMessage;
  final bool isResending; // Add resending state
  final Function(String) onOtpChanged;
  final Function(String)? onOtpCompleted;
  final VoidCallback onVerifyCode;
  final VoidCallback onResendCode;

  const OtpFormCard({
    super.key,
    required this.otpController,
    required this.isButtonEnabled,
    required this.isVerifying,
    required this.timer,
    this.hasError = false,
    this.errorMessage,
    this.isResending = false, // Default to false
    required this.onOtpChanged,
    required this.onOtpCompleted,
    required this.onVerifyCode,
    required this.onResendCode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: UnifiedContainer(
        width: 380,
        padding: const EdgeInsets.all(32),
        borderRadius: 20,
        borderColor: isDark ? AppColors.gray600 : AppColors.gray300,
        borderWidth: 0.3,
        child: Column(
          children: [
            // Card Title
            Text(
              'Enter Verification Code',
              style: AppTextStyles.titleMediumThemed(context),
            ),
            const SizedBox(height: 8),

            // Card Subtitle
            Text(
              'Enter the 6-digit code we sent to your phone',
              style: AppTextStyles.bodyMediumThemed(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // OTP Fields
            CustomOtpField(
              fieldHeight: 56,
              spacing: 4,
              borderRadius: 12,
              borderWidth: 1.5,
              hasError: hasError,
              onChanged: onOtpChanged,
              onCompleted: onOtpCompleted,
            ),
            if (hasError && errorMessage != null) ...[
              const SizedBox(height: 12),
              OtpErrorMessage(message: errorMessage!),
            ],
            const SizedBox(height: 16),

            // Demo Code Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryHover.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Demo: Use code 123456',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Resend Code Section
            ResendCodeSection(
              timer: timer,
              onResendCode: onResendCode,
              isResending: isResending, // Pass the new state
            ),
            const SizedBox(height: 24),

            // Verify Code Button
            VerifyCodeButton(
              isEnabled: isButtonEnabled,
              isVerifying: isVerifying,
              onVerifyCode: onVerifyCode,
            ),
          ],
        ),
      ),
    );
  }
} 