import 'package:firebase_auth/firebase_auth.dart';
import '../../models/auth/user_model.dart';

abstract class AuthRepositoryInterface {
  // Getters
  User? get currentUser;
  bool get isSignedIn;
  Stream<User?> get authStateChanges;

  // Email/Password Authentication
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);

  // Phone Authentication
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  });

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  });

  // User Data Management
  Future<void> saveUserData(UserModel user);
  Future<UserModel?> getUserData(String uid);
  Future<void> updateUserData(String uid, Map<String, dynamic> data);
  Future<bool> userExistsByEmail(String email);
  Future<bool> userExistsByPhone(String phoneNumber);
  Future<UserModel?> findUserByFullPhone(String fullPhoneNumber);

  // Complete Authentication Flows
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String countryCode,
  });

  Future<UserModel> signUpWithPhone({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String verificationId,
    required String smsCode,
  });

  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel?> signInWithPhone({
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
  });

  // Utility Methods
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> updatePhoneVerificationStatus(String uid, bool isVerified);
}
