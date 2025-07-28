import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/themes/theme_model.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeModel = Provider.of<ThemeModel>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
          ),
          icon: Icon(
            isDark ? Icons.wb_sunny_outlined : Icons.bedtime_outlined,
            color: theme.iconTheme.color,
          ),
          onPressed: () => themeModel.isDark = !isDark,
        ),
      ),
    );
  }
}

