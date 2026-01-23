import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cgpa_calculator/ux/shared/view_models/theme_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
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

          // versioning
          // 'appVersion': '1.0.0',
          // 'onboardingVersion': 1,

          //timestamps
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          // 'lastActiveAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user?.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
          // 'lastActiveAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userCredential.user?.uid)
            .get();

        if (!userDoc.exists) {
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
          });
        } else {
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(userCredential.user?.uid)
              .update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential.user;
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
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
    await Future.wait([
      _auth.signOut(),
      // _googleSignIn.signOut(),
    ]);
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .delete();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
