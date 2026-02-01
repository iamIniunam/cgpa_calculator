import 'package:cgpa_calculator/platform/firebase/auth/auth_result_status.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static AuthResultStatus handleException(dynamic exception) {
    if (exception is! FirebaseAuthException) {
      return AuthResultStatus.unknown;
    }

    final code = exception.code;

    switch (code) {
      case 'email-already-in-use':
        return AuthResultStatus.emailAlreadyInUse;
      case 'weak-password':
        return AuthResultStatus.weakPassword;
      case 'invalid-email':
        return AuthResultStatus.invalidEmail;
      case 'user-not-found':
        return AuthResultStatus.userNotFound;
      case 'wrong-password':
        return AuthResultStatus.wrongPassword;
      case 'user-disabled':
        return AuthResultStatus.userDisabled;
      case 'invalid-credential':
        return AuthResultStatus.invalidCredential;
      case 'too-many-requests':
        return AuthResultStatus.tooManyRequests;
      case 'network-request-failed':
        return AuthResultStatus.networkRequestFailed;
      case 'operation-not-allowed':
        return AuthResultStatus.operationNotAllowed;
      case 'requires-recent-login':
        return AuthResultStatus.requiresRecentLogin;
      case 'account-exists-with-different-credential':
        return AuthResultStatus.accountExistsWithDifferentCredential;
      case 'expired-action-code':
        return AuthResultStatus.expiredActionCode;
      case 'invalid-action-code':
        return AuthResultStatus.invalidActionCode;
      default:
        return AuthResultStatus.unknown;
    }
  }

  static String getErrorMessage(dynamic exception) {
    final status = handleException(exception);
    return status.message;
  }
}
