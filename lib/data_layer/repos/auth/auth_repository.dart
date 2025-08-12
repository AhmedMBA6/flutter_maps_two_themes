import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/auth/user_model.dart';
import 'auth_repository_interface.dart';
import '../../../utils/logger.dart';

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _usersCollection {
    final collection = _firestore.collection('users');
    Logger.debug('Firestore collection path: ${collection.path}');
    return collection;
  }

  // Get current user
  @override
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  @override
  bool get isSignedIn => _auth.currentUser != null;

  // Stream of auth state changes
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== EMAIL/PASSWORD AUTHENTICATION ====================

  /// Sign in with email and password
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Create account with email and password
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      Logger.info('Attempting to create Firebase Auth user for email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      Logger.success('Firebase Auth user created successfully: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      Logger.error('Firebase Auth error in createUserWithEmailAndPassword: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      Logger.error('Unexpected error in createUserWithEmailAndPassword: $e');
      throw 'Failed to create account: $e';
    }
  }

  /// Send email verification
  @override
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Reset password via email
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ==================== PHONE AUTHENTICATION ====================

  /// Send OTP to phone number
  @override
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      Logger.info('AuthRepository: Sending OTP to phone: $phoneNumber');
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          Logger.info('AuthRepository: Auto-verification completed for phone: $phoneNumber');
          // Auto-verification (Android only)
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Logger.error('AuthRepository: Verification failed for phone: $phoneNumber, error: ${e.code}');
          onError(_handleAuthException(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          Logger.success('AuthRepository: Code sent successfully for phone: $phoneNumber, verification ID: $verificationId');
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Logger.warning('AuthRepository: Code auto-retrieval timeout for verification ID: $verificationId');
          // Handle timeout
        },
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      Logger.error('AuthRepository: Firebase Auth exception in sendOTP: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    }
  }

  /// Verify OTP and sign in
  @override
  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      Logger.info('AuthRepository: Verifying OTP with verification ID: $verificationId, SMS code: $smsCode');
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      Logger.debug('AuthRepository: PhoneAuthCredential created, attempting to sign in...');
      final result = await _auth.signInWithCredential(credential);
      Logger.success('AuthRepository: Sign in with credential successful: ${result.user?.uid}');
      
      return result;
    } on FirebaseAuthException catch (e) {
      Logger.error('AuthRepository: Firebase Auth exception in verifyOTP: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      Logger.error('AuthRepository: Unexpected error in verifyOTP: $e');
      throw 'Failed to verify OTP: $e';
    }
  }

  // ==================== USER DATA MANAGEMENT ====================

  /// Save user data to Firestore
  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      Logger.debug('Saving user data: ${user.toMap()}');
      Logger.debug('User ID: ${user.id}');
      
      if (user.id != null) {
        // Check if the document already exists
        final docRef = _usersCollection.doc(user.id);
        Logger.debug('Checking if document exists at path: ${docRef.path}');
        
        final doc = await docRef.get();
        Logger.debug('Document exists: ${doc.exists}');
        
        if (doc.exists) {
          // Update existing user
          Logger.info('Updating existing user document...');
          await docRef.update(user.toMap());
          Logger.success('User document updated successfully');
        } else {
          // Create new user with the specified ID
                  Logger.info('Creating new user document with ID: ${user.id}');
        await docRef.set(user.toMap());
        Logger.success('User document created successfully');
        }
      } else {
        // Create new user without specifying ID (Firestore will generate one)
        Logger.info('Creating new user document with auto-generated ID...');
        final docRef = await _usersCollection.add(user.toMap());
        Logger.success('User document created with auto-generated ID: ${docRef.id}');
      }
    } catch (e) {
      Logger.error('Error saving user data: $e');
      
      // Handle specific Firestore errors
      if (e.toString().contains('No document to update')) {
        Logger.warning('Document not found error - trying to create instead of update');
        try {
          if (user.id != null) {
            await _usersCollection.doc(user.id).set(user.toMap());
            Logger.success('User document created successfully after error recovery');
            return;
          }
        } catch (recoveryError) {
          Logger.error('Error during recovery: $recoveryError');
        }
      }
      
      throw 'Failed to save user data: $e';
    }
  }

  /// Get user data from Firestore by UID
  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  /// Update user data
  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(uid).update({
        ...data,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw 'Failed to update user data: $e';
    }
  }

  /// Check if user exists by email
  @override
  Future<bool> userExistsByEmail(String email) async {
    try {
      Logger.debug('Checking if user exists by email: $email');
      final query = await _usersCollection
          .where('email', isEqualTo: email.trim().toLowerCase())
          .get();
      final exists = query.docs.isNotEmpty;
      Logger.debug('User exists check result: $exists (found ${query.docs.length} documents)');
      return exists;
    } catch (e) {
      Logger.error('Error checking user existence by email: $e');
      throw 'Failed to check user existence: $e';
    }
  }

  /// Check if user exists by phone
  @override
  Future<bool> userExistsByPhone(String phoneNumber) async {
    try {
      Logger.debug('AuthRepository: Checking if user exists by phone: $phoneNumber');
      
      // Try to find user by the full phone number (with country code)
      final fullPhoneQuery = await _usersCollection
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      
      if (fullPhoneQuery.docs.isNotEmpty) {
        Logger.debug('AuthRepository: User found with full phone number: $phoneNumber');
        return true;
      }
      
      // If not found, try to extract country code and phone number
      // This handles cases where the phone number might be stored differently
      if (phoneNumber.startsWith('+')) {
        // Try to find by phone number without country code
        final phoneWithoutCountry = phoneNumber.substring(1);
        final phoneQuery = await _usersCollection
            .where('phoneNumber', isEqualTo: phoneWithoutCountry)
            .get();
        
        if (phoneQuery.docs.isNotEmpty) {
          Logger.debug('AuthRepository: User found with phone number (without country code): $phoneWithoutCountry');
          return true;
        }
      }
      
      Logger.debug('AuthRepository: No user found with phone: $phoneNumber');
      return false;
    } catch (e) {
      Logger.error('AuthRepository: Error checking user existence by phone: $e');
      throw 'Failed to check user existence: $e';
    }
  }

  /// Find user by full phone number (with country code)
  @override
  Future<UserModel?> findUserByFullPhone(String fullPhoneNumber) async {
    try {
      Logger.debug('AuthRepository: Finding user by full phone: $fullPhoneNumber');
      
      // First try to find by the full phone number as stored
      if (fullPhoneNumber.startsWith('+')) {
        // Extract country code and phone number
        String countryCode = '';
        String phoneNumber = '';
        
        // Find the country code (usually 1-4 digits after +)
        int countryCodeEnd = 1;
        for (int i = 1; i < fullPhoneNumber.length && i <= 5; i++) {
          if (fullPhoneNumber[i].contains(RegExp(r'[0-9]'))) {
            countryCodeEnd = i + 1;
          } else {
            break;
          }
        }
        
        countryCode = fullPhoneNumber.substring(0, countryCodeEnd);
        phoneNumber = fullPhoneNumber.substring(countryCodeEnd);
        
        Logger.debug('AuthRepository: Extracted country code: $countryCode, phone: $phoneNumber');
        
        // Query by both country code and phone number
        final query = await _usersCollection
            .where('countryCode', isEqualTo: countryCode)
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();
        
        if (query.docs.isNotEmpty) {
          Logger.debug('AuthRepository: User found by country code + phone number');
          return UserModel.fromFirestore(query.docs.first);
        }
      }
      
      // Fallback: try to find by phone number only (in case country code format is different)
      final phoneQuery = await _usersCollection
          .where('phoneNumber', isEqualTo: fullPhoneNumber)
          .get();
      
      if (phoneQuery.docs.isNotEmpty) {
        Logger.debug('AuthRepository: User found by phone number only');
        return UserModel.fromFirestore(phoneQuery.docs.first);
      }
      
      Logger.debug('AuthRepository: No user found with full phone: $fullPhoneNumber');
      return null;
    } catch (e) {
      Logger.error('AuthRepository: Error finding user by full phone: $e');
      throw 'Failed to find user: $e';
    }
  }

  // ==================== COMPLETE AUTHENTICATION FLOWS ====================

  /// Complete sign-up flow with email/password + user data
  @override
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      Logger.info('Starting sign up process for email: $email');
      
      // 1. Check if user already exists in Firestore
      final userExists = await userExistsByEmail(email);
      Logger.debug('User exists check result: $userExists');
      
      if (userExists) {
        throw 'User with this email already exists';
      }

      // 1.5. Also check if user exists in Firebase Auth (additional safety check)
      try {
        // Note: fetchSignInMethodsForEmail is deprecated for security reasons
        // We'll rely on the Firestore check and handle Firebase Auth errors gracefully
        Logger.info('Skipping Firebase Auth email check (deprecated method)');
      } catch (e) {
        Logger.warning('Error in email existence check: $e');
        // Continue with sign up if this check fails
      }

      // 2. Create Firebase Auth user
      Logger.info('Creating Firebase Auth user...');
      final credential = await createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logger.success('Firebase Auth user created with UID: ${credential.user?.uid}');

      // 3. Create UserModel
      final user = UserModel(
        id: credential.user?.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      Logger.debug('UserModel created: ${user.toMap()}');

      // 4. Save to Firestore
      Logger.info('Saving user data to Firestore...');
      await saveUserData(user);
      Logger.success('User data saved to Firestore successfully');

      // 5. Send email verification
      Logger.info('Sending email verification...');
      await sendEmailVerification();
      Logger.success('Email verification sent');

      return user;
    } catch (e) {
      Logger.error('Error in signUpWithEmail: $e');
      if (e.toString().contains('email-already-in-use')) {
        throw 'An account already exists with this email. Please sign in instead.';
      }
      throw e.toString();
    }
  }

  /// Complete sign-up flow with phone + user data
  @override
  Future<UserModel> signUpWithPhone({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      Logger.info('AuthRepository: Starting phone sign-up for email: $email, phone: $phoneNumber');
      
      // 1. Check if user already exists
      if (await userExistsByEmail(email)) {
        Logger.warning('AuthRepository: User already exists with email: $email');
        throw 'User with this email already exists';
      }

      // 2. Verify OTP and create Firebase Auth user
      Logger.info('AuthRepository: Verifying OTP for phone sign-up...');
      final credential = await verifyOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      Logger.success('AuthRepository: OTP verified successfully, user UID: ${credential.user?.uid}');

      // 3. Create UserModel
      final user = UserModel(
        id: credential.user?.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        isPhoneVerified: true,
      );
      Logger.debug('AuthRepository: UserModel created: ${user.toMap()}');

      // 4. Save to Firestore
      Logger.info('AuthRepository: Saving user data to Firestore...');
      await saveUserData(user);
      Logger.success('AuthRepository: User data saved to Firestore successfully');

      return user;
    } catch (e) {
      Logger.error('AuthRepository: Error in signUpWithPhone: $e');
      throw e.toString();
    }
  }

  /// Sign in with email/password
  @override
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Firebase Auth
      await signInWithEmailAndPassword(email: email, password: password);

      // 2. Get user data from Firestore
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        return await getUserData(currentUser.uid);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Sign in with phone/OTP
  @override
  Future<UserModel?> signInWithPhone({
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      Logger.info('AuthRepository: Starting phone sign-in for phone: $phoneNumber');
      
      // 1. First check if a user with this phone number exists in our database
      Logger.debug('AuthRepository: Checking if user exists with phone: $phoneNumber');
      final existingUser = await findUserByFullPhone(phoneNumber);
      
      if (existingUser == null) {
        Logger.warning('AuthRepository: No user found with phone: $phoneNumber');
        throw 'No account found with this phone number. Please sign up first.';
      }
      
      Logger.debug('AuthRepository: User exists with phone: $phoneNumber, proceeding with OTP verification');
      Logger.debug('AuthRepository: Existing user data: ${existingUser.toMap()}');

      // 2. Verify OTP and sign in
      final credential = await verifyOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // 3. Get user data from Firestore using the existing user's ID
      if (credential.user != null) {
        Logger.success('AuthRepository: OTP verified successfully, fetching user data for UID: ${credential.user!.uid}');
        
        // Use the existing user data we already found
        if (existingUser.id == credential.user!.uid) {
          Logger.debug('AuthRepository: User ID matches, returning existing user data');
          return existingUser;
        } else {
          // This shouldn't happen in normal flow, but handle it gracefully
          Logger.warning('AuthRepository: User ID mismatch, fetching fresh data from Firestore');
          final userData = await getUserData(credential.user!.uid);
          
          if (userData != null) {
            Logger.debug('AuthRepository: User data retrieved successfully: ${userData.toMap()}');
            return userData;
          } else {
            Logger.error('AuthRepository: User exists in Firebase Auth but not in Firestore');
            throw 'User data not found. Please contact support.';
          }
        }
      } else {
        Logger.error('AuthRepository: No user returned from OTP verification');
        throw 'Failed to verify phone number. Please try again.';
      }
    } catch (e) {
      Logger.error('AuthRepository: Error in signInWithPhone: $e');
      throw e.toString();
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Sign out
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out: $e';
    }
  }

  /// Delete user account
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete from Firestore
        await _usersCollection.doc(user.uid).delete();
        // Delete from Firebase Auth
        await user.delete();
      }
    } catch (e) {
      throw 'Failed to delete account: $e';
    }
  }

  /// Update phone verification status
  @override
  Future<void> updatePhoneVerificationStatus(String uid, bool isVerified) async {
    try {
      await updateUserData(uid, {'isPhoneVerified': isVerified});
    } catch (e) {
      throw 'Failed to update phone verification status: $e';
    }
  }

  // ==================== ERROR HANDLING ====================

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'invalid-phone-number':
        return 'Invalid phone number.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
