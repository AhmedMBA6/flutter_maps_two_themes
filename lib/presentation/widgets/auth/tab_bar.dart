import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';

class AuthTabBar extends StatelessWidget {
  final TabController tabController;

  const AuthTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: SizedBox(
        width: 500,
        child: Container(
          height: 58,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TabBar(
            controller: tabController,
            labelColor: isDark ? Colors.white : AppColors.gray900,
            unselectedLabelColor: isDark ? Colors.white70 : AppColors.gray600,
            indicator: BoxDecoration(
              color: isDark ? AppColors.gray600 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            tabs: const [
              Tab(text: 'Sign In'),
              Tab(text: 'Create Account'),
            ],
          ),
        ),
      ),
    );
  }
}
