import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/background_wrapper.dart';
import '../../../logic_layer/auth/auth_cubit.dart';
import '../../../logic_layer/auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          // Navigate back to auth screen
          Navigator.of(context).pushReplacementNamed('/auth');
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: AppBackground(
              showThemeToggle: true,
              showBackButton: false,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Success Title
                      Text(
                        'Welcome to Maps!',
                        style: AppTextStyles.titleLargeThemed(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Success Message
                      Text(
                        state is AuthSuccess 
                            ? 'Welcome back, ${state.user.fullName}!'
                            : 'You have successfully signed in. Welcome to the app!',
                        style: AppTextStyles.bodyLargeThemed(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Continue Button
                          Container(
                            width: 150,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigate to main app content
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Welcome to the main app!'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: const Center(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Sign Out Button
                          Container(
                            width: 120,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final isDark = Theme.of(context).brightness == Brightness.dark;
                                      return AlertDialog(
                                        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        title: Text(
                                          'Sign Out',
                                          style: AppTextStyles.titleMedium.copyWith(
                                            color: isDark ? Colors.white : AppColors.gray900,
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to sign out?',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.gray600,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: AppTextStyles.buttonMedium.copyWith(
                                                color: isDark ? AppColors.gray400 : AppColors.gray600,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              context.read<AuthCubit>().signOut();
                                            },
                                            child: Text(
                                              'Sign Out',
                                              style: AppTextStyles.buttonMedium.copyWith(
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: const Center(
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 