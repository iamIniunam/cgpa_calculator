import 'package:cloud_firestore/cloud_firestore.dart';

class CGPAService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String usersCollection = 'users';

  Future<void> setTargetCGPA({
    required String userId,
    required double targetCGPA,
    required double currentCGPA,
  }) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'targetCGPA': targetCGPA,
        'currentCGPA': currentCGPA,
      });
    } catch (e) {
      throw Exception('Failed to set target CGPA: ${e.toString()}');
    }
  }
}
