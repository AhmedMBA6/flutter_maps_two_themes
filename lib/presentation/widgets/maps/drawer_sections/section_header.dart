import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
