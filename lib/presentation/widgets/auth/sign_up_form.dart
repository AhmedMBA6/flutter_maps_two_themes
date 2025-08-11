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

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String _selectedCountryCode = '+20'; // Default to Egypt

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {
      // First send OTP to get verification ID, then navigate to OTP screen
      context.read<AuthCubit>().sendOtpForSignUp(
        phoneNumber: _phoneController.text.trim(),
        countryCode: _selectedCountryCode,
      );
    }
  }

  void _verifyEmailAndPhone() {
    // Use AuthCubit to create account with email and password
    context.read<AuthCubit>().signUpWithEmail(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: _phoneController.text.trim(),
      countryCode: _selectedCountryCode,
    );
  }

  void _onCountryCodeChanged(String countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          // Navigate to OTP screen with the verification ID
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: _phoneController.text.trim(),
                verificationId: state.verificationId,
                countryCode: _selectedCountryCode,
                isSignUp: true, // Mark as sign-up mode
                fullName: _fullNameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            ),
          );
        } else if (state is SignUpSuccess) {
          // Show success message and navigate to OTP screen for phone verification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to OTP screen for phone verification
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: _phoneController.text.trim(),
                verificationId: '', // This will be set when OTP is sent
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
            SnackBar(
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
                          CustomTextFormField(
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            controller: _fullNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'Full name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
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
                          PhoneFormField(
                            controller: _phoneController,
                            onCountryCodeChanged: _onCountryCodeChanged,
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
                          const SizedBox(height: 20),
                          PasswordFormField(
                            label: 'Confirm Password',
                            hintText: 'Confirm your password',
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: "Create Account",
                            onPressed: state is AuthLoading ? null : _onCreateAccount,
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
