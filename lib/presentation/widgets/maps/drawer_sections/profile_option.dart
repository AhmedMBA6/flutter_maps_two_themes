import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive 
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.gray400,
          size: 16,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
      ),
    );
  }
}
