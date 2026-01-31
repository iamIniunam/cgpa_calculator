import 'package:cgpa_calculator/platform/firebase/course/course_service.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CourseService _courseService = CourseService();

  Future<void> createSemester(
      {required String userId, required Semester semester}) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semester.id)
          .set(semester.toMap());
    } catch (e) {
      throw Exception('Failed to create semester: ${e.toString()}');
    }
  }

  Future<List<Semester>> getSemesters(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .orderBy('createdAt', descending: false)
          .get();

      final semesters = <Semester>[];

      for (var doc in snapshot.docs) {
        final semesterData = doc.data();
        final courses = await _courseService.getCourses(userId, doc.id);
        semesters.add(Semester.fromJson(semesterData, courses: courses));
      }

      return semesters;
    } catch (e) {
      throw Exception('Failed to get semesters: ${e.toString()}');
    }
  }

  Future<Semester?> getSemester(String userId, String semesterId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .get();
      if (!doc.exists) return null;

      final courses = await _courseService.getCourses(userId, semesterId);
      return Semester.fromJson(doc.data() ?? {}, courses: courses);
    } catch (e) {
      throw Exception('Failed to get semester: ${e.toString()}');
    }
  }

  Future<void> updateSemester(
      {required String userId, required Semester semester}) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semester.id)
          .update(semester.toMap());
    } catch (e) {
      throw Exception('Failed to update semester: ${e.toString()}');
    }
  }

  Future<void> deleteSemester(
      {required String userId, required String semesterId}) async {
    try {
      // Delete all courses in the semester first
      final coursesSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .collection(AppConstants.coursesCollection)
          .get();

      for (var doc in coursesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Then delete the semester
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete semester: ${e.toString()}');
    }
  }

  Future<void> updateSemesterStatus({
    required String userId,
    required String semesterId,
    required SemesterStatus status,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.semestersCollection)
          .doc(semesterId)
          .update({
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update semester status: ${e.toString()}');
    }
  }

  Stream<List<Semester>> semestersStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.semestersCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
      final semesters = <Semester>[];

      for (var doc in snapshot.docs) {
        final semesterData = doc.data();
        final courses = await _courseService.getCourses(userId, doc.id);
        semesters.add(Semester.fromJson(semesterData, courses: courses));
      }

      return semesters;
    });
  }
}
