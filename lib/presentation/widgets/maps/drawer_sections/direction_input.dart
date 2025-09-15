import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';

class DirectionInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;

  const DirectionInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.inputBackgroundDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.borderDark,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.gray400,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: AppColors.gray500,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
