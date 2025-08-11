import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/widgets/background_wrapper.dart';
import '../../../logic_layer/auth/auth_cubit.dart';
import '../../../logic_layer/auth/auth_state.dart';
import '../../widgets/auth/otp_header.dart';
import '../../widgets/auth/otp_form_card.dart';
import '../../widgets/auth/try_different_phone_link.dart';
import '../../widgets/auth/secure_verification_card.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final String countryCode;
  final bool isSignUp; // Add mode parameter
  final String? fullName; // Add sign-up fields
  final String? email;
  final String? password;
  
  const OtpScreen({
    super.key, 
    required this.phoneNumber,
    required this.verificationId,
    required this.countryCode,
    this.isSignUp = false, // Default to sign-in mode
    this.fullName,
    this.email,
    this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _timer = 30;
  bool _isButtonEnabled = false;
  bool _isVerifying = false;
  bool _hasError = false;
  String? _errorMessage;
  String _currentVerificationId = ''; // Track current verification ID
  bool _isResending = false; // Track resend state

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.doWhile(() async {
      if (_timer == 0) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _timer--);
      return _timer > 0;
    });
  }

  void _verifyCode() async {
    if (!_isButtonEnabled || _isVerifying) return;

    setState(() {
      _isVerifying = true;
      _hasError = false;
      _errorMessage = null;
    });

    if (widget.isSignUp) {
      // Use sign-up verification for new accounts
      context.read<AuthCubit>().verifyOtpForSignUp(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
        verificationId: _currentVerificationId,
        smsCode: _otpController.text,
        fullName: widget.fullName!,
        email: widget.email!,
        password: widget.password!,
      );
    } else {
      // Use sign-in verification for existing users
      context.read<AuthCubit>().verifyOtpForSignIn(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
        verificationId: _currentVerificationId,
        smsCode: _otpController.text,
      );
    }
  }

  void _handleOtpChanged(String value) {
    setState(() {
      _otpController.text = value;
      _isButtonEnabled = value.length == 6;
      // Clear error when user starts typing
      if (_hasError) {
        _hasError = false;
        _errorMessage = null;
      }
    });
  }

  void _handleOtpCompleted(String value) {
    setState(() {
      _otpController.text = value;
      _isButtonEnabled = value.length == 6;
      // Clear error when user completes OTP
      if (_hasError) {
        _hasError = false;
        _errorMessage = null;
      }
    });
  }

  void _handleResendCode() {
    if (_isResending) return; // Prevent multiple resend attempts
    
    setState(() {
      _isResending = true;
      _timer = 30;
      _hasError = false;
      _errorMessage = null;
      _otpController.clear(); // Clear the OTP input
    });
    
    _startTimer();
    
    if (widget.isSignUp) {
      // Use sign-up OTP sending for new accounts
      context.read<AuthCubit>().sendOtpForSignUp(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
      );
    } else {
      // Use sign-in OTP sending for existing users
      context.read<AuthCubit>().sendOtpForSignIn(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          // Navigate to home screen for sign-in
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is SignUpSuccess) {
          // Show success message and navigate to home screen for sign-up
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Navigate to home screen after successful sign-up
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is OtpSentSuccess) {
          // Update verification ID and show success message
          setState(() {
            _currentVerificationId = state.verificationId;
            _isResending = false;
            _hasError = false;
            _errorMessage = null;
          });
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is AuthError) {
          // Show error message
          setState(() {
            _isVerifying = false;
            _isResending = false;
            _hasError = true;
            _errorMessage = state.message;
          });
        } else if (state is ValidationError) {
          // Show validation error
          setState(() {
            _isVerifying = false;
            _isResending = false;
            _hasError = true;
            _errorMessage = 'Please enter a valid OTP code';
          });
        }
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpHeader(phoneNumber: widget.phoneNumber),
                    const SizedBox(height: 32),
                    OtpFormCard(
                      onOtpChanged: _handleOtpChanged,
                      onOtpCompleted: _handleOtpCompleted,
                      otpController: _otpController,
                      isButtonEnabled: _isButtonEnabled,
                      isVerifying: _isVerifying,
                      hasError: _hasError,
                      errorMessage: _errorMessage,
                      onVerifyCode: _verifyCode,
                      onResendCode: _handleResendCode,
                      timer: _timer,
                      isResending: _isResending, // Pass resending state
                    ),
                    const SizedBox(height: 24),
                    TryDifferentPhoneLink(
                      onTryDifferentPhone: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 24),
                    const SecureVerificationCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
