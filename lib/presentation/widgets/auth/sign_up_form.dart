import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/unified_container.dart';
import '../../../constants/widgets/app_button.dart';
import 'custom_text_form_field.dart';
import 'password_form_field.dart';
import 'phone_form_field.dart';
import '../../screens/auth/otp_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpScreen(phoneNumber: _phoneController.text),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: UnifiedContainer(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                          Text(
              'Create Account',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 28,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
              const SizedBox(height: 8),
              Text(
                'Join to save your favorite places and travel history',
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
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    const CustomTextFormField(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    PhoneFormField(
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 20),
                    const PasswordFormField(label: 'Password'),
                    const SizedBox(height: 20),
                    const PasswordFormField(
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: "Create Account",
                      onPressed: _onCreateAccount,
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
      ),
    );
  }
}
