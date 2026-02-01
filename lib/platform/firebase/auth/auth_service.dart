import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/analytics_logger.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_exception_handler.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_result_status.dart';
import 'package:cgpa_calculator/platform/firebase/auth/models/auth_response.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cgpa_calculator/ux/shared/view_models/theme_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AnalyticsLogger _analyticsLogger = AppDI.getIt<AnalyticsLogger>();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult(status: AuthResultStatus.unknown);
      }

      await userCredential.user?.updateDisplayName(fullName);

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user?.uid)
          .set({
        'uid': userCredential.user?.uid,
        'name': fullName,
        'email': email,
        'profileComplete': false,
        'themePreference': AppThemeMode.system.name,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
      });

      await _analyticsLogger.setUser(user);
      await _analyticsLogger.logSignUp(method: 'email');

      return AuthResult(
        status: AuthResultStatus.successful,
        user: user,
        message: 'Account created successfully',
      );
    } on FirebaseAuthException catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await _analyticsLogger.logSignUpFailed(
          method: 'email', errorCode: e.code);

      return AuthResult(
        status: status,
        message: status.message,
      );
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.unknown,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult(status: AuthResultStatus.unknown);
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user?.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
      });

      await _analyticsLogger.setUser(user);
      await _analyticsLogger.logLogin(method: 'email');

      return AuthResult(
        status: AuthResultStatus.successful,
        user: user,
        message: 'Login successful',
      );
    } on FirebaseAuthException catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await _analyticsLogger.logLoginFailed(method: 'email', errorCode: e.code);

      return AuthResult(
        status: status,
        message: status.message,
      );
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.unknown,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        await _analyticsLogger.logGoogleSignInCancelled();
        return AuthResult(
          status: AuthResultStatus.cancelled,
          message: 'Google sign-in cancelled',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return AuthResult(status: AuthResultStatus.unknown);
      }

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user?.uid)
          .get();

      final isNewUser = !userDoc.exists;

      if (isNewUser) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user?.uid)
            .set({
          'uid': userCredential.user?.uid,
          'name': userCredential.user?.displayName ?? '',
          'email': userCredential.user?.email ?? '',
          'profileComplete': false,
          'themePreference': AppThemeMode.system.name,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'lastActiveAt': FieldValue.serverTimestamp(),
          'profilePicture': userCredential.user?.photoURL,
          'googleImageUrl': userCredential.user?.photoURL,
        });

        await _analyticsLogger.setUser(user);
        await _analyticsLogger.logSignUp(method: 'google');
      } else {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user?.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
          'lastActiveAt': FieldValue.serverTimestamp(),
          'profilePicture': userCredential.user?.photoURL,
          'googleImageUrl': userCredential.user?.photoURL,
        });

        await _analyticsLogger.setUser(user);
        await _analyticsLogger.logLogin(method: 'google');
      }

      return AuthResult(
        status: AuthResultStatus.successful,
        user: user,
        message: 'Google sign-in successful',
      );
    } on FirebaseAuthException catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await _analyticsLogger.logLoginFailed(
          method: 'google', errorCode: e.toString());

      return AuthResult(
        status: status,
        message: status.message,
      );
    } catch (e) {
      await _analyticsLogger.logLoginFailed(
          method: 'google', errorCode: e.toString());
      return AuthResult(
        status: AuthResultStatus.unknown,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<void> completeProfile({
    required String userId,
    required String school,
    required Map<String, dynamic> gradingScale,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'school': school,
        'gradingScale': gradingScale,
        'profileComplete': true,
      });

      await _analyticsLogger.logProfileCompleted(
        userId: userId,
        school: school,
        gradingScale: gradingScale['name'] ?? 'unknown',
      );
    } catch (e) {
      throw Exception('Failed to complete profile: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(updates);

      await _analyticsLogger.logProfileUpdated(
        userId: userId,
        fieldsUpdated: updates.keys.toList(),
      );
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  Future<void> updateLastActive(String userId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> checkUserExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      await _analyticsLogger.logLogout(userId: userId);
    }
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);

    await _analyticsLogger.clearUser();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userId = user.uid;

    try {
      final semesterSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .get();
      for (var semesterDoc in semesterSnapshot.docs) {
        final coursesSnapshot = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .collection(AppConstants.semestersCollection)
            .doc(semesterDoc.id)
            .collection(AppConstants.coursesCollection)
            .get();

        for (var courseDoc in coursesSnapshot.docs) {
          await courseDoc.reference.delete();
        }

        await semesterDoc.reference.delete();
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .delete();

      await _analyticsLogger.clearUser();
      return await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      await _analyticsLogger.logPasswordResetRequested(email: email);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
