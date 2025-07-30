import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/unified_container.dart';
import '../../../constants/widgets/app_button.dart';
import 'custom_text_form_field.dart';
import 'password_form_field.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: UnifiedContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 28,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your saved places and history',
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const CustomTextFormField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  const PasswordFormField(label: 'Password'),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: "Sign In",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    text: "Continue as Guest",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
