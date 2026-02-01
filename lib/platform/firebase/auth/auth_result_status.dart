enum AuthResultStatus {
  successful,
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,
  userNotFound,
  wrongPassword,
  userDisabled,
  invalidCredential,
  tooManyRequests,
  networkRequestFailed,
  operationNotAllowed,
  requiresRecentLogin,
  accountExistsWithDifferentCredential,
  expiredActionCode,
  invalidActionCode,
  cancelled,
  unknown,
}

extension AuthResultStatusExtension on AuthResultStatus {
  String get message {
    switch (this) {
      case AuthResultStatus.successful:
        return 'Operation successful';
      case AuthResultStatus.emailAlreadyInUse:
        return 'This email is already registered. Please login or use a different email.';
      case AuthResultStatus.weakPassword:
        return 'The password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      case AuthResultStatus.invalidEmail:
        return 'The email address is invalid. Please check and try again.';
      case AuthResultStatus.userNotFound:
        return 'No account found with this email. Please sign up first.';
      case AuthResultStatus.wrongPassword:
        return 'Incorrect password. Please try again or reset your password.';
      case AuthResultStatus.userDisabled:
        return 'This account has been disabled. Please contact support for assistance.';
      case AuthResultStatus.invalidCredential:
        return 'Invalid credentials. Please check your email and password.';
      case AuthResultStatus.tooManyRequests:
        return 'Too many unsuccessful attempts. Please wait a few minutes and try again.';
      case AuthResultStatus.networkRequestFailed:
        return 'Network error. Please check your internet connection and try again.';
      case AuthResultStatus.operationNotAllowed:
        return 'This sign-in method is not enabled. Please contact support.';
      case AuthResultStatus.requiresRecentLogin:
        return 'This operation requires recent authentication. Please log in again.';
      case AuthResultStatus.accountExistsWithDifferentCredential:
        return 'An account already exists with the same email but different sign-in credentials.';
      case AuthResultStatus.expiredActionCode:
        return 'This password reset link has expired. Please request a new one.';
      case AuthResultStatus.invalidActionCode:
        return 'This password reset link is invalid. Please request a new one.';
      case AuthResultStatus.cancelled:
        return 'Operation cancelled';
      case AuthResultStatus.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  bool get isSuccessful => this == AuthResultStatus.successful;

  bool get isError => this != AuthResultStatus.successful;
}
