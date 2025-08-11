class AuthValidationService {
  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Phone number validation
  static bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length >= 7 && phoneNumber.length <= 15;
  }

  // Password strength validation
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Password confirmation validation
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Full name validation
  static bool isValidFullName(String fullName) {
    return fullName.trim().length >= 2;
  }

  // Country code validation
  static bool isValidCountryCode(String countryCode) {
    return countryCode.startsWith('+') && countryCode.length >= 2;
  }

  // Complete registration validation
  static Map<String, String?> validateRegistration({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String password,
    required String confirmPassword,
  }) {
    Map<String, String?> errors = {};

    // Full name validation
    if (!isValidFullName(fullName)) {
      errors['fullName'] = 'Please enter a valid full name (minimum 2 characters)';
    }

    // Email validation
    if (!isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Phone number validation
    if (!isValidPhoneNumber(phoneNumber)) {
      errors['phoneNumber'] = 'Please enter a valid phone number';
    }

    // Country code validation
    if (!isValidCountryCode(countryCode)) {
      errors['countryCode'] = 'Please select a valid country code';
    }

    // Password validation
    if (!isValidPassword(password)) {
      errors['password'] = 'Password must be at least 6 characters long';
    }

    // Password confirmation validation
    if (!passwordsMatch(password, confirmPassword)) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    return errors;
  }

  // Sign in validation
  static Map<String, String?> validateSignIn({
    required String email,
    required String password,
  }) {
    Map<String, String?> errors = {};

    // Email validation
    if (!isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Password validation
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    }

    return errors;
  }

  // Phone sign in validation
  static Map<String, String?> validatePhoneSignIn({
    required String phoneNumber,
    required String countryCode,
  }) {
    Map<String, String?> errors = {};

    // Phone number validation
    if (!isValidPhoneNumber(phoneNumber)) {
      errors['phoneNumber'] = 'Please enter a valid phone number';
    }

    // Country code validation
    if (!isValidCountryCode(countryCode)) {
      errors['countryCode'] = 'Please select a valid country code';
    }

    return errors;
  }

  // OTP validation
  static Map<String, String?> validateOTP(String otp) {
    Map<String, String?> errors = {};

    if (otp.length != 6) {
      errors['otp'] = 'Please enter a 6-digit verification code';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
      errors['otp'] = 'Please enter only numbers';
    }

    return errors;
  }

  // Check if form is valid
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  // Get first error message
  static String? getFirstError(Map<String, String?> errors) {
    return errors.values.firstWhere((error) => error != null, orElse: () => null);
  }
}
