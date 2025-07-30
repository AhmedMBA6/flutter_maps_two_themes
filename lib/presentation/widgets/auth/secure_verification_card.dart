import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/unified_container.dart';

class SecureVerificationCard extends StatelessWidget {
  const SecureVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: UnifiedContainer(
        width: 380,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        borderRadius: 12,
        borderColor: AppColors.gray500,
        borderWidth: 0.5,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(320),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Verification',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.gray900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your phone number helps keep your account safe',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 