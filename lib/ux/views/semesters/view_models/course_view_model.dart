import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_service.dart';
import 'package:cgpa_calculator/platform/firebase/course/course_service.dart';
import 'package:cgpa_calculator/ux/shared/models/course_model.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:cgpa_calculator/ux/views/semesters/view_models/semester_view_model.dart';
import 'package:flutter/cupertino.dart';

class CourseViewModel extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  final AuthService _authService = AuthService();

  final SemesterViewModel _semesterViewModel = AppDI.getIt<SemesterViewModel>();

  ValueNotifier<List<Course>> courses = ValueNotifier([]);
  ValueNotifier<UIResult<Course>> addCourseResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<Course>> updateCourseResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<String>> deleteCourseResult =
      ValueNotifier(UIResult.empty());

  Future<void> loadCourses() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final loadedCourses = await _courseService.getCourses(
          userId, _semesterViewModel.semesters.value.first.id ?? '');
      courses.value = loadedCourses;
    } catch (e) {
      debugPrint('Error loading semesters: $e');
    }
  }

  Future<void> addCourse(
      {required String semesterId, required Course course}) async {
    addCourseResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _courseService.addCourse(
        userId: userId,
        semesterId: semesterId,
        course: course,
      );

      await _semesterViewModel.loadSemesters();

      addCourseResult.value = UIResult.success(
        data: course,
        message: 'Course added successfully',
      );
    } catch (e) {
      addCourseResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateCourse(
      {required String semesterId, required Course course}) async {
    updateCourseResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _courseService.updateCourse(
        userId: userId,
        semesterId: semesterId,
        course: course,
      );

      await _semesterViewModel.loadSemesters();

      updateCourseResult.value = UIResult.success(
        data: course,
        message: 'Course updated successfully',
      );
    } catch (e) {
      updateCourseResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> deleteCourse(
      {required String semesterId, required String courseId}) async {
    deleteCourseResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _courseService.deleteCourse(
        userId: userId,
        semesterId: semesterId,
        courseId: courseId,
      );

      await _semesterViewModel.loadSemesters();

      deleteCourseResult.value = UIResult.success(
        data: courseId,
        message: 'Course deleted successfully',
      );
    } catch (e) {
      deleteCourseResult.value = UIResult.error(message: e.toString());
    }
  }

  List<Course> getCoursesForSemester(String semesterId) {
    final semester = _semesterViewModel.semesters.value.firstWhere(
      (s) => s.id == semesterId,
      orElse: () => Semester.create(
        semesterName: '',
        academicYear: '',
      ),
    );
    return semester.courses ?? [];
  }

  Semester? getSemesterById(String semesterId) {
    try {
      return _semesterViewModel.semesters.value
          .firstWhere((s) => s.id == semesterId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    addCourseResult.dispose();
    updateCourseResult.dispose();
    deleteCourseResult.dispose();
    super.dispose();
  }
}
