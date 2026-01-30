import 'package:cgpa_calculator/platform/di/dependency_injection.dart';
import 'package:cgpa_calculator/platform/firebase/analytics_logger.dart';
import 'package:cgpa_calculator/platform/firebase/auth/auth_service.dart';
import 'package:cgpa_calculator/platform/firebase/semester/semester_service.dart';
import 'package:cgpa_calculator/ux/shared/models/semester_model.dart';
import 'package:cgpa_calculator/ux/shared/models/ui_models.dart';
import 'package:flutter/cupertino.dart';

class SemesterViewModel extends ChangeNotifier {
  final SemesterService _semesterService = SemesterService();
  final AuthService _authService = AuthService();
  final AnalyticsLogger _analytics = AppDI.getIt<AnalyticsLogger>();

  ValueNotifier<List<Semester>> semesters = ValueNotifier([]);
  ValueNotifier<UIResult<Semester>> createSemesterResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<Semester>> updateSemesterResult =
      ValueNotifier(UIResult.empty());
  ValueNotifier<UIResult<String>> deleteSemesterResult =
      ValueNotifier(UIResult.empty());

  double get currentCGPA => CGPACalculator.calculateCGPA(semesters.value);
  int get totalCredits => CGPACalculator.calculateTotalCredits(semesters.value);
  int get completedSemestersCount =>
      CGPACalculator.getCompletedSemestersCount(semesters.value);
  int get totalSemesters => semesters.value.length;

  double get previousCGPA {
    if (semesters.value.length < 2) return 0.0;
    final previousSemesters =
        semesters.value.sublist(0, semesters.value.length - 1);
    return CGPACalculator.calculateCGPA(previousSemesters);
  }

  double get cgpaChange =>
      CGPACalculator.calculateCGPAChange(currentCGPA, previousCGPA);

  List<Map<String, dynamic>> get semesterGPAData =>
      CGPACalculator.getSemesterGPAData(semesters.value);

  Map<String, double> get statistics =>
      CGPACalculator.calculateStatistics(semesters.value);

  bool get hasSemesters => semesters.value.isNotEmpty;

  Future<void> loadSemesters() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final loadedSemesters = await _semesterService.getSemesters(userId);
      semesters.value = loadedSemesters;
      debugPrint('Semesters loaded: ${loadedSemesters.length}');
    } catch (e) {
      debugPrint('Error loading semesters: $e');
    }
  }

  Future<void> createSemester(Semester semester) async {
    createSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.createSemester(
        userId: userId,
        semester: semester,
      );

      await loadSemesters();

      if (semester.id != null) {
        final String loggedSemesterName =
            (semester.semesterName == null || semester.semesterName!.isEmpty)
                ? 'unnamed_semester'
                : semester.semesterName!;
        await _analytics.logSemesterCreated(
          userId: userId,
          semesterId: semester.id!,
          semesterName: loggedSemesterName,
        );
      } else {
        debugPrint(
          'Semester ID is null after creation; skipping analytics logging for created semester. '
          'This is unexpected and may indicate an issue with semester ID assignment in the SemesterService '
          'or the backing store (e.g., missing or failed document creation). Verify that createSemester '
          'returns a persisted Semester with a non-null ID for userId=$userId and semesterName="${semester.semesterName ?? ''}".',
        );
      }

      createSemesterResult.value = UIResult.success(
        data: semester,
        message: 'Semester created successfully',
      );
    } catch (e) {
      createSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateSemester(Semester semester) async {
    updateSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.updateSemester(
        userId: userId,
        semester: semester,
      );

      await loadSemesters();

      updateSemesterResult.value = UIResult.success(
        data: semester,
        message: 'Semester updated successfully',
      );
    } catch (e) {
      updateSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> deleteSemester(String semesterId) async {
    deleteSemesterResult.value = UIResult.loading();
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _semesterService.deleteSemester(
        userId: userId,
        semesterId: semesterId,
      );

      await loadSemesters();

      await _analytics.logCustomEvent(
        eventName: 'semester_deleted',
        parameters: {
          'user_id': userId,
          'semester_id': semesterId,
        },
      );

      deleteSemesterResult.value = UIResult.success(
        data: semesterId,
        message: 'Semester deleted successfully',
      );
    } catch (e) {
      deleteSemesterResult.value = UIResult.error(message: e.toString());
    }
  }

  Future<void> updateSemesterStatus({
    required String semesterId,
    required SemesterStatus status,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      await _semesterService.updateSemesterStatus(
        userId: userId,
        semesterId: semesterId,
        status: status,
      );

      await loadSemesters();
    } catch (e) {
      debugPrint('Error updating semester status: $e');
    }
  }

  void listenToSemesters() {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    _semesterService.semestersStream(userId).listen((loadedSemesters) {
      semesters.value = loadedSemesters;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    semesters.dispose();
    createSemesterResult.dispose();
    updateSemesterResult.dispose();
    deleteSemesterResult.dispose();
    super.dispose();
  }
}
