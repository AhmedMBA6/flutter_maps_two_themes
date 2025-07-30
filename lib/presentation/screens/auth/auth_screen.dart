import 'package:flutter/material.dart';
import '../../../constants/widgets/background_wrapper.dart';
import '../../../constants/widgets/icon_container.dart';
import '../../../constants/widgets/feature_icon.dart';
import '../../../constants/themes/app_colors.dart';

import '../../widgets/auth/tab_bar.dart';
import '../../widgets/auth/sign_in_form.dart';
import '../../widgets/auth/sign_up_form.dart';

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
                      // Top icon and texts
                      const SizedBox(height: 24),
                      IconContainer(
                        icon: Icons.near_me_outlined,
                        size: 80,
                        iconSize: 44,
                        backgroundColor: AppColors.primary,
                        iconColor: isDark ? Colors.black : Colors.white,
                        borderRadius: 20,
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
                            FeatureIcon(
                              icon: Icons.place_outlined,
                              label: 'Discover Places',
                              iconColor: AppColors.discoverPlacesIcon,
                              bgColor: AppColors.discoverPlacesBg,
                            ),
                            FeatureIcon(
                              icon: Icons.directions,
                              label: 'Get Directions',
                              iconColor: AppColors.getDirectionsIcon,
                              bgColor: AppColors.getDirectionsBg,
                            ),
                            FeatureIcon(
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
