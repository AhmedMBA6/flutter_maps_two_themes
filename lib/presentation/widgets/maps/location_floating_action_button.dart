import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class LocationFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final bool isLoading;

  const LocationFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.onLongPress,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onLongPress: onLongPress,
        child: FloatingActionButton(
          onPressed: isLoading ? null : onPressed,
          tooltip: 'Center on my location (long press to refresh)',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: isLoading 
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
