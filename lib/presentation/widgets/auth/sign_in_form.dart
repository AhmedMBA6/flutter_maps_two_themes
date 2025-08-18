import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/themes/app_text_styles.dart';
import '../../../constants/widgets/unified_container.dart';
import '../../../constants/widgets/app_button.dart';
import '../../../logic_layer/auth/auth_cubit.dart';
import '../../../logic_layer/auth/auth_state.dart';
import 'custom_text_form_field.dart';
import 'password_form_field.dart';
import 'phone_form_field.dart';
import '../../screens/auth/otp_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isEmailMode = true;
  String _selectedCountryCode = '+20'; // Default to Egypt



  void _onSignIn() {
    if (_formKey.currentState!.validate()) {
      if (_isEmailMode) {
        // Handle email/password sign in
        context.read<AuthCubit>().signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Handle phone/OTP sign in
        context.read<AuthCubit>().sendOtpForSignIn(
          phoneNumber: _phoneController.text.trim(),
          countryCode: _selectedCountryCode,
        );
      }
    }
  }

  void _onCountryCodeChanged(String countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          // Navigate to home screen
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is OtpSentSuccess) {
          // Navigate to OTP screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: _phoneController.text.trim(),
                verificationId: state.verificationId,
                countryCode: _selectedCountryCode,
              ),
            ),
          );
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ValidationError) {
          // Show validation error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fix the validation errors'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
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
                    
                    // Auth Mode Toggle
                    Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isEmailMode = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: _isEmailMode 
                                      ? (isDark ? AppColors.gray600 : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: _isEmailMode ? [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withValues(alpha: 0.2)
                                          : Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ] : null,
                                ),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _isEmailMode ? FontWeight.w600 : FontWeight.w500,
                                    letterSpacing: 0.2,
                                    color: _isEmailMode 
                                        ? (isDark ? Colors.white : AppColors.gray900)
                                        : (isDark ? Colors.white70 : AppColors.gray600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isEmailMode = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: !_isEmailMode 
                                      ? (isDark ? AppColors.gray600 : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: !_isEmailMode ? [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withValues(alpha: 0.2)
                                          : Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ] : null,
                                ),
                                child: Text(
                                  'Phone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: !_isEmailMode ? FontWeight.w600 : FontWeight.w500,
                                    letterSpacing: 0.2,
                                    color: !_isEmailMode 
                                        ? (isDark ? Colors.white : AppColors.gray900)
                                        : (isDark ? Colors.white70 : AppColors.gray600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if (_isEmailMode) ...[
                            // Email/Password Fields
                            CustomTextFormField(
                              label: 'Email Address',
                              hint: 'Enter your email',
                              prefixIcon: Icons.email_outlined,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            PasswordFormField(
                              label: 'Password',
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ] else ...[
                            // Phone Field
                            PhoneFormField(
                              controller: _phoneController,
                              onCountryCodeChanged: _onCountryCodeChanged,
                            ),
                          ],
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: _isEmailMode ? "Sign In" : "Send OTP",
                            onPressed: state is AuthLoading ? null : _onSignIn,
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
        },
      ),
    );
  }
}