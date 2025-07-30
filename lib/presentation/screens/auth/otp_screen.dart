import 'package:flutter/material.dart';
import '../../../constants/widgets/background_wrapper.dart';
import '../../widgets/auth/otp_header.dart';
import '../../widgets/auth/otp_form_card.dart';
import '../../widgets/auth/try_different_phone_link.dart';
import '../../widgets/auth/secure_verification_card.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

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

  @override
  void initState() {
    super.initState();
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

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });

      // Check if the code is correct (demo: 123456)
      final enteredCode = _otpController.text;
      if (enteredCode == "123456") {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Show error state
        setState(() {
          _hasError = true;
          _errorMessage = "Invalid verification code. Try again or use 123456 for demo.";
        });
      }
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
    setState(() {
      _timer = 30;
    });
    _startTimer();
  }

  void _handleTryDifferentPhone() {
    // Navigate back to sign up form
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        showThemeToggle: true,
        showBackButton: true,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Section
                  OtpHeader(phoneNumber: widget.phoneNumber),
                  
                  // Main Form Card
                  OtpFormCard(
                    otpController: _otpController,
                    isButtonEnabled: _isButtonEnabled,
                    isVerifying: _isVerifying,
                    timer: _timer,
                    hasError: _hasError,
                    errorMessage: _errorMessage,
                    onOtpChanged: _handleOtpChanged,
                    onOtpCompleted: _handleOtpCompleted,
                    onVerifyCode: _verifyCode,
                    onResendCode: _handleResendCode,
                  ),
                  const SizedBox(height: 18),

                  // Try Different Phone Link
                  TryDifferentPhoneLink(
                    onTryDifferentPhone: _handleTryDifferentPhone,
                  ),
                  const SizedBox(height: 24),

                  // Secure Verification Card
                  const SecureVerificationCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
