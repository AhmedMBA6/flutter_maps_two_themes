import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : AppColors.gray400,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.gray400,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
