import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class CircularActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          onPressed: onPressed,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ),
    );
  }
}
