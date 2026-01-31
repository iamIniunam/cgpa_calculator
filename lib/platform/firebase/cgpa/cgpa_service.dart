import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CGPAService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setTargetCGPA({
    required String userId,
    required double targetCGPA,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'targetCGPA': targetCGPA,
      });
    } catch (e) {
      throw Exception('Failed to set target CGPA: ${e.toString()}');
    }
  }
}
