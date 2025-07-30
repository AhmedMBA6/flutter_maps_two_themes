import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';

class OtpHeader extends StatelessWidget {
  final String phoneNumber;

  const OtpHeader({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phone = _maskPhone(phoneNumber);

    return Column(
      children: [
        // Shield Icon
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.shield_outlined,
            size: 40,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Verify Your Phone',
          style: AppTextStyles.titleLargeThemed(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'We sent a 6-digit code to',
          style: AppTextStyles.bodyLargeThemed(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          phone,
          style: AppTextStyles.bodyLargeThemed(context).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return phone.replaceRange(3, phone.length - 2, '*' * (phone.length - 5));
  }
} 