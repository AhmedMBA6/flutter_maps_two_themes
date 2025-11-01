import 'package:equatable/equatable.dart';
import '../../data_layer/models/auth/user_model.dart';

// Base state class
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state - app just started
class AuthInitial extends AuthState {}

// Loading state - operation in progress
class AuthLoading extends AuthState {}

// Success states
class AuthSuccess extends AuthState {
  final UserModel user;
  
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpSuccess extends AuthState {
  final UserModel user;
  final String message;
  
  const SignUpSuccess(this.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class SignInSuccess extends AuthState {
  final UserModel user;
  final String message;
  
  const SignInSuccess(this.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class OtpSentSuccess extends AuthState {
  final String verificationId;
  final String phoneNumber;
  final String message;
  
  const OtpSentSuccess(this.verificationId, this.phoneNumber, this.message);

  @override
  List<Object?> get props => [verificationId, phoneNumber, message];
}

class OtpVerifiedSuccess extends AuthState {
  final String message;
  
  const OtpVerifiedSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailVerificationSent extends AuthState {
  final String message;
  
  const EmailVerificationSent(this.message);

  @override
  List<Object?> get props => [message];
}

class SignOutSuccess extends AuthState {
  final String message;
  
  const SignOutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Error states
class AuthError extends AuthState {
  final String message;
  final String? code;
  
  const AuthError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class ValidationError extends AuthState {
  final Map<String, String?> errors;
  
  const ValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}

// Special states
class AuthNeedsEmailVerification extends AuthState {
  final UserModel user;
  
  const AuthNeedsEmailVerification(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthNeedsPhoneVerification extends AuthState {
  final UserModel user;
  final String verificationId;
  
  const AuthNeedsPhoneVerification(this.user, this.verificationId);

  @override
  List<Object?> get props => [user, verificationId];
}