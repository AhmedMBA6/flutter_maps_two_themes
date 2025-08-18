import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data_layer/repos/auth/auth_repository_export.dart';
import 'auth_state.dart';
import '../../utils/logger.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryInterface _authRepository;

  AuthCubit({required AuthRepositoryInterface authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial());

  // Getters for easy access to repository properties
  bool get isSignedIn => _authRepository.isSignedIn;
  User? get currentUser => _authRepository.currentUser;
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  // ==================== INITIALIZATION ====================

  /// Check initial authentication state
  Future<void> checkInitialAuthState() async {
    try {
      emit(const AuthLoading());
      
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        // User is already signed in, get their data
        final userData = await _authRepository.getUserData(currentUser.uid);
        if (userData != null) {
          emit(AuthSuccess(userData));
        } else {
          // User exists in Firebase Auth but not in Firestore
          emit(const AuthError('User data not found. Please sign in again.'));
          await _authRepository.signOut();
        }
      } else {
        // No user signed in
        emit(const AuthInitial());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication state: ${e.toString()}'));
    }
  }

  // ==================== SIGN UP METHODS ====================

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      Logger.info('AuthCubit: Starting sign up process for email: $email');
      emit(const AuthLoading());

      // Validate input data
      final validationErrors = AuthValidationService.validateRegistration(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: password, // For sign up, password and confirmPassword are the same
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      if (!AuthValidationService.isFormValid(validationErrors)) {
        Logger.warning('AuthCubit: Validation errors found: $validationErrors');
        emit(ValidationError(validationErrors));
        return;
      }

      Logger.debug('AuthCubit: Validation passed, calling repository...');

      // Create user with email and password
      final user = await _authRepository.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      Logger.success('AuthCubit: User created successfully: ${user.id}');
      emit(SignUpSuccess(user, 'Account created successfully! Please verify your email.'));
    } catch (e) {
      Logger.error('AuthCubit: Error in signUpWithEmail: $e');
      
      // Handle specific error messages
      String errorMessage = e.toString();
      if (errorMessage.contains('email-already-in-use') || 
          errorMessage.contains('already exists with this email')) {
        errorMessage = 'An account already exists with this email. Please sign in instead.';
      } else if (errorMessage.contains('weak-password')) {
        errorMessage = 'Password is too weak. Please choose a stronger password.';
      } else if (errorMessage.contains('invalid-email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (errorMessage.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      emit(AuthError(errorMessage));
    }
  }

  /// Sign up with phone number
  Future<void> signUpWithPhone({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      emit(const AuthLoading());

      // Validate input data
      final validationErrors = AuthValidationService.validateRegistration(
        fullName: fullName,
        email: email,
        password: '', // Not needed for phone sign up
        confirmPassword: '', // Not needed for phone sign up
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      if (!AuthValidationService.isFormValid(validationErrors)) {
        emit(ValidationError(validationErrors));
        return;
      }

      // Create user with phone verification
      final user = await _authRepository.signUpWithPhone(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        verificationId: verificationId,
        smsCode: smsCode,
      );

      emit(SignUpSuccess(user, 'Account created successfully!'));
    } catch (e) {
      emit(AuthError('Failed to create account: ${e.toString()}'));
    }
  }

  // ==================== SIGN IN METHODS ====================

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());

      // Validate input data
      final validationErrors = AuthValidationService.validateSignIn(
        email: email,
        password: password,
      );

      if (!AuthValidationService.isFormValid(validationErrors)) {
        emit(ValidationError(validationErrors));
        return;
      }

      // Sign in with email and password
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        emit(SignInSuccess(user, 'Welcome back!'));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError('Failed to sign in: ${e.toString()}'));
    }
  }

  /// Send OTP for phone sign in
  Future<void> sendOtpForSignIn({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      Logger.info('AuthCubit: Sending OTP for phone: $phoneNumber, country: $countryCode');
      emit(const AuthLoading());

      // Validate phone number
      final validationErrors = AuthValidationService.validatePhoneSignIn(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      if (!AuthValidationService.isFormValid(validationErrors)) {
        Logger.warning('AuthCubit: Validation errors found: $validationErrors');
        emit(ValidationError(validationErrors));
        return;
      }

      final fullPhoneNumber = '$countryCode$phoneNumber';
      Logger.debug('AuthCubit: Full phone number: $fullPhoneNumber');
      Logger.debug('AuthCubit: Country code: $countryCode, Phone: $phoneNumber');
      Logger.debug('AuthCubit: Phone number length: ${phoneNumber.length}');
      Logger.debug('AuthCubit: Full phone number length: ${fullPhoneNumber.length}');

      await _authRepository.sendOTP(
        phoneNumber: fullPhoneNumber,
        onCodeSent: (verificationId) {
          Logger.success('AuthCubit: OTP sent successfully with verification ID: $verificationId');
          emit(OtpSentSuccess(
            verificationId,
            fullPhoneNumber,
            'OTP sent successfully!',
          ));
        },
        onError: (error) {
          Logger.error('AuthCubit: OTP sending failed: $error');
          emit(AuthError('Failed to send OTP: $error'));
        },
      );
    } catch (e) {
      Logger.error('AuthCubit: Error in sendOtpForSignIn: $e');
      emit(AuthError('Failed to send OTP: ${e.toString()}'));
    }
  }

  /// Verify OTP for phone sign in
  Future<void> verifyOtpForSignIn({
    required String phoneNumber,
    required String countryCode,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      Logger.info('AuthCubit: Verifying OTP for phone sign-in, phone: $phoneNumber');
      emit(const AuthLoading());

      // Validate OTP
      final validationErrors = AuthValidationService.validateOTP(smsCode);
      if (validationErrors.isNotEmpty) {
        Logger.warning('AuthCubit: OTP validation errors: $validationErrors');
        emit(ValidationError(validationErrors));
        return;
      }

      final fullPhoneNumber = '$countryCode$phoneNumber';
      Logger.debug('AuthCubit: Full phone number: $fullPhoneNumber');

      // Verify OTP and sign in
      final user = await _authRepository.signInWithPhone(
        phoneNumber: phoneNumber,
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (user != null) {
        Logger.success('AuthCubit: Phone sign-in successful for user: ${user.id}');
        emit(SignInSuccess(user, 'Phone verification successful!'));
      } else {
        Logger.warning('AuthCubit: Phone sign-in failed - no user returned');
        emit(const AuthError('Invalid OTP code'));
      }
    } catch (e) {
      Logger.error('AuthCubit: Error in verifyOtpForSignIn: $e');
      
      // Provide better error messages for common scenarios
      String errorMessage = e.toString();
      if (errorMessage.contains('No account found with this phone number')) {
        errorMessage = 'No account found with this phone number. Please sign up first.';
      } else if (errorMessage.contains('Invalid verification code')) {
        errorMessage = 'Invalid verification code. Please check and try again.';
      } else if (errorMessage.contains('Invalid verification ID')) {
        errorMessage = 'Verification session expired. Please request a new code.';
      } else if (errorMessage.contains('User data not found')) {
        errorMessage = 'Account data not found. Please contact support.';
      } else if (errorMessage.contains('network')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      }
      
      emit(AuthError(errorMessage));
    }
  }

  /// Send OTP for phone sign up (not sign in)
  Future<void> sendOtpForSignUp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      Logger.info('AuthCubit: Sending OTP for sign-up, phone: $phoneNumber, country: $countryCode');
      emit(const AuthLoading());

      // Validate phone number
      final validationErrors = AuthValidationService.validatePhoneSignIn(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      if (!AuthValidationService.isFormValid(validationErrors)) {
        Logger.warning('AuthCubit: Validation errors found: $validationErrors');
        emit(ValidationError(validationErrors));
        return;
      }

      final fullPhoneNumber = '$countryCode$phoneNumber';
      Logger.debug('AuthCubit: Full phone number: $fullPhoneNumber');
      Logger.debug('AuthCubit: Country code: $countryCode, Phone: $phoneNumber');
      Logger.debug('AuthCubit: Phone number length: ${phoneNumber.length}');
      Logger.debug('AuthCubit: Full phone number length: ${fullPhoneNumber.length}');

      await _authRepository.sendOTP(
        phoneNumber: fullPhoneNumber,
        onCodeSent: (verificationId) {
          Logger.success('AuthCubit: OTP sent successfully for sign-up with verification ID: $verificationId');
          emit(OtpSentSuccess(
            verificationId,
            fullPhoneNumber,
            'OTP sent successfully!',
          ));
        },
        onError: (error) {
          Logger.error('AuthCubit: OTP sending failed for sign-up: $error');
          emit(AuthError('Failed to send OTP: $error'));
        },
      );
    } catch (e) {
      Logger.error('AuthCubit: Error in sendOtpForSignUp: $e');
      emit(AuthError('Failed to send OTP: ${e.toString()}'));
    }
  }

  /// Verify OTP for phone sign up (not sign in)
  Future<void> verifyOtpForSignUp({
    required String phoneNumber,
    required String countryCode,
    required String verificationId,
    required String smsCode,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      Logger.info('AuthCubit: Verifying OTP for sign-up, phone: $phoneNumber');
      emit(const AuthLoading());

      // Validate OTP
      final validationErrors = AuthValidationService.validateOTP(smsCode);
      if (validationErrors.isNotEmpty) {
        Logger.warning('AuthCubit: OTP validation errors: $validationErrors');
        emit(ValidationError(validationErrors));
        return;
      }

      final fullPhoneNumber = '$countryCode$phoneNumber';
      Logger.debug('AuthCubit: Full phone number: $fullPhoneNumber');

      // Verify OTP and create user
      final user = await _authRepository.signUpWithPhone(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        verificationId: verificationId,
        smsCode: smsCode,
      );

      Logger.success('AuthCubit: User created successfully with phone verification: ${user.id}');
      emit(SignUpSuccess(user, 'Account created successfully!'));
    } catch (e) {
      Logger.error('AuthCubit: Error in verifyOtpForSignUp: $e');
      emit(AuthError('Failed to create account: ${e.toString()}'));
    }
  }

  // ==================== VERIFICATION METHODS ====================

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      emit(const AuthLoading());

      await _authRepository.sendEmailVerification();
      emit(const EmailVerificationSent('Email verification sent! Please check your inbox.'));
    } catch (e) {
      emit(AuthError('Failed to send email verification: ${e.toString()}'));
    }
  }

  /// Update phone verification status
  Future<void> updatePhoneVerificationStatus(String uid, bool isVerified) async {
    try {
      await _authRepository.updatePhoneVerificationStatus(uid, isVerified);
    } catch (e) {
      emit(AuthError('Failed to update phone verification status: ${e.toString()}'));
    }
  }

  // ==================== USER DATA METHODS ====================

  /// Get current user data
  Future<void> getCurrentUserData() async {
    try {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        final userData = await _authRepository.getUserData(currentUser.uid);
        if (userData != null) {
          emit(AuthSuccess(userData));
        }
      }
    } catch (e) {
      emit(AuthError('Failed to get user data: ${e.toString()}'));
    }
  }

  /// Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      emit(const AuthLoading());

      await _authRepository.updateUserData(uid, data);
      
      // Refresh user data
      await getCurrentUserData();
    } catch (e) {
      emit(AuthError('Failed to update user data: ${e.toString()}'));
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Sign out
  Future<void> signOut() async {
    try {
      emit(const AuthLoading());

      await _authRepository.signOut();
      emit(const SignOutSuccess('Signed out successfully'));
    } catch (e) {
      emit(AuthError('Failed to sign out: ${e.toString()}'));
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      emit(const AuthLoading());

      await _authRepository.deleteAccount();
      emit(const SignOutSuccess('Account deleted successfully'));
    } catch (e) {
      emit(AuthError('Failed to delete account: ${e.toString()}'));
    }
  }

  /// Check if user exists by email
  Future<bool> checkUserExistsByEmail(String email) async {
    try {
      return await _authRepository.userExistsByEmail(email);
    } catch (e) {
      emit(AuthError('Failed to check user existence: ${e.toString()}'));
      return false;
    }
  }

  /// Check if user exists by phone
  Future<bool> checkUserExistsByPhone(String phoneNumber) async {
    try {
      return await _authRepository.userExistsByPhone(phoneNumber);
    } catch (e) {
      emit(AuthError('Failed to check user existence: ${e.toString()}'));
      return false;
    }
  }

  /// Reset to initial state
  void resetToInitial() {
    emit(const AuthInitial());
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError || state is ValidationError) {
      emit(const AuthInitial());
    }
  }
}