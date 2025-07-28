import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

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
                  Color(0xFF1E40AF),     // Top Left → Bright Blue
                  Color(0xFF0B132B),     // Center Diagonal → Deep Dark Blue
                  Color(0xFF1E40AF),     // Bottom Right → Bright Blue
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFF3FC),     // Light blue/white
                  Color(0xFFFFFFFF),     // Center soft white
                  Color(0xFFEFF3FC),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
      ),
      child: child,
    );
  }
}
