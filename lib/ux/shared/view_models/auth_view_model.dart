import 'package:cgpa_calculator/platform/persistence/preference_manager.dart';
import 'package:cgpa_calculator/platform/persistence/preference_manager_extensions.dart';
import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_service.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_request.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final PreferenceManager _preferenceManager = AppDI.getIt<PreferenceManager>();

  ValueNotifier<UIResult<AppUser>> signUpResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<AppUser>> loginResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<AppUser>> googleSignInResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<AppUser>> completeProfileResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<AppUser>> updateProfileResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<bool>> checkUserExistsResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<String>> forgotPasswordResult =
      ValueNotifier(UIResult.empty());

  ValueNotifier<AppUser?> currentUser = ValueNotifier(null);

  Future<void> signUp(SignUpRequest request) async {
    signUpResult.value = UIResult.loading();
    try {
      final user = await _authService.signUp(
        email: request.email,
        password: request.password,
        fullName: request.fullName,
      );

      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          final appUser = AppUser.fromJson(userData);
          currentUser.value = appUser;
          _preferenceManager.userId = user.uid;
          signUpResult.value = UIResult.success(
            data: appUser,
            message: 'Sign up successful',
          );
        }
      }
    } catch (e) {
      signUpResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> login(LoginRequest request) async {
    loginResult.value = UIResult.loading();
    try {
      final user = await _authService.login(
        email: request.email,
        password: request.password,
      );

      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          final appUser = AppUser.fromJson(userData);
          currentUser.value = appUser;
          _preferenceManager.userId = user.uid;
          loginResult.value = UIResult.success(
            data: appUser,
            message: 'Login successful',
          );
        }
      }
    } catch (e) {
      loginResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    googleSignInResult.value = UIResult.loading();
    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          final appUser = AppUser.fromJson(userData);
          currentUser.value = appUser;
          _preferenceManager.userId = user.uid;
          googleSignInResult.value = UIResult.success(
            data: appUser,
            message: 'Google sign-in successful',
          );
        }
      } else {
        googleSignInResult.value =
            UIResult.error(message: 'Google sign-in failed');
      }
    } catch (e) {
      googleSignInResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> completeProfile(CompleteProfileRequest request) async {
    completeProfileResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _authService.completeProfile(
        userId: userId,
        school: request.school,
        gradingScale: request.gradingScale.toMap(),
      );

      final userData = await _authService.getUserData(userId);
      if (userData != null) {
        final appUser = AppUser.fromJson(userData);
        currentUser.value = appUser;
        completeProfileResult.value = UIResult.success(
          data: appUser,
          message: 'Profile completed successfully',
        );
      }
    } catch (e) {
      completeProfileResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateProfile(UpdateUserProfileRequest request) async {
    updateProfileResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _authService.updateUserProfile(
        userId: userId,
        updates: request.toMap(),
      );

      final userData = await _authService.getUserData(userId);
      if (userData != null) {
        final appUser = AppUser.fromJson(userData);
        currentUser.value = appUser;
        updateProfileResult.value = UIResult.success(
          data: appUser,
          message: 'Profile updated successfully',
        );
      }
    } catch (e) {
      updateProfileResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> checkUserExists(String email) async {
    checkUserExistsResult.value = UIResult.loading();
    try {
      final exists = await _authService.checkUserExists(email);
      checkUserExistsResult.value =
          UIResult.success(data: exists, message: 'Check completed');
    } catch (e) {
      checkUserExistsResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        debugPrint('Loaded user data: $userData');
        if (userData != null) {
          currentUser.value = AppUser.fromJson(userData);
          debugPrint(
              'AppUser.profileComplete: ${currentUser.value?.profileComplete}');
          _preferenceManager.userId = user.uid;
        }
      } else {
        currentUser.value = null;
        _preferenceManager.userId = null;
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  bool isLoggedIn() {
    return _authService.currentUser != null;
  }

  bool isProfileComplete() {
    return currentUser.value?.profileComplete ?? false;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _authService.logout();
      currentUser.value = null;
      _preferenceManager.userId = null;
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      currentUser.value = null;
      _preferenceManager.userId = null;
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(ForgotPasswordRequest request) async {
    forgotPasswordResult.value = UIResult.loading();
    try {
      await _authService.sendPasswordResetEmail(request.email);
      forgotPasswordResult.value = UIResult.success(
        data: 'Password reset email sent successfully',
        message: 'Check your email for instructions to reset your password',
      );
    } catch (e) {
      forgotPasswordResult.value = UIResult.error(message: e.toString());
    }
  }

  void listenToAuthStateChanges() {
    _authService.authStateChanges.listen((User? user) {
      if (user == null) {
        currentUser.value = null;
        _preferenceManager.userId = null;
      } else {
        loadCurrentUser();
      }
    });
  }
}
