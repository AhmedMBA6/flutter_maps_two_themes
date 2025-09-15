import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/theme_model.dart';

class MapErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const MapErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<ThemeModel>(
              builder: (context, themeModel, child) {
                final isDark = themeModel.isDark;
                return Icon(
                  Icons.location_off,
                  size: 64,
                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<ThemeModel>(
              builder: (context, themeModel, child) {
                final isDark = themeModel.isDark;
                return Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
