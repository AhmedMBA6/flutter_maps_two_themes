import 'package:flutter/material.dart';
import '../../../constants/widgets/background_wrapper.dart';
import '../../../constants/themes/app_colors.dart';
import '../../widgets/auth/sign_in_form.dart';
import '../../widgets/auth/sign_up_form.dart';
import '../../widgets/auth/tab_bar.dart';
import '../../widgets/auth/theme_toggle_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ThemeToggleButton(),
                          SizedBox(width: 8),
                        ],
                      ),
                      // Top icon and texts
                      const SizedBox(height: 24),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.10),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.near_me_outlined,
                            color: isDark ? Colors.black : Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Welcome to Maps',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: isDark ? Colors.white : AppColors.gray900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Discover amazing places around you',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 500,
                          child: AuthTabBar(tabController: _tabController),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 500,
                        child: AnimatedBuilder(
                          animation: _tabController,
                          builder: (context, _) {
                            return _tabController.index == 0
                                ? const SignInForm()
                                : const SignUpForm();
                          },
                        ),
                      ),
                      const SizedBox(height: 23),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _FeatureIcon(
                              icon: Icons.place_outlined,
                              label: 'Discover Places',
                              iconColor: AppColors.discoverPlacesIcon,
                              bgColor: AppColors.discoverPlacesBg,
                            ),
                            _FeatureIcon(
                              icon: Icons.directions,
                              label: 'Get Directions',
                              iconColor: AppColors.getDirectionsIcon,
                              bgColor: AppColors.getDirectionsBg,
                            ),
                            _FeatureIcon(
                              icon: Icons.favorite_border,
                              label: 'Save Favorites',
                              iconColor: AppColors.saveFavoritesIcon,
                              bgColor: AppColors.saveFavoritesBg,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  
  const _FeatureIcon({
    required this.icon, 
    required this.label, 
    required this.iconColor, 
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.2) : bgColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withValues(alpha: 0.2) 
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon, 
            size: 28, 
            color: iconColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDark ? Colors.white : AppColors.gray700,
          ),
        ),
      ],
    );
  }
}
