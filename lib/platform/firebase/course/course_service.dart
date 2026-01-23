import 'package:cgpa_calculator/ux/shared/models/course_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCourse({
    required String userId,
    required String semesterId,
    required Course course,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .collection(AppConstants.coursesCollection)
          .doc(course.id)
          .set(course.toMap());

      await _recalculateSemester(userId, semesterId);
    } catch (e) {
      throw Exception('Failed to add course: ${e.toString()}');
    }
  }

  Future<List<Course>> getCourses(String userId, String semesterId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .collection(AppConstants.coursesCollection)
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get courses: ${e.toString()}');
    }
  }

  Future<void> updateCourse({
    required String userId,
    required String semesterId,
    required Course course,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .collection(AppConstants.coursesCollection)
          .doc(course.id)
          .update(course.toMap());

      await _recalculateSemester(userId, semesterId);
    } catch (e) {
      throw Exception('Failed to update course: ${e.toString()}');
    }
  }

  Future<void> deleteCourse({
    required String userId,
    required String semesterId,
    required String courseId,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .collection(AppConstants.coursesCollection)
          .doc(courseId)
          .delete();

      await _recalculateSemester(userId, semesterId);
    } catch (e) {
      throw Exception('Failed to delete course: ${e.toString()}');
    }
  }

  Future<void> _recalculateSemester(String userId, String semesterId) async {
    try {
      final courses = await getCourses(userId, semesterId);

      final totalCreditUnits = courses.fold<int>(
        0,
        (sum, course) => sum + course.creditUnits,
      );

      final totalGradePoints = courses.fold<double>(
        0.0,
        (sum, course) => sum + course.gradePointsScored,
      );

      final semesterGPA =
          totalCreditUnits > 0 ? totalGradePoints / totalCreditUnits : 0.0;

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .update({
        'totalCreditUnits': totalCreditUnits,
        'totalGradePoints': totalGradePoints,
        'semesterGPA': semesterGPA,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to recalculate semester: ${e.toString()}');
    }
  }

  Stream<List<Course>> coursesStream(String userId, String semesterId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.semestersCollection)
        .doc(semesterId)
        .collection(AppConstants.coursesCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList());
  }
}
