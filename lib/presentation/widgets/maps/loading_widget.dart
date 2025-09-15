import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/theme_model.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            Consumer<ThemeModel>(
              builder: (context, themeModel, child) {
                final isDark = themeModel.isDark;
                return Text(
                  'Getting your location...',
                  style: TextStyle(
                    color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
