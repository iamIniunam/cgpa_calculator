import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AnalyticsLogger {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsLogger();

  Future<void> setUser(User user) async {
    try {
      await _analytics.setUserId(id: user.uid);

      final providerId = user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown';

      await _analytics.setUserProperty(
        name: 'auth_provider',
        value: providerId,
      );

      await _analytics.setUserProperty(
        name: 'email_verified',
        value: user.emailVerified.toString(),
      );

      if (kDebugMode) {
        print('📊 Analytics: User set - ${user.uid}');
      }
    } catch (e) {
      _logError('setUser', e);
    }
  }

  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);

      if (kDebugMode) {
        print('📊 Analytics: User cleared');
      }
    } catch (e) {
      _logError('clearUser', e);
    }
  }

  Future<void> setUserProperty(
      {required String name, required String value}) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);

      if (kDebugMode) {
        print('📊 Analytics: User property set - $name: $value');
      }
    } catch (e) {
      _logError('setUserProperty', e);
    }
  }

  Future<void> logSignUp({required String method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      await _logEvent(
        name: 'user_registered',
        parameters: {'method': method},
      );
    } catch (e) {
      _logError('logSignUp', e);
    }
  }

  Future<void> logLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      _logError('logLogin', e);
    }
  }

  Future<void> logSignUpFailed(
      {required String method, required String errorCode}) async {
    await _logEvent(
      name: 'signup_failed',
      parameters: {
        'method': method,
        'error_code': errorCode,
      },
    );
  }

  Future<void> logLoginFailed(
      {required String method, required String errorCode}) async {
    await _logEvent(
      name: 'login_failed',
      parameters: {
        'method': method,
        'error_code': errorCode,
      },
    );
  }

  Future<void> logGoogleSignInCancelled() async {
    await _logEvent(name: 'google_signin_cancelled');
  }

  Future<void> logLogout({String? userId}) async {
    await _logEvent(
      name: 'user_logged_out',
      parameters: userId != null ? {'user_id': userId} : null,
    );
  }

  Future<void> logProfileCompleted({
    required String userId,
    required String school,
    required String gradingScale,
  }) async {
    await _logEvent(
      name: 'profile_completed',
      parameters: {
        'user_id': userId,
        'school': school,
        'grading_scale': gradingScale,
      },
    );
  }

  Future<void> logProfileUpdated(
      {required String userId, required List<String> fieldsUpdated}) async {
    await _logEvent(
      name: 'profile_updated',
      parameters: {
        'user_id': userId,
        'fields_updated': fieldsUpdated.join(','),
      },
    );
  }

  Future<void> logTargetCGPASet(
      {required String userId, required double targetCGPA}) async {
    await _logEvent(
      name: 'target_cgpa_set',
      parameters: {
        'user_id': userId,
        'target_cgpa': targetCGPA,
      },
    );
  }

  Future<void> logSemesterCreated({
    required String userId,
    required String semesterId,
    required String semesterName,
  }) async {
    await _logEvent(
      name: 'semester_created',
      parameters: {
        'user_id': userId,
        'semester_id': semesterId,
        'semester_name': semesterName,
      },
    );
  }

  Future<void> logSemesterCompleted({
    required String userId,
    required String semesterId,
    required double gpa,
    required int totalCredits,
  }) async {
    await _logEvent(
      name: 'semester_completed',
      parameters: {
        'user_id': userId,
        'semester_id': semesterId,
        'gpa': gpa,
        'total_credits': totalCredits,
      },
    );
  }

  Future<void> logCourseAdded({
    required String userId,
    required String semesterId,
    required String courseCode,
    required int creditUnits,
  }) async {
    await _logEvent(
      name: 'course_added',
      parameters: {
        'user_id': userId,
        'semester_id': semesterId,
        'course_code': courseCode,
        'credit_units': creditUnits,
      },
    );
  }

  Future<void> logCGPAMilestone({
    required String userId,
    required double cgpa,
    required String milestone,
  }) async {
    await _logEvent(
      name: 'cgpa_milestone',
      parameters: {
        'user_id': userId,
        'cgpa': cgpa,
        'milestone': milestone, // e.g., "first_class", "dean_list"
      },
    );
  }

  Future<void> logScreenView(
      {required String screenName, String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      if (kDebugMode) {
        print('📊 Analytics: Screen view - $screenName');
      }
    } catch (e) {
      _logError('logScreenView', e);
    }
  }

  Future<void> logThemeChanged({required String theme}) async {
    await _logEvent(
      name: 'theme_changed',
      parameters: {'theme': theme},
    );
  }

  Future<void> logPasswordResetRequested({required String email}) async {
    await _logEvent(
      name: 'password_reset_requested',
      parameters: {'email': email},
    );
  }

  Future<void> logAccountDeleted(
      {required String userId, String? reason}) async {
    await _logEvent(
      name: 'account_deleted',
      parameters: {
        'user_id': userId,
        if (reason != null) 'reason': reason,
      },
    );
  }

  Future<void> logCustomEvent(
      {required String eventName, Map<String, dynamic>? parameters}) async {
    await _logEvent(name: eventName, parameters: parameters);
  }

  Future<void> _logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );

      if (kDebugMode) {
        print('📊 Analytics: Event logged - $name ${parameters ?? ""}');
      }
    } catch (e) {
      _logError(name, e);
    }
  }

  void _logError(String method, dynamic error) {
    if (kDebugMode) {
      print('❌ Analytics Error [$method]: $error');
    }
  }
}
