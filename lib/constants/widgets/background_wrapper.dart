import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/presentation/widgets/auth/theme_toggle_button.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showThemeToggle;
  final bool showBackButton;

  const AppBackground({
    super.key,
    required this.child,
    this.showThemeToggle = true,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E40AF),
                  Color(0xFF0B132B),
                  Color(0xFF1E40AF),
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFF3FC),
                  Color(0xFFFFFFFF),
                  Color(0xFFEFF3FC),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          if (showThemeToggle || showBackButton)
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showBackButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 6),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          color: isDark ? Colors.white : Colors.black,
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ),
                  if (!showBackButton) const SizedBox(width: 48),
                  if (showThemeToggle) const ThemeToggleButton(),
                  if (!showThemeToggle) const SizedBox(width: 48),
                ],
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
